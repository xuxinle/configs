-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local lazyrepo = "https://github.com/folke/lazy.nvim.git"
    local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
    if vim.v.shell_error ~= 0 then
        vim.api.nvim_echo({
            { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
            { out,                            "WarningMsg" },
            { "\nPress any key to exit..." },
        }, true, {})
        vim.fn.getchar()
        os.exit(1)
    end
end
vim.opt.rtp:prepend(lazypath)

-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)
-- vim.g.mapleader = " "
-- vim.g.maplocalleader = "\\"

-- Setup lazy.nvim
require("lazy").setup({
    spec = {
        -- add your plugins here
        {
            "nvim-treesitter/nvim-treesitter",
            build = ":TSUpdate",
        },
        { 'neovim/nvim-lspconfig' },
        { 'hrsh7th/cmp-nvim-lsp' },
        { 'hrsh7th/cmp-buffer' },
        { 'hrsh7th/cmp-path' },
        { 'hrsh7th/cmp-cmdline' },
        { 'hrsh7th/nvim-cmp' },
        { "catppuccin/nvim",      name = "catppuccin", priority = 1000 },
        {
            "nvim-tree/nvim-tree.lua",
            version = "*",
            lazy = false,
            dependencies = {
                "nvim-tree/nvim-web-devicons",
            },
            config = function()
                require("nvim-tree").setup {}
            end,
        },
        {
            'nvim-telescope/telescope.nvim',
            tag = '0.1.8',
            dependencies = { 'nvim-lua/plenary.nvim' }
        },
        {
            "folke/which-key.nvim",
            event = "VeryLazy",
            opts = {
                -- your configuration comes here
                -- or leave it empty to use the default settings
                -- refer to the configuration section below
            },
        }
    },
    -- Configure any other settings here. See the documentation for more details.
    -- colorscheme that will be used when installing plugins.
    install = { colorscheme = { "habamax" } },
    -- automatically check for plugin updates
    checker = { enabled = true },
})
-- require("config.lazy")



-- clipboard
vim.g.clipboard = {
    name = 'OSC 52',
    copy = {
        ['+'] = require('vim.ui.clipboard.osc52').copy('+'),
        ['*'] = require('vim.ui.clipboard.osc52').copy('*'),
    },
    paste = {
        ['+'] = require('vim.ui.clipboard.osc52').paste('+'),
        ['*'] = require('vim.ui.clipboard.osc52').paste('*'),
    },
}




vim.cmd('set nu')
vim.cmd('colorscheme catppuccin')
vim.opt.termguicolors = true
vim.opt.redrawtime = 10000 -- 10秒

vim.opt.tabstop = 4        -- 一个 <Tab> 字符显示为 4 列
vim.opt.softtabstop = 4    -- 按 Tab 或 Backspace 时，缩进/删除 4 个空格
vim.opt.shiftwidth = 4     -- 自动缩进（如 >>、<<）时使用 4 个空格
vim.opt.expandtab = true   -- 将 <Tab> 键输入转换为空格（推荐）



vim.keymap.set({ 'n', 'x' }, '<leader>?', function()
    require('which-key').show({ global = true })
end, { desc = 'which-key' })


-- 代码开发相关快捷键
vim.keymap.set('n', '<Space>d', vim.lsp.buf.definition, { desc = 'Goto definition' })
vim.keymap.set('n', '<Space>D', vim.lsp.buf.declaration, { desc = 'Goto declaration' })
vim.keymap.set('n', '<Space>r', vim.lsp.buf.rename, { desc = 'Rename' })
vim.keymap.set('n', '<Space>i', vim.lsp.buf.implementation, { desc = 'Goto implementation' })
vim.keymap.set('n', '<Space>R', vim.lsp.buf.references, { desc = 'References' })
vim.keymap.set('n', '<Space>a', vim.lsp.buf.code_action, { desc = 'Code action' })



vim.keymap.set('n', '<Space>/', function()
    return require('vim._comment').operator() .. '_'
end, { expr = true, desc = 'Toggle comment line' })
vim.keymap.set({ 'n', 'x' }, '<Space>c', function()
    return require('vim._comment').operator()
end, { expr = true, desc = 'Toggle comment' })



require 'nvim-treesitter.configs'.setup {
    -- A list of parser names, or "all" (the listed parsers MUST always be installed)
    ensure_installed = { "c", "cpp", "lua", "python", "go", "rust", "bash" },

    -- Install parsers synchronously (only applied to `ensure_installed`)
    sync_install = false,

    -- Automatically install missing parsers when entering buffer
    -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
    auto_install = false,

    -- List of parsers to ignore installing (or "all")
    -- ignore_install = { "javascript" },

    ---- If you need to change the installation directory of the parsers (see -> Advanced Setup)
    -- parser_install_dir = "/some/path/to/store/parsers", -- Remember to run vim.opt.runtimepath:append("/some/path/to/store/parsers")!

    highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
    },
    incremental_selection = {
        enable = true,
        keymaps = {
            init_selection = "gnn", -- set to `false` to disable one of the mappings
            node_incremental = "grn",
            scope_incremental = "grc",
            node_decremental = "grm",
        },
    },
    indent = {
        enable = true
    }
}
-- vim.wo.foldmethod = 'expr'
-- vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'





-- disable netrw at the very start of your init.lua
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- optionally enable 24-bit colour
vim.opt.termguicolors = true

-- empty setup using defaults
require("nvim-tree").setup()
vim.keymap.set('n', '<leader>e', ':NvimTreeToggle<CR>', { desc = 'NvimTreeToggle' })



local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Telescope find files' })
vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Telescope live grep' })
vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Telescope buffers' })
vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'Telescope help tags' })



-- 高亮
vim.keymap.set('n', '<leader>hl', function()
    vim.lsp.buf.document_highlight()
end, { desc = "LSP Document Highlight" })

-- 取消高亮
vim.keymap.set('n', '<leader>hc', function()
    vim.cmd('noh')
    vim.lsp.buf.clear_references()
end, { desc = "Clear Highlight" })



-- 在当前窗口 下方 打开水平终端（推荐）
vim.keymap.set('n', '<leader>th', ':bel 15split | terminal<CR>i', {
    silent = true,
    desc = "Terminal: horizontal split (below)"
})

-- 在当前窗口 右侧 打开垂直终端（推荐）
vim.keymap.set('n', '<leader>tv', ':bel 80vsplit | terminal<CR>i', {
    silent = true,
    desc = "Terminal: vertical split (right)"
})

-- 在整个布局 最底部 打开终端（最常用）
vim.keymap.set('n', '<leader>tt', ':botright bel 15split | terminal<CR>i', {
    silent = true,
    desc = "Terminal: at bottom"
})

-- 在终端模式下，按 <leader>q 直接关闭
vim.keymap.set('t', '<leader>q', '<C-\\><C-n>:close<CR>', { silent = true, desc = "Close terminal" })

-- 或者在普通模式下关闭（如果你已退出终端模式）
vim.keymap.set('n', '<leader>q', ':close<CR>', { desc = "Close window" })




vim.diagnostic.config({
    virtual_text = true,      -- 在代码行下方显示浮动提示（默认）
    signs = true,             -- 在左侧栏显示图标（需配置 signs）
    underline = true,         -- 下划线标出错误位置
    update_in_insert = false, -- 插入模式下不更新（提升性能）
    severity_sort = true,     -- 按严重性排序
})

vim.keymap.set("n", "<Space>f", function()
    local clients = vim.lsp.get_clients({ bufnr = 0 })

    if next(clients) == nil then
        vim.notify("No active LSP clients for this buffer", vim.log.levels.WARN)
        return
    end

    vim.lsp.buf.format({
        async = true,
        timeout_ms = 5000,
    })
end, { noremap = true, silent = true, desc = "LSP Format" })

-- Set up nvim-cmp.
local cmp = require 'cmp'

cmp.setup({
    snippet = {
        -- REQUIRED - you must specify a snippet engine
        expand = function(args)
            -- vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
            -- require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
            -- require('snippy').expand_snippet(args.body) -- For `snippy` users.
            -- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
            vim.snippet.expand(args.body) -- For native neovim snippets (Neovim v0.10+)

            -- For `mini.snippets` users:
            -- local insert = MiniSnippets.config.expand.insert or MiniSnippets.default_insert
            -- insert({ body = args.body }) -- Insert at cursor
            -- cmp.resubscribe({ "TextChangedI", "TextChangedP" })
            -- require("cmp.config").set_onetime({ sources = {} })
        end,
    },
    window = {
        -- completion = cmp.config.window.bordered(),
        -- documentation = cmp.config.window.bordered(),
    },
    mapping = cmp.mapping.preset.insert({
        ['<C-b>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<C-e>'] = cmp.mapping.abort(),
        ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
        ['<Tab>'] = function(fallback)
            if vim.snippet.active() then
                vim.snippet.jump(1)
            elseif cmp.visible() then
                cmp.select_next_item()
            else
                fallback()
            end
        end,
        ['<S-Tab>'] = function(fallback)
            if vim.snippet.active() then
                vim.snippet.jump(-1)
            elseif cmp.visible() then
                cmp.select_prev_item()
            else
                fallback()
            end
        end,
    }),
    sources = cmp.config.sources({
        { name = 'nvim_lsp' },
        -- { name = 'vsnip' }, -- For vsnip users.
        -- { name = 'luasnip' }, -- For luasnip users.
        -- { name = 'ultisnips' }, -- For ultisnips users.

        -- { name = 'snippy' }, -- For snippy users.
    }, {
        { name = 'buffer' },
    })
})

-- To use git you need to install the plugin petertriho/cmp-git and uncomment lines below
-- Set configuration for specific filetype.
--[[ cmp.setup.filetype('gitcommit', {
  sources = cmp.config.sources({
    { name = 'git' },
  }, {
    { name = 'buffer' },
  })
})
require("cmp_git").setup() ]] --

-- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline({ '/', '?' }, {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
        { name = 'buffer' }
    }
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(':', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
        { name = 'path' }
    }, {
        { name = 'cmdline' }
    }),
    matching = { disallow_symbol_nonprefix_matching = false }
})


vim.lsp.enable('clangd')
vim.lsp.enable('pyright')
-- ruff格式化python
vim.lsp.enable('ruff')
vim.lsp.enable('bashls')
vim.lsp.enable('gopls')
vim.lsp.enable('lua_ls')
