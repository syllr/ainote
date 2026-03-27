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
  # Get exclude patterns from .gitignore
  var exclude_patterns: list<string> = []
  var repo_root: string = ''

  if IsGitRepository(start_path)
    if !CheckGit()
      return
    endif
    repo_root = system('git -C ' .. shellescape(start_path) .. ' rev-parse --show-toplevel')->trim()
    # Read exclude patterns from .gitignore
    exclude_patterns = ReadGitIgnore(repo_root)
  endif

  # Build fzf options as a list (fzf.vim expects options to be a list, not a string)
  # fzf 内置目录遍历，一次性应用所有 exclude 规则
  # 不用 Vimscript 自己全量遍历，避免大目录卡死
  # Options must be a list (each element is one argument) for correct merging with fzf.vim defaults
  var fzf_options: list<string> = []
  # Add walker settings: only files, follow symlinks
  add(fzf_options, '--walker=file,follow')
  # Default skip common large directories that don't need to be searched
  add(fzf_options, '--walker-skip=.git,node_modules,target,venv,.venv')
  # Add --exclude for each gitignore pattern
  # Each pattern is a separate argument in the list
  for pattern in exclude_patterns
    add(fzf_options, '--exclude')
    add(fzf_options, pattern)
  endfor

  # Use fzf.vim built-in file browsing with our exclude patterns
  # All gitignore exclusives are passed as --exclude directly to fzf
  # This avoids full directory traversal in Vimscript, won't freeze on large projects
  call fzf#vim#files(start_path, {
  \ 'sink': function('ProcessSelectedFile'),
  \ 'options': fzf_options,
  \ 'prompt': 'code2prompt > ',
  \ }, 0)
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
