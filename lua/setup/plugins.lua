local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

local vimrc = vim.g.vimrc
require('lazy').setup({
    -- vim-fugitive for git integration
    'tpope/vim-fugitive',

    -- nerdcomment for easy commenting
    {
        'scrooloose/nerdcommenter',
        enabled = not vimrc.disable_nerdcommenter,
        config = function() require('setup.nerdcommenter') end
    },

    -- Comment.nvim -- like nerdcommenter but in Lua
    {
        'numToStr/Comment.nvim',
        enabled = not vimrc.disable_commentnvim,
        config = function() require('setup.comment') end
    },

    -- vim-easy-align for easy alignment
    {
        'junegunn/vim-easy-align',
        config = function() require('setup.easyalign') end
    },

    -- vim-surround
    'tpope/vim-surround',

    -- vim-repeat
    'tpope/vim-repeat',

    -- latex plugin
    {
        'lervag/vimtex',
        lazy = true,
        ft = 'tex',
        config = function()
            vim.g.vimtex_compiler_latexmk = { callback = 0 }
        end
    },

    -- for diffing blocks of text
    'AndrewRadev/linediff.vim',

    -- extra syntax for tex- and bib-files
    'maxisacson/vim-latex-extra',

    -- syntax for geant4 macro files
    'maxisacson/vim-geant4-mac',

    -- syntax for EGS input files
    'maxisacson/vim-egsinp',

    -- syntax for experimental files
    'maxisacson/vim-rs-experimental-syntax',

    -- clang-format intergration for vim
    {
        'rhysd/vim-clang-format',
        enabled = not vimrc.disable_clang_format,
        config = function() require('setup.clang-format') end
    },

    -- LSP configurations for neovim
    {
        'neovim/nvim-lspconfig',
        enabled = not vimrc.disable_lsp,
        config = function() require('setup.lsp') end,
        dependencies = {
            'williamboman/mason.nvim',
            'williamboman/mason-lspconfig.nvim'
        }
    },

    -- better support for lsp colors
    {
        'folke/lsp-colors.nvim',
        enabled = not vimrc.disable_lsp
    },

    -- lsp status spinner
    {
        'j-hui/fidget.nvim',
        enabled = not vimrc.disable_lsp,
        config = function()
            require('fidget').setup({ text = { spinner = "dots", } })
        end
    },

    -- live parameter hints
    {
        'ray-x/lsp_signature.nvim',
        enabled = not vimrc.disable_lsp or vimrc.disable_lsp_signature,
        config = function()
            require 'lsp_signature'.setup({
                hint_enable = false,
                hint_prefix = "param: "
            })
        end
    },

    -- null-ls for non-LSP sources
    {
        "jose-elias-alvarez/null-ls.nvim",
        config = function()
            require("null-ls").setup({
                sources = require('null-ls').builtins.diagnostics.mypy
            })
        end,
        dependencies = { "nvim-lua/plenary.nvim" },
    },

    -- nvim-cmp for autocompletion
    {
        'hrsh7th/nvim-cmp',
        enabled = not vimrc.disable_nvim_cmp,
        dependencies = {
            {
                'hrsh7th/cmp-nvim-lsp',
                enabled = not vimrc.disable_lsp
            },
            { 'L3MON4D3/LuaSnip' }, -- snippet plugin
            { 'saadparwaiz1/cmp_luasnip' }, -- snippet source
            { 'hrsh7th/cmp-buffer' }, -- buffer source
            { 'hrsh7th/cmp-path' }, -- path source
            { 'hrsh7th/cmp-nvim-lsp-signature-help' },
            { 'hrsh7th/cmp-cmdline' },
            { 'dmitmel/cmp-cmdline-history' }
        },
        config = function() require('setup.nvim-cmp') end
    },

    -- VSCode-like icons in completion menu
    {
        'onsails/lspkind-nvim',
        enabled = not vimrc.disable_nvim_cmp
    },

    -- preconfigured snippets
    {
        'rafamadriz/friendly-snippets',
        enabled = not vimrc.disable_nvim_cmp
    },

    -- treesitter
    {
        'nvim-treesitter/nvim-treesitter',
        enabled = not vimrc.disable_treesitter,
        build = ':TSUpdate',
        config = function() require('setup.treesitter') end
    },

    -- feline airline alternative
    {
        'feline-nvim/feline.nvim',
        dependencies = {
            { 'nvim-tree/nvim-web-devicons' },
            {
                'lewis6991/gitsigns.nvim',
                config = function() require('setup.gitsigns') end
            }
        },
        config = function() require('setup.feline') end
    },

    -- tabline plugin
    {
        'akinsho/bufferline.nvim',
        dependencies = {
            'nvim-tree/nvim-web-devicons',
            'famiu/bufdelete.nvim',
        },
        config = function()
            require('setup.bufferline')
        end
    },

    -- gruvbox theme
    {
        'ellisonleao/gruvbox.nvim',
        dependencies = 'rktjmp/lush.nvim',
        lazy = false,
        priority = 1000,
        config = function()
            require('gruvbox').setup {}
            vim.cmd [[colorscheme gruvbox]]
        end
    },

    -- visualize color codes
    {
        'norcalli/nvim-colorizer.lua',
        config = function() require 'colorizer'.setup() end
    },

    -- NvimTree alternative to NerdTree
    {
        'nvim-tree/nvim-tree.lua',
        dependencies = 'nvim-tree/nvim-web-devicons',
        config = function() require('setup.nvim-tree') end
    },

    -- Telescope -- modular fuzzy finder
    {
        'nvim-telescope/telescope.nvim',
        enabled = not vimrc.disable_telescope,
        dependencies = {
            { 'nvim-lua/plenary.nvim' },
            { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' }
        },
        config = function() require('setup.telescope') end
    },
    { 'nvim-telescope/telescope-ui-select.nvim',
        config = function()
            require('telescope').load_extension('ui-select')
        end
    },

    -- Visualize the undo tree
    {
        'mbbill/undotree',
        config = function() require('setup.undotree') end
    },

    -- To enable more features from rust-analyzer
    {
        'simrat39/rust-tools.nvim',
        lazy = true,
        dependencies = 'nvim-lua/popup.nvim'
    },

    -- Debugging
    {
        'mfussenegger/nvim-dap',
        lazy = true,
        config = function() require('setup.nvim-dap') end,
        dependencies = {
            'rcarriga/nvim-dap-ui',
            'nvim-telescope/telescope-dap.nvim',
            'theHamsta/nvim-dap-virtual-text',
            'mfussenegger/nvim-dap-python',
        }
    },
})
