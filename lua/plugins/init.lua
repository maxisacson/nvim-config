local globals = require('setup.globals')

return {
    -- gruvbox theme
    {
        'ellisonleao/gruvbox.nvim',
        dependencies = 'rktjmp/lush.nvim',
        lazy = false,
        priority = 1000,
        config = function()
            require('gruvbox').setup {
                overrides = {
                    GitSignsAdd = { link = 'GruvboxGreenSign' },
                    GitSignsChange = { link = 'GruvboxOrangeSign' },
                    GitSignsDelete = { link = 'GruvboxRedSign' },
                }
            }
            vim.cmd [[colorscheme gruvbox]]
        end
    },

    -- vim-fugitive for git integration
    'tpope/vim-fugitive',

    -- nerdcomment for easy commenting
    {
        'scrooloose/nerdcommenter',
        enabled = not globals.disable_nerdcommenter,
        config = function() require('setup.nerdcommenter') end
    },

    -- Comment.nvim -- like nerdcommenter but in Lua
    {
        'numToStr/Comment.nvim',
        enabled = not globals.disable_commentnvim,
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
        enabled = not globals.disable_clang_format,
        config = function() require('setup.clang-format') end
    },

    -- LSP configurations for neovim
    {
        'neovim/nvim-lspconfig',
        enabled = not globals.disable_lsp,
        config = function() require('setup.lsp') end,
        dependencies = {
            'mason-org/mason.nvim',
            'mason-org/mason-lspconfig.nvim',
            'j-hui/fidget.nvim',     -- lsp status spinner
            'folke/lsp-colors.nvim', -- better support for lsp colors
        }
    },

    -- live parameter hints
    {
        'ray-x/lsp_signature.nvim',
        enabled = not globals.disable_lsp_signature,
        config = function()
            require 'lsp_signature'.setup({
                floating_window = true, -- show signature in floating window
                hint_enable = false,    -- disable virtual text
                handler_opts = {
                    border = 'none',
                }
            })
        end
    },

    -- nvim-cmp for autocompletion
    {
        'hrsh7th/nvim-cmp',
        enabled = not globals.disable_nvim_cmp,
        dependencies = {
            { 'hrsh7th/cmp-nvim-lsp' },
            { 'L3MON4D3/LuaSnip' },         -- snippet plugin
            { 'saadparwaiz1/cmp_luasnip' }, -- snippet source
            { 'hrsh7th/cmp-buffer' },       -- buffer source
            { 'hrsh7th/cmp-path' },         -- path source
            -- { 'hrsh7th/cmp-nvim-lsp-signature-help' },
            { 'hrsh7th/cmp-cmdline' },
            { 'onsails/lspkind-nvim' },         -- VSCode-like icons in completion menu
            { 'rafamadriz/friendly-snippets' }, -- preconfigured snippets
        },
        config = function() require('setup.nvim-cmp') end
    },

    -- treesitter
    {
        'nvim-treesitter/nvim-treesitter',
        enabled = not globals.disable_treesitter,
        build = ':TSUpdate',
        config = function() require('setup.treesitter') end
    },
    {
        'nvim-treesitter/nvim-treesitter-context',
        dependencies = 'nvim-treesitter'
    },

    {
        'lewis6991/gitsigns.nvim',
        config = function() require('setup.gitsigns') end
    },

    -- status bar plugin
    {
        'nvim-lualine/lualine.nvim',
        dependencies = {
            'nvim-tree/nvim-web-devicons',
            'lewis6991/gitsigns.nvim'
        },
        config = function() require('setup.lualine') end
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
        enabled = not globals.disable_telescope,
        dependencies = {
            { 'nvim-lua/plenary.nvim' },
            { 'nvim-telescope/telescope-fzf-native.nvim',  build = 'make' },
            { 'nvim-telescope/telescope-ui-select.nvim' },
            { 'nvim-telescope/telescope-file-browser.nvim' },
        },
        config = function() require('setup.telescope') end
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

    -- Tmux integration
    {
        'aserowy/tmux.nvim',
        config = function()
            require('tmux').setup({
                navigation = {
                    cycle_navigation = false,
                    enable_default_keybindings = true,
                    persist_zoom = false,
                },
                copy_sync = {
                    enable = false,
                },
            })
        end,
    },

    -- Session managment
    {
        'rmagatti/auto-session',
        config = function()
            vim.o.sessionoptions="blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"
            require('auto-session').setup({
                log_level = "error",
                suppressed_dirs = { '~/', '/', "~/.config/*", "~/.local/*" },
            })
        end
    },

    -- Oil.nvim - edit the filesystem as a buffer
    {
        'stevearc/oil.nvim',
        dependencies = { "nvim-tree/nvim-web-devicons" },
        config = function() require('setup.oil') end
    },

    -- fancy notifications
    {
        'rcarriga/nvim-notify',
        config = function()
            vim.notify = require('notify')
        end
    },

    -- lazydev for configuring lua_ls for nvim plugin dev
    {
        "folke/lazydev.nvim",
        ft = "lua", -- only load on lua files
        opts = {
            library = {
                -- See the configuration section for more details
                -- Load luvit types when the `vim.uv` word is found
                { path = "${3rd}/luv/library", words = { "vim%.uv" } },
            },
        },
    },
}
