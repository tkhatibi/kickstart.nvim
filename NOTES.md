# Neovim

## Tips

- `<C-w>d <C-w>d` shows diagnostics under the cursor and moves cursor to that floating window
- `<S-k> <S-k>` shows docs of token under the cursor and moves cursor to that floating window

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
- N`!` navigator keys

## Key Codes

- `<leader>` is normally defined by the mapleader variable as `\` or `Space`
- `<C-w>` means `Ctrl+W`
- `<A-k>` or `<M-k>` mean `Alt+K`
- `<CR>` means `Enter`
- `<S-i>` or `I` means `Shift+I`

## Quick Fix

- `<leader>sl` to see all the symbols in current document.
  - filter symbols
  - `<C-q>` to add all filtered symbols to quickfix list.
- `<A-n>` to go to next place in quickfix list
- `<A-p>` to go to prev place in quickfix list
- `<leader>c` to see all avaiable quickfix commands

## Pattern Jumping (Normal Mode)

- `vi"` selects items inside first double quotations
- `ya'` yanks items inside first quotations included quotations
- `da(` deletes items inside first paranthesis included paranthesis
- `ci[` deletes items inside first brackets and goes to insert mode
- `vib` selects inside block
- `vip` selects inside paragraph

## Custom Key Maps

- `:map <F2> :wq<CR>` to map `F2` key to save and quit the current file

- N`<leader>ot` to open terminal
- T`<C-[>` to back to normal mode when you're in terminal insert mode
- **You need to `zsh` shortcuts, if you don't want to use arrow keys at all
  - `Ctrl+P` for previous command
  - `Ctrl+N` for next command
  - `Ctrl+R` for reverse search
  - `Ctrl+E` to move to end of line or use placeholder
  - `Ctrl+A` to move to beginning

## Commands

- `:SessionDelete /path/to/dir` deletes the session `/path/to/dir`

## Substitution

- `:s/old/new` To substitute `new` for the first `old` in a line
- `:s/old/new/g` To substitute new for all olds on a line
- `:#,#s/old/new/g` To substitute phrases between two lines
- `:%s/old/new/g` To substitute all occurrences in the file type
- `:%s/old/new/gc` To ask for confirmation each time add 'c'

## Buffers, Windows, Tabs

- `:tabe %` copies current window to a new tab

- `:tabe .` opens a new tab
- `:tabnew` opens a new, empty tab.
- `:tabclose` closes the current tab.

- `:qa` closes all tabs and exits

## Commenting Several Lines

### First Approach

- Place your cursor on the first character of the first line you want to comment.
- Press `<C V>` (or `<C Q>` on some systems, especially Windows, though `<C V>` is standard for Linux/macOS).
- You'll see `VISUAL BLOCK` in the status line.
- Move your cursor down to the last line you want to comment.
- Press `<S I>` (capital I).
- You'll enter insert mode, but only for the first selected line.
- Type your comment character(s), e.g., `//` for C-like languages, `#` for Python/Ruby, `--` for SQL/Lua,

### Easier Approach

- `gcc` comments or uncomments the selected lines

## Editing

- N`yl` yanks current char
- N`y5l` yanks 5 chars to the right
- N`y5h` yanks 5 chars to the left
- N`~` toggles selected char(s) to uppercase or lowercase
- N`x` deletes current char
- N`X` deletes prev char
- N`r` replaces current char
- N`R` replaces current char and goes to next char while still is in replace mode
- N`D` deletes rest of current line
- N`C` clears rest of current line before going to insert mode
- N`I` goes to first significant letter of current line in insert mode
- N`A` goes to last char of current line in insert mode
- N`dd` deletes current line
- N`cc` clears current line
- N`<S-i>` moves cursor before the first alphanumeric char in the line and then goes to insert mode
- N`==` removes all indents before the first letter in the line
- I`<C-h>` = `backspace`
- I`<C-d>` = `delete`
- I`<C-m>` = `enter`
- I`<C-u>` removes all the chars before cursor in the current line
- I`<C-t>` indents current line forward
- I`<C-w>` deletes the word before the cursor

## LSP

- N`K` opens the floating doc of the hovered symbol in normal mode
  - N`K` again or `<C-w>w` switches to the floating doc window to make you able to scroll up/down with k/j

### Auto Complete

- I`<C-Space>` opens the autocomplete window
  - I`<C-y>` selects the first item in autocomplete window
  - I`<C-n>` selects the next item in autocomplete window
  - I`<C-p>` selects the prev item in autocomplete window
  - I`<C-Space>` opens/closes the floating documentation of the hovered item in autocomplete window
    - I`<C-f>` scrolls down the floating documentation of the hovered item in autocomplete window
    - I`<C-b>` scrolls up the floating documentation of the hovered item in autocomplete window

## Multi Cursor

### With plugin

You can see it here [Youtube](https://youtu.be/p4D8-brdrZo?t=263)

- `<C-n>` selects the current occurance and goes to next
- `n` selects next occurance
- `q` skips the current occurance
- `Q` deselectes last occurance and goes to previous
- `c` or `a` or `i` goes to insert mode for all the occurances
- `Esc` goes to visual mode
- now you can move all the cursors and do your stuff
- `<C Down>` duplicates cursor to bottom lines

### With Macros

You can see it here [Youtube](https://www.youtube.com/watch?v=tdbHFNxEBhM)

- N`qr` starts recording as `r`
- N`0` goes to beginning of line
- Do whatever you want
- N`j0` goes to the beginning of next line
- N`q` stops recording
- N`@r` to apply what you recorded on current line
- N`10@r` to apply what you recorded on 10 lines

## Jumping and Navigation (Normal Mode)

- `mA` marks current line as `A`.
- `'A` go to bookmark `A`
- `<C-o>` to walk backward
- `<C-i>` to walk forward
- `gg` goes to first line of the file
- `G` goes to last line of the file
- `120gg` or `120G` goes to line 120
- `^` goes to the first significant letter in current line
- `0` goes to the beginning of current line
- `$` goes to the end of current line
- `f d` goes to first d character of current line
  - `;` goes to next occurance
  - `,` goes to prev occurance
- `*` goes to next token occurance
  - `n` goes next
  - `N` goes previous
- `#` goes to previous token occurance
  - `n` goes previous
  - `N` goes next
- `[d` goes to prev diagnostic
- `]d` goes to next diagnostic
- `[m` goes to prev method start
- `]m` goes to next method start
- `{` goes to prev empty line
- `}` goes to next empty line
- `<C-d>` moves cursor down for 20 lines
- `<C-u>` moves cursor up for 20 lines
- `L` moves cursor down to the last visible line
- `H` moves cursor up to the first visible line
- `<C-y>` scrolls up without moving cursor
- `<C-e>` scrolls down without moving cursor
- `zz` centers current line

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

Then enable experimental features: (Optional)

```sh
echo "experimental-features = nix-command flakes" >> /etc/nix/nix.conf
```

### Install neovim (using nix)

```sh
nix profile install nixpkgs#neovim
```

## Tips

### For CI or scripts:

```sh
nvim --headless "+Lazy! sync" +qa
```

which will sync plugins and then quit Neovim without opening the UI 

### How to run Neovim with no configuration files?

```sh
nvim -u NONE -N
```

- `u None` starts Neovim with no configuration files loaded.
- `N` starts Neovim in non-compatible mode (like vim).

