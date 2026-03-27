" Vim9 plugin for code2prompt integration
" Requires: Vim 9+, fzf.vim, code2prompt in PATH
" Description: Select a file via fzf and insert code2prompt output at cursor

vim9script

# Only load once
if exists('g:loaded_code2prompt')
  finish
endif
g:loaded_code2prompt = 1

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

def ReadGitIgnore(repo_root: string): list<string>
  # Read .gitignore from repository root, extract exclude patterns
  var gitignore_path = repo_root .. '/.gitignore'
  if !filereadable(gitignore_path)
    return []
  endif

  var lines = readfile(gitignore_path)
  var patterns: list<string> = []

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

def GetGitFileList(start_dir: string): list<string>
  # Get repository root
  var repo_root = system('git -C ' .. shellescape(start_dir) .. ' rev-parse --show-toplevel')->trim()
  if repo_root == ''
    return []
  endif

  # Get all files recursively from repo root
  var all_files = GetAllFiles(repo_root)
  return all_files
enddef

def GetAllFiles(start_dir: string, depth: number = 10): list<string>
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
  var target_dir = fnamemodify(abs_path, ':h')
  var file_name = fnamemodify(abs_path, ':t')
  var cmd = 'code2prompt ' .. shellescape(target_dir) .. ' --include ' .. shellescape(file_name) .. ' -c 2>&1'
  var output = system(cmd)

  if v:shell_error != 0
    echoerr 'code2prompt: command failed with error: ' .. output
    return
  endif

  echohl InfoMsg
  echo 'code2prompt: content copied to system clipboard from ' .. abs_path
  echohl None
enddef

# -------------------------------------
# Fzf source for file selection
# -------------------------------------

def Code2PromptFzf(start_path: string): void
  # Build walker-skip list:
  # 1. Skip all hidden directories (starting with .) - .git, .github, .vscode etc.
  # 2. Plus common large directories that don't need to be searched
  var skip_dirs = '*.git,node_modules,target,venv,.venv'

  # Build fzf options as a list (each option is separate list item - correct format for fzf.vim)
  var fzf_options: list<string> = []

  # Basic layout
  add(fzf_options, '--layout=reverse')
  add(fzf_options, '--info=inline')
  add(fzf_options, '--height=40%')

  # Walker settings: only list files, follow symlinks, skip configured directories
  add(fzf_options, '--walker=file,follow')
  add(fzf_options, '--walker-skip')
  add(fzf_options, skip_dirs)

  # Custom prompt (each part is separate list item, no quotes needed - fzf.vim escapes automatically)
  add(fzf_options, '--prompt')
  add(fzf_options, 'code2prompt > ')

  # Directly use fzf#run with fzf#wrap - let fzf do the directory walking
  # fzf handles skipping internally, no Vimscript traversal, won't freeze on large projects
  call fzf#run(fzf#wrap({
  \ 'cwd': start_path,
  \ 'sink': function('ProcessSelectedFile'),
  \ 'options': fzf_options,
  \ }))
enddef

# -------------------------------------
# Main user command
# -------------------------------------

def Code2PromptCommand(args: string = ''): void
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

  # Start fzf selection
  Code2PromptFzf(start_path)
enddef

# Create the user command (must start with uppercase per Vim rules)
command! -nargs=* Code2Prompt :call Code2PromptCommand(<q-args>)
# Allow lowercase :code2prompt via abbreviation
cabbrev code2prompt Code2Prompt

# -------------------------------------
# End of plugin
# -------------------------------------
