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

-- Setup lazy.nvim
require("lazy").setup({
    spec = {
        { 'neovim/nvim-lspconfig' },
        { 'hrsh7th/cmp-nvim-lsp' },
        { 'hrsh7th/cmp-buffer' },
        { 'hrsh7th/cmp-path' },
        { 'hrsh7th/cmp-cmdline' },
        { 'hrsh7th/nvim-cmp' },
        { 'nvim-tree/nvim-web-devicons' },
        { 'nvim-lua/plenary.nvim' },
        { 'catppuccin/nvim',                 name = 'catppuccin', },
        { 'folke/tokyonight.nvim' },
        { 'nvim-treesitter/nvim-treesitter', build = ':TSUpdate', },
        { 'nvim-telescope/telescope.nvim',   tag = '0.1.8', },
        { 'folke/which-key.nvim',            event = 'VeryLazy', },
        { 'lewis6991/gitsigns.nvim' },
        { 'nvim-tree/nvim-tree.lua',         config = true },
        { 'akinsho/bufferline.nvim',         config = true },
        { 'kylechui/nvim-surround',          config = true },
        { 'windwp/nvim-autopairs',           event = 'InsertEnter', config = true },
        { 'hedyhli/outline.nvim', },
    },
    -- colorscheme that will be used when installing plugins.
    install = { colorscheme = { "habamax" } },
    -- automatically check for plugin updates
    -- checker = { enabled = true },
})






-- 基础配置
vim.opt.number = true
vim.opt.shell = '/usr/bin/fish'
vim.opt.tabstop = 4      -- 一个 <Tab> 字符显示为 4 列
vim.opt.softtabstop = 4  -- 按 Tab 或 Backspace 时，缩进/删除 4 个空格
vim.opt.shiftwidth = 4   -- 自动缩进（如 >>、<<）时使用 4 个空格
vim.opt.expandtab = true -- 将 <Tab> 键输入转换为空格（推荐）
vim.keymap.set('n', '<leader>n', function()
    vim.opt.relativenumber = not vim.opt.relativenumber:get()
end, { desc = '切换行号显示' })
vim.keymap.set('n', '<leader>w', ':wa<CR>', { desc = '全部保存' })



-- 主题
require("catppuccin").setup({ term_colors = true, auto_integrations = true, })
-- vim.cmd('colorscheme catppuccin')
vim.cmd('colorscheme tokyonight')
vim.opt.termguicolors = true
vim.opt.redrawtime = 10000 -- 10秒






-- 外观布局相关
vim.keymap.set('n', '<F11>', ":let g:neovide_fullscreen = !g:neovide_fullscreen<CR>", {})
vim.keymap.set('n', '<leader>o', ':Outline<CR>', { desc = 'Toggle Outline' })
require("outline").setup {
    outline_window = {
        width = 40,
        relative_width = false,
    }
}



-- disable netrw at the very start of your init.lua
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.keymap.set('n', '<leader>e', ':NvimTreeToggle<CR>', { desc = 'NvimTreeToggle' })
vim.keymap.set('n', '<leader>E', ':NvimTreeRefresh<CR>', { desc = 'NvimTreeRefresh' })



local telescope = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', telescope.find_files, { desc = 'Telescope find files' })
vim.keymap.set('n', '<leader>fg', telescope.live_grep, { desc = 'Telescope live grep' })
vim.keymap.set('n', '<leader>fb', telescope.buffers, { desc = 'Telescope buffers' })
vim.keymap.set('n', '<leader>fh', telescope.help_tags, { desc = 'Telescope help tags' })



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
vim.keymap.set('n', '<leader>tt', ':bel 20split | terminal<CR>i', {
    silent = true,
    desc = "Terminal: horizontal split (below)"
})

-- 在当前窗口 右侧 打开垂直终端（推荐）
vim.keymap.set('n', '<leader>tv', ':bel 80vsplit | terminal<CR>i', {
    silent = true,
    desc = "Terminal: vertical split (right)"
})

-- 在整个布局 最底部 打开终端（最常用）
vim.keymap.set('n', '<leader>th', ':botright bel 20split | terminal<CR>i', {
    silent = true,
    desc = "Terminal: at bottom"
})

-- 在终端模式下，按 <leader>q 直接关闭
vim.keymap.set('t', '<leader>q', '<C-\\><C-n>:bd!<CR>', { silent = true, desc = "Close terminal" })

-- 或者在普通模式下关闭（如果你已退出终端模式）
vim.keymap.set('n', '<leader>q', ':bd!<CR>', { desc = "Close window" })
vim.keymap.set('n', '<leader>c', ':close<CR>', { desc = "Close window" })






-- 代码开发相关快捷键
vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { desc = 'Goto definition' })
vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, { desc = 'Goto declaration' })
vim.keymap.set('n', 'gI', vim.lsp.buf.implementation, { desc = 'Goto implementation' })
vim.keymap.set('n', 'gR', vim.lsp.buf.references, { desc = 'References' })
vim.keymap.set('n', '<Space>r', vim.lsp.buf.rename, { desc = 'Rename' })
vim.keymap.set('n', '<Space>a', vim.lsp.buf.code_action, { desc = 'Code action' })


vim.keymap.set('n', '<Space>c', function()
    return require('vim._comment').operator() .. '_'
end, { expr = true, desc = 'Toggle comment line' })
-- vim.keymap.set({ 'n', 'x' }, '<Space>c', function()
--     return require('vim._comment').operator()
-- end, { expr = true, desc = 'Toggle comment' })



require 'nvim-treesitter.configs'.setup {
    -- A list of parser names, or "all" (the listed parsers MUST always be installed)
    ensure_installed = { "c", "cpp", "lua", "python", "go", "rust", "bash" },

    -- Install parsers synchronously (only applied to `ensure_installed`)
    sync_install = false,

    -- Automatically install missing parsers when entering buffer
    -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
    auto_install = false,

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
vim.wo.foldmethod = 'expr'
vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
vim.opt.foldlevel = 99



vim.diagnostic.config({
    virtual_text = false,
    underline = false,
    severity_sort = true,
})
vim.keymap.set('n', '<leader>d', function()
    vim.diagnostic.open_float()
end, { desc = "弹窗显示诊断" })
vim.keymap.set('n', '<Space>d', function()
    if vim.diagnostic.config().virtual_text then
        vim.diagnostic.config({
            virtual_text = false,
            underline = false,
        })
    else
        vim.diagnostic.config({
            virtual_text = true,
            underline = true,
        })
    end
end, { desc = "行内显示诊断" })



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






-- 代码补全
local cmp = require 'cmp'

cmp.setup({
    snippet = {
        -- REQUIRED - you must specify a snippet engine
        expand = function(args)
            vim.snippet.expand(args.body) -- For native neovim snippets (Neovim v0.10+)
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






-- 剪切板
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






-- LSP
vim.lsp.enable('clangd')
vim.lsp.enable('pyright')
vim.lsp.enable('ruff')
vim.lsp.enable('bashls')
vim.lsp.enable('gopls')
vim.lsp.enable('rust_analyzer')
vim.lsp.enable('lua_ls')
vim.lsp.enable('ts_ls')
