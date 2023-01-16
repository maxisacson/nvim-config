local ensure_packer = function()
    local fn = vim.fn
    local install_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
    if fn.empty(fn.glob(install_path)) > 0 then
        fn.system({ 'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path })
        vim.cmd.packadd('packer.nvim')
        return true
    end
    return false
end

local packer_bootstrap = ensure_packer()

local ag = vim.api.nvim_create_augroup("PackerUserConfig", { clear = true })
vim.api.nvim_create_autocmd("BufWritePost", {
    group = ag,
    pattern = "plugins.lua",
    command = "source <afile> | PackerCompile"
})

local packer = require('packer')
return packer.startup({
    function(use)
        local vimrc = vim.g.vimrc

        -- Packer can manage itself
        use 'wbthomason/packer.nvim'

        -- vim-fugitive for git integration
        use 'tpope/vim-fugitive'

        -- nerdcomment for easy commenting
        use {
            'scrooloose/nerdcommenter',
            disable = vimrc.disable_nerdcommenter,
            config = function() require('setup.nerdcommenter') end
        }

        -- Comment.nvim -- like nerdcommenter but in Lua
        use {
            'numToStr/Comment.nvim',
            disable = vimrc.disable_commentnvim,
            config = function() require('setup.comment') end
        }

        -- vim-easy-align for easy alignment
        use { 'junegunn/vim-easy-align', config = function() require('setup.easyalign') end }

        -- vim-surround
        use 'tpope/vim-surround'

        -- vim-repeat
        use 'tpope/vim-repeat'

        -- GLSL syntax
        use 'tikhomirov/vim-glsl'

        -- latex plugin
        use { 'lervag/vimtex',
            config = function()
                vim.g.vimtex_compiler_latexmk = { callback = 0 }
            end
        }

        -- for diffing blocks of text
        use 'AndrewRadev/linediff.vim'

        -- extra syntax for cpp-files
        use 'maxisacson/vim-cpp-extra'

        -- extra syntax for tex- and bib-files
        use 'maxisacson/vim-latex-extra'

        -- syntax for geant4 macro files
        use 'maxisacson/vim-geant4-mac'

        -- syntax for EGS input files
        use 'maxisacson/vim-egsinp'

        -- syntax for experimental files
        use 'maxisacson/vim-rs-experimental-syntax'

        -- clang-format intergration for vim
        use {
            'rhysd/vim-clang-format',
            disable = vimrc.disable_clang_format,
            config = function() require('setup.clang-format') end
        }

        -- vim-cmake
        use { 'vhdirk/vim-cmake', disable = vimrc.disable_vim_cmake }

        -- LSP configurations for neovim
        use {
            'neovim/nvim-lspconfig',
            disable = vimrc.disable_lsp,
            config = function() require('setup.lsp') end,
            requires = {
                'williamboman/mason.nvim',
                'williamboman/mason-lspconfig.nvim'
            }
        }

        -- better support for lsp colors
        use { 'folke/lsp-colors.nvim', disable = vimrc.disable_lsp }

        -- lsp status spinner
        use { 'j-hui/fidget.nvim',
            disable = vimrc.disable_lsp,
            config = function()
                require('fidget').setup({ text = { spinner = "dots", } })
            end
        }

        -- live parameter hints
        use {
            'ray-x/lsp_signature.nvim',
            disable = vimrc.disable_lsp or vimrc.disable_lsp_signature,
            config = function()
                require 'lsp_signature'.setup({
                    hint_enable = false,
                    hint_prefix = "param: "
                })
            end
        }

        -- nvim-cmp for autocompletion
        use {
            'hrsh7th/nvim-cmp', disable = vimrc.disable_nvim_cmp,
            requires = {
                { 'hrsh7th/cmp-nvim-lsp', disable = vimrc.disable_lsp },
                { 'L3MON4D3/LuaSnip' }, -- snippet plugin
                { 'saadparwaiz1/cmp_luasnip' }, -- snippet source
                { 'hrsh7th/cmp-buffer' }, -- buffer source
                { 'hrsh7th/cmp-path' }, -- path source
                { 'hrsh7th/cmp-nvim-lsp-signature-help' },
                { 'hrsh7th/cmp-cmdline' },
                { 'dmitmel/cmp-cmdline-history' }
            },
            config = function() require('setup.nvim-cmp') end
        }

        -- VSCode-like icons in completion menu
        use { 'onsails/lspkind-nvim', disable = vimrc.disable_nvim_cmp }

        -- preconfigured snippets
        use { 'rafamadriz/friendly-snippets', disable = vimrc.disable_nvim_cmp }

        -- treesitter
        use {
            'nvim-treesitter/nvim-treesitter',
            disable = vimrc.disable_treesitter,
            run = ':TSUpdate',
            config = function() require('setup.treesitter') end
        }

        -- feline airline alternative
        use {
            'feline-nvim/feline.nvim',
            requires = {
                { 'kyazdani42/nvim-web-devicons' },
                { 'lewis6991/gitsigns.nvim', config = function() require('setup.gitsigns') end }
            },
            config = function() require('setup.feline') end
        }

        -- tabline plugin
        use {
            'romgrk/barbar.nvim',
            requires = 'kyazdani42/nvim-web-devicons',
            config = function() require('setup.barbar') end
        }

        -- gruvbox theme
        use { 'ellisonleao/gruvbox.nvim', requires = 'rktjmp/lush.nvim' }

        -- visualize color codes
        use { 'norcalli/nvim-colorizer.lua',
            config = function() require 'colorizer'.setup() end }

        -- NvimTree alternative to NerdTree
        use {
            'kyazdani42/nvim-tree.lua',
            requires = 'kyazdani42/nvim-web-devicons',
            config = function() require('setup.nvim-tree') end
        }

        -- Telescope -- modular fuzzy finder
        use {
            'nvim-telescope/telescope.nvim',
            disable = vimrc.disable_telescope,
            requires = {
                { 'nvim-lua/plenary.nvim' },
                { 'nvim-telescope/telescope-fzf-native.nvim', run = 'make' }
            },
            config = function() require('setup.telescope') end
        }
        use { 'nvim-telescope/telescope-ui-select.nvim',
            config = function()
                require('telescope').load_extension('ui-select')
            end
        }

        -- Visualize the undo tree
        use { 'mbbill/undotree', config = function() require('setup.undotree') end }

        -- To enable more features from rust-analyzer
        use { 'simrat39/rust-tools.nvim', requires = 'nvim-lua/popup.nvim' }

        -- Debugging
        use { 'mfussenegger/nvim-dap', config = function() require('setup.nvim-dap') end }
        use { 'rcarriga/nvim-dap-ui', config = function() require('setup.nvim-dap-ui') end }
        use { 'nvim-telescope/telescope-dap.nvim',
            config = function() require 'telescope'.load_extension('dap') end }
        use { 'theHamsta/nvim-dap-virtual-text',
            config = function() require('nvim-dap-virtual-text').setup({}) end }
        use { 'mfussenegger/nvim-dap-python',
            config = function()
                require('dap-python').setup(vim.g.utils.python_interpreter())
            end
        }

        if packer_bootstrap then
            packer.sync()
        end
    end,

    config = {
        profile = {
            enable = true,
            threshold = 1,
        }
    }
})
