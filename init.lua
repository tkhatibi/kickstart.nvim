-- TODO: editorconfig
-- NOTE: `:bd` deletes buffer
-- NOTE: `:za` toggles fold
-- NOTE: `viw`
--   - following `an`s selects outer scope
--   - following `in`s selects inner scope

-------------------------------------------------------------
-- SETTINGS
-------------------------------------------------------------

local animate = true

local themes = {
  -- [[ DARK ONLY ]]
  'retrobox',
  'unokai',
  'slate',
  'catppuccin',
  'sorbet',
  'wildcharm',
  -- "tokyonight",
  -- "tokyonight-day",
  -- "tokyonight-moon",
  -- "tokyonight-night",
  -- "tokyonight-storm",
  'torte',
  'vim',
  'zaibatsu',
  'blue',
  'darkblue',
  'lunaperche',
  'default',
  'desert',
  'elflord',
  'evening',
  'habamax',
  'industry',
  'koehler',
  'murphy',
  'pablo',
  'ron',

  -- [[ LIGH AND DARK ]]
  'randomhue',
  'quiet',
  'miniautumn',
  'minicyan',
  'minischeme',
  'minispring',
  'minisummer',
  'miniwinter',

  -- [[ LIGHT ONLY]]
  'shine',
  'zellner',
  'delek',
  'morning',
  'peachpuff',
}

local ensure_syntax_supported = { 'all' }

-- NOTE: `:MasonInstall gopls pyright` the only way to have LSPs at the moment.
-- TODO: setup ensure_installed to skip manually installation of LSPs with `:MasonInstall`
--
-- NOTE: `:help lspconfig-all` for a list of all the pre-configured LSPs
--
-- Some languages (like typescript) have entire language plugins that can be useful:
--    https://github.com/pmizio/typescript-tools.nvim
--
local servers = {
  -- docker_compose_language_service = {},
  -- gitlab_ci_ls = {}, -- unofficial (rust)
  -- gh_actions_ls = {}, -- unofficial (javascript)
  -- ols = {}, -- odin ls
  -- vacuum = {}, -- openapi 2 and 3 (go)
  -- gopls = {}, -- golang
  -- pyright = {},
  clangd = {},
  neocmakelsp = {},    -- faster than cmake (rust)
  jinja_lsp = {},
  css_variables = {},  -- unofficial (typescript)
  buf_ls = {},         -- proto buffer (go)
  tailwindcss = {},    -- official
  html = {},           -- vscode extracted (js)
  eslint = {},         -- vscode extracted (js)
  cssls = {},          -- vscode extracted (js)
  jsonls = {},         -- vscode extracted (js)
  markdown_oxide = {}, -- markdown ls (rust)
  taplo = {},          -- toml formatter (rust)
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
      -- NOTE: to override these global settings, you can define a `.luarc.json` in project root:
      -- {
      --   "$schema": "https://raw.githubusercontent.com/LuaLS/vscode-lua/master/schema/schema.json",
      --   "workspace": {
      --     "checkThirdParty": false,
      --     "library": [
      --       ".luastubs",
      --       "${3rd}/love2d/library",
      --       "${3rd}/busted/library",
      --       "${3rd}/luaassert/library"
      --     ]
      --   },
      --   "diagnostics": {
      --     "globals": ["vim"]
      --   },
      --   "format": {
      --     "enable": true,
      --     "defaultConfig": {
      --       "trailing_table_separator": "smart"
      --     }
      --   },
      --   "hint": {
      --     "enable": true,
      --     "setType": true
      --   }
      -- }
      Lua = {
        workspace = {
          library = { vim.fn.expand '.luastubs' },
          checkThirdParty = false,
        },
        type = {
          weakNilCheck = false,
          weakUnionCheck = false,
        },
        format = {
          enable = true,
          defaultConfig = { -- EmmyLua
            indent_style = 'space',
            indent_size = '2',
            quote_style = 'single',
          },
        },
        -- completion = {
        --   callSnippet = 'Replace',
        -- },
        hint = {
          enable = true,
          setType = true,
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
      },
    },
  },
}

-------------------------------------------------------------
-- OPTIONS
-------------------------------------------------------------

-- NOTE: `:help vim.o`
-- NOTE: `:help option-list`
-- NOTE: `:help vim.keymap.set()`
local function setup_options()
  -- [[ KEYS ]]
  vim.g.mapleader = ' '                -- NOTE: `:help mapleader`
  vim.g.maplocalleader = ' '
  vim.o.backspace = 'indent,eol,start' -- better backspace behaviour
  vim.o.updatetime = 1000              -- Decrease update time
  vim.o.timeoutlen = 1000              -- Decrease mapped sequence wait time
  vim.o.ttimeoutlen = 50               -- key code timeout

  -- [[ CURSOR, MOUSE, SOUNDS ]]
  -- NOTE: `h 'guicursor'`
  -- vim.o.guicursor =
  -- 'n-v-c:block,i-ci-ve:ver25,r-cr:hor20,o:hor50,a:blinkwait700-blinkoff400-blinkon250-Cursor/lCursor,sm:block-blinkwait175-blinkoff150-blinkon175'
  vim.o.guicursor =
  'n-v-c:block,t:ver25,i-ci-ve:ver25,r-cr:hor20,o:hor50,a:blinkwait700-blinkoff400-blinkon250-Cursor/lCursor,sm:block-blinkwait175-blinkoff150-blinkon175'
  vim.o.mouse = 'a'        -- enable mouse support
  vim.o.errorbells = false -- no error sounds
  vim.g.neovide_cursor_vfx_mode = 'wireframe'
  vim.o.background = 'dark'

  -- [[ FONT ]]
  vim.o.termguicolors = true
  vim.o.guifont = 'FiraCode Nerd Font Mono:h12'
  vim.g.have_nerd_font = true
  vim.g.neovide_scale_factor = 1

  -- [[ FILE ]]
  -- ask to save the current file before performing an operation needing saved changes (like `:q`)
  -- NOTE: `:help 'confirm'`
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

  -- [[ CLIPBOARD ]]
  vim.opt.clipboard:append 'unnamedplus' -- use system clipboard NOTE: `:help 'clipboard'`
  if vim.fn.has 'wsl' == 1 then          -- clipboard sync wrapper
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

  -- [[ LINES ]]
  vim.o.number = true               -- line number
  vim.o.relativenumber = true       -- relative line numbers
  vim.o.cursorline = true           -- highlight current line
  vim.o.concealcursor = ''          -- do not hide cursorline in markup
  vim.o.wrap = false                -- do not wrap lines by default
  vim.o.scrolloff = 5               -- Minimal number of screen lines to keep above and below the cursor.
  vim.o.sidescrolloff = 0           -- keep 5 lines to left/right of cursor
  vim.opt.fillchars = { eob = ' ' } -- hide "~" on empty lines

  -- [[ COLUMNS ]]
  vim.o.signcolumn = 'yes' -- always show a sign column
  vim.o.colorcolumn = '0'  -- don't show a coloumn as line limit
  vim.o.colorcolumn = '80' -- show a column at 80 position chars as line limit

  -- [[ INDENTS ]]
  vim.o.tabstop = 2        -- tabwidth
  vim.o.shiftwidth = 2     -- indent width
  vim.o.softtabstop = 2    -- soft tab stop not tabs on tab/backspace
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
  vim.o.winborder = 'rounded' -- style of bordered window
  vim.o.pumheight = 10        -- popup menu height
  vim.o.pumblend = 10         -- popup menu transparency
  vim.o.winblend = 0          -- floating window transparency
  vim.o.splitbelow = true     -- horizontal splits go below
  vim.o.splitright = true     -- vertical splits go right
  --vim.g.netrw_banner = 0 -- show only files and folders in file explorer

  -- [[ LIST, COMPLETION ]]
  -- Sets how neovim will display certain whitespace characters in the editor.
  -- NOTE: `:help 'list'`
  -- NOTE: `:help 'listchars'`
  --
  --  Notice listchars is set using `vim.opt` instead of `vim.o`.
  --  It is very similar to `vim.o` but offers an interface for conveniently interacting with tables.
  --   NOTE: `:help lua-options`
  --   NOTE: `:help lua-guide-options`
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
end

-------------------------------------------------------------
-- HELPERS
-------------------------------------------------------------

local function contains(string, substring)
  return string:lower():find(substring:lower()) ~= nil
end

local function starts_with(str, substr)
  if not str or not substr then
    return false
  end
  return str:sub(1, #substr) == substr
end

local clue_window_width = 0

--- turns text to button
---@param text ?string
---@return string
local function button(text)
  if type(text) ~= 'string' then return text end

  local function mini(category, name) return ' ' .. MiniIcons.get(category, name) .. ' ' .. text end

  if text:len() + 3 > clue_window_width then
    clue_window_width = text:len() + 3
  end

  local starts_with_icon = vim.trim(text):sub(1, 1):byte() > 127

  if starts_with_icon then return text end

  if contains(text, 'hunk') then return mini('filetype', 'git') end
  if contains(text, 'git') then return mini('filetype', 'git') end
  if contains(text, 'neovim') then return mini('file', 'init.lua') end
  if contains(text, 'diff') then return mini('filetype', 'diff') end
  if contains(text, 'terminal') then return '🗔  ' .. text end
  if contains(text, 'terminal') then return mini('filetype', 'sh') end
  if contains(text, 'execute') then return mini('filetype', 'sh') end
  if contains(text, 'comment') then return '💬 ' .. text end
  if contains(text, 'mark') then return '📌 ' .. text end
  if contains(text, 'mark') then return '⚓ ' .. text end
  if contains(text, 'mark') then return '🏷 ' .. text end
  if contains(text, 'case') then return '🗛  ' .. text end
  if contains(text, 'health') then return '🏥 ' .. text end
  if contains(text, 'help') then return '🆘 ' .. text end
  if contains(text, 'theme') then return '🎨 ' .. text end
  if contains(text, 'keyboard') then return '⌨  ' .. text end
  if contains(text, 'keymap') then return '⌨  ' .. text end
  if contains(text, 'sleep') then return '💤 ' .. text end
  if contains(text, 'stage ') then return '➕ ' .. text end
  if contains(text, 'add') then return '➕ ' .. text end
  if contains(text, 'reset ') then return '➖ ' .. text end
  if contains(text, 'remove') then return '➖ ' .. text end
  if contains(text, 'clear') then return '🧹 ' .. text end
  if contains(text, 'close') then return '❌ ' .. text end
  if contains(text, 'delete') then return '🗑 ' .. text end
  if contains(text, 'bug') then return '🪲 ' .. text end
  if contains(text, 'diagnostic') then return '⚠️ ' .. text end
  if contains(text, 'warning') then return '⚠️ ' .. text end
  if contains(text, 'issue') then return '⚠️ ' .. text end
  if contains(text, 'format') then return '💅 ' .. text end
  if contains(text, 'zen') then return '🧘‍♂️ ' .. text end
  if contains(text, 'undo') then return '⎌  ' .. text end
  if contains(text, 'tree') then return '🌳 ' .. text end
  if contains(text, 'kill') then return '💀 ' .. text end
  if contains(text, 'save') then return '💾 ' .. text end
  if contains(text, 'write') then return '💾 ' .. text end
  if contains(text, 'switch') then return '🔄 ' .. text end
  if contains(text, 'fix') then return '🔧 ' .. text end
  if contains(text, 'mason') then return '📦 ' .. text end
  if contains(text, 'package') then return '📦 ' .. text end
  if contains(text, 'replace') then return '♻️ ' .. text end
  if contains(text, 'setting') then return '⚙️ ' .. text end
  if contains(text, 'highlight') then return '🟨 ' .. text end
  if contains(text, 'search') then return '🔎 ' .. text end
  if contains(text, 'find left') then return '🔍 ' .. text end
  if contains(text, 'find right') then return '🔎 ' .. text end
  if contains(text, 'terminal') then return '🖥 ' .. text end
  if contains(text, 'file explorer') then return '📂 ' .. text end
  if contains(text, 'file') then return '📝 ' .. text end
  if contains(text, 'buffer') then return '📝 ' .. text end
  if contains(text, 'yank') then return '📋 ' .. text end
  if contains(text, 'copy') then return '📋 ' .. text end
  if contains(text, 'go ') then return '🏃 ' .. text end
  if contains(text, 'open') then return '📂 ' .. text end

  return '   ' .. text
end

local vim_keymap_set = vim.keymap.set
local keymap_adder = ''
vim.keymap.set = function(modes, lhs, rhs, opts)
  opts = opts or {}
  local desc = button(opts.desc)
  if type(desc) ~= 'string' and type(rhs) == 'string' then
    desc = rhs
  end
  if type(desc) == 'string' and keymap_adder ~= '' and not starts_with(lhs, '<leader>') then
    if starts_with(keymap_adder, '#') then
      desc = desc .. ' 👉 ' .. keymap_adder
    else
      desc = desc .. ' ' .. keymap_adder
    end
  end
  local is_overriding = false
  local mode_list = type(modes) == 'table' and modes or { modes }
  for _, mode in ipairs(mode_list) do
    if vim.fn.mapcheck(lhs, mode) ~= '' then
      is_overriding = true
      break
    end
  end
  if is_overriding and type(desc) == 'string' then
    desc = desc .. ' 👺'
  end
  opts.desc = desc
  return vim_keymap_set(modes, lhs, rhs, opts)
end

local function is_code(buf)
  buf = buf or vim.api.nvim_get_current_buf()
  local buftype = vim.bo[buf].buftype
  local filetype = vim.bo[buf].filetype
  return buftype == ''
      and filetype ~= 'markdown'
      and filetype ~= 'md'
      and filetype ~= 'text'
      and filetype ~= 'txt'
      and filetype ~= 'log'
end

local function get_current_theme_index()
  local current_theme = vim.g.colors_name
  for i, theme in ipairs(themes) do
    if theme == current_theme then
      return i
    end
  end
  -- If current theme is not in the list (or none is set), default to the first one
  return 1
end

local function map_array(list, func)
  local new_list = {}
  for i, v in ipairs(list) do
    new_list[i] = func(v)
  end
  return new_list
end

--- generates a keymap rhs as help
---@param name string
---@return string
local function h(name)
  return ':h ' .. name .. '<CR>'
end

local n = 'n'
local c = 'c'
local i = 'i'
local t = 't'
local v = 'v'
local o = 'o'
local x = 'x'
local remap = 'remap'
local nowait = 'nowait'
local silent = 'silent'
local script = 'script'
local unique = 'unique'
local expr = 'expr'

local function map(lhs, rhs, desc, ...)
  local modes = {}
  local opts = {
    desc = button(desc),
    noremap = true,
  }
  local help = nil
  for _, value in ipairs { ... } do
    if value == silent then
      opts.silent = true
    elseif value == remap then
      opts.noremap = false
      opts.remap = true
    elseif value == expr then
      opts.expr = true
    elseif value == script then
      opts.script = true
    elseif value == unique then
      opts.unique = true
    elseif value == nowait then
      opts.nowait = true
    elseif value == c then
      modes[#modes + 1] = c
    elseif value == n then
      modes[#modes + 1] = n
    elseif value == i then
      modes[#modes + 1] = i
    elseif value == t then
      modes[#modes + 1] = t
    elseif value == v then
      modes[#modes + 1] = v
    elseif value == o then
      modes[#modes + 1] = o
    elseif value == x then
      modes[#modes + 1] = x
    elseif type(value) == 'string' and starts_with(value, ':h ') then
      help = value
    elseif type(value) == 'table' then
      for k, val in pairs(value) do
        opts[k] = val
      end
    else
      vim.print('invalid value for map `' .. lhs .. '`. value = `' .. value .. '`')
    end
  end
  if help ~= nil then
    for i, mode in ipairs(modes) do
      -- vim.keymap.set(n, '<leader>h' .. mode .. lhs, help, { desc = desc })
      vim.keymap.set(n, '<C-M-' .. mode .. '>' .. lhs, help, {
        desc = 'Help for `' .. desc .. '`'
      })
    end
  end
  vim.keymap.set(modes, lhs, rhs, opts)
end

local function nmap(l, r, d, ...) map(l, r, d, n, ...) end
local function imap(l, r, d, ...) map(l, r, d, i, ...) end
local function tmap(l, r, d, ...) map(l, r, d, t, ...) end
local function vmap(l, r, d, ...) map(l, r, d, v, ...) end
local function xmap(l, r, d, ...) map(l, r, d, x, ...) end

-------------------------------------------------------------
-- IMPORTS
-------------------------------------------------------------

vim.pack.add {
  'https://github.com/mg979/vim-visual-multi',
  'https://github.com/folke/lazydev.nvim',
  -- 'https://github.com/rafamadriz/friendly-snippets',
  'https://github.com/nvim-mini/mini.nvim',
  { src = 'https://github.com/nvim-treesitter/nvim-treesitter', branch = 'main', build = ':TSUpdate' },
  'https://github.com/neovim/nvim-lspconfig',
  'https://github.com/mason-org/mason.nvim',
  'https://github.com/tpope/vim-fugitive',
}

local MiniDiff = require 'mini.diff'
local MiniCompletion = require 'mini.completion'
local MiniFiles = require 'mini.files'
local MiniPick = require 'mini.pick'
local MiniExtra = require 'mini.extra'
local MiniIcons = require 'mini.icons'
local MiniSplitjoin = require 'mini.splitjoin'
-- local MiniSnippets = require 'mini.snippets'
local MiniHiPatterns = require('mini.hipatterns')
-- local MiniMap = require('mini.map')
-- local MiniComment = require('mini.comment')

-------------------------------------------------------------
-- CUSTOM FUNCTIONS
-------------------------------------------------------------

local fts = { buf = nil, win = nil, is_open = false } -- floating terminal state
local function toggle_floating_terminal()
  if fts.is_open and fts.win and vim.api.nvim_win_is_valid(fts.win) then
    vim.api.nvim_win_close(fts.win, false)
    fts.is_open = false
    return
  end

  if not fts.buf or not vim.api.nvim_buf_is_valid(fts.buf) then
    fts.buf = vim.api.nvim_create_buf(false, true)
    vim.bo[fts.buf].bufhidden = 'hide'
  end

  local width = math.floor(vim.o.columns * 0.8)
  local height = math.floor(vim.o.lines * 0.8)
  local row = math.floor((vim.o.lines - height) / 2)
  local col = math.floor((vim.o.columns - width) / 2)

  fts.win = vim.api.nvim_open_win(fts.buf, true, {
    relative = 'editor',
    width = width,
    height = height,
    row = row,
    col = col,
    style = 'minimal',
    border = 'rounded',
  })

  vim.wo[fts.win].winblend = 0
  vim.wo[fts.win].winhighlight = 'Normal:FloatingTermNormal,FloatBorder:FloatingTermBorder'
  vim.api.nvim_set_hl(0, 'FloatingTermNormal', { bg = 'none' })
  vim.api.nvim_set_hl(0, 'FloatingTermBorder', { bg = 'none' })

  local has_terminal = vim.bo[fts.buf].buftype == 'terminal'
  if not has_terminal then
    vim.fn.termopen(os.getenv('SHELL'))
  end

  fts.is_open = true
  vim.cmd('startinsert')

  local term_augroup = vim.api.nvim_create_augroup('FloatingTermLeave_' .. fts.win,
    { clear = true })
  vim.api.nvim_create_autocmd('BufLeave', {
    group = term_augroup,
    buffer = fts.buf,
    callback = function()
      if fts.is_open and fts.win and vim.api.nvim_win_is_valid(fts.win) then
        vim.api.nvim_win_close(fts.win, false)
        fts.is_open = false
      end
    end,
    once = true,
  })
end

local zen = false
function toggle_zen()
  zen = not zen

  -- GLOBAL OPTIONS (Apply instantly to the whole Neovim instance)
  vim.o.cmdheight = zen and 0 or 1
  vim.o.laststatus = zen and 0 or 3
  vim.o.showtabline = zen and 0 or 2

  -- Global diagnostics and mini.nvim plugin toggles
  vim.diagnostic.enable(not zen)
  vim.g.minitabline_disable = zen
  vim.g.miniindentscope_disable = zen
  vim.g.ministatusline_disable = zen
  vim.g.minicursorword_disable = zen

  -- Set the current buffer and global defaults for any FUTURE windows you open
  if is_code() then
    vim.o.number = not zen
    vim.o.relativenumber = not zen
    vim.o.signcolumn = zen and 'no' or 'yes'
  end

  -- WINDOW-LOCAL OPTIONS (Must be applied to EVERY open window)
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    local buf = vim.api.nvim_win_get_buf(win)
    if is_code(buf) then
      local opts = { scope = 'local', win = win }
      vim.api.nvim_set_option_value('number', not zen, opts)
      vim.api.nvim_set_option_value('relativenumber', not zen, opts)
      vim.api.nvim_set_option_value('signcolumn', zen and 'no' or 'yes', opts)
    end
  end
end

-------------------------------------------------------------
-- CUSTOM COMMANDS
-------------------------------------------------------------

local function setup_custom_commands()
  -- NOTE: `:PackAdd https://github.com/bluz71/vim-moonfly-colors`
  vim.api.nvim_create_user_command(
    'PackAdd',
    function(opts) vim.pack.add(opts.fargs) end,
    { nargs = '+', desc = 'Add plugins (:PackAdd user/repo1 user2/repo2)' }
  )

  -- NOTE: `:PackDel vim-moonfly-colors`
  vim.api.nvim_create_user_command(
    'PackDel',
    function(opts) vim.pack.del(opts.fargs) end,
    { nargs = '+', desc = 'Del plugins (:PackDel user/repo1 user2/repo2)' }
  )

  -- NOTE: `:PackUpdate vim-moonfly-colors`
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

  -- NOTE: `:Format`
  vim.api.nvim_create_user_command(
    'Format',
    function() vim.lsp.buf.format() end,
    { desc = 'Format the current buffer synchronously' }
  )

  -- NOTE: `:FormatAsync`
  vim.api.nvim_create_user_command(
    'FormatAsync',
    function() vim.lsp.buf.format({ async = true }) end,
    { desc = 'Format the current buffer asynchronously' }
  )

  -- NOTE: `:SelectNextTheme`
  vim.api.nvim_create_user_command('SelectNextTheme', function()
    local idx = get_current_theme_index()
    local next_idx = (idx == #themes) and 1 or (idx + 1)
    vim.cmd('colorscheme ' .. themes[next_idx])
    vim.print('Theme changed to ' .. themes[next_idx])
  end, { desc = 'Cycle to the next theme in the list' })

  -- NOTE: `:SelectPreviousTheme`
  vim.api.nvim_create_user_command('SelectPreviousTheme', function()
    local idx = get_current_theme_index()
    local prev_idx = (idx == 1) and #themes or (idx - 1)
    vim.cmd('colorscheme ' .. themes[prev_idx])
    vim.print('Theme changed to ' .. themes[prev_idx])
  end, { desc = 'Cycle to the previous theme in the list' })

  vim.api.nvim_create_user_command(
    'ToggleZen',
    toggle_zen,
    { desc = 'Toggle zen mode' }
  )

  vim.api.nvim_create_user_command(
    'ToggleFloatingTerminal',
    toggle_floating_terminal,
    { desc = 'Toggle floating terminal' }
  )
end

-------------------------------------------------------------
-- BASIC AUTOCOMMANDS
-------------------------------------------------------------

local augroup = vim.api.nvim_create_augroup('UserConfig', { clear = true })

-- NOTE: `:help lua-guide-autocommands`
local function setup_auto_commands()
  vim.api.nvim_create_autocmd('FileType', {
    desc = 'wrap, linebreak, number and spellcheck on markdown and text files',
    group = augroup,
    pattern = { 'markdown', 'text', 'gitcommit' },
    callback = function()
      vim.opt_local.wrap = true
      vim.opt_local.linebreak = true
      vim.opt_local.spell = true
      vim.opt_local.number = false
      vim.opt_local.relativenumber = false
    end,
  })

  -- NOTE: `:help vim.hl.on_yank()`
  vim.api.nvim_create_autocmd('TextYankPost', {
    desc = 'Highlight when yanking (copying) text',
    group = augroup,
    callback = function() vim.hl.on_yank() end,
  })

  vim.api.nvim_create_autocmd('BufReadPost', {
    desc = 'Restore last cursor position',
    group = augroup,
    callback = function()
      if vim.o.diff then -- except in diff mode
        return
      end

      local last_pos = vim.api.nvim_buf_get_mark(0, '"') -- {line, col}
      local last_line = vim.api.nvim_buf_line_count(0)

      local row = last_pos[1]
      if row < 1 or row > last_line then return end

      pcall(vim.api.nvim_win_set_cursor, 0, last_pos)
    end,
  })

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

  vim.api.nvim_create_autocmd('FileType', {
    desc = 'Open help, quickfix, etc. far right with fixed width',
    pattern = { 'help', 'qf' },
    group = augroup,
    callback = function()
      vim.cmd('wincmd L')
      vim.wo.winfixwidth = true
      vim.cmd('vertical resize 80')
    end,
  })

  vim.api.nvim_create_autocmd('TermOpen', {
    desc = 'Disable mini.indentscope in ternimals',
    group = augroup,
    callback = function(arg) vim.b[arg.buf].miniindentscope_disable = true end
  })

  vim.api.nvim_create_autocmd('TermClose', {
    desc = 'Delete terminal bufer on close',
    group = augroup,
    callback = function()
      if vim.v.event.status == 0 then
        vim.api.nvim_buf_delete(0, {})
      end
    end,
  })
end

-------------------------------------------------------------
-- KEYMAPS
-------------------------------------------------------------

-- [ mini.jump2d ]
-- NOTE: n`<CR>` starts motion
--
-- [ mini.diff ]
-- NOTE: `[h` previous hunk
-- NOTE: `]h` next hunk
-- NOTE: `[H` first hunk
-- NOTE: `]H` last hunk
-- NOTE: `Vgh` or `ghip` stage hunk
-- NOTE: `VgH` or `gHip` reset hunk
-- NOTE: `ghl` stage line hunk
-- NOTE: `gHl` reset line hunk
--
-- [ mini.snippets ]
-- NOTE: `<C-l>` next placeholder
-- NOTE: `<C-h>` prev placeholder
--
-- [ mini.surround ]
-- NOTE: `sr'"` replaces ' with "
-- NOTE: `sd"` deletes surrounding (")
-- NOTE: `viwsa'` or `saiw'` surrounds selected with `'`
-- NOTE: `saiwtp className="m2"<CR>` surrounds selected with `<p className="m2">` and `</p>`
-- NOTE: `srtth3<CR>` replaces p tag with h3
-- NOTE: `srtb` deletes tags around and surrounds with ()
-- NOTE: `srb{` deletes () around and surrounds with {}
-- NOTE: `sd{` deletes {} around
--
-- [ mini.files ]
-- NOTE: close = "q",
-- NOTE: create_file = "o",
-- NOTE: rename_file = "ciw",
-- NOTE: delete_file = "dd",
-- NOTE: copy_file = "yyp",
-- NOTE: apply_changes = "=y",
--
local function setup_keymaps(plugin_name, plugin_payload)
  if plugin_name == 'lsp' then
  end

  if plugin_name ~= nil then return end

  -- [[ OVERRIDES ]]

  nmap('<ESC>', '<CMD>nohlsearch<CR>', 'Clear highlight search') -- NOTE: `:help hlsearch`

  nmap('<left>', '<CMD>echo "Use h to move!!"<CR>')
  nmap('<right>', '<CMD>echo "Use l to move!!"<CR>')
  nmap('<up>', '<CMD>echo "Use k to move!!"<CR>')
  nmap('<down>', '<CMD>echo "Use j to move!!"<CR>')

  -- [[ UNCATEGORIZED ]]

  nmap('<leader>oh', ':checkhealth<CR>', 'Health Check')
  nmap('<leader>rx', '<CMD>!chmod +x %<CR>', 'Make file executable')
  nmap('<leader><', ':@<CR>', 'Executes last command') -- FIXME

  -- [[ TOGGLES ]]

  nmap('<leader>,d', ':lua vim.diagnostic.enable(not vim.diagnostic.is_enabled())<CR>', 'Toggle diagnostics')

  nmap('<leader>,w', ':set wrap!<CR>', 'Toggle line wrap')

  nmap('<C-w>m', '<C-w>|<C-w>_', 'Max Out')

  nmap('<leader>,z', toggle_zen, 'Toggle zen')

  -- [[ QUICKFIX ]]

  nmap('<A-n>', '<CMD>cnext<CR>', 'Next Place in QuickFix List')
  nmap('<A-p>', '<CMD>cprev<CR>', 'Prev Place in QuickFix List')

  nmap('<leader>cc', '<CMD>copen<CR>', 'Open Quickfix List')

  nmap('<leader>cq', function()
    vim.fn.setqflist({}, 'r') -- replace with empty list
    vim.cmd.cclose()
  end, 'Clear and close whole list')

  nmap('<leader>ca', function()
    local qf = vim.fn.getqflist()
    table.insert(qf, {
      bufnr = vim.api.nvim_get_current_buf(),
      lnum = vim.fn.line '.',
      col = vim.fn.col '.',
      text = vim.fn.getline '.',
    })
    vim.fn.setqflist(qf, 'r')
  end, 'Add current line to list (workspace wide)')

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
  end, 'Remove current line from list')

  -- [[ TERMINAL ]]

  nmap('<leader>>', ':terminal<CR>i', 'Open terminal')
  tmap('<ESC><ESC>', '<C-\\><C-n>', 'Exit terminal mode')
  tmap('<C-[>', '<C-\\><C-n>', 'Exit terminal mode')
  map('<A->>', toggle_floating_terminal, 'Toggle floating terminal', silent, n, t, i, v)

  -- [[ YANK ]]

  vmap('p', 'P', 'Paste without yanking replaced text')
  vmap('P', 'p', 'Paste and yank replaced text')

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

  nmap('<leader>yy', 'mzggVGy`z', 'Yank whole content')

  nmap('<leader>yc', 'g<ggVGy<C-w>w', 'Yank cmdline message', remap) -- FIXME:

  -- [[ EDITING ]]

  nmap('<c-a>', 'ggVG', 'Select All Lines')
  vmap('<c-a>', '<ESC>ggVG', 'Select All Lines')

  imap('<C-d>', '<Del>', 'Delete next char')

  nmap('J', 'mzJ`z', 'Join lines and keep cursor position')
  nmap('<leader>j', 'J', 'Join lines and put cursor between')
  nmap('<leader>J', function() MiniSplitjoin.toggle({}) end, 'Toggle split/join arguments')

  nmap('<A-o>', 'mzo<ESC>`z', 'Add blank line below cursor')
  nmap('<A-S-o>', 'mzO<ESC>`z', 'Add blank line above cursor')

  imap('<A-j>', '<ESC>:m +1<CR>gi', 'Move line down')
  -- nmap('<A-j>', 'mz:m+1<CR>`z==', 'Move line down') -- mini.move does the same
  -- vmap('<A-j>', ":m '>+1<CR>gv=gv", 'Move lines down') -- mini.move does the same
  --
  imap('<A-k>', '<ESC>:m -2<CR>gi', 'Move line up')
  -- nmap('<A-k>', 'mz:m-2<CR>`z==', 'Move line up') -- mini.move does the same
  -- vmap('<A-k>', ":m '<-2<CR>gv=gv", 'Move lines up') -- mini.move does the same

  nmap('<A-h>', '<<', 'Indent left')
  -- vmap('<A-h>', '<gv', 'Indent left and reselect') -- mini.move does the same

  nmap('<A-l>', '>>', 'Indent right')
  -- vmap('<A-l>', '>gv', 'Indent right and reselect') -- mini.move does the same

  -- NOTE: notice `remap`. `gc` is not a builtin vim keymap. it's made in `defaults.lua` file
  nmap('<leader>/', 'gcc', 'Toggle line comment', remap)
  vmap('<leader>/', 'gc', 'Toggle comment', remap)
  nmap('<leader>?', 'gcip', 'Toggle paragraph comment', remap)

  nmap('<leader>u', function()
    vim.cmd.packadd 'nvim.undotree'
    require('undotree').open()
  end, 'Undo Tree')

  -- [[ BUFFER ]]

  -- NOTE: `:help wincmd` for a list of all window commands

  nmap('<leader><leader>', '<C-6>', 'Switch buffer')

  nmap('<leader>xx', '<C-w>o', 'Close all splits but current')

  nmap('<leader>w', ':Format<CR>:w<CR>', 'Format and write buffer')

  nmap('H', ':bprevious<CR>', 'Go to previous buffer')
  nmap('L', ':bnext<CR>', 'Go to next next')

  -- nmap('[<leader>', 'gT', 'Go to previous tab')
  -- nmap(']<leader>', 'gt', 'Go to next tab')

  -- nmap('[w', '<C-w>W', 'Go to the previous window')
  -- nmap(']w', '<C-w>w', 'Go to to the next window')

  nmap('<C-h>', '<C-w><C-h>', 'Go to to the left window')
  nmap('<C-l>', '<C-w><C-l>', 'Go to to the right window')
  nmap('<C-j>', '<C-w><C-j>', 'Go to to the lower window')
  nmap('<C-k>', '<C-w><C-k>', 'Go to to the upper window')

  nmap('<A-S-h>', '<C-w>H', 'Move window to the left')
  nmap('<A-S-l>', '<C-w>L:vertical resize 80<CR>', 'Move window to the right')
  nmap('<A-S-j>', '<C-w>J', 'Move window to the lower')
  nmap('<A-S-k>', '<C-w>K', 'Move window to the upper')

  nmap('<C-Up>', ':resize +2<CR>', 'Increase height of current window')
  nmap('<C-Right>', ':vertical resize +2<CR>', 'Increase width of current window')
  nmap('<C-Down>', ':resize -2<CR>', 'Decrease height of current window')
  nmap('<C-Left>', ':vertical resize -2<CR>', 'Decrease width of current window')
  nmap('<C-w>8', ':vertical resize 80<CR>', 'Set width of current window to 80')

  nmap('<leader>;', function() MiniPick.builtin.buffers() end, 'Pick buffer')
  nmap('<leader>:', ':bd<CR>', 'Delete buffer')

  nmap('<leader>.', function() MiniPick.builtin.files() end, 'Open file')

  nmap('<leader>f', function()
    MiniFiles.open(vim.api.nvim_buf_get_name(0), false)
    MiniFiles.reveal_cwd()
  end, 'file tree')

  -- [[ VIM ]]

  nmap('<leader>vc', ':e ~/.config/nvim/init.lua<CR>', 'configure')
  nmap('<leader>vv', ':Format<CR>:w<CR>:so %<CR>:nohlsearch<CR>', 'source')
  nmap('<leader>vn', ':e ~/.config/nvim/NOTES.md<CR>', 'NOTES.md')
  nmap('<leader>vt', ':e ~/.config/nvim/TOOLS.md<CR>', 'TOOLS.md')
  nmap('<leader>vu', ':packupdate<CR>', 'update')

  -- [[ SCROLLING ]]

  nmap('j', "v:count == 0 ? 'gj' : 'j'", 'Down (wrap-aware)', expr)
  nmap('k', "v:count == 0 ? 'gk' : 'k'", 'Up (wrap-aware)', expr)

  nmap('n', 'nzzzv', 'Next search result with cursor centered')
  nmap('N', 'Nzzzv', 'Previous search result with cursor centered')

  nmap('<C-u>', '<C-u>zz', 'Half page up (centered)')
  nmap('<C-d>', '<C-d>zz', 'Half page down (centered)')

  nmap('[v', 'H', 'Scroll up to begginng of visible lines')
  nmap(']v', 'L', 'Scroll down to begginng of visible lines')

  -- [[ UI ]]

  nmap('<C-0>', ':lua vim.g.neovide_scale_factor = 1<CR>', 'Reset zoom')
  nmap('<C-=>', ':lua vim.g.neovide_scale_factor = vim.g.neovide_scale_factor + 0.05<CR>', 'Zoom in')
  nmap('<C-->', ':lua vim.g.neovide_scale_factor = vim.g.neovide_scale_factor - 0.05<CR>', 'Zoom out')

  nmap('>>', ':SelectNextTheme<CR>', 'Select next theme')
  nmap('<<', ':SelectPreviousTheme<CR>', 'Select previous theme')
  nmap('<leader>,t', function()
    vim.o.background = vim.o.background == 'light' and 'dark' or 'light'
    -- Reapply current theme to force the background change
    -- if vim.g.colors_name then
    --   vim.cmd('colorscheme ' .. vim.g.colors_name)
    -- end
  end, 'Toggle theme')
  nmap('<leader>,T', ':Pick colorschemes<CR>', 'Change theme')

  -- [[ MASON ]]

  nmap('<leader>mm', ':Mason<CR>', 'Open mason window')
  nmap('<leader>mi', ':MasonInstall ', 'Mason install')
  nmap('<leader>mp', ':lua print(vim.fn.exepath(""))<Left><Left><Left>', 'See installed lsp path')

  -- [[ GIT ]]

  nmap(
    '<leader>gg',
    '<CMD>Git | only<CR><ESC>g?<C-w>L<C-w>8<C-w>h',
    'Status',
    h('fugitive-navigation-map'),
    remap
  )

  nmap('<leader>gd', '<CMD>Gvdiffsplit<CR><C-w>l', 'Git diff split')

  nmap('<leader>gbc', ':Git checkout ', 'Checkout to branch')

  nmap('<leader>gbd', ':Git branch -D ', 'Delete branch')

  nmap('<leader>gm', ':Git commit<CR>', 'Commit')

  nmap('<leader>gl', ':Gclog<CR>', 'Logs')

  nmap('<leader>gb', ':Git blame<CR><C-w>l', 'Blame')

  -- vim.keymap.set("n", "]h", function() MiniDiff.goto_hunk("next") end, { desc = "Next git hunk" })
  -- vim.keymap.set("n", "[h", function() MiniDiff.goto_hunk("prev") end, { desc = "Prev git hunk" })
  --
  -- vim.keymap.set("n", "<leader>gs", MiniDiff.operator, { desc = "Stage hunk" })
  -- vim.keymap.set("n", "<leader>hp", function() MiniDiff.toggle_overlay() end, { desc = "Preview diff overlay" })
  -- vim.keymap.set("n", "<leader>hb", function() require("mini.git").show_at_cursor() end, { desc = "Git blame/show" })

  -- [[ REPLACE ]]

  nmap('<leader>rr', ':%s//gc<Left><Left><Left>', 'Replace snippet')
  nmap('<leader>rw', [[:%s/<C-r><C-w>//gc<Left><Left><Left>]], 'Replace word under cursor')

  -- [[ SEARCH ]]

  nmap('<leader>p', ':Pick ', 'Pick')

  nmap('<leader>sh', function() MiniPick.builtin.help() end, 'Search helps')
  nmap('<leader>sk', function() MiniExtra.pickers.keymaps() end, 'Search keymaps')

  nmap('<leader>sd', function() MiniExtra.pickers.diagnostic() end, 'Search diagnostics (workspace)')

  nmap('<leader>sw', function() MiniPick.builtin.grep { pattern = vim.fn.expand '<cword>' } end,
    'Search word under cursor')

  -- [[ MAP ]]

  -- nmap('<leader>mc', MiniMap.close, 'Close mini map')
  -- nmap('<leader>mf', MiniMap.toggle_focus, 'Toggle mini map focus')
  -- nmap('<leader>mo', MiniMap.open, 'Open mini map')
  -- nmap('<leader>mr', MiniMap.refresh, 'Refresh mini map')
  -- nmap('<leader>ms', MiniMap.toggle_side, 'Toggle mini map side')
  -- nmap('<leader>mm', MiniMap.toggle, 'Toggle mini map')
end

local function set_lsp_keymaps()
end

-------------------------------------------------------------
-- PLUGINS
-------------------------------------------------------------

-- NOTE: `:h lsp`
local function setup_lsp()
  -- local opts = event.buf
  local opts = {}

  -- [[ DEFAULTS ]]
  -- NOTE: map('gri', vim.lip.buf.implementation, 'Go to implementation', opts)
  -- NOTE: map('grt', vim.lsp.buf.type_definition, 'Go to type definition', opts)
  -- NOTE: map('grr', vim.lsp.buf.references, 'Find references', opts)
  -- NOTE: map('grn;, vim.lsp.buf.rename, 'Rename', opts)
  -- NOTE: map(;gra', vim.lsp.buf.code_action, opts, 'Code action', n, v, opts)
  -- NOTE: map('grx', vim.lsp.buf.run, 'Run code lens', opts)
  -- NOTE: map('gO', vim.lsp.buf.document_symbol, 'Document symbols', opts)
  -- NOTE: map('<C-s>', vim.lsp.buf.signature_help, 'Signature help', opts)
  -- NOTE: map('K', vim.lsp.buf.hover, "Show documentation", opts)
  -- NOTE: map('<C-w>d', vim.diagnostic.open_float, 'Show line diagnostics', opts)

  -- NOTE: `:help vim.diagnostic.opts`
  vim.diagnostic.config {
    update_in_insert = false,
    severity_sort = true,
    float = { border = 'rounded', source = 'if_many' },
    -- draws an underline below diagnosed words
    underline = { severity = { min = vim.diagnostic.severity.warn } },

    -- Can switch between these as you prefer
    virtual_text = false,  -- Text shows up at the end of the line (TODO: false in zen mode)
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

  -- TODO move to setup_keymaps
  nmap('grd', vim.lsp.buf.definition, 'Go to definition', opts)
  nmap('<leader>ll', '<C-w>s:e ~/.local/state/nvim/lsp.log<CR>G', 'Open lsp.log')
  nmap('grf', ':FormatAsync<CR>', 'Format current buffer asynchronously', opts)
end

-------------------------------------------------------------
-- INTEGRATE SETUPS
-------------------------------------------------------------

-- NOTE: `g<` jumps to commandline output
require('vim._core.ui2').enable {}

-- Enable faster startup by caching compiled Lua modules
vim.loader.enable()

vim.cmd('colorscheme ' .. themes[1])

setup_options()

if vim.fn.isdirectory(vim.o.undodir) == 0 then vim.fn.mkdir(vim.o.undodir, 'p') end

setup_custom_commands()

setup_auto_commands()

keymap_adder = '#treesitter'
require 'nvim-treesitter'.install(ensure_syntax_supported)

keymap_adder = '#mason'
require('mason').setup()

keymap_adder = '#lsp'
setup_lsp()

-- `lazydev` configures Lua LSP for your Neovim config, runtime and plugins
-- used for completion, annotations and signatures of Neovim apis
keymap_adder = '#lazydev'
require('lazydev').setup {
  library = {
    -- Load luvit types when the `vim.uv` word is found
    { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
  },
}

------------------------------------------------------------- TEXT EDITING

-- Split and join arguments
keymap_adder = '#mini.splitjoin'
MiniSplitjoin.setup({
  mappings = {
    toggle = '',
    split = '',
    join = '',
  },
})

-- Completion and signature help
keymap_adder = '#mini.completion'
MiniCompletion.setup {
  lsp_completion = {
    auto_setup = true,
  },
}

-- Move any selection in any direction
keymap_adder = '#mini.move'
require('mini.move').setup({})

-- Auto pairs
keymap_adder = '#mini.pairs'
require('mini.pairs').setup({})

-- Surround actions
keymap_adder = '#mini.surround'
require('mini.surround').setup({})

-- --  Manage and expand snippets
-- keymap_adder = '#mini.snippets'
-- MiniSnippets.setup {
--   snippets = {
--     -- loads friendly-snippets automatically
--     MiniSnippets.gen_loader.from_lang(),
--   },
-- }
-- MiniSnippets.start_lsp_server { match = false }

-- --  Comment lines
-- keymap_adder = '#mini.comment'
-- MiniComment.setup({})

-- --  Extend and create `a`/`i` textobjects
-- keymap_adder = '#mini.ai'
-- require('mini.ai').setup({})

-- --  Align text interactively
-- keymap_adder = '#mini.align'
-- require('mini.align').setup({})

-- --  Special key mappings
-- keymap_adder = '#mini.keymap'
-- require('mini.keymap').setup({})

-- -- Text edit operators
-- keymap_adder = '#mini.operators'
-- require('mini.operators').setup({})

------------------------------------------------------------- APPEARANCE

keymap_adder = '#mini.icons'
MiniIcons.setup {}

keymap_adder = '#mini.animate'
require 'mini.animate'.setup {
  cursor = { enable = animate },
  scroll = { enable = false },
  resize = { enable = false },
  open = { enable = animate },
  close = { enable = animate },
}

keymap_adder = '#mini.hipatterns'
MiniHiPatterns.setup({
  highlighters = {
    fixme     = { pattern = '%f[%w]()FIXME()%f[%W]', group = 'MiniHipatternsFixme' },
    hack      = { pattern = '%f[%w]()HACK()%f[%W]', group = 'MiniHipatternsHack' },
    todo      = { pattern = '%f[%w]()TODO()%f[%W]', group = 'MiniHipatternsTodo' },
    note      = { pattern = '%f[%w]()NOTE()%f[%W]', group = 'MiniHipatternsNote' },
    hex_color = MiniHiPatterns.gen_highlighter.hex_color(),
  },
})

keymap_adder = '#mini.statusline'
local statusline = require 'mini.statusline'
statusline.setup { use_icons = vim.g.have_nerd_font }
statusline.section_location = function() return '%2l:%-2v/%2L' end

-- Autohighlight word under cursor
keymap_adder = '#mini.cursorword'
require('mini.cursorword').setup({})

-- Visualize and work with indent scope
keymap_adder = '#mini.indentscope'
require('mini.indentscope').setup({})

-- Show notifications
keymap_adder = '#mini.notify'
require('mini.notify').setup({})

-- Trailspace (highlight and remove)
keymap_adder = '#mini.trailspace'
require('mini.trailspace').setup({})

-- Show buffers as tabs
keymap_adder = '#mini.tabline'
require('mini.tabline').setup {
  format = function(buf_id, label)
    -- add "*" suffix for modified buffers
    local suffix = vim.bo[buf_id].modified and '* ' or ''
    return MiniTabline.default_format(buf_id, label) .. suffix
  end
}

-- -- Window with buffer text overview
-- keymap_adder = '#mini.map'
-- MiniMap.setup({
--   integrations = {
--     MiniMap.gen_integration.builtin_search(),
--     MiniMap.gen_integration.diagnostic(),
--     MiniMap.gen_integration.diff(),
--   }
-- })

-- -- Generate configurable color scheme
-- keymap_adder = '#mini.hues'
-- require('mini.hues').setup {}

-- -- Tweak and save any color scheme
-- keymap_adder = '#mini.colors'
-- require('mini.colors').setup {}

-- -- Base16 colorscheme creation
-- keymap_adder = '#mini.base16'
-- require('mini.base16').setup {}

-- -- Start screen
-- keymap_adder = '#mini.starter'
-- require('mini.starter').setup({})

------------------------------------------------------------- GENERAL WORKFLOW

-- Common configuration presets
keymap_adder = '#mini.basics'
require('mini.basics').setup({})

-- Go forward/backward with square brackets
keymap_adder = '#mini.bracketed'
require('mini.bracketed').setup({})

-- Buffer removing (unshow, delete, wipeout), which saves window layout
keymap_adder = '#mini.bufremove'
require('mini.bufremove').setup({})

-- Jump to next/previous single character
keymap_adder = '#mini.jump'
require('mini.jump').setup {}

-- Jump within visible lines
keymap_adder = '#mini.jump2d'
require('mini.jump2d').setup {}

-- Session management
keymap_adder = '#mini.sessions'
require('mini.sessions').setup { autoread = true }

-- Miscellaneous functions
keymap_adder = '#mini.misc'
require('mini.misc').setup {}

-- Pick anything
keymap_adder = '#mini.pick'
MiniPick.setup()

-- Extra 'mini.nvim' functionality
keymap_adder = '#mini.extra'
MiniExtra.setup()

-- Command line tweaks
keymap_adder = '#mini.cmdline'
require('mini.cmdline').setup {
  autocorrect = { enable = false },
}

-- Navigate and manipulate file system
keymap_adder = '#mini.files'
MiniFiles.setup {
  -- TODO: move them to keymap
  mappings = {
    go_in = '<CR>',
    go_in_plus = 'L',
    go_out = '_',
    go_out_plus = 'H',
  },
}

-- Work with diff hunks
keymap_adder = '#mini.diff'
MiniDiff.setup {
  view = {
    style = 'sign',
    -- signs = { add = '▌', change = '▌', delete = '▂▂' },
    signs = { add = '▌', change = '▌', delete = '▌' },
  },
}

-- Show next key clues
keymap_adder = '#mini.clue'
local MiniClue = require('mini.clue')
local function improve_clues(clues)
  return map_array(clues, function(clue)
    clue.desc = button(clue.desc)
    return clue
  end)
end
MiniClue.setup({
  triggers = {
    { mode = { 'n', 'x' }, keys = '<Leader>' },
    { mode = { 'n' },      keys = '<C-S-n>' },
    { mode = { 'x' },      keys = '<C-S-x>' },
    { mode = { 'i' },      keys = '<C-S-i>' },
    { mode = { 'c' },      keys = '<C-S-c>' },
    { mode = 'n',          keys = '[' },     -- previous
    { mode = 'n',          keys = ']' },     -- next
    { mode = 'i',          keys = '<C-x>' }, -- Built-in completion
    { mode = { 'n', 'x' }, keys = 'g' },
    { mode = { 'n', 'x' }, keys = "'" },     -- Marks
    { mode = { 'n', 'x' }, keys = '`' },     -- Marks
    { mode = { 'n', 'x' }, keys = '"' },     -- Registers
    { mode = { 'i', 'c' }, keys = '<C-r>' }, -- Registers
    { mode = 'n',          keys = '<C-w>' },
    { mode = { 'n', 'x' }, keys = 'z' },
    { mode = { 'n', 'x' }, keys = 'Z' },
    { mode = { 'n', 'x' }, keys = 's' },
    -- { mode = { 'n' },      keys = 'c' }, -- interupts vim-visual-multi
    -- { mode = { 'n' },      keys = 'd' }, -- interupts vim-visual-multi
    -- { mode = { 'n' },      keys = 'y' }, -- interupts vim-visual-multi
  },
  clues = {
    -- Enhance this by adding descriptions for <Leader> mapping groups
    improve_clues(MiniClue.gen_clues.square_brackets()),
    improve_clues(MiniClue.gen_clues.builtin_completion()),
    improve_clues(MiniClue.gen_clues.g()),
    improve_clues(MiniClue.gen_clues.marks()),
    improve_clues(MiniClue.gen_clues.registers()),
    improve_clues(MiniClue.gen_clues.windows()),
    improve_clues(MiniClue.gen_clues.z()),
    { mode = 'n', keys = '<leader>c', desc = button('+Quickfix') },
    { mode = 'n', keys = '<leader>g', desc = button('+Git') },
    { mode = 'n', keys = '<leader>m', desc = button('+Mason') },
    { mode = 'n', keys = '<leader>v', desc = button('+Neovim') },
    { mode = 'n', keys = '<leader>r', desc = button('+Replace') },
    { mode = 'n', keys = '<leader>s', desc = button('+Search') },
    { mode = 'n', keys = '<leader>,', desc = button('+Settings') },
    { mode = 'n', keys = '<leader>y', desc = button('+Yank') },
  },
  window = {
    config = { width = clue_window_width + 10 },
    delay = 0,
    scroll_down = '<C-d>',
    scroll_up = '<C-u>',
  },
})

-- -- Plugin manager
-- keymap_adder = '#mini.deps'
-- require('mini.deps').setup()

-- -- Git integration
-- keymap_adder = '#mini.git'
-- require('mini.git').setup()

-- -- Get user input
-- keymap_adder = '#mini.input'
-- require('mini.input').setup()

-- -- Track and reuse file system visits
-- keymap_adder = '#mini.visits'
-- require('mini.visits').setup()

--------------------------------------------------------------- MINI OTHERS

-- -- Fuzzy matching
keymap_adder = '#mini.fuzzy'
require('mini.fuzzy').setup {}

-- -- Generate Neovim help files
-- keymap_adder = '#mini.doc'
-- require('mini.doc').setup()

-- -- Test Neovim plugins
-- keymap_adder = '#mini.test'
-- require('mini.test').setup()

---------------------------------------------------------------

keymap_adder = '😎'
setup_keymaps()
