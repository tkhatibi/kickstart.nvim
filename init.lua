-- NOTE `:reset` and `ZR` reset neovim
-- NOTE `:PackAdd https://github.com/bluz71/vim-moonfly-colors`
-- NOTE `:PackDel https://github.com/bluz71/vim-moonfly-colors`

-------------------------------------------------------------
-- SETTINGS
-------------------------------------------------------------

local animate = true

local is_dark_theme = true

-- local light_theme = 'shine'
local light_theme = "peachpuff"

-- local dark_theme = "slate"
-- local dark_theme = "retrobox"
local dark_theme = 'unokai'

local ensure_syntax_supported = { 'all' }

-- NOTE `:MasonInstall gopls pyright` the only way to have LSPs at the moment.
-- TODO: setup ensure_installed to skip manually installation of LSPs with `:MasonInstall`
--
-- NOTE `:help lspconfig-all` for a list of all the pre-configured LSPs
--
-- Some languages (like typescript) have entire language plugins that can be useful:
--    https://github.com/pmizio/typescript-tools.nvim
--
local servers = {
    clangd = {},
    neocmakelsp = {},   -- faster than cmake (rust)
    jinja_lsp = {},
    css_variables = {}, -- unofficial (typescript)
    -- docker_compose_language_service = {},
    -- gitlab_ci_ls = {}, -- unofficial (rust)
    -- gh_actions_ls = {}, -- unofficial (javascript)
    -- ols = {}, -- odin ls
    buf_ls = {},         -- proto buffer (go)
    tailwindcss = {},    -- official
    html = {},           -- vscode extracted (js)
    eslint = {},         -- vscode extracted (js)
    cssls = {},          -- vscode extracted (js)
    jsonls = {},         -- vscode extracted (js)
    markdown_oxide = {}, -- markdown ls (rust)
    taplo = {},          -- toml formatter (rust)
    -- vacuum = {}, -- openapi 2 and 3 (go)
    -- gopls = {}, -- golang
    -- pyright = {},
    rust_analyzer = {
        settings = {
            ['rust-analyzer'] = {
                check = {
                    command = "clippy",
                },
                procMacro = {
                    enable = true,
                },
                experimental = {
                    procAttrMacros = true,
                },
                cargo = {
                    buildScripts = {
                        enable = true,
                    },
                    allFeatures = true,
                },
            },
        },
    },
    lua_ls = {
        -- cmd = { ... },
        -- filetypes = { ... },
        -- capabilities = {},
        settings = {
            Lua = {
                workspace = {
                    library = { vim.fn.expand '.luastubs' },
                },
                type = {
                    weakNilCheck = false,
                    weakUnionCheck = false,
                },
                diagnostics = {
                    -- You can toggle below to ignore Lua_LS's noisy `missing-fields` warnings
                    -- disable = { 'missing-fields' },
                    neededFileStatus = {
                        any = 'Error',
                        unknown = 'Error',
                    },
                    globals = {
                        'vim',
                        'opts',
                        'describe',
                        'context',
                        'spec',
                        'test',
                        'insulate',
                        'expose',
                        'randomize',
                        'it',
                        'specify',
                        'pending',
                        'before_each',
                        'after_each',
                        'setup',
                        'teardown',
                        'before_all',
                        'after_all',
                        'lazy_setup',
                        'lazy_teardown',
                        'strict_setup',
                        'strict_teardown',
                        'finally',
                        'async',
                        'done',
                        'spy',
                        'stub',
                        'mock',
                        'assert',
                        'match',
                    },
                },
                completion = {
                    callSnippet = 'Replace',
                },
            },
        },
    },
}

-------------------------------------------------------------
-- DEPENDENCIES
-------------------------------------------------------------

vim.pack.add {
    'https://github.com/rafamadriz/friendly-snippets',
    'https://github.com/bluz71/vim-moonfly-colors',
    'https://github.com/nvim-mini/mini.nvim',
    { src = 'https://github.com/nvim-treesitter/nvim-treesitter', branch = 'main' },
    'https://github.com/neovim/nvim-lspconfig',
    'https://github.com/mason-org/mason.nvim',
    'https://github.com/tpope/vim-fugitive',
}

require('vim._core.ui2').enable {}

local MiniCompletion = require 'mini.completion'

local function setup_dependencies()
    vim.api.nvim_create_user_command("PackAdd", function(opts)
        vim.pack.add(opts.fargs)
    end, { nargs = "+", desc = "Add plugins (:PackAdd user/repo1 user2/repo2)" })

    vim.api.nvim_create_user_command("PackDel", function(opts)
        vim.pack.del(opts.fargs)
    end, { nargs = "+", desc = "Del plugins (:PackDel user/repo1 user2/repo2)" })

    vim.api.nvim_create_user_command("PackUpdate", function(opts)
        -- check if any arg is passed
        if opts.args:match("%S") then
            -- update specific plugins
            local plugins = vim.split(opts.args, "%s+", { trimempty = true })
            -- update only specific plugins
            vim.pack.update(plugins)
        else
            -- updat all
            vim.pack.update()
        end
    end, { nargs = "*", desc = "Update plugins (:PackUpdate user/repo1 user2/repo2)" })
end

-------------------------------------------------------------
-- PRIMITIVES
-------------------------------------------------------------

local function setup_base()
    --  NOTE `:help vim.o`
    --  NOTE `:help option-list`
    --  NOTE `:help vim.keymap.set()`

    -- Enable faster startup by caching compiled Lua modules
    vim.loader.enable()

    -- NOTE `:help mapleader`
    vim.g.mapleader = ' '
    vim.g.maplocalleader = ' '
    vim.o.updatetime = 1000 -- Decrease update time
    vim.o.timeoutlen = 1000 -- Decrease mapped sequence wait time

    vim.keymap.set('n', '<left>', '<cmd>echo "Use h to move!!"<CR>')
    vim.keymap.set('n', '<right>', '<cmd>echo "Use l to move!!"<CR>')
    vim.keymap.set('n', '<up>', '<cmd>echo "Use k to move!!"<CR>')
    vim.keymap.set('n', '<down>', '<cmd>echo "Use j to move!!"<CR>')

    -- TODO: move below lines to better setup function

    --vim.g.netrw_banner = 0 -- show only files and folders in file explorer

    vim.o.swapfile = false
    vim.o.backup = false

    vim.opt.isfname:append("@-@")

    vim.o.signcolumn = 'yes'

    vim.o.colorcolumn = "0"

    vim.keymap.set('n', '<leader>oh', ':checkhealth<CR>', { noremap = true, desc = 'Health Check' })
    vim.keymap.set('n', '<leader>ou', function()
        vim.cmd.packadd 'nvim.undotree'
        require('undotree').open()
    end, { noremap = true, desc = 'Undotree' })

    vim.keymap.set('n', '<leader>rx', '<cmd>!chmod +x %<CR>', { silent = true, desc = 'Make file executable' })

    vim.keymap.set('n', '<leader>xx', ':@<CR>', { noremap = true, desc = 'Executes last command' })

    -------------------------------------------------------------
    -- BASIC AUTOCOMMANDS
    -------------------------------------------------------------
    --  NOTE `:help lua-guide-autocommands`
end

-------------------------------------------------------------

local function setup_search()
    vim.o.ignorecase = true    -- case-insensitive search
    vim.o.smartcase = true     -- enable case-sensitive search when uppercased letter is present
    vim.o.inccommand = 'split' -- preview substitutions live, as you type!

    -- clear highlights on search when pressing <esc> in normal mode
    --  NOTE `:help hlsearch`
    vim.keymap.set('n', '<esc>', '<cmd>nohlsearch<cr>')

    vim.keymap.set('n', 'n', 'nzzzv', { desc = 'Next search result with cursor centered' })
    vim.keymap.set('n', 'N', 'Nzzzv', { desc = 'Previous search result with cursor centered' })

    vim.keymap.set('n', '<leader>rr', [[:%s//gc<Left><Left><Left>]], { desc = 'Replace' })

    vim.keymap.set('n', '<leader>rw', [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gc<Left><Left><Left>]],
        { desc = 'Replace word under cursor' })
end

-------------------------------------------------------------

local function setup_quickfix()
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

    --  NOTE `:help vim.diagnostic.opts`
    vim.diagnostic.config {
        update_in_insert = false,
        severity_sort = true,
        float = { border = 'rounded', source = 'if_many' },
        underline = { severity = { min = vim.diagnostic.severity.warn } },

        -- Can switch between these as you prefer
        virtual_text = false,  -- Text shows up at the end of the line
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
end

-------------------------------------------------------------

local function setup_file_management()
    vim.keymap.set('n', '<leader>ox', ':e .<CR>',
        { noremap = true, desc = 'Default file explorer' })
end

-------------------------------------------------------------

local function setup_terminal()
    vim.keymap.set('n', '<leader>to', ':terminal<CR>', { noremap = true, silent = true, desc = 'Open terminal here' })

    vim.keymap.set('n', '<leader>tt', '<C-w>v<C-w>T:terminal<CR>',
        { noremap = true, silent = true, desc = 'Open terminal in new tab' })

    vim.keymap.set('n', '<leader>tl', '<C-w>v:terminal<CR>',
        { noremap = true, silent = true, desc = 'Open terminal right' })

    vim.keymap.set('n', '<leader>tj', '<C-w>s:terminal<CR>',
        { noremap = true, silent = true, desc = 'Open terminal below' })

    -- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
    -- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
    -- is not what someone will guess without a bit more experience.
    --
    -- NOTE This won't work in all terminal emulators/tmux/etc. Try your own mapping
    -- or just use <C-\><C-n> to exit terminal mode
    vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })
    vim.keymap.set('t', '<C-[>', [[<C-\><C-n>]], { noremap = true, desc = 'Exit terminal mode' })
end

-------------------------------------------------------------

local function setup_yank()
    -- Sync clipboard between OS and Neovim.
    --  Schedule the setting after `UiEnter` because it can increase startup-time.
    --  Remove this option if you want your OS clipboard to remain independent.
    --  NOTE `:help 'clipboard'`
    vim.schedule(function() vim.o.clipboard = 'unnamedplus' end)

    -- Highlight when yanking (copying) text
    --  Try it with `yap` in normal mode
    --  NOTE `:help vim.hl.on_yank()`
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
end

-------------------------------------------------------------

local function setup_editing()
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
    -- NOTE `:help 'confirm'`
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
end

-------------------------------------------------------------

local function setup_buffers()
    -- NOTE `:help wincmd` for a list of all window commands

    vim.o.splitright = true
    vim.o.splitbelow = true

    vim.keymap.set('n', '<leader><leader>', '<C-6>', { desc = 'Switch buffer' })

    vim.keymap.set('n', '<C-w>t', ':tabe %<CR>', { desc = 'Copy into a new tab' })

    -- NOTE <C-A-l> and <C-A-h> are reserved for terminal tab moves
    vim.keymap.set('n', '<A-l>', 'gt', { noremap = true, desc = 'Go to next tab' })
    vim.keymap.set('n', '<A-h>', 'gT', { noremap = true, desc = 'Go to prev tab' })

    vim.keymap.set('n', '[w', '<C-w>W', { noremap = true, desc = 'Move focus to the previous window' })
    vim.keymap.set('n', ']w', '<C-w>w', { noremap = true, desc = 'Move focus to the next window' })

    vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
    vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
    vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
    vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

    vim.keymap.set('n', '<A-S-h>', '<C-w>H', { desc = 'Move window to the left' })
    vim.keymap.set('n', '<A-S-l>', '<C-w>L', { desc = 'Move window to the right' })
    vim.keymap.set('n', '<A-S-j>', '<C-w>J', { desc = 'Move window to the lower' })
    vim.keymap.set('n', '<A-S-k>', '<C-w>K', { desc = 'Move window to the upper' })

    vim.keymap.set('n', '<C-Up>', ':resize +2<CR>', { desc = 'Increase height of current window' })
    vim.keymap.set('n', '<C-Down>', ':resize -2<CR>', { desc = 'Decrease height of current window' })
    vim.keymap.set('n', '<C-Right>', ':vertical resize +2<CR>', { desc = 'Increase width of current window' })
    vim.keymap.set('n', '<C-Left>', ':vertical resize -2<CR>', { desc = 'Decrease width of current window' })

    -- TODO: toggle `<C-w>m`
    vim.keymap.set('n', '<C-w>m', '<C-w>|<C-w>_', { desc = 'Max Out' })
    vim.keymap.set('n', '<C-w>e', '<C-w>=', { desc = 'Equally high and width' })
end

-------------------------------------------------------------

local function setup_vim()
    vim.keymap.set('n', '<leader>vc', ':e ~/.config/nvim/init.lua<cr>', { desc = 'configure' })

    vim.keymap.set('n', '<leader>vv', ':w<cr>:source ~/.config/nvim/init.lua<cr>', { desc = 'source' })

    vim.keymap.set('n', '<leader>vn', ':e ~/.config/nvim/NOTES.md<cr>', { desc = 'NOTES.md' })

    vim.keymap.set('n', '<leader>vt', ':e ~/.config/nvim/TOOLS.md<cr>', { desc = 'TOOLS.md' })

    vim.keymap.set('n', '<leader>vu', ':packupdate<cr>', { desc = 'update' })
end

-------------------------------------------------------------

local function setup_scrolling()
    vim.o.scrolloff = 5 -- Minimal number of screen lines to keep above and below the cursor.
    -- vim.opt.sidescrolloff = 999

    vim.keymap.set('n', '<C-u>', '<C-u>zz', { desc = 'Scroll up in buffer with cursor centered' })
    vim.keymap.set('n', '<C-d>', '<C-d>zz', { desc = 'Scroll down in buffer with cursor centered' })

    vim.keymap.set('n', '[v', 'H', { desc = 'Scroll up to begginng of visible lines' })
    vim.keymap.set('n', ']v', 'L', { desc = 'Scroll down to begginng of visible lines' })
end

-------------------------------------------------------------

local function set_theme()
    if is_dark_theme then
        vim.cmd.colorscheme(dark_theme)
    else
        vim.cmd.colorscheme(light_theme)
    end
end

local function setup_theme()
    -- [[ CURSOR ]]
    vim.o.mouse = 'a'
    vim.o.guicursor = ''
    vim.o.cursorline = true -- Show which line your cursor is on

    vim.o.showmode = false  -- it's already in the status line
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
    --  NOTE `:help 'list'`
    --  NOTE `:help 'listchars'`
    --
    --  Notice listchars is set using `vim.opt` instead of `vim.o`.
    --  It is very similar to `vim.o` but offers an interface for conveniently interacting with tables.
    --   NOTE `:help lua-options`
    --   NOTE `:help lua-guide-options`
    vim.o.list = true
    vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

    set_theme()

    vim.api.nvim_set_keymap('n', '<C-0>', ':lua vim.g.neovide_scale_factor = 1<CR>', { silent = true, noremap = true })
    vim.api.nvim_set_keymap('n', '<C-=>', ':lua vim.g.neovide_scale_factor = vim.g.neovide_scale_factor + 0.05<CR>',
        { silent = true })
    vim.api.nvim_set_keymap('n', '<C-->', ':lua vim.g.neovide_scale_factor = vim.g.neovide_scale_factor - 0.05<CR>',
        { silent = true })

    vim.keymap.set('n', '<leader>,t', function()
        is_dark_theme = not is_dark_theme
        set_theme()
    end, { desc = 'Toggle theme' })

    vim.keymap.set('n', '<leader>,T', ':colorscheme ', { desc = 'Change theme' })
end

-------------------------------------------------------------
--- TREESITTER, MASON, AND LSP SETUPS
-------------------------------------------------------------

local function setup_treesitter()
    local treesitter = require 'nvim-treesitter'

    treesitter.install(ensure_syntax_supported)

    vim.api.nvim_create_autocmd('FileType', {
        pattern = '*',
        callback = function(args)
            local buf = args.buf
            local ft = vim.bo[buf].filetype

            local lang = vim.treesitter.language.get_lang(ft)
            if not lang then return end

            local ok_add = pcall(vim.treesitter.language.add, lang)
            if not ok_add then return end

            pcall(vim.treesitter.start, buf, lang)
        end,
    })
end

local function setup_mason()
    require('mason').setup()

    -- NOTE: press `i` on each LSP to be installed
    vim.keymap.set('n', '<leader>mm', ':Mason<CR>', { noremap = true, desc = 'Open mason window' })
    vim.keymap.set('n', '<leader>mi', ':MasonInstall ', { noremap = true, desc = 'Mason install' })
    vim.keymap.set('n', '<leader>mp', ':lua print(vim.fn.exepath(""))<Left><Left><Left>',
        { noremap = true, desc = 'See installed lsp path' })
end

-- NOTE `:h lsp`
local function setup_lsp()
    vim.keymap.set('n', '<leader>ll', '<C-w>s:e ~/.local/state/nvim/lsp.log<cr>G', { desc = 'Open lsp.log' })

    -- defaults
    -- NOTE vim.keymap.set('n', 'gri', vim.lsp.buf.implementation, opts, { desc = "Go to implementation" })
    -- NOTE vim.keymap.set('n', 'grt', vim.lsp.buf.type_definition, opts, { desc = "Go to type definition" })
    -- NOTE vim.keymap.set('n', 'grr', vim.lsp.buf.references, opts, { desc = "Find references" })
    -- NOTE vim.keymap.set('n', 'grn', vim.lsp.buf.rename, opts, { desc = "Rename" })
    -- NOTE vim.keymap.set({ 'n', 'v' }, 'gra', vim.lsp.buf.code_action, opts, { desc = "Code action" })
    -- NOTE vim.keymap.set('n', 'grx', vim.lsp.buf.run, opts, { desc = "Run code lens" })
    -- NOTE vim.keymap.set('n', 'gO', vim.lsp.buf.document_symbol, opts, { desc = "Document symbols" })
    -- NOTE vim.keymap.set('n', '<C-s>', vim.lsp.buf.signature_help, opts, { desc = "Signature help" })
    -- NOTE vim.keymap.set('n', 'K', vim.lsp.buf.hover, vim.tbl_extend("force", opts, { desc = "Show documentation" }))
    -- NOTE vim.keymap.set('n', '<C-w>d', vim.diagnostic.open_float, opts, { desc = 'Show line diagnostics' })

    vim.keymap.set('n', 'grd', vim.lsp.buf.definition, opts, { desc = 'Go to definition' })
    vim.keymap.set('n', 'grf', vim.lsp.buf.format, opts, { desc = 'Format local buffer' })

    vim.diagnostic.config({
        virtual_text = true, -- TODO: toggle to false in zen mode
        underline = false,   -- draws an underline below diagnosed words
        update_in_insert = false,
    })

    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities = vim.tbl_deep_extend('force', capabilities, MiniCompletion.get_lsp_capabilities())

    vim.lsp.config('*', { capabilities = capabilities })

    for name, options in pairs(servers) do
        -- TODO: install unavailble servers
        -- local exepath = vim.fn.exepath(name)
        vim.lsp.config(name, options)
    end

    local ensure_installed = vim.tbl_keys(servers or {})
    vim.list_extend(ensure_installed, {
        -- 'stylua', -- Used to format Lua code
    })
    vim.lsp.enable(ensure_installed)
end

-------------------------------------------------------------
--- MINI SETUPS
-------------------------------------------------------------

local function setup_mini_icons()
    require("mini.icons").setup()
end

local function setup_mini_animate()
    local MiniAnimate = require("mini.animate")

    local setup_animate = function()
        MiniAnimate.setup({
            cursor = { enable = animate },
            scroll = { enable = false },
            resize = { enable = animate },
            open = { enable = animate },
            close = { enable = animate },
        })
    end

    setup_animate()

    vim.keymap.set('n', '<leader>,a', function()
        animate = not animate
        setup_animate()
    end, { desc = 'Toggle animation' })
end

local function setup_mini_notify()
    require("mini.notify").setup {
        -- Content management
        content = {
            -- Function which formats the notification message
            -- By default prepends message with notification time
            format = function(notif) return notif.msg end,

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
    }
end

local function setup_mini_files()
    local MiniFiles = require 'mini.files'

    MiniFiles.setup {
        mappings = {
            -- NOTE close = "q",
            -- NOTE create_file = "o",
            -- NOTE rename_file = "ciw",
            -- NOTE delete_file = "dd",
            -- NOTE copy_file = "yypp",
            -- NOTE apply_changes = "<C-[>=y",
            go_in = '<CR>',
            go_in_plus = 'L',
            go_out = '_',
            go_out_plus = 'H',
        },
    }

    vim.keymap.set('n', '.', '<cmd>lua MiniFiles.open()<CR>', { desc = 'Mini file explorer' })

    vim.keymap.set('n', '<C-.>', function()
        MiniFiles.open(vim.api.nvim_buf_get_name(0), false)
        MiniFiles.reveal_cwd()
    end, { desc = 'Toggle into currently open file' })
end

local function setup_mini_pick()
    local MiniPick = require 'mini.pick'

    MiniPick.setup()

    vim.keymap.set('n', '<leader>p', ':Pick ', { desc = 'Pick' })

    vim.keymap.set('n', '<leader>sw', function() MiniPick.builtin.grep { pattern = vim.fn.expand '<cword>' } end,
        { desc = 'Search word under cursor' })

    vim.keymap.set('n', '<leader>ob', function() MiniPick.builtin.buffers() end, { desc = 'Open buffer' })

    vim.keymap.set('n', '<leader>oo', function() MiniPick.builtin.files() end, { desc = 'Open file' })

    vim.keymap.set('n', '<leader>sh', function() MiniPick.builtin.help() end, { desc = 'Search helps' })
end

local function setup_mini_extra()
    local MiniExtra = require 'mini.extra'

    MiniExtra.setup()

    vim.keymap.set('n', '<leader>sk', function() MiniExtra.pickers.keymaps() end, { desc = 'Search keymaps' })

    vim.keymap.set('n', '<leader>sd', function() MiniExtra.pickers.diagnostic() end,
        { desc = 'Search diagnostics (workspace)' })
end

local function setup_mini_cmdline()
    require('mini.cmdline').setup {
        autocorrect = { enable = false },
    }
end

local function setup_mini_completion()
    vim.opt.completeopt = 'menuone,noselect,fuzzy,nosort'
    vim.opt.shortmess:append 'c'

    MiniCompletion.setup {
        lsp_completion = {
            auto_setup = true,
        },
    }
end

-- NOTE `<C-l>` jumps to next placeholder
-- NOTE `<C-h>` jumps to prev placeholder
local function setup_mini_snippets()
    local MiniSnippets = require 'mini.snippets'

    MiniSnippets.setup {
        snippets = {
            MiniSnippets.gen_loader.from_lang(), -- loads friendly-snippets automatically
        },
    }

    MiniSnippets.start_lsp_server { match = false }
end

-- NOTE `sr'"` replaces ' with "
-- NOTE `sd"` deletes surrounding (")
-- NOTE `viwsa'` or `saiw'` surrounds selected with `'`
-- NOTE `saiwtp className="m2"<CR>` surrounds selected with `<p className="m2">` and `</p>`
-- NOTE `srtth3<CR>` replaces p tag with h3
-- NOTE `srtb` deletes tags around and surrounds with ()
-- NOTE `srb{` deletes () around and surrounds with {}
-- NOTE `sd{` deletes {} around
local function setup_mini_surround()
    require 'mini.surround'.setup()
end

local function setup_mini_git()
    require("mini.git").setup()
end

-- NOTE `N [h` previous hunk
-- NOTE `N ]h` next hunk
-- NOTE `N [H` first hunk
-- NOTE `N ]H` last hunk
-- NOTE `V gh` stage hunk
-- NOTE `V gH` reset hunk
local function setup_mini_diff()
    local MiniDiff = require("mini.diff")

    MiniDiff.setup({
        source = MiniDiff.gen_source.git({ index = false })
    })

    vim.keymap.set('n', '<leader>gg', '<cmd>tabnew | Git | only<cr>', { desc = 'Open fugitive tab' })

    vim.keymap.set('n', '<leader>gd', '<cmd>Gvdiffsplit<CR>', { desc = 'Git diff split' })

    vim.keymap.set('n', '<leader>gc', ':!git commit -m ""<Left>', { desc = 'Commit staged files' })
end

-- NOTE `[b` goes to previous tab
-- NOTE `]b` goes toprevious tab
local function setup_mini_tabline()
    require("mini.tabline").setup()
end

local function setup_mini_statusline()
    local statusline = require('mini.statusline')

    statusline.setup { use_icons = vim.g.have_nerd_font }

    statusline.section_location = function()
        return '%2l:%-2v/%2L'
    end
end

-------------------------------------------------------------

-------------------------------------------------------------
-- INTEGRATE SETUPS
-------------------------------------------------------------

setup_dependencies()
setup_base()
setup_yank()
setup_editing()
setup_scrolling()
setup_buffers()
setup_search()
setup_terminal()
setup_quickfix()
setup_file_management()
setup_vim()
setup_theme()

setup_treesitter()
setup_mason()
setup_lsp()

setup_mini_icons()
setup_mini_animate()
setup_mini_notify()
setup_mini_files()
setup_mini_pick()
setup_mini_extra()
setup_mini_cmdline()
setup_mini_completion()
setup_mini_snippets()
setup_mini_surround()
-- setup_mini_git()
setup_mini_diff()
setup_mini_tabline()
setup_mini_statusline()
