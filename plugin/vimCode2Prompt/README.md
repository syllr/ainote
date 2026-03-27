# vimCode2Prompt

Vim 9+ plugin for integrating [code2prompt](https://github.com/gabotechs/code2prompt) into Vim.

Select a file via TUI (fzf) and insert the code2prompt-formatted output at your current cursor position.

## Requirements

- **Vim 9.0+** (only Vim 9+ is supported, no Neovim support)
- **code2prompt** - must be installed and available in your system `PATH`
- **fzf** - the command-line fuzzy finder
- **fzf.vim** - Vim plugin for fzf

## Installation

### 1. Install code2prompt

Make sure `code2prompt` is installed and in your PATH:

```bash
# Verify installation
which code2prompt
```

If not installed, install it according to code2prompt documentation.

### 2. Install fzf and fzf.vim

**Install fzf (command-line tool):**

```bash
# macOS (Homebrew)
brew install fzf

# Ubuntu/Debian
sudo apt install fzf

# Other systems
# See https://github.com/junegunn/fzf#installation
```

**Install fzf.vim (Vim plugin):**

Using Vim 9 package:
```vim
# Add to your vimrc
packadd fzf.vim
```

Using Pathogen:
```
git clone https://github.com/junegunn/fzf.vim.git ~/.vim/bundle/fzf.vim
```

Using Vundle:
```vim
Plugin 'junegunn/fzf.vim'
```

### 3. Install this plugin

The plugin is located at: `/Users/yutao/ainote/plugin/vimCode2Prompt/`

Add this line to your `~/.vimrc` to load the plugin:

```vim
# Add to ~/.vimrc - load code2prompt plugin
source /Users/yutao/ainote/plugin/vimCode2Prompt/plugin/code2prompt.vim
```

Or if you use Vim 9 packages:
```vim
packadd! code2prompt
```

## Usage

From Vim, run:

```vim
:code2prompt
```

This will:
1. Detect if you're in a git repository
   - If yes: uses `git ls-files` to get all tracked files (automatically respects .gitignore)
   - If no: recursively finds all files starting from current directory
2. Open fzf TUI for interactive fuzzy filtering
3. Select a file by pressing Enter
4. `code2prompt <selected-file> -c` is called, which copies the formatted output to system clipboard
5. The clipboard content is automatically inserted at your current cursor position

### With path argument

You can specify a starting path:

```vim
:code2prompt path/to/directory
```

This will search for files only within that directory.

## Features

- ✅ Automatic dependency checking - clear error if code2prompt or fzf not found
- ✅ Git aware - automatically respects .gitignore via git ls-files
- ✅ Non-git project support - recursively scans directory
- ✅ Handles absolute/relative paths correctly
- ✅ Inserts at cursor position - preserves existing text before/after cursor
- ✅ Works with multi-line content correctly
- ✅ Vim 9+ native script - modern clean syntax

## Troubleshooting

### Check if plugin loaded correctly

After starting Vim, run:

```vim
:echo g:loaded_code2prompt
```

You should see output `1`. If not, plugin didn't load correctly - check your vimrc path.

### Check if command exists

```vim
:command Code2Prompt
```

Should show the command definition: `Code2Prompt       -nargs=*  call Code2PromptCommand(<q-args>)`

### Check Vim version

Make sure you're running Vim 9+:

```vim
:version
```

Look at the first line - should say `VIM - Vi IMproved 9.X`

### Check code2prompt in Vim

```vim
:!echo exepath('code2prompt')
```

Should output the full path to code2prompt. If empty, code2prompt is not in PATH.

### Check fzf.vim loaded

```vim
:echo exists('*fzf#run')
```

Should output `1`. If `0`, fzf.vim is not loaded correctly.

### Check runtime log for errors

Enable logging before starting Vim:

```bash
vim -V10 /tmp/vim.log
```

Then run `:code2prompt` and reproduce the error. Quit Vim and check `/tmp/vim.log` for error messages.

## Directory Structure

```
/Users/yutao/ainote/plugin/vimCode2Prompt/
├── README.md                # This file
└── plugin/
    └── code2prompt.vim      # Main plugin code (Vim 9 script)
```

## License

MIT
