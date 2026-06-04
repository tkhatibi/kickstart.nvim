-- `:reset` and `ZR` reset neovim
-- `:PackAdd https://github.com/bluz71/vim-moonfly-colors`

-------------------------------------------------------------
-- SETTINGS
-------------------------------------------------------------

local is_dark_theme = true

local light_theme = "peachpuff"
local light_theme = "shine"

local dark_theme = "slate"
local dark_theme = "retrobox"
local dark_theme = "unokai"

local ensure_syntax_supported = {
    -- languages
    "html", "json", "markdown", "markdown_inline",
    "typescript", "javascript", "tsx", "jsx", "css",
    "go", "rust",
    -- extras
    "http", "dockerfile",
}
local ensure_syntax_supported = { "all" }

-- ============================================================
-- SECTION 0: DEPENDENCIES
-- ============================================================

vim.pack.add({
    "https://github.com/rafamadriz/friendly-snippets",
    "https://github.com/bluz71/vim-moonfly-colors",
    "https://github.com/nvim-mini/mini.nvim",
    { src = "https://github.com/nvim-treesitter/nvim-treesitter", branch = "main" },
})

require("vim._core.ui2").enable({})

local MiniCompletion = require('mini.completion')
local MiniSnippets = require('mini.snippets')
local MiniExtra = require('mini.extra')
local MiniNotify = require('mini.notify')
local MiniCmdline = require('mini.cmdline')
local MiniSurround = require('mini.surround')
local MiniFiles = require("mini.files")
local MiniPick = require("mini.pick")

require("options")
require("keymaps")
require("commands")

local dependents = {}

local function setup_after(plugin_name, setup)
    if not dependents[plugin_name] then
        dependents[plugin_name] = {}
    end
    dependents[plugin_name][#dependents[plugin_name] + 1] = setup
end

local function setup_dependents_of(plugin_name, dependency)
    if not dependents[plugin_name] then
        return
    end
    for _, cb in ipairs(dependents[plugin_name]) do
        cb(plugin_name, dependency)
    end
end

local setups = {}

local function add_setup(name, cb)
    if not setups[name] then
        setups[name] = {}
    end
    setups[name][#setups[name] + 1] = setup
end

local function setup(name, ...)
    if not setups[plugin_name] then
        return
    end
    for _, cb in ipairs(setups[name]) do
        cb(name, unpack(arg))
    end
    table.remove(setups, name)
end

-------------------------------------------------------------
-- SETUPS
-------------------------------------------------------------

local function setup_base()
    --  See `:help vim.o`
    --  See `:help option-list`
    --  See `:help vim.keymap.set()`

  -- Enable faster startup by caching compiled Lua modules
  vim.loader.enable()

  -- See `:help mapleader`
  vim.g.mapleader = ' '
  vim.g.maplocalleader = ' '
  vim.o.updatetime = 250 -- Decrease update time
  vim.o.timeoutlen = 300 -- Decrease mapped sequence wait time

  vim.keymap.set('n', '<left>', '<cmd>echo "Use h to move!!"<CR>')
  vim.keymap.set('n', '<right>', '<cmd>echo "Use l to move!!"<CR>')
  vim.keymap.set('n', '<up>', '<cmd>echo "Use k to move!!"<CR>')
  vim.keymap.set('n', '<down>', '<cmd>echo "Use j to move!!"<CR>')

    -- TODO: move below lines to better setup function

    vim.opt.completeopt = "menuone,noselect,fuzzy,nosort"
    vim.opt.shortmess:append("c")

    setup_after("options", function()
        vim.keymap.set('n', '<leader>oh', ':checkhealth<CR>', { noremap = true, desc = 'Health Check' })
        vim.keymap.set('n', '<leader>om', ':Mason<CR>', { noremap = true, desc = 'Mason' })
        vim.keymap.set('n', '<leader>ou', function()
            vim.cmd.packadd("nvim.undotree")
            require("undotree").open()
        end, { noremap = true, desc = 'Undotree' })

        vim.keymap.set('n', '<leader>rx', '<cmd>!chmod +x %<CR>', { silent = true, desc = 'Make file executable' })

        vim.keymap.set('n', '<leader>xx', ':@<CR>', { noremap = true, desc = 'Executes last command' })
    end)


    -------------------------------------------------------------
    -- BASIC AUTOCOMMANDS
    -------------------------------------------------------------
    --  See `:help lua-guide-autocommands`
end

  local function set_theme()
      if is_dark_theme then
          vim.cmd.colorscheme(dark_theme)
      else
          vim.cmd.colorscheme(light_theme)
      end
  end

  local function toggle_theme()
    is_dark_theme = not is_dark_theme
    set_theme()
  end

local function setup_theme()
    set_theme()
    setup_after("options", function()
            vim.keymap.set('n', '<leader>tt', toggle_theme, { desc = 'Toggle theme' })
    end)
end

  local function setup_search()
    setup_after("primitives", function()
        vim.o.ignorecase = true -- case-insensitive search
        vim.o.smartcase = true -- enable case-sensitive search when uppercased letter is present
        vim.o.inccommand = 'split' -- preview substitutions live, as you type!

        -- clear highlights on search when pressing <esc> in normal mode
        --  see `:help hlsearch`
        vim.keymap.set('n', '<esc>', '<cmd>nohlsearch<cr>')

        vim.keymap.set('n', 'n', 'nzzzv', { desc = "Next search result with cursor centered" })
        vim.keymap.set('n', 'N', 'Nzzzv', { desc = "Previous search result with cursor centered" })

        vim.keymap.set('n', '<C-8>', [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]],
        { desc = "Replace word under cursor" })
    end)

    setup_after("mini.pick", function()
        vim.keymap.set('n', '<leader>sw',
        function() MiniPick.builtin.grep({ pattern = vim.fn.expand("<cword>") }) end,
        { desc = "Search word under cursor" })

        vim.keymap.set('n', '<leader>sh', function() MiniPick.builtin.help() end, { desc = "Search helps" })
    end)

    setup_after("mini.extra", function()
        vim.keymap.set('n', '<leader>sk', function() MiniExtra.pickers.keymaps() end, { desc = "Search keymaps" })
    end)
  end

  local function setup_quickfix()
    setup_after("primitives", function()
        vim.keymap.set('n', '<A-n>', '<cmd>cnext<CR>', { desc = 'Next Place in QuickFix List' })
        vim.keymap.set('n', '<A-p>', '<cmd>cprev<CR>', { desc = 'Prev Place in QuickFix List' })

        vim.keymap.set('n', '<leader>co', '<cmd>copen<CR>', { desc = 'Open Quickfix List' })

        -- Clear and close quickfix list completely
        vim.keymap.set('n', '<leader>cq', function()
            vim.fn.setqflist({}, 'r') -- replace with empty list
            vim.cmd.cclose()
        end, { desc = 'Clear and close whole list' })

        -- Add current line to quickfix list (workspace-wide)
        vim.keymap.set('n', '<leader>cc', function()
            local qf = vim.fn.getqflist()
            table.insert(qf, {
                bufnr = vim.api.nvim_get_current_buf(),
                lnum = vim.fn.line '.',
                col = vim.fn.col '.',
                text = vim.fn.getline '.',
            })
            vim.fn.setqflist(qf, 'r')
        end, { desc = 'Add current line to list' })

        -- Delete current line from quickfix list
        vim.keymap.set('n', '<leader>cd', function()
            local qf = vim.fn.getqflist()
            local idx = vim.fn.line '.' -- current line in quickfix window
            if vim.bo.filetype ~= 'qf' then
                vim.notify('Open quickfix window and place cursor on the entry to delete', vim.log.levels.WARN)
                return
            end
            table.remove(qf, idx)
            vim.fn.setqflist(qf, 'r')
            vim.cmd.copen() -- refresh
        end, { desc = 'Delete current line from list' })

        --  see `:help vim.diagnostic.opts`
        vim.diagnostic.config {
            update_in_insert = false,
            severity_sort = true,
            float = { border = 'rounded', source = 'if_many' },
            underline = { severity = { min = vim.diagnostic.severity.warn } },

            -- Can switch between these as you prefer
            virtual_text = true, -- Text shows up at the end of the line
            virtual_lines = false, -- Text shows up underneath the line, with virtual lines

            -- Auto open the float, so you can easily read the errors when jumping with `[d` and `]d`
            jump = {
                on_jump = function(_, bufnr)
                    vim.diagnostic.open_float {
                        bufnr = bufnr,
                        scope = 'cursor',
                        focus = false,
                    }
                end,
            },
        }
    end)

    setup_after("mini.extra", function()
        vim.keymap.set('n', '<leader>sd', function() MiniExtra.pickers.diagnostic() end, { desc = "Search diagnostics" })
    end)
  end

local function setup_file_management()
    setup_after("primitives", function()
            vim.keymap.set('n', '<leader>ox', ':e .<CR>', { noremap = true, desc = 'Default file explorer' })
    end)

    setup_after("mini.files", function()
        vim.keymap.set('n', '.', '<cmd>lua MiniFiles.open()<CR>', { desc = "Mini file explorer" })

        vim.keymap.set('n', '<C-.>', function()
            MiniFiles.open(vim.api.nvim_buf_get_name(0), false)
            MiniFiles.reveal_cwd()
        end, { desc = "Toggle into currently open file" })
    end)

    setup_after("mini.pick", function()
        vim.keymap.set('n', '<leader>oo', function() MiniPick.builtin.files() end, { desc = "Pick file" })
    end)
end

local function setup_terminal()
    setup_after("primitives", function()
        vim.keymap.set('n', '<leader>ott', ':terminal<CR>', { noremap = true, silent = true, desc = 'Open terminal here' })
        vim.keymap.set('n', '<leader>otT', '<C-w>v<C-w>T:terminal<CR>', { noremap = true, silent = true, desc = 'Open terminal in new tab' })
        vim.keymap.set('n', '<leader>otl', '<C-w>v:terminal<CR>', { noremap = true, silent = true, desc = 'Open terminal right' })
        vim.keymap.set('n', '<leader>otj', '<C-w>s:terminal<CR>', { noremap = true, silent = true, desc = 'Open terminal below' })

        -- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
        -- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
        -- is not what someone will guess without a bit more experience.
        --
        -- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
        -- or just use <C-\><C-n> to exit terminal mode
        vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })
        vim.keymap.set('t', '<C-[>', [[<C-\><C-n>]], { noremap = true, desc = 'Exit terminal mode' })
    end)
end

local function setup_yank()
    setup_after("primitives", function()
        -- Sync clipboard between OS and Neovim.
        --  Schedule the setting after `UiEnter` because it can increase startup-time.
        --  Remove this option if you want your OS clipboard to remain independent.
        --  See `:help 'clipboard'`
        vim.schedule(function() vim.o.clipboard = 'unnamedplus' end)

        -- Highlight when yanking (copying) text
        --  Try it with `yap` in normal mode
        --  See `:help vim.hl.on_yank()`
        vim.api.nvim_create_autocmd('TextYankPost', {
            desc = 'Highlight when yanking (copying) text',
            -- group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
            callback = function() vim.hl.on_yank() end,
        })

        -- clipboard sync wrapper
        if vim.fn.has 'wsl' == 1 then
            vim.g.clipboard = {
                name = 'X11ClipboardFallback',
                copy = {
                    ['+'] = 'xclip -selection clipboard',
                    ['*'] = 'xclip -selection primary',
                },
                paste = {
                    ['+'] = 'xclip -selection clipboard -o',
                    ['*'] = 'xclip -selection primary -o',
                },
                cache_enabled = 0,
            }
        end

        -- Paste without yanking replaced text
        vim.keymap.set('v', 'p', 'P')
        vim.keymap.set('v', 'P', 'p')

        -- Yank only the filename (e.g., "main.lua")
        vim.keymap.set('n', '<leader>yn', function()
            vim.fn.setreg('+', vim.fn.expand '%:t')
            print('Yanked filename: ' .. vim.fn.expand '%:t')
        end, { desc = 'Yank File Name' })

        -- Yank relative file path (e.g., "src/main.lua")
        vim.keymap.set('n', '<leader>yp', function()
            vim.fn.setreg('+', vim.fn.expand '%:.')
            print('Yanked relative path: ' .. vim.fn.expand '%:.')
        end, { desc = 'Yank Relative File Path' })

        -- Yank absolute file path (e.g., "/home/user/project/src/main.lua")
        vim.keymap.set('n', '<leader>yP', function()
            vim.fn.setreg('+', vim.fn.expand '%:p')
            print('Yanked absolute path: ' .. vim.fn.expand '%:p')
        end, { desc = 'Yank Absolute File Path' })

        -- Yank whole content
        vim.keymap.set('n', '<leader>yy', 'mzggVGy`z', { noremap = true, silent = true, desc = 'Yank whole content' })

        -- TODO: Yank status bar message
        vim.keymap.set('n', '<leader>ys', '', { noremap = true, silent = true, desc = 'Yank status bar message' })
    end)
end

  local function setup_editing()
    setup_after("primitives", function()
        vim.opt.autoread = true
        vim.opt.autowrite = false
        vim.opt.encoding = 'UTF-8'
        vim.opt.breakindent = true
        vim.opt.tabstop = 4
        vim.opt.softtabstop = 4
        vim.opt.shiftwidth = 4
        vim.opt.expandtab = true
        vim.opt.wrap = true
        vim.opt.smartindent = true

        -- if performing an operation that would fail due to unsaved changes in the buffer (like `:q`),
        -- instead raise a dialog asking if you wish to save the current file(s)
        -- See `:help 'confirm'`
        vim.o.confirm = true

        vim.o.undofile = true -- Enable undo/redo changes even after closing and reopening a file

        vim.api.nvim_set_keymap('n', '<c-a>', 'ggVG', { noremap = true, silent = true, desc = 'Select All Lines' })

        vim.keymap.set('i', '<C-d>', '<Del>', { noremap = true, desc = 'Delete next char' })

        vim.keymap.set('n', '<A-o>', 'mzo<Esc>`z', { desc = 'Add blank line below staying here' })
        vim.keymap.set('n', '<A-S-o>', 'mzO<Esc>`z', { desc = 'Add blank line above staying here' })
        vim.keymap.set('n', '<S-CR>', 'O<Esc>', { desc = 'Add blank line above and go there' })
        vim.keymap.set('n', '<CR>', 'o<Esc>', { desc = 'Add blank line below and go there' })

        vim.keymap.set('n', '<A-j>', 'mz:m+1<CR>`z==', { desc = 'Move line down' })
        vim.keymap.set('i', '<A-j>', '<Esc>:m +1<CR>gi', { desc = 'Move line down' })
        vim.keymap.set('v', '<A-j>', ":m '>+1<CR>gv=gv", { desc = 'Move lines down' })

        vim.keymap.set('n', '<A-k>', 'mz:m-2<CR>`z==', { desc = 'Move line up' })
        vim.keymap.set('i', '<A-k>', '<Esc>:m -2<CR>gi', { desc = 'Move line up' })
        vim.keymap.set('v', '<A-k>', ":m '<-2<CR>gv=gv", { desc = 'Move lines up' })

        vim.keymap.set('v', '<', '<gv', { desc = 'Indent Left and Reselect' })
        vim.keymap.set('v', '>', '>gv', { desc = 'Indent Right and Reselect' })

        -- TODO: Toggle comment
        vim.keymap.set('v', '<C-/>', ':echo "comment"', { desc = 'Toggle comment' })
    end)
  end

  local function setup_buffers()
    setup_after("primitives", function()
        -- See `:help wincmd` for a list of all window commands

        vim.o.splitright = true
        vim.o.splitbelow = true

        vim.keymap.set('n', '<leader><leader>', '<C-6>', { desc = 'Switch buffer' })

        vim.keymap.set('n', '<C-w>t', ':tabe %<CR>', { desc = 'Copy into a new tab' })

        -- NOTE: <C-A-l> and <C-A-h> are reserved for terminal tab moves
        vim.keymap.set('n', '<C-A-k>', 'gt', { noremap = true, desc = 'Go to next tab' })
        vim.keymap.set('n', '<C-A-j>', 'gT', { noremap = true, desc = 'Go to prev tab' })

        vim.keymap.set('n', '<A-l>', '<C-w>w', { desc = 'Go to next window' })
        vim.keymap.set('n', '<A-h>', '<C-w>W', { desc = 'Go to prev window' })

        vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
        vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
        vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
        vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

        vim.keymap.set('n', '<C-Up>', ':resize +2<CR>', { desc = 'Increase Height of Current Window' })
        vim.keymap.set('n', '<C-Down>', ':resize -2<CR>', { desc = 'Decrease Height of Current Window' })
        vim.keymap.set('n', '<C-Right>', ':vertical resize +2<CR>', { desc = 'Increase Width of Current Window' })
        vim.keymap.set('n', '<C-Left>', ':vertical resize -2<CR>', { desc = 'Decrease Width of Current Window' })

        vim.keymap.set('n', '<A-S-h>', '<C-w>H', { desc = 'Move window to the left' })
        vim.keymap.set('n', '<A-S-l>', '<C-w>L', { desc = 'Move window to the right' })
        vim.keymap.set('n', '<A-S-j>', '<C-w>J', { desc = 'Move window to the lower' })
        vim.keymap.set('n', '<A-S-k>', '<C-w>K', { desc = 'Move window to the upper' })

        -- TODO: toggle `<C-w>m`
        vim.keymap.set('n', '<C-w>m', '<C-w>|<C-w>_', { desc = 'Max Out' })
        vim.keymap.set('n', '<C-w>e', '<C-w>=', { desc = 'Equally high and width' })
    end)
  end

  local function setup_vim()
    setup_after("primitives", function()
        vim.keymap.set('n', '<leader>vc', ':e ~/.config/nvim/init.lua<cr>', { desc = 'configure' })

        -- vim.keymap.set('n', '<leader>vv', ':wa<cr>:source ~/.config/nvim/init.lua<cr>', { desc = 'source' })

        vim.keymap.set('n', '<leader>vn', ':e ~/.config/nvim/notes.md<cr>', { desc = 'notes.md' })

        vim.keymap.set('n', '<leader>vt', ':e ~/.config/nvim/tools.md<cr>', { desc = 'tools.md' })

        vim.keymap.set('n', '<leader>vu', ':packupdate<cr>', { desc = 'update' })

        vim.keymap.set('n', '<leader>vv', function()
            -- write all modified buffers first
            vim.cmd 'wa'

            -- clear the neovim/lua module cache for your custom config files
            for name, _ in pairs(package.loaded) do
                if name:match '^user' or name:match '^config' or name:match '^plugins' then
                    package.loaded[name] = nil
                end
            end

            -- source the main init.lua
            vim.cmd 'source ~/.config/nvim/init.lua'
            vim.cmd 'source %'
            vim.cmd 'so'
            print 'config reloaded!'
        end, { desc = 'reload neovim config' })
    end)
  end

  local function setup_scrolling()
    setup_after("primitives", function()
        vim.o.scrolloff = 5 -- Minimal number of screen lines to keep above and below the cursor.
        -- vim.opt.sidescrolloff = 999

        vim.keymap.set('n', '<C-u>', '<C-u>zz', { desc = 'Scroll up in buffer with cursor centered' })
        vim.keymap.set('n', '<C-d>', '<C-d>zz', { desc = 'Scroll down in buffer with cursor centered' })
    end)
end

local function setup_ui()
    setup_after("primitives", function()
        -- [[ CURSOR ]]
        vim.o.mouse = 'a'
        vim.o.guicursor = ""
        vim.o.cursorline = true -- Show which line your cursor is on


        vim.o.showmode = true -- it's already in the status line
        vim.o.cmdheight = 0 -- Don't show command line if we're not in command mode
        vim.o.laststatus = 3
        -- vim.o.termguicolors = true

        vim.o.number = true
        vim.o.relativenumber = true

        vim.o.winborder = 'rounded'

        vim.g.have_nerd_font = true
        vim.o.guifont = 'FiraCode Nerd Font Mono:h12'
        vim.g.neovide_scale_factor = 1
        vim.g.neovide_cursor_vfx_mode = 'wireframe'

        -- Sets how neovim will display certain whitespace characters in the editor.
        --  See `:help 'list'`
        --  and `:help 'listchars'`
        --
        --  Notice listchars is set using `vim.opt` instead of `vim.o`.
        --  It is very similar to `vim.o` but offers an interface for conveniently interacting with tables.
        --   See `:help lua-options`
        --   and `:help lua-guide-options`
        vim.o.list = true
        vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

        vim.api.nvim_set_keymap('n', '<C-0>', ':lua vim.g.neovide_scale_factor = 1<CR>', { silent = true, noremap = true })
        vim.api.nvim_set_keymap('n', '<C-=>', ':lua vim.g.neovide_scale_factor = vim.g.neovide_scale_factor + 0.05<CR>', { silent = true })
        vim.api.nvim_set_keymap('n', '<C-->', ':lua vim.g.neovide_scale_factor = vim.g.neovide_scale_factor - 0.05<CR>', { silent = true })
    end)
end

-------------------------------------------------------------
-- SETUP PLUGINS
-------------------------------------------------------------

local function setup_treesitter()
    setup_after("primitives", function()
        local treesitter = require("nvim-treesitter")

        treesitter.install(ensure_syntax_supported)

        vim.api.nvim_create_autocmd("FileType", {
            pattern = "*",
            callback = function(args)
                local buf = args.buf
                local ft = vim.bo[buf].filetype

                local lang = vim.treesitter.language.get_lang(ft)
                if not lang then return end

                local ok_add = pcall(vim.treesitter.language.add, lang)
                if not ok_add then return end

                pcall(vim.treesitter.start, buf, lang)
            end
        })
    end)
end

-------------------------------------------------------------
-- INTEGRATE SETUPS
-------------------------------------------------------------

setup_base()
setup_yank()
setup_editing()
setup_scrolling()
setup_buffers()
setup_search()
setup_terminal()
setup_quickfix()
setup_theme()
setup_file_management()
setup_vim()
setup_ui()
setup_treesitter()

setup_dependents_of("options")
setup_dependents_of("primitives")

setup_dependents_of("mini_notify", MiniNotify.setup({
  -- Content management
  content = {
    -- Function which formats the notification message
    -- By default prepends message with notification time
    format = function(notif)
        return notif.msg
    end,

    -- Function which orders notification array from most to least important
    -- By default orders first by level and then by update timestamp
    sort = nil,
  },

  -- Notifications about LSP progress
  lsp_progress = {
    -- Whether to enable showing
    enable = true,

    -- Notification level
    level = 'INFO',

    -- Duration (in ms) of how long last message should be shown
    duration_last = 1000,
  },
}))

-- Command Line Completion
setup_dependents_of("mini.cmdline", MiniCmdline.setup({
    autocorrect = { enable = false }
}))

-- `sr'"` replaces ' with "
-- `sd"` deletes surrounding (")
-- `viwsa'` surrounds selected with `'`
-- `viwsatp className="m2"<CR>` surrounds selected with `<p className="m2">` and `</p>`
-- `srtth3<CR>` replaces p tag with h3
-- `srtb` deletes tags around and surrounds with ()
-- `srb{` deletes () around and surrounds with {}
-- `sd{` deletes {} around
setup_dependents_of("mini.surround", MiniSurround.setup())

setup_dependents_of("mini.pick", MiniPick.setup())

setup_dependents_of("mini.files", MiniFiles.setup({
    mappings = {
        -- close = "q",
        -- create_file = "o",
        -- rename_file = "ciw",
        -- delete_file = "dd",
        -- copy_file = "yypp",
        -- apply_changes = "<C-[>=y",
        go_in = "<CR>",
        go_in_plus = "L",
        go_out = "_",
        go_out_plus = "H",
    },
}))

setup_dependents_of("mini.extra", MiniExtra.setup())

setup_dependents_of("mini.completion", MiniCompletion.setup({
    lsp_completion = {
        auto_setup = true,
        process_time = function(items, base)
            return MiniCompletion.default_process_items(items, base, {
                filtersort = "fuzzy",
            })
        end
    },
}))

-- `<C-l>` jumps to next placeholder
-- `<C-h>` jumps to prev placeholder
MiniSnippets.setup({
    snippets = {
        MiniSnippets.gen_loader.from_lang(), -- loads friendly-snippets automatically
    },
    expand = {
        insert = function(snippet)
            MiniSnippets.default_insert(snippet, { empty_tabstop = "" })
        end
    },
})
MiniSnippets.start_lsp_server({ match = false })
vim.api.nvim_create_autocmd("ColorScheme", {
    callback = function()
        vim.api.nvim_set_hl(0, "MiniSnippetsCurrent", {})
        vim.api.nvim_set_hl(0, "MiniSnippetsCurrentReplace", {})
        vim.api.nvim_set_hl(0, "MiniSnippetsFinal", {})
        vim.api.nvim_set_hl(0, "MiniSnippetsUnvisited", {})
        vim.api.nvim_set_hl(0, "MiniSnippetsVisited", {})
    end
})
setup_dependents_of("mini.snippets")

