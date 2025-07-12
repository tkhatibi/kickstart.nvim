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

## Shortcuts

*`<leader>` is normally defined by the mapleader variable as `\` or `Space`*
*`<C W>` means `Ctrl+W`
*`<CR>` means `Enter`
*`<S I>` means `Shift+I`

### Commands

- `:source %` reloads your `init.lua` without `lazy.nvim` changes
- `:luafile $HOME/.config/nvim/init.lua` like above
- `:Lazy sync` Runs install, clean and update
- `@:` runs the last command in Neovim

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

### Normal Mode

- `~` toggles current char to uppercase if it's lowercase or vice versa
- `r` replaces current char
- `R` replaces current char and goes to next char while still is in replace mode

### Insert Mode

- `C` clears rest of current line before going to insert mode
- `<C n>` goes to next item in autocomplete window
- `<C p>` goes to prev item in autocomplete window

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

- `<C d>` goes down for 20 lines
- `<C u>` goes up for 20 lines
- `gg` goes to first line of the file
- `G` goes to last line of the file
- `f d` goes to first d character of current line
- `Shift A` goes to last char of current line in insert mode

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


