-- TODO: editorconfig, stylua
-- NOTE `:bd` deletes buffer
-- NOTE `:za` toggles fold
-- NOTE `viw`
--   - following `an`s selects outer scope
--   - following `in`s selects inner scope

-------------------------------------------------------------
-- SETTINGS
-------------------------------------------------------------

local animate = true

local is_dark_theme = true

-- local light_theme = 'shine'
local light_theme = 'peachpuff'

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
                    command = 'clippy',
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
                    -- library = {
                    --     vim.fn.expand '.luastubs',
                    --     unpack(vim.api.nvim_get_runtime_file("", true))
                    -- },
                    checkThirdParty = false,
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
                        -- 'vim',
                        -- 'opts',
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
-- OPTIONS
-------------------------------------------------------------
-- NOTE `:help vim.o`
-- NOTE `:help option-list`
-- NOTE `:help vim.keymap.set()`

-- [[ KEYS ]]
vim.g.mapleader = ' '                -- NOTE `:help mapleader`
vim.g.maplocalleader = ' '
vim.o.backspace = 'indent,eol,start' -- better backspace behaviour
vim.o.updatetime = 1000              -- Decrease update time
vim.o.timeoutlen = 1000              -- Decrease mapped sequence wait time
vim.o.ttimeoutlen = 50               -- key code timeout

-- [[ CURSOR, MOUSE, SOUNDS ]]
-- NOTE `h 'guicursor'`
vim.o.guicursor =
'n-v-c:block,i-ci-ve:ver25,r-cr:hor20,o:hor50,a:blinkwait700-blinkoff400-blinkon250-Cursor/lCursor,sm:block-blinkwait175-blinkoff150-blinkon175'
vim.o.mouse = 'a'        -- enable mouse support
vim.o.errorbells = false -- no error sounds
vim.g.neovide_cursor_vfx_mode = 'wireframe'

-- [[ FONT ]]
vim.o.termguicolors = true
vim.o.guifont = 'FiraCode Nerd Font Mono:h12'
vim.g.have_nerd_font = true
vim.g.neovide_scale_factor = 1

-- [[ FILE ]]
-- ask to save the current file before performing an operation needing saved changes (like `:q`)
-- NOTE `:help 'confirm'`
vim.o.confirm = true
vim.o.autochdir = false                        -- do not autochange directories
vim.o.backup = false                           -- do not create a backup file
vim.o.writebackup = false                      -- do not write to a backup file
vim.o.swapfile = false                         -- do not create a swapfile
vim.o.undofile = true                          -- do create an undo file
vim.o.undodir = vim.fn.expand '~/.vim/undodir' -- set the undo directory
vim.o.autoread = true                          -- auto-reload changes if outside of neovim
vim.o.autowrite = false                        -- do not auto-save
vim.o.modifiable = true                        -- allow buffer modifications
vim.o.hidden = true                            -- allow hidden buffers
vim.o.encoding = 'UTF-8'

-- [[ SCOPES ]]
vim.o.foldmethod = 'expr'                          -- use expression for folding
vim.o.foldexpr = 'v:lua.vim.treesitter.foldexpr()' -- use treesitter for folding
vim.o.foldlevel = 99                               -- start with all folds open
vim.o.showmatch = true                             -- highlights matching brackets
vim.o.selection = 'inclusive'                      -- include last char in selection
vim.opt.iskeyword:append '-'                       -- include - in words
vim.opt.clipboard:append 'unnamedplus'             -- use system clipboard NOTE: `:help 'clipboard'`

-- [[ LINES ]]
vim.o.number = true               -- line number
vim.o.relativenumber = true       -- relative line numbers
vim.o.cursorline = true           -- highlight current line
vim.o.concealcursor = ''          -- do not hide cursorline in markup
vim.o.wrap = false                -- do not wrap lines by default
vim.o.scrolloff = 5               -- Minimal number of screen lines to keep above and below the cursor.
vim.o.sidescrolloff = 5           -- keep 5 lines to left/right of cursor
vim.opt.fillchars = { eob = ' ' } -- hide "~" on empty lines

-- [[ COLUMNS ]]
vim.o.signcolumn = 'yes'  -- always show a sign column
vim.o.colorcolumn = '0'   -- don't show a coloumn as line limit
vim.o.colorcolumn = '100' -- show a column at 100 position chars as line limit

-- [[ INDENTS ]]
vim.o.tabstop = 4        -- tabwidth
vim.o.shiftwidth = 4     -- indent width
vim.o.softtabstop = 4    -- soft tab stop not tabs on tab/backspace
vim.o.expandtab = true   -- use spaces instead of tabs
vim.o.smartindent = true -- smart auto-indent
vim.o.autoindent = true  -- copy indent from current line
vim.o.breakindent = true -- break indent

-- [[ SEARCH ]]
vim.o.ignorecase = true    -- case-insensitive search
vim.o.smartcase = true     -- enable case-sensitive search when uppercased letter is present
vim.o.inccommand = 'split' -- preview substitutions live, as you type!
vim.o.hlsearch = true      -- highlight search matches
vim.o.incsearch = true     -- shows matches as you type
vim.opt.path:append '**'   -- include subdirs in search

-- [[ STATUSLINE ]]
vim.o.cmdheight = 1    -- single line command line
vim.o.showmode = false -- do not show the mode, it's already in the status line
vim.o.laststatus = 3

-- [[ WINDOWS ]]
vim.o.winborder = 'rounded'
vim.o.pumheight = 10    -- popup menu height
vim.o.pumblend = 10     -- popup menu transparency
vim.o.winblend = 0      -- floating window transparency
vim.o.splitbelow = true -- horizontal splits go below
vim.o.splitright = true -- vertical splits go right
--vim.g.netrw_banner = 0 -- show only files and folders in file explorer

-- [[ LIST, COMPLETION ]]
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
vim.o.completeopt = 'menuone,noselect,fuzzy,nosort,noinsert'
vim.o.wildmenu = true -- tab completion
vim.opt.shortmess:append 'c'

-- [[ RESOURCES ]]
vim.o.redrawtime = 10000    -- increase neovim redraw tolerance
vim.o.maxmempattern = 20000 -- increase max memory
vim.o.synmaxcol = 300       -- syntax highlighting limit

-- [[ OTHERS ]]
vim.o.conceallevel = 2                -- obsidian requirement
vim.opt.diffopt:append 'linematch:60' -- improve diff display
vim.opt.isfname:append '@-@'

-------------------------------------------------------------
-- DEPENDENCIES
-------------------------------------------------------------

vim.pack.add {
    'https://github.com/mg979/vim-visual-multi',
    'https://github.com/folke/lazydev.nvim',
    'https://github.com/rafamadriz/friendly-snippets',
    'https://github.com/nvim-mini/mini.nvim',
    { src = 'https://github.com/nvim-treesitter/nvim-treesitter', branch = 'main' },
    'https://github.com/neovim/nvim-lspconfig',
    'https://github.com/mason-org/mason.nvim',
    'https://github.com/tpope/vim-fugitive',
}

-- NOTE `g<` jumps to commandline output
require('vim._core.ui2').enable {}

local MiniCompletion = require 'mini.completion'

-- NOTE `:PackAdd https://github.com/bluz71/vim-moonfly-colors`
-- NOTE `:PackDel vim-moonfly-colors`
local function setup_dependencies()
    vim.api.nvim_create_user_command(
        'PackAdd',
        function(opts) vim.pack.add(opts.fargs) end,
        { nargs = '+', desc = 'Add plugins (:PackAdd user/repo1 user2/repo2)' }
    )

    vim.api.nvim_create_user_command(
        'PackDel',
        function(opts) vim.pack.del(opts.fargs) end,
        { nargs = '+', desc = 'Del plugins (:PackDel user/repo1 user2/repo2)' }
    )

    vim.api.nvim_create_user_command('PackUpdate', function(opts)
        -- check if any arg is passed
        if opts.args:match '%S' then
            -- update specific plugins
            local plugins = vim.split(opts.args, '%s+', { trimempty = true })
            -- update only specific plugins
            vim.pack.update(plugins)
        else
            -- updat all
            vim.pack.update()
        end
    end, { nargs = '*', desc = 'Update plugins (:PackUpdate user/repo1 user2/repo2)' })
end

-------------------------------------------------------------
-- HELPER FUNCTIONS
-------------------------------------------------------------

local i = 'i'
local n = 'n'
local t = 't'
local v = 'v'
local x = 'x'
local noremap = 'noremap'
local nowait = 'nowait'
local silent = 'silent'
local script = 'script'
local unique = 'unique'
local expr = 'expr'

local function map(lhs, rhs, desc, ...)
    local modes = {}
    local opts = { desc = desc }
    for _, value in ipairs { ... } do
        if value == silent then
            opts.silent = true
        elseif value == expr then
            opts.expr = true
        elseif value == noremap then
            opts.noremap = true
        elseif value == script then
            opts.script = true
        elseif value == unique then
            opts.unique = true
        elseif value == nowait then
            opts.nowait = true
        elseif value == i then
            modes[#modes + 1] = i
        elseif value == n then
            modes[#modes + 1] = n
        elseif value == t then
            modes[#modes + 1] = t
        elseif value == v then
            modes[#modes + 1] = v
        elseif value == x then
            modes[#modes + 1] = x
        elseif type(value) == 'table' then
            for k, val in pairs(value) do
                opts[k] = val
            end
        end
    end
    modes = #modes > 0 and modes or { n }
    vim.keymap.set(modes, lhs, rhs, opts)
end

local function imap(l, r, d, ...) map(l, r, d, i, ...) end
local function nmap(l, r, d, ...) map(l, r, d, n, ...) end
local function tmap(l, r, d, ...) map(l, r, d, t, ...) end
local function vmap(l, r, d, ...) map(l, r, d, v, ...) end
local function xmap(l, r, d, ...) map(l, r, d, x, ...) end

local function inoremap(l, r, d, ...) map(l, r, d, i, noremap, ...) end
local function nnoremap(l, r, d, ...) map(l, r, d, n, noremap, ...) end
local function tnoremap(l, r, d, ...) map(l, r, d, t, noremap, ...) end
local function vnoremap(l, r, d, ...) map(l, r, d, v, noremap, ...) end
local function xnoremap(l, r, d, ...) map(l, r, d, x, noremap, ...) end

-------------------------------------------------------------
-- PRIMITIVES
-------------------------------------------------------------

local function setup_base()
    if vim.fn.isdirectory(vim.o.undodir) == 0 then vim.fn.mkdir(vim.o.undodir, 'p') end

    -- Enable faster startup by caching compiled Lua modules
    vim.loader.enable()

    nmap('j', function() return vim.v.count == 0 and 'gj' or 'j' end, 'Down (wrap-aware)', silent, expr)
    nmap('k', function() return vim.v.count == 0 and 'gk' or 'k' end, 'Up (wrap-aware)', silent, expr)

    nmap('<left>', '<cmd>echo "Use h to move!!"<CR>')
    nmap('<right>', '<cmd>echo "Use l to move!!"<CR>')
    nmap('<up>', '<cmd>echo "Use k to move!!"<CR>')
    nmap('<down>', '<cmd>echo "Use j to move!!"<CR>')

    -- TODO: move below lines to better setup function

    nnoremap('<leader>oh', ':checkhealth<CR>', 'Health Check')

    nnoremap('<leader>ou', function()
        vim.cmd.packadd 'nvim.undotree'
        require('undotree').open()
    end, 'Undotree')

    nmap('<leader>rx', '<cmd>!chmod +x %<CR>', 'Make file executable', silent)

    nnoremap('<leader>xx', ':@<CR>', 'Executes last command')

    -------------------------------------------------------------
    -- BASIC AUTOCOMMANDS
    -------------------------------------------------------------
    --  NOTE `:help lua-guide-autocommands`
end

-------------------------------------------------------------

local function setup_toggles()
    nmap('<leader>,d', ':lua vim.diagnostic.enable(not vim.diagnostic.is_enabled())<CR>', 'Toggle diagnostics')

    nmap('<leader>,w', ':set wrap!<CR>', 'Toggle line wrap')

    -- TODO: Toggle comment
    vmap('<C-/>', ':echo "comment"', 'Toggle comment')

    -- TODO: toggle `<C-w>m`
    nmap('<C-w>m', '<C-w>|<C-w>_', 'Max Out')
    nmap('<C-w>e', '<C-w>=', 'Equally high and width')
end

-------------------------------------------------------------

local function setup_search()
    -- clear highlights on search when pressing <esc> in normal mode
    --  NOTE `:help hlsearch`
    nmap('<esc>', '<cmd>nohlsearch<cr>')

    nmap('n', 'nzzzv', 'Next search result with cursor centered')
    nmap('N', 'Nzzzv', 'Previous search result with cursor centered')

    nmap('<leader>rr', [[:%s//gc<Left><Left><Left>]], 'Replace')

    nmap('<leader>rw', [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gc<Left><Left><Left>]], 'Replace word under cursor')
end

-------------------------------------------------------------

local function setup_quickfix()
    nmap('<A-n>', '<cmd>cnext<CR>', 'Next Place in QuickFix List')
    nmap('<A-p>', '<cmd>cprev<CR>', 'Prev Place in QuickFix List')

    nmap('<leader>co', '<cmd>copen<CR>', 'Open Quickfix List')

    -- Clear and close quickfix list completely
    nmap('<leader>cq', function()
        vim.fn.setqflist({}, 'r') -- replace with empty list
        vim.cmd.cclose()
    end, 'Clear and close whole list')

    -- Add current line to quickfix list (workspace-wide)
    nmap('<leader>cc', function()
        local qf = vim.fn.getqflist()
        table.insert(qf, {
            bufnr = vim.api.nvim_get_current_buf(),
            lnum = vim.fn.line '.',
            col = vim.fn.col '.',
            text = vim.fn.getline '.',
        })
        vim.fn.setqflist(qf, 'r')
    end, 'Add current line to list')

    -- Delete current line from quickfix list
    nmap('<leader>cd', function()
        local qf = vim.fn.getqflist()
        local idx = vim.fn.line '.' -- current line in quickfix window
        if vim.bo.filetype ~= 'qf' then
            vim.notify('Open quickfix window and place cursor on the entry to delete', vim.log.levels.WARN)
            return
        end
        table.remove(qf, idx)
        vim.fn.setqflist(qf, 'r')
        vim.cmd.copen() -- refresh
    end, 'Delete current line from list')

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

local function setup_terminal()
    nnoremap('<leader>to', ':terminal<CR>', 'Open terminal here', silent)

    nnoremap('<leader>tt', '<C-w>v<C-w>T:terminal<CR>', 'Open terminal in new tab', silent)

    nnoremap('<leader>tl', '<C-w>v:terminal<CR>', 'Open terminal right', silent)

    nnoremap('<leader>tj', '<C-w>s:terminal<CR>', 'Open terminal below', silent)

    -- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
    -- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
    -- is not what someone will guess without a bit more experience.
    --
    -- NOTE This won't work in all terminal emulators/tmux/etc. Try your own mapping
    -- or just use <C-\><C-n> to exit terminal mode
    tmap('<Esc><Esc>', '<C-\\><C-n>', 'Exit terminal mode')
    tnoremap('<C-[>', [[<C-\><C-n>]], 'Exit terminal mode')
end

-------------------------------------------------------------

local function setup_yank()
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
    vmap('p', 'P')
    vmap('P', 'p')

    nmap('<leader>yn', function()
        vim.fn.setreg('+', vim.fn.expand '%:t')
        print('Yanked filename: ' .. vim.fn.expand '%:t')
    end, 'Yank File Name')

    nmap('<leader>yp', function()
        vim.fn.setreg('+', vim.fn.expand '%:.')
        print('Yanked relative path: ' .. vim.fn.expand '%:.')
    end, 'Yank Relative File Path')

    nmap('<leader>yP', function()
        vim.fn.setreg('+', vim.fn.expand '%:p')
        print('Yanked absolute path: ' .. vim.fn.expand '%:p')
    end, 'Yank Absolute File Path')

    nnoremap('<leader>yy', 'mzggVGy`z', 'Yank whole content', silent)

    -- FIXME
    nmap('<leader>yc', 'g<ggVGy:q<CR>', 'Yank cmdline message')
end

-------------------------------------------------------------

local function setup_editing()
    nnoremap('<c-a>', 'ggVG', 'Select All Lines', silent)

    inoremap('<C-d>', '<Del>', 'Delete next char')

    nmap('<A-o>', 'mzo<Esc>`z', 'Add blank line below staying here')
    nmap('<A-S-o>', 'mzO<Esc>`z', 'Add blank line above staying here')
    nmap('<S-CR>', 'O<Esc>', 'Add blank line above and go there')
    nmap('<CR>', 'o<Esc>', 'Add blank line below and go there')

    nmap('<A-j>', 'mz:m+1<CR>`z==', 'Move line down')
    imap('<A-j>', '<Esc>:m +1<CR>gi', 'Move line down')
    vmap('<A-j>', ":m '>+1<CR>gv=gv", 'Move lines down')

    nmap('<A-k>', 'mz:m-2<CR>`z==', 'Move line up')
    imap('<A-k>', '<Esc>:m -2<CR>gi', 'Move line up')
    vmap('<A-k>', ":m '<-2<CR>gv=gv", 'Move lines up')

    vmap('<', '<gv', 'Indent Left and Reselect')
    vmap('>', '>gv', 'Indent Right and Reselect')
end

-------------------------------------------------------------

-- NOTE `:help wincmd` for a list of all window commands
local function setup_buffers()
    nmap('<leader><leader>', '<C-6>', 'Switch buffer')

    nmap('<C-w>t', ':tabe %<CR>', 'Copy into a new tab')

    -- NOTE <C-A-l> and <C-A-h> are reserved for terminal tab moves
    nnoremap('<A-l>', 'gt', 'Go to next tab')
    nnoremap('<A-h>', 'gT', 'Go to prev tab')

    nnoremap('[w', '<C-w>W', 'Move focus to the previous window')
    nnoremap(']w', '<C-w>w', 'Move focus to the next window')

    nmap('<C-h>', '<C-w><C-h>', 'Move focus to the left window')
    nmap('<C-l>', '<C-w><C-l>', 'Move focus to the right window')
    nmap('<C-j>', '<C-w><C-j>', 'Move focus to the lower window')
    nmap('<C-k>', '<C-w><C-k>', 'Move focus to the upper window')

    nmap('<A-S-h>', '<C-w>H', 'Move window to the left')
    nmap('<A-S-l>', '<C-w>L', 'Move window to the right')
    nmap('<A-S-j>', '<C-w>J', 'Move window to the lower')
    nmap('<A-S-k>', '<C-w>K', 'Move window to the upper')

    nmap('<C-Up>', ':resize +2<CR>', 'Increase height of current window')
    nmap('<C-Down>', ':resize -2<CR>', 'Decrease height of current window')
    nmap('<C-Right>', ':vertical resize +2<CR>', 'Increase width of current window')
    nmap('<C-Left>', ':vertical resize -2<CR>', 'Decrease width of current window')
end

-------------------------------------------------------------

local function setup_vim()
    nmap('<leader>vc', ':e ~/.config/nvim/init.lua<cr>', 'configure')

    nmap('<leader>vv', ':w<cr>:source ~/.config/nvim/init.lua<cr><Esc>', 'source')

    nmap('<leader>vn', ':e ~/.config/nvim/NOTES.md<cr>', 'NOTES.md')

    nmap('<leader>vt', ':e ~/.config/nvim/TOOLS.md<cr>', 'TOOLS.md')

    nmap('<leader>vu', ':packupdate<cr>', 'update')
end

-------------------------------------------------------------

local function setup_scrolling()
    nmap('<C-u>', '<C-u>zz', 'Half page up (centered)')
    nmap('<C-d>', '<C-d>zz', 'Half page down (centered)')

    nmap('[v', 'H', 'Scroll up to begginng of visible lines')
    nmap(']v', 'L', 'Scroll down to begginng of visible lines')
end

-------------------------------------------------------------

local function set_theme(is_dark)
    is_dark_theme = is_dark
    if is_dark_theme then
        vim.cmd.colorscheme(dark_theme)
    else
        vim.cmd.colorscheme(light_theme)
    end
end

local function setup_theme()
    set_theme(is_dark_theme)

    nnoremap('<C-0>', ':lua vim.g.neovide_scale_factor = 1<CR>', 'Reset zoom', silent)

    nmap('<C-=>', ':lua vim.g.neovide_scale_factor = vim.g.neovide_scale_factor + 0.05<CR>', 'Zoom in', silent)

    nmap('<C-->', ':lua vim.g.neovide_scale_factor = vim.g.neovide_scale_factor - 0.05<CR>', 'Zoom out', silent)

    nmap('<leader>,t', function() set_theme(not is_dark_theme) end, 'Toggle theme')

    nmap('<leader>,T', ':colorscheme ', 'Change theme')
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
    nnoremap('<leader>mm', ':Mason<CR>', 'Open mason window')
    nnoremap('<leader>mi', ':MasonInstall ', 'Mason install')
    nnoremap('<leader>mp', ':lua print(vim.fn.exepath(""))<Left><Left><Left>', 'See installed lsp path')
end

-- NOTE `:h lsp`
local function setup_lsp()
    nmap('<leader>ll', '<C-w>s:e ~/.local/state/nvim/lsp.log<cr>G', 'Open lsp.log')

    -- local opts = event.buf
    local opts = {}

    -- [[ DEFAULTS ]]
    -- NOTE map('gri', vim.lip.buf.implementation, 'Go to implementation', opts)
    -- NOTE map('grt', vim.lsp.buf.type_definition, 'Go to type definition', opts)
    -- NOTE map('grr', vim.lsp.buf.references, 'Find references', opts)
    -- NOTE map('grn;, vim.lsp.buf.rename, 'Rename', opts)
    -- NOTE map(;gra', vim.lsp.buf.code_action, opts, 'Code action', n, v, opts)
    -- NOTE map('grx', vim.lsp.buf.run, 'Run code lens', opts)
    -- NOTE map('gO', vim.lsp.buf.document_symbol, 'Document symbols', opts)
    -- NOTE map('<C-s>', vim.lsp.buf.signature_help, 'Signature help', opts)
    -- NOTE map('K', vim.lsp.buf.hover, "Show documentation", opts)
    -- NOTE map('<C-w>d', vim.diagnostic.open_float, 'Show line diagnostics', opts)

    map('grd', vim.lsp.buf.definition, 'Go to definition', opts)
    map('grf', vim.lsp.buf.format, 'Format local buffer', opts)

    vim.diagnostic.config {
        virtual_text = true, -- TODO: toggle to false in zen mode
        underline = false,   -- draws an underline below diagnosed words
        update_in_insert = false,
    }

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

-- `lazydev` configures Lua LSP for your Neovim config, runtime and plugins
-- used for completion, annotations and signatures of Neovim apis
local function setup_lazydev()
    require('lazydev').setup({
        library = {
            -- Load luvit types when the `vim.uv` word is found
            { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
        },
    })
end

-------------------------------------------------------------
--- MINI SETUPS
-------------------------------------------------------------

local function setup_mini_icons() require('mini.icons').setup() end

local function setup_mini_animate()
    local MiniAnimate = require 'mini.animate'

    local setup_animate = function()
        MiniAnimate.setup {
            cursor = { enable = animate },
            scroll = { enable = false },
            resize = { enable = false },
            open = { enable = animate },
            close = { enable = animate },
        }
    end

    setup_animate()

    nmap('<leader>,a', function()
        animate = not animate
        setup_animate()
    end, 'Toggle animation')
end

local function setup_mini_notify()
    require('mini.notify').setup {
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

    nmap('.', '<cmd>lua MiniFiles.open()<CR>', 'Mini file explorer')

    nmap('<C-.>', function()
        MiniFiles.open(vim.api.nvim_buf_get_name(0), false)
        MiniFiles.reveal_cwd()
    end, 'Toggle into currently open file')
end

local function setup_mini_pick()
    local MiniPick = require 'mini.pick'

    MiniPick.setup()

    nmap('<leader>p', ':Pick ', 'Pick')

    nmap('<leader>sw', function() MiniPick.builtin.grep { pattern = vim.fn.expand '<cword>' } end,
        'Search word under cursor')

    nmap('<leader>ob', function() MiniPick.builtin.buffers() end, 'Open buffer')

    nmap('<leader>oo', function() MiniPick.builtin.files() end, 'Open file')

    nmap('<leader>sh', function() MiniPick.builtin.help() end, 'Search helps')
end

local function setup_mini_extra()
    local MiniExtra = require 'mini.extra'

    MiniExtra.setup()

    nmap('<leader>sk', function() MiniExtra.pickers.keymaps() end, 'Search keymaps')

    nmap('<leader>sd', function() MiniExtra.pickers.diagnostic() end, 'Search diagnostics (workspace)')
end

local function setup_mini_cmdline()
    require('mini.cmdline').setup {
        autocorrect = { enable = false },
    }
end

local function setup_mini_completion()
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
local function setup_mini_surround() require('mini.surround').setup() end

local function setup_mini_git() require('mini.git').setup() end

-- NOTE `[h` previous hunk
-- NOTE `]h` next hunk
-- NOTE `[H` first hunk
-- NOTE `]H` last hunk
-- NOTE `Vgh` stage hunk
-- NOTE `VgH` reset hunk
local function setup_mini_diff()
    local MiniDiff = require 'mini.diff'

    MiniDiff.setup {
        source = MiniDiff.gen_source.git { index = false },
    }

    nmap('<leader>gg', '<cmd>tabnew | Git | only<cr>', 'Open fugitive tab')

    nmap('<leader>gd', '<cmd>Gvdiffsplit<CR>', 'Git diff split')

    -- FIXME: not working
    nmap('<leader>gh', 'Vgh<Esc>', 'Stage current line')
    nmap('<leader>gH', 'VgH<Esc>', 'Reset staged line')

    nmap('<leader>gc', ':!git commit -m ""<Left>', 'Commit staged files')
end

-- NOTE `[b` goes to previous buffer
-- NOTE `]b` goes toprevious buffer
local function setup_mini_tabline() require('mini.tabline').setup() end

local function setup_mini_statusline()
    local statusline = require 'mini.statusline'

    statusline.setup { use_icons = vim.g.have_nerd_font }

    statusline.section_location = function() return '%2l:%-2v/%2L' end
end

-------------------------------------------------------------
--- OTHER SETUPS
-------------------------------------------------------------

local function setup_multi_cursor() require('visual_multi').setup() end

-------------------------------------------------------------
-- INTEGRATE SETUPS
-------------------------------------------------------------

setup_dependencies()
setup_base()
setup_toggles()
setup_yank()
setup_editing()
setup_scrolling()
setup_buffers()
setup_search()
setup_terminal()
setup_quickfix()
setup_vim()
setup_theme()

setup_treesitter()
setup_mason()
setup_lsp()
setup_lazydev()

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

setup_multi_cursor()

