" Vim9 plugin code2prompt 集成插件
" 依赖: Vim 9+, fzf.vim, 系统 PATH 中需要有 code2prompt 命令
" 功能描述: 通过 fzf 选择文件，将 code2prompt 生成的 prompt 插入光标位置

vim9script

# 只加载一次
if exists('g:loaded_code2prompt')
  finish
endif
g:loaded_code2prompt = 1

# 存储最初调用 code2prompt 的源文件路径
# 当你通过 Ctrl-T/Ctrl-V/Ctrl-X 打开新文件时，我们记住你从哪里来
# 将选中内容追加到源文件后，会清空这个变量
g:code2prompt_origin_file = ''

# -------------------------------------
# 检查依赖
# -------------------------------------

# 检查系统 PATH 中是否有 code2prompt 命令
def CheckCode2prompt(): bool
  # 使用 exepath 检查命令是否存在
  if exepath('code2prompt') == ''
    echoerr 'code2prompt: 在 PATH 中找不到 code2prompt 命令，请先安装 code2prompt。'
    return false
  endif
  return true
enddef

# 检查 fzf.vim 是否可用
def CheckFzf(): bool
  if !exists('*fzf#run')
    echoerr 'code2prompt: 找不到 fzf#run 函数，请先安装 fzf 和 fzf.vim。'
    return false
  endif
  return true
enddef

# 从系统剪贴板读取内容
# 优先使用系统命令，回退到 Vim * 寄存器
def GetClipboardContent(): string
  var content: string
  if has('macunix')
    content = system('pbpaste')
  elseif has('x11')
    content = system('xclip -o -selection clipboard')
  else
    # 回退到 Vim 剪贴板寄存器
    content = getreg('*')
  endif
  return content
enddef

# -------------------------------------
# 文件选择后的主处理函数
# -------------------------------------

# 单个文件选择 - 直接处理一个文件
def ProcessSelectedFile(abs_path: string): void
  # 检查文件是否存在且可读
  if !filereadable(abs_path)
    echoerr 'code2prompt: 文件不可读: ' .. abs_path
    return
  endif

  # 直接对单个文件运行 code2prompt
  # code2prompt 会生成 prompt 并通过 -c 复制到剪贴板
  # -l: 输出行号，--line-numbers: 在输出中启用行号
  var cmd = 'code2prompt ' .. shellescape(abs_path) .. ' -l --absolute-paths -c 2>&1'
  var output = system(cmd)

  if v:shell_error != 0
    echoerr 'code2prompt: 命令执行失败: ' .. output
    return
  endif

  # 从系统剪贴板读取实际内容
  # 因为 code2prompt -c 会把实际内容复制到剪贴板，stdout 只输出提示信息
  var clipboard_content = GetClipboardContent()

  # 如果有源文件（本次选择就是从这里发起的）
  # 直接将 code2prompt 输出追加到源文件末尾
  # 这样用户不需要手动从剪贴板粘贴
  var target_origin: string
  if g:code2prompt_origin_file != '' && filereadable(g:code2prompt_origin_file) && filewritable(g:code2prompt_origin_file)
    target_origin = g:code2prompt_origin_file
  else
    # 没有存储的源文件 - 当前缓冲区就是源文件
    # 这就是用户在 fzf 中直接按 Enter 选择的场景
    var current_buf_file = expand('%:p')
    if current_buf_file != '' && filereadable(current_buf_file) && filewritable(current_buf_file)
      target_origin = current_buf_file
    else
      # 没有有效的源文件 - 回退到只复制到剪贴板
      target_origin = ''
    endif
  endif

  if target_origin != '' && len(trim(clipboard_content)) > 0
    var output_lines = split(clipboard_content, '\n', 1)
    var origin_buf = bufadd(target_origin)
    if origin_buf >= 0
      var winview = winsaveview()
      silent exe 'buffer ' .. origin_buf
      normal! G$
      # 如果文件不为空，在新内容前添加空行
      # 如果文件是空的（0 行或第一行为空），直接从第一行插入
      var last_line = line('$')
      if last_line > 0 && trim(getline('$')) != ''
        # 文件已有内容，追加前添加空行
        call append('$', '')
        for line in output_lines
          call append('$', line)
        endfor
      else
        # 文件是空的，从第一行开始插入
        # 因为 append() 是在指定行后添加，所以从后往前插入保持顺序
        for i in range(len(output_lines) - 1, 0, -1)
          call append(0, output_lines[i])
        endfor
      endif
      silent write
      winrestview(winview)

      var display_path = fnamemodify(abs_path, ':~')
      var origin_display = fnamemodify(target_origin, ':~')
      echohl InfoMsg
      echo 'code2prompt: ' .. display_path .. ' 已追加到 ' .. origin_display
      echohl None
      # 清空源文件路径 - 一次性使用
      g:code2prompt_origin_file = ''
      return
    endif
  endif

  # 没有源文件或打开失败或剪贴板为空 - 回退到只复制到剪贴板
  echohl InfoMsg
  echo 'code2prompt: 内容已复制到系统剪贴板来自 ' .. abs_path
  echohl None
enddef

# 处理多选，支持不同按键绑定（支持 Ctrl-T/Ctrl-V/Ctrl-X 打开文件）
# 使用这些快捷键时，在新标签页/分屏打开文件而不是直接处理 code2prompt
# 文件以只读模式打开
def ProcessSelectedFiles(lines: list<any>): void
  # 从全局配置获取默认 fzf 动作映射
  var default_action = {
    'ctrl-t': 'tab split',
    'ctrl-x': 'split',
    'ctrl-v': 'vsplit'
  }
  var actions = default_action
  if exists('g:fzf_action')
    actions = g:fzf_action
  endif

  # --expect 输出格式: 第一行 **总是**按下的按键
  # - 空按键 ("") 表示按下了 Enter（正常选择 -> 作为 code2prompt 处理）
  # - 非空按键匹配我们预期的绑定（ctrl-t/ctrl-x/ctrl-v）-> 在新标签页/分屏打开
  # 第一行之后: 选中的文件名
  if len(lines) < 1
    return
  endif

  # 第一行总是来自 --expect 的按键
  var key = lines[0]

  if key == ''
    # 按下了 Enter（没有使用快捷键）- 正常选择
    # 直接处理文件为 code2prompt
    if len(lines) < 2
      return
    endif
    var abs_path = lines[1]
    ProcessSelectedFile(abs_path)
    return
  endif

  # 按键非空 - 用户按下了我们的一个快捷键（ctrl-t/ctrl-x/ctrl-v）
  # 保存当前文件（code2prompt 就是在这里调用的）作为源文件
  # 之后我们会把选中内容追加回这个源文件
  var current_origin = expand('%:p')
  if current_origin != '' && filereadable(current_origin)
    g:code2prompt_origin_file = current_origin
  endif

  # 只读模式打开文件
  if has_key(actions, key)
    var cmd = actions[key]
    if key == 'ctrl-t' && len(lines) == 2
      # Ctrl-T 单个文件: 打开前记住原始标签页编号
      var origin_tab = tabpagenr()
      var abs_path = lines[1]
      execute cmd .. ' | view ' .. fnameescape(abs_path)
      # 现在我们在新标签页了，先保存原始标签页再关闭
      silent! write
      execute 'silent! tabclose ' .. origin_tab
    else
      # 多个文件或 Ctrl-X/Ctrl-V 分割: 正常打开
      if len(lines) == 2
        # 单个文件
        var abs_path = lines[1]
        execute cmd .. ' | view ' .. fnameescape(abs_path)
      else
        # 多个文件 - 第一行是按键，每个文件都打开
        for abs_path in lines[1 : ]
          execute cmd .. ' | view ' .. fnameescape(abs_path)
        endfor
      endif
    endif
  else
    # 未知按键 - 回退: 把第一行当作文件名
    ProcessSelectedFile(key)
  endif
enddef

# -------------------------------------
# Fzf 文件选择源
# -------------------------------------

def Code2PromptFzf(start_path: string, include_hidden: bool = false): void
  # 构建 walker-skip 列表:
  # 总是跳过 .git（太多内部文件）和常见大目录
  # include_hidden 为 false（默认）时: 还跳过所有其他以 . 开头的隐藏目录
  # include_hidden 为 true 时: 只跳过 .git，显示其他隐藏文件/目录
  var skip_dirs: string

  if include_hidden
    # 只跳过 .git 和常见大项目目录（按basename）
    # 保留 **所有其他** 隐藏文件/目录（包括 .claude, .gitignore 等）
    skip_dirs = '.git,node_modules,target,venv,.venv'
  else
    # 跳过 **所有** 以 . 开头的隐藏目录加上常见大目录
    # .* 匹配任何以点开头的隐藏文件/目录
    skip_dirs = '.*,.git,node_modules,target,venv,.venv'
  endif

  # 构建 fzf 选项为列表（每个选项是单独的列表项 - fzf.vim 要求的正确格式）
  var fzf_options: list<any> = []

  # 基础布局
  add(fzf_options, '--layout=reverse')
  add(fzf_options, '--info=inline')
  add(fzf_options, '--height=40%')

  # Walker 设置: 只列出文件，跟随符号链接，跳过配置的目录
  # include_hidden 为 true 时给 walker 添加 'hidden' - 启用显示隐藏文件/目录
  if include_hidden
    add(fzf_options, '--walker=file,follow,hidden')
  else
    add(fzf_options, '--walker=file,follow')
  endif
  add(fzf_options, '--walker-skip')
  add(fzf_options, skip_dirs)

  # 为 Ctrl-T/Ctrl-X/Ctrl-V 期望按键绑定 - 允许在新标签页/分屏打开
  add(fzf_options, '--expect')
  add(fzf_options, 'ctrl-t,ctrl-x,ctrl-v')

  # 自定义提示符（每部分单独列表项，不需要引号 - fzf.vim 会自动转义）
  if include_hidden
    add(fzf_options, '--prompt')
    add(fzf_options, 'code2prompt (含隐藏) > ')
  else
    add(fzf_options, '--prompt')
    add(fzf_options, 'code2prompt > ')
  endif

  # 直接使用 fzf#run 配合 fzf#wrap - 让 fzf 处理目录遍历
  # fzf 内部处理跳过，Vimscript 不需要遍历，大项目不会卡住
  # 使用 fzf#vim#with_preview 添加文件预览（和 :Files 命令一样）
  # 使用 sink* 而不是 sink 来支持多个按键绑定（Ctrl-T/Ctrl-V/Ctrl-X）
  var spec = {
    'cwd': start_path,
    'sink*': function('ProcessSelectedFiles'),
    'options': fzf_options
  }
  # 使用 fzf.vim 的 with_preview 助手启用预览窗口
  # 这会自动:
  # - 添加 --preview 使用支持 bat 语法高亮的 preview.sh 脚本
  # - 添加 --preview-window 使用默认配置（尊重 g:fzf_vim.preview_window）
  # - 添加按键 ctrl-/ 切换预览窗口
  # - 自动处理 bat 检测
  var wrapped_spec = fzf#vim#with_preview(spec)
  call fzf#run(wrapped_spec)
enddef

# -------------------------------------
# 主用户命令
# -------------------------------------

def Code2PromptCommand(line1: number, line2: number, args: string = ''): void
  # 检查是否有激活的可视区域选择
  # 当从可视模式使用 :'<,'>command 时，line1 和 line2 总会被设置
  # 即使单行选择，line1 == line2 但我们仍然有选择
  # 检查 visualmode() 确认我们来自可视模式
  if visualmode() != ''
    # 用户可视选择了文本 - 使用 code2prompt 处理选择
    Code2PromptProcessSelection(line1, line2)
    return
  endif

  # 没有选择 - 继续原始逻辑
  # 先检查所有依赖
  if !CheckCode2prompt()
    return
  endif
  if !CheckFzf()
    return
  endif

  # 确定起始路径
  var start_path: string

  if args != ''
    # 用户提供了路径参数
    start_path = expand(args)
  else
    # 默认: 当前工作目录
    start_path = getcwd()
  endif

  # 归一化为绝对路径
  if !isdirectory(expand(start_path))
    if filereadable(expand(start_path))
      # 如果是文件，使用它的目录
      start_path = fnamemodify(start_path, ':h')
    else
      echoerr 'code2prompt: 路径不存在: ' .. start_path
      return
    endif
  endif

  # 转换为绝对路径
  start_path = fnamemodify(start_path, ':p')

  # 开始 fzf 选择（排除隐藏文件，默认行为）
  Code2PromptFzf(start_path, false)
enddef

# 处理可视区域选中文本 - 直接带着源信息追加到源文件
def Code2PromptProcessSelection(line1: number, line2: number): void
  # line1 和 line2 已经从命令传入

  # 获取选中的文本
  var selected_lines = getline(line1, line2)
  if len(selected_lines) == 0
    echoerr 'code2prompt: 没有选中文本'
    return
  endif

  # 获取当前文件绝对路径（选择是在这里做的）
  var current_file = expand('%:p')
  if current_file == ''
    echoerr 'code2prompt: 无法获取当前文件名'
    return
  endif

  # 使用波浪路径显示
  var display_path = fnamemodify(current_file, ':~')

  # 在代码块外前置源信息头: 文件路径加行号范围
  var content_lines: list<string> = []
  add(content_lines, 'File: ' .. display_path .. ' (lines: ' .. string(line1) .. '-' .. string(line2) .. ')')
  add(content_lines, '```')
  # 原样添加选中行，保持原始缩进
  for line in selected_lines
    add(content_lines, line)
  endfor
  add(content_lines, '```')
  add(content_lines, '')

  # 检查是否有有效的源文件可以追加
  if g:code2prompt_origin_file != '' && filereadable(g:code2prompt_origin_file)
    # 分支 1: 有有效源文件 - 追加到**源文件末尾**
    # 在后台打开源文件，追加，保存，关闭
    # 我们静默操作避免打扰用户
    var origin_buf = bufadd(g:code2prompt_origin_file)
    if origin_buf < 0
      echoerr 'code2prompt: 无法打开源文件: ' .. g:code2prompt_origin_file
      g:code2prompt_origin_file = ''
      return
    endif

    # 保持原始窗口视图
    var winview = winsaveview()
    silent exe 'buffer ' .. origin_buf
    normal! G$
    # 在末尾追加每个内容行
    for line in content_lines
      call append('$', line)
    endfor
    silent write
    winrestview(winview)

    # 清空源文件 - 这只是一次性使用
    var origin_path = g:code2prompt_origin_file
    g:code2prompt_origin_file = ''

    echohl InfoMsg
    echo 'code2prompt: 选中 ' .. display_path .. ' 行 ' .. string(line1) .. '-' .. string(line2) .. ' 已追加到 ' .. fnamemodify(origin_path, ':~')
    echohl None
  else
    # 分支 2: 没有源文件 - 格式化内容复制到系统剪贴板
    # 合并所有行为单个字符串
    var full_content = join(content_lines, "\n")

    # 根据 OS 复制到剪贴板
    if has('macunix')
      # macOS: 使用 pbcopy
      call system('pbcopy', split(full_content, "\n"))
    else
      # Linux: 使用 xclip
      call system('xclip -selection clipboard', split(full_content, "\n"))
    endif

    echohl InfoMsg
    echo 'code2prompt: 选中 ' .. display_path .. ' 行 ' .. string(line1) .. '-' .. string(line2) .. ' 已复制到剪贴板'
    echohl None
  endif
enddef

def Code2PromptWithHiddenFileCommand(line1: number, line2: number, args: string = ''): void
  # 检查是否有激活的可视区域选择
  # 当从可视模式使用 :'<,'>command 时，line1 和 line2 总会被设置
  # 即使单行选择，line1 == line2 但我们仍然有选择
  # 检查 visualmode() 确认我们来自可视模式
  if visualmode() != ''
    # 用户可视选择了文本 - 使用 code2prompt 处理选择
    Code2PromptProcessSelection(line1, line2)
    return
  endif

  # 没有选择 - 继续原始逻辑
  # 先检查所有依赖
  if !CheckCode2prompt()
    return
  endif
  if !CheckFzf()
    return
  endif

  # 确定起始路径
  var start_path: string

  if args != ''
    # 用户提供了路径参数
    start_path = expand(args)
  else
    # 默认: 当前工作目录
    start_path = getcwd()
  endif

  # 归一化为绝对路径
  if !isdirectory(expand(start_path))
    if filereadable(expand(start_path))
      # 如果是文件，使用它的目录
      start_path = fnamemodify(start_path, ':h')
    else
      echoerr 'code2prompt: 路径不存在: ' .. start_path
      return
    endif
  endif

  # 转换为绝对路径
  start_path = fnamemodify(start_path, ':p')

  # 开始 fzf 选择（包含隐藏文件，除了 .git）
  Code2PromptFzf(start_path, true)
enddef

# 创建用户命令（按 Vim 规则必须以大写开头）
# -range: 允许可视选择，传递 <line1> <line2>
command! -range -nargs=* Code2Prompt :call Code2PromptCommand(<line1>, <line2>, <q-args>)
# 允许小写 :code2prompt 通过缩写
cabbrev code2prompt Code2Prompt

# 创建包含隐藏文件的命令（除了 .git）
# -range: 允许可视选择，传递 <line1> <line2>
command! -range -nargs=* Code2PromptWithHiddenFile :call Code2PromptWithHiddenFileCommand(<line1>, <line2>, <q-args>)
# 通过缩写允许小写（连字符不好用 cabbrev，所以改用下划线）
cabbrev code2prompt_with_hidden Code2PromptWithHiddenFile

# -------------------------------------
# Claude Code 外部编辑器自动检测
# -------------------------------------

# Vim 启动时自动检测 Claude Code 临时文件并处理 @ 语法
# 只在以下情况触发:
# 1. Vim 启动只打开这一个文件（就是 Claude 临时文件）
# 2. 文件恰好只有一行
# 3. 该行以 @ 开头（Claude Code 文件选择格式）
def HandleClaudeCodeStartup(): void
  # 只在以下情况运行:
  # - 只有一个缓冲区打开（Vim 直接启动编辑这个文件）
  # - 文件恰好只有一行
  # - 行以 @ 开头
  # - 文件可写（跳过 ctrl-t 打开的只读文件）
  if len(getbufinfo({'buflisted': 1})) != 1
    return
  endif

  if !filewritable(expand('%:p'))
    return
  endif

  var lines = getline(1, '$')
  if len(lines) != 1
    return
  endif

  var content = trim(lines[0])
  if len(content) == 0 || content[0] != '@'
    return
  endif

  # 提取 @ 之后的路径部分
  var path_part = trim(content[1 : ])
  var current_file = expand('%:p')

  # 清空原始行（用户要求: 处理前先清空文件）
  # 删除所有内容（我们已经知道只有一行）
  call deletebufline('', 1, '$')
  silent! write  # 先保存空状态再继续

  if path_part == ''
    # 情况 1: 仅仅 @ - 直接打开 code2Prompt 选择框
    echohl InfoMsg
    echo 'code2prompt: 检测到空 @ 语法，打开文件选择器...'
    echohl None
    # 直接执行打开文件选择器
    execute('Code2Prompt')
    silent! write
    return
  endif

  # 路径相对于项目根目录（当前工作目录）
  # 因为 Claude Code 从项目根目录启动
  var abs_path = fnamemodify(path_part, ':p')

  if isdirectory(abs_path)
    # 情况 2: @目录/ - 处理整个目录
    echohl InfoMsg
    echo 'code2prompt: 处理目录: ' .. path_part
    echohl None

    var target_dir = abs_path
    # 目录: 需要包含里面所有文件
    # code2prompt -c: 输出复制到剪贴板，stdout 只输出提示信息
    var cmd = 'code2prompt ' .. shellescape(target_dir) .. ' -l --absolute-paths -c 2>&1'
    var output = system(cmd)

    if v:shell_error != 0
      echoerr 'code2prompt: 命令执行失败: ' .. output
      return
    endif

    # 从系统剪贴板读取实际内容，因为 -c 复制到剪贴板
    var clipboard_content = GetClipboardContent()

    if len(trim(clipboard_content)) > 0
      # 分割剪贴板内容为行并追加到当前文件
      var output_lines = split(clipboard_content, '\n', 1)
      # 从第一行开始追加所有输出行（缓冲区已经是空的）
      call append(0, output_lines)
      silent! write

      echohl InfoMsg
      echo 'code2prompt: 目录 ' .. path_part .. ' 内容已插入当前文件'
      echohl None
    endif
  elseif filereadable(abs_path)
    # 情况 3: @文件/路径 - 单个文件，使用现有处理
    echohl InfoMsg
    echo 'code2prompt: 处理文件: ' .. path_part
    echohl None

    # 获取这个单个文件的 code2prompt 输出
    # -c: 输出复制到剪贴板，stdout 只输出提示信息
    var cmd = 'code2prompt ' .. shellescape(abs_path) .. ' -l --absolute-paths -c 2>&1'
    var output = system(cmd)

    if v:shell_error != 0
      echoerr 'code2prompt: 命令执行失败: ' .. output
      return
    endif

    # 从系统剪贴板读取实际内容，因为 -c 复制到剪贴板
    var clipboard_content = GetClipboardContent()

    if len(trim(clipboard_content)) > 0
      # 分割剪贴板内容为行并追加到当前文件
      var output_lines = split(clipboard_content, '\n', 1)
      # 从第一行开始追加所有输出行（缓冲区已经是空的）
      call append(0, output_lines)
      silent! write

      echohl InfoMsg
      echo 'code2prompt: 文件 ' .. path_part .. ' 内容已插入当前文件'
      echohl None
    endif
  else
    # 路径找不到 - 不做任何事，让用户手动编辑
    echohl WarningMsg
    echo 'code2prompt: 路径不存在: ' .. abs_path .. ' - 保持原样'
    echohl None
  endif
enddef

# 自动命令在 Vim 启动运行检测
augroup Code2PromptClaudeDetection
  autocmd!
  # Vim 启动完成缓冲区加载后运行
  autocmd VimEnter * ++once call HandleClaudeCodeStartup()
augroup END

# -------------------------------------
# 插件结束
# -------------------------------------
