" Vim9 plugin for code2prompt integration
" Requires: Vim 9+, fzf.vim, code2prompt in PATH
" Description: Select a file via fzf and insert code2prompt output at cursor

vim9script

# Only load once
if exists('g:loaded_code2prompt')
  finish
endif
g:loaded_code2prompt = 1

# Store the origin file path where code2prompt was originally invoked from
# When you open a new file via Ctrl-T/Ctrl-V/Ctrl-X, we remember where you came from
# After appending selected content to origin file, we clear it
g:code2prompt_origin_file = ''

# -------------------------------------
# Check dependencies
# -------------------------------------

# Check if code2prompt is available in PATH
def CheckCode2prompt(): bool
  # Use exepath to check if command exists
  if exepath('code2prompt') == ''
    echoerr 'code2prompt: command not found in PATH. Please install code2prompt first.'
    return false
  endif
  return true
enddef

# Check if fzf.vim is available
def CheckFzf(): bool
  if !exists('*fzf#run')
    echoerr 'code2prompt: fzf#run function not found. Please install fzf and fzf.vim first.'
    return false
  endif
  return true
enddef

# Check if git is available when needed
def CheckGit(): bool
  if exepath('git') == ''
    echoerr 'code2prompt: git command not found in PATH.'
    return false
  endif
  return true
enddef

# -------------------------------------
# Get file list based on git project detection
# -------------------------------------

def IsGitRepository(start_dir: string): bool
  # Check if we're in a git repository
  return system('git -C ' .. shellescape(start_dir) .. ' rev-parse --is-inside-work-tree 2>/dev/null') =~ '^true'
enddef

def ReadGitIgnore(repo_root: string): list<any>
  # Read .gitignore from repository root, extract exclude patterns
  var gitignore_path = repo_root .. '/.gitignore'
  if !filereadable(gitignore_path)
    return []
  endif

  var lines = readfile(gitignore_path)
  var patterns: list<any> = []

  for line in lines
    var trimmed = trim(line)
    # Skip empty lines and comments
    if trimmed == '' || trimmed[0] == '#'
      continue
    endif
    # Skip negation patterns (we don't handle complex rules anyway)
    if trimmed[0] == '!'
      continue
    endif
    # Add the pattern
    add(patterns, trimmed)
  endfor

  return patterns
enddef

def GetGitFileList(start_dir: string): list<any>
  # Get repository root
  var repo_root = system('git -C ' .. shellescape(start_dir) .. ' rev-parse --show-toplevel')->trim()
  if repo_root == ''
    return []
  endif

  # Get all files recursively from repo root
  var all_files = GetAllFiles(repo_root)
  return all_files
enddef

def GetAllFiles(start_dir: string, depth: number = 10): list<any>
  # Non-git project: recursively find all files from starting directory
  # Limit depth to avoid infinite recursion
  # Skip .git directory to avoid processing thousands of git internal files
  var files: list<string> = []

  def Walk(dir: string, current_depth: number): void
    if current_depth > depth
      return
    endif

    var items = glob(dir .. '/*', v:false)
    for item in items
      if isdirectory(item)
        # Skip .git directory - it contains lots of internal files we don't need
        if fnamemodify(item, ':t') != '.git'
          Walk(item, current_depth + 1)
        endif
      elseif filereadable(item)
        add(files, item)
      endif
    endfor
  enddef

  if isdirectory(start_dir)
    Walk(start_dir, 0)
  endif

  return files
enddef

# -------------------------------------
# Main handler after file selection
# -------------------------------------

# Single file selection - one file directly processed
def ProcessSelectedFile(abs_path: string): void
  # Check if file exists and is readable
  if !filereadable(abs_path)
    echoerr 'code2prompt: file not readable: ' .. abs_path
    return
  endif

  # Run code2prompt on the file's directory, include only this file
  # code2prompt will generate the prompt and copy to clipboard with -c
  # -l: output line numbers, --line-numbers: enable line numbers in output
  var target_dir = fnamemodify(abs_path, ':h')
  var file_name = fnamemodify(abs_path, ':t')
  var cmd = 'code2prompt ' .. shellescape(target_dir) .. ' --include ' .. shellescape(file_name) .. ' -l --absolute-paths -c 2>&1'
  var output = system(cmd)

  if v:shell_error != 0
    echoerr 'code2prompt: command failed with error: ' .. output
    return
  endif

  echohl InfoMsg
  echo 'code2prompt: content copied to system clipboard from ' .. abs_path
  echohl None
enddef

# Handle multiple selections with different key bindings (supports Ctrl-T/Ctrl-V/Ctrl-X to open files)
# When using these shortcut keys, open files in new tab/split instead of processing for code2prompt
# Files are opened in read-only mode
def ProcessSelectedFiles(lines: list<any>): void
  # Get default fzf action mapping from global config
  var default_action = {
    'ctrl-t': 'tab split',
    'ctrl-x': 'split',
    'ctrl-v': 'vsplit'
  }
  var actions = default_action
  if exists('g:fzf_action')
    actions = g:fzf_action
  endif

  # --expect output format: first line is ALWAYS the key pressed
  # - Empty key ("") means Enter was pressed (normal selection -> process as code2prompt)
  # - Non-empty key matches our expected bindings (ctrl-t/ctrl-x/ctrl-v) -> open in new tab/split
  # After first line: the selected filenames
  if len(lines) < 1
    return
  endif

  # First line is always the key from --expect
  var key = lines[0]

  if key == ''
    # Enter pressed (no shortcut key used) - normal selection
    # Process the file directly with code2prompt
    if len(lines) < 2
      return
    endif
    var abs_path = lines[1]
    ProcessSelectedFile(abs_path)
    return
  endif

  # Key is not empty - user pressed one of our shortcut keys (ctrl-t/ctrl-x/ctrl-v)
  # Save the current file (where code2prompt was invoked) as origin file
  # We will append selected content back to this origin file later
  var current_origin = expand('%:p')
  if current_origin != '' && filereadable(current_origin)
    g:code2prompt_origin_file = current_origin
  endif

  # Open the file(s) in read-only mode
  if has_key(actions, key)
    var cmd = actions[key]
    if key == 'ctrl-t' && len(lines) == 2
      # For Ctrl-T single file: remember original tab number before opening
      var origin_tab = tabpagenr()
      var abs_path = lines[1]
      execute cmd .. ' | view ' .. fnameescape(abs_path)
      # Close the original origin tab now that we're in new tab
      execute 'silent tabclose ' .. origin_tab
    else
      # Multiple files or Ctrl-X/Ctrl-V split: normal opening
      if len(lines) == 2
        # Single file
        var abs_path = lines[1]
        execute cmd .. ' | view ' .. fnameescape(abs_path)
      else
        # Multiple files - first line is key, open each file
        for abs_path in lines[1 : ]
          execute cmd .. ' | view ' .. fnameescape(abs_path)
        endfor
      endif
    endif
  else
    # Unknown key - fallback: treat first line as filename
    ProcessSelectedFile(key)
  endif
enddef

# -------------------------------------
# Fzf source for file selection
# -------------------------------------

def Code2PromptFzf(start_path: string, include_hidden: bool = false): void
  # Build walker-skip list:
  # Always skip .git (too many internal files) and common large directories
  # When include_hidden is false (default): also skip all other hidden directories starting with .
  # When include_hidden is true: only skip .git, show other hidden files/directories
  var skip_dirs: string

  if include_hidden
    # Only skip .git directory and common large project directories (by basename)
    # Keep ALL OTHER hidden files/directories (including .claude, .gitignore, etc.)
    skip_dirs = '.git,node_modules,target,venv,.venv'
  else
    # Skip ALL hidden directories starting with . plus common large directories
    # .* matches any hidden file/directory starting with dot
    skip_dirs = '.*,.git,node_modules,target,venv,.venv'
  endif

  # Build fzf options as a list (each option is separate list item - correct format for fzf.vim)
  var fzf_options: list<any> = []

  # Basic layout
  add(fzf_options, '--layout=reverse')
  add(fzf_options, '--info=inline')
  add(fzf_options, '--height=40%')

  # Walker settings: only list files, follow symlinks, skip configured directories
  # Add 'hidden' to walker when include_hidden is true - enables showing hidden files/directories
  if include_hidden
    add(fzf_options, '--walker=file,follow,hidden')
  else
    add(fzf_options, '--walker=file,follow')
  endif
  add(fzf_options, '--walker-skip')
  add(fzf_options, skip_dirs)

  # Expect key bindings for Ctrl-T/Ctrl-X/Ctrl-V - enables opening in new tab/split
  add(fzf_options, '--expect')
  add(fzf_options, 'ctrl-t,ctrl-x,ctrl-v')

  # Custom prompt (each part is separate list item, no quotes needed - fzf.vim escapes automatically)
  if include_hidden
    add(fzf_options, '--prompt')
    add(fzf_options, 'code2prompt (incl. hidden) > ')
  else
    add(fzf_options, '--prompt')
    add(fzf_options, 'code2prompt > ')
  endif

  # Directly use fzf#run with fzf#wrap - let fzf do the directory walking
  # fzf handles skipping internally, no Vimscript traversal, won't freeze on large projects
  # Add file preview using fzf#vim#with_preview (same as :Files command)
  # Use sink* instead of sink to support multiple key bindings (Ctrl-T/Ctrl-V/Ctrl-X)
  var spec = {
    'cwd': start_path,
    'sink*': function('ProcessSelectedFiles'),
    'options': fzf_options
  }
  # Use fzf.vim's with_preview helper to enable preview window
  # This automatically:
  # - Adds --preview with the preview.sh script that supports bat syntax highlighting
  # - Adds --preview-window with default configuration (respects g:fzf_vim.preview_window)
  # - Adds key binding (ctrl-/) to toggle preview window
  # - Handles bat detection automatically
  var wrapped_spec = fzf#vim#with_preview(spec)
  call fzf#run(wrapped_spec)
enddef

# -------------------------------------
# Main user command
# -------------------------------------

def Code2PromptCommand(line1: number, line2: number, args: string = ''): void
  # Check if there is an active visual selection
  # When using :'<,'>command from visual mode, line1 and line2 are always set
  # Even for single-line selection, line1 == line2 but we still have a selection
  # Check visualmode() to confirm we came from visual mode
  if visualmode() != ''
    # User has visually selected text - process selection with code2prompt
    Code2PromptProcessSelection(line1, line2)
    return
  endif

  # NO selection - continue with original logic
  # Check all dependencies first
  if !CheckCode2prompt()
    return
  endif
  if !CheckFzf()
    return
  endif

  # Determine starting path
  var start_path: string

  if args != ''
    # User provided path argument
    start_path = expand(args)
  else
    # Default: current working directory
    start_path = getcwd()
  endif

  # Normalize path to absolute
  if !isdirectory(expand(start_path))
    if filereadable(expand(start_path))
      # If it's a file, use its directory
      start_path = fnamemodify(start_path, ':h')
    else
      echoerr 'code2prompt: path not found: ' .. start_path
      return
    endif
  endif

  # Convert to absolute path
  start_path = fnamemodify(start_path, ':p')

  # Start fzf selection (exclude hidden files, default behavior)
  Code2PromptFzf(start_path, false)
enddef

# Process visually selected text - directly append to origin file with source info
def Code2PromptProcessSelection(line1: number, line2: number): void
  # line1 and line2 already passed from command

  # Get the selected text
  var selected_lines = getline(line1, line2)
  if len(selected_lines) == 0
    echoerr 'code2prompt: no text selected'
    return
  endif

  # Get current file absolute path (the file where selection was made)
  var current_file = expand('%:p')
  if current_file == ''
    echoerr 'code2prompt: cannot get current file name'
    return
  endif

  # Use tilde path for display
  var display_path = fnamemodify(current_file, ':~')

  # Prepend source header: file path with line range outside code block
  var content_lines: list<string> = []
  add(content_lines, 'File: ' .. display_path .. ' (lines: ' .. string(line1) .. '-' .. string(line2) .. ')')
  add(content_lines, '```')
  # Add the selected lines as-is, keep original indentation
  for line in selected_lines
    add(content_lines, line)
  endfor
  add(content_lines, '```')
  add(content_lines, '')

  # Check if we have a valid origin file to append to
  if g:code2prompt_origin_file != '' && filereadable(g:code2prompt_origin_file)
    # Branch 1: have valid origin file - append to the END of origin file
    # Open origin file in the background, append, save, close
    # We do this silently to avoid disrupting user
    var origin_buf = bufadd(g:code2prompt_origin_file)
    if origin_buf < 0
      echoerr 'code2prompt: cannot open origin file: ' .. g:code2prompt_origin_file
      g:code2prompt_origin_file = ''
      return
    endif

    # Keep the original window view
    var winview = winsaveview()
    silent exe 'buffer ' .. origin_buf
    normal! G$
    # Append each content line at the end
    for line in content_lines
      call append('$', line)
    endfor
    silent write
    winrestview(winview)

    # Clear the origin file - this is one-time use only
    var origin_path = g:code2prompt_origin_file
    g:code2prompt_origin_file = ''

    echohl InfoMsg
    echo 'code2prompt: selected ' .. display_path .. ' lines ' .. string(line1) .. '-' .. string(line2) .. ' appended to ' .. fnamemodify(origin_path, ':~')
    echohl None
  else
    # Branch 2: no origin file - copy formatted content to system clipboard
    # Join all lines into single string
    var full_content = join(content_lines, "\n")

    # Copy to clipboard based on OS
    if has('macunix')
      # macOS: use pbcopy
      call system('pbcopy', split(full_content, "\n"))
    else
      # Linux: use xclip
      call system('xclip -selection clipboard', split(full_content, "\n"))
    endif

    echohl InfoMsg
    echo 'code2prompt: selected ' .. display_path .. ' lines ' .. string(line1) .. '-' .. string(line2) .. ' copied to clipboard'
    echohl None
  endif
enddef

def Code2PromptWithHiddenFileCommand(line1: number, line2: number, args: string = ''): void
  # Check if there is an active visual selection
  # When using :'<,'>command from visual mode, line1 and line2 are always set
  # Even for single-line selection, line1 == line2 but we still have a selection
  # Check visualmode() to confirm we came from visual mode
  if visualmode() != ''
    # User has visually selected text - process selection with code2prompt
    Code2PromptProcessSelection(line1, line2)
    return
  endif

  # NO selection - continue with original logic
  # Check all dependencies first
  if !CheckCode2prompt()
    return
  endif
  if !CheckFzf()
    return
  endif

  # Determine starting path
  var start_path: string

  if args != ''
    # User provided path argument
    start_path = expand(args)
  else
    # Default: current working directory
    start_path = getcwd()
  endif

  # Normalize path to absolute
  if !isdirectory(expand(start_path))
    if filereadable(expand(start_path))
      # If it's a file, use its directory
      start_path = fnamemodify(start_path, ':h')
    else
      echoerr 'code2prompt: path not found: ' .. start_path
      return
    endif
  endif

  # Convert to absolute path
  start_path = fnamemodify(start_path, ':p')

  # Start fzf selection (include hidden files, except .git)
  Code2PromptFzf(start_path, true)
enddef

# Create the user command (must start with uppercase per Vim rules)
# -range: allow visual selection, passes <line1> <line2>
command! -range -nargs=* Code2Prompt :call Code2PromptCommand(<line1>, <line2>, <q-args>)
# Allow lowercase :code2prompt via abbreviation
cabbrev code2prompt Code2Prompt

# Create the command that includes hidden files (except .git)
# -range: allow visual selection, passes <line1> <line2>
command! -range -nargs=* Code2PromptWithHiddenFile :call Code2PromptWithHiddenFileCommand(<line1>, <line2>, <q-args>)
# Allow lowercase via abbreviation (use underscore instead of hyphen - cabbrev doesn't work well with hyphen)
cabbrev code2prompt_with_hidden Code2PromptWithHiddenFile

# -------------------------------------
# End of plugin
# -------------------------------------
