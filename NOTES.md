# Neovim

## How to run Neovim with no configuration files?

```sh
nvim -u NONE -N
```

- `u None` starts Neovim with no configuration files loaded.
- `N` starts Neovim in non-compatible mode (like vim).

## Helps

- https://learnxinyminutes.com/docs/lua/
- `:help lua-guide` a reference for how neovim integrates lua
- `:Tutor` a neovim tutorial
  *search for `summary` to review the most important parts*
- `:help`
- `:help notation`
- `:help keycodes`
- `<space>sh` shows you lists of all the helps
- `:help wincmd`

## Keycodes

*`<leader>` is normally defined by the mapleader variable as `\` or `Space`*
*`<C-w>` means `Ctrl+W`
*`<A-k>` means `Alt+K`
*`<CR>` means `Enter`
*`<S-i>` means `Shift+I`

### Custom keymaps

- N`<leader>e` to open file explorer
- N`<leader>z` to open lazy window

- N`<leader>t` to open terminal
- T`<leader><leader>` to back to normal mode when you're in terminal insert mode
- **You need to `zsh` shortcuts, if you don't want to use arrow keys at all
  - `Ctrl+P` for previous command
  - `Ctrl+N` for next command
  - `Ctrl+R` for reverse search
  - `Ctrl+E` to move to end of line or use placeholder
  - `Ctrl+A` to move to beginning

- N`<C-0>` reset neovide scale factor
- N`<C-=>` increase neovide scale factor
- N`<C-->` decrease neovide scale factor

- N`gl` LSP commands
- N`<F2>` rename symbol in the whole workspace
- N`<leader>g` to open and switch to line diagnostics window
- N`<leader>k` to open and switch to wiki window (docs)
- N`<leader>d` to open document symbols
- N`<leader>w` to open workspace symbols
- N`<leader>r` to open symbol references

- N`<C-a>` to select all lines
- N`<A-o>` to add a line below without cursor moving
- N`<A-O>` to add a line above without cursor moving
- N`<A-k>` to move current line above
- N`<A-j>` to move current line below
- V`<A-k>` to move selected lines above
- V`<A-j>` to move selected lines below

- N`<C-Tab>` to switch tabs
- N`<C-l>` to go to the right window
- N`<C-h>` to go to the left window
- N`<A-l>` to go to the next tab
- N`<A-h>` to go to the prev tab

- N`<leader>m` to remove all `^M`s in the document

### Commands

- `:source %` reloads your `init.lua` without `lazy.nvim` changes (works on keymaps)
- `:luafile $HOME/.config/nvim/init.lua` like above
- `:Lazy sync` Runs install, clean and update
- `:@` runs the last command in Neovim
- `:SessionDelete /path/to/dir` deletes the session `/path/to/dir`
- `:e .` opens the current directory using the native `netrw` plugin

### Substitution

- `:s/old/new` To substitute new for the first old in a line type
- `:s/old/new/g` To substitute new for all olds on a line type
- `:#,#s/old/new/g` To substitute phrases between two line #'s type
- `:%s/old/new/g` To substitute all occurrences in the file type
- `:%s/old/new/gc` To ask for confirmation each time add 'c'

### Buffers, Windows, Tabs

- `<C 6>` toggles between last cuple of buffer files

- `<C W W>` cycles through windows
- `<C W> V` or `:vsplit` duplicates current window to right
- `<C W> L` goes to right window
- `<C W> H` goes to left window

- `<C W> T` moves current window to a new tab
- `:tabe %` copies current window to a new tab

- `:tabe .` opens a new tab
- `:tabnew` opens a new, empty tab.
- `:tabclose` closes the current tab.
- `gt` or `:tabnext` goes to the next tab.
- `gT` or `:tabprev` goes to the previous tab.

- `:qa` closes all tabs and exits

### Commenting Several Lines

#### First Approach

- Place your cursor on the first character of the first line you want to comment.
- Press `<C V>` (or `<C Q>` on some systems, especially Windows, though `<C V>` is standard for Linux/macOS).
- You'll see `VISUAL BLOCK` in the status line.
- Move your cursor down to the last line you want to comment.
- Press `<S I>` (capital I).
- You'll enter insert mode, but only for the first selected line.
- Type your comment character(s), e.g., `//` for C-like languages, `#` for Python/Ruby, `--` for SQL/Lua,

#### Easier Approach

- `gcc` comments or uncomments the selected lines

### Case

- N`~` toggles selected char(s) to uppercase or lowercase

### Editing

- N`x` deletes current char
- N`X` deletes prev char
- N`r` replaces current char
- N`R` replaces current char and goes to next char while still is in replace mode
- N`D` deletes rest of current line
- N`C` clears rest of current line before going to insert mode
- N`dd` deletes current line
- N`cc` clears current line
- N`<S-i>` moves cursor before the first alphanumeric char in the line and then goes to insert mode
- I`<C-h>` = `backspace`
- I`<C-d>` = `delete`
- I`<C-m>` = `enter`
- I`<C-t>` indents current line forward
- I`<C-w>` deletes the word before the cursor
- I`<C-u>` Deletes everything before the cursor on the current line
- N`A` goes to last char of current line in insert mode

### Auto Complete
- I`<C Space>` opens the autocomplete window
  - I`<C-y>` selects the first item in autocomplete window
  - I`<C-n>` selects the next item in autocomplete window
  - I`<C-p>` selects the prev item in autocomplete window
  - I`<C-Space>` opens/closes the floating documentation of the hovered item in autocomplete window
    - I`<C-f>` scrolls down the floating documentation of the hovered item in autocomplete window
    - I`<C-b>` scrolls up the floating documentation of the hovered item in autocomplete window
- N`<S k>` opens the floating doc of the hovered symbol in normal mode
  - N`<C-w>w` switches to the floating doc window to make you able to scroll up/down with k/j

### Multi Cursor

[Youtube](https://youtu.be/p4D8-brdrZo?t=263)

- `<C N>` selects the current occurance and goes to next
- `q` skips the current occurance
- `Shift+q` deselectes last occurance and goes to previous
- `c` goes to insert mode for all the occurances
- `Esc` goes to visual mode
- now you can move all the cursors and do your stuff
- `<C Down>` duplicates cursor to bottom lines

### Copy Pasting Moving

- `<leader>y` yanks (copies) selected content into system clipboard
- `<leader>p` pastes from system clipboard
- `Shift <<` shifts current line left
- `<` shifts selected content left

### Navigation

- `<C-d>` moves cursor down for 20 lines
- `<C-u>` moves cursor up for 20 lines
- `gg` goes to first line of the file
- `G` goes to last line of the file
- `L` moves cursor down to the last visible line
- `H` moves cursor up to the first visible line
- `f d` goes to first d character of current line
- `<C-y>` scrolls up without moving cursor
- `<C-e>` scrolls down without moving cursor

## How to install?

### Install nix (If not installed)

```sh
sudo apt update
sudo apt install xz-utils curl
curl -L https://nixos.org/nix/install | sh -s -- --daemon
```

Now add the following to your shell startup (e.g. `~/.bashrc`, or `~/.zshrc`, or `~/.profile`):

```sh
if [ -e /etc/profile.d/nix.sh ]; then
  . /etc/profile.d/nix.sh
fi
```

now reload shell startup:

```sh
source ~/.bashrc
```

Then enable experimental features:

```sh
echo "experimental-features = nix-command flakes" >> /etc/nix/nix.conf
```

### Install neovim (using nix)

```sh
nix profile install nixpkgs#neovim
```

### enable yanking to system clipboard

```sh
sudo apt install wl-clipboard
```

## Useful commands

- `:map <F2> :wq<CR>` to map `F2` key to save and quit the current file

### Telescope

- `:Telescope find_files` to search for files in your project
- `:Telescope live_grep` to search for a string across files
- `:Telescope buffers` to list and switch between open buffers
- `:Telescope help_tags` to search through neovim's help documentation

### Lazy

- `:Lazy` to open lazy.nvim’s interactive interface
- `:Lazy health` to run `:checkhealth lazy` to validate your setup
- `:Lazy profile` to generate a detailed startup profile to help you optimize load times.

## For CI or scripts:

```sh
nvim --headless "+Lazy! sync" +qa
```

which will sync plugins and then quit Neovim without opening the UI 


