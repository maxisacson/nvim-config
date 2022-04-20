local ag = vim.api.nvim_create_augroup("PackerUserConfig", { clear = true })
vim.api.nvim_create_autocmd("BufWritePost", {
    group = ag,
    pattern = "plugins.lua",
    command = "source <afile> | PackerCompile"
})

local function setup(mod)
    return string.format('require("setup.%s")', mod)
end

local packer = require('packer')
local putil = require('packer.util')
packer.init({
    display = {
        open_fn = function()
            return putil.float({border = 'single'})
        end
    },
    profile = {
        enable = true,
        threshold = 1,
    }
})

return packer.startup(function(use)
    local vimrc = vim.g.vimrc

    -- Packer can manage itself
    use 'wbthomason/packer.nvim'

    -- vim-fugitive for git integration
    use 'tpope/vim-fugitive'

    -- ack.vim for ag and ack integration
    use {
        'mileszs/ack.vim',
        disable = vimrc.disable_ack,
        config = setup('ack')
    }

    -- nerdcomment for easy commenting
    use { 'scrooloose/nerdcommenter', config = setup('nerdcommenter') }

    -- vim-easy-align for easy alignment
    use { 'junegunn/vim-easy-align', config = setup('easyalign') }

    -- vim-surround
    use 'tpope/vim-surround'

    -- vim-repeat
    use 'tpope/vim-repeat'

    -- vim-markdown
    use 'tpope/vim-markdown'

    -- GLSL syntax
    use 'tikhomirov/vim-glsl'

    -- latex plugin
    use { 'lervag/vimtex', config = setup('vimtex') }

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
    use { 'rhysd/vim-clang-format', config = setup('clang-format') }

    -- vim-cmake
    use { 'vhdirk/vim-cmake', disable = vimrc.disable_vim_cmake }

    -- fzf fuzzy finder
    use {
        'junegunn/fzf.vim',
        disable = vimrc.disable_fzf,
        config = setup('fzf'),
        requires = {
            { 'junegunn/fzf', run = vim.fn['fzf#install'] }
        }
    }

    -- LSP configurations for neovim
    use {
        'neovim/nvim-lspconfig',
        disable = vimrc.disable_lsp,
        config = setup('lsp')
    }

    -- better support for lsp colors
    use { 'folke/lsp-colors.nvim', disable = vimrc.disable_lsp }

    -- live parameter hints
    use {
        'ray-x/lsp_signature.nvim',
        disable = vimrc.disable_lsp or vimrc.disable_lsp_signature,
        config = setup('lsp_signature')
    }

    -- nvim-cmp for autocompletion
    use {
        'hrsh7th/nvim-cmp', disable = vimrc.disable_nvim_cmp,
        requires = {
            { 'hrsh7th/cmp-nvim-lsp', disable = vimrc.disable_lsp },
            { 'hrsh7th/vim-vsnip' }, -- snippet plugin
            { 'hrsh7th/cmp-vsnip' }, -- snippet source
            { 'hrsh7th/cmp-buffer' }, -- buffer source
            { 'hrsh7th/cmp-path' }, -- path source
            { 'hrsh7th/nvim-cmp' },
        },
        config = setup('nvim-cmp')
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
        config = setup('treesitter')
    }

    -- feline airline alternative
    use {
        'feline-nvim/feline.nvim',
        requires = {
            { 'kyazdani42/nvim-web-devicons' },
            { 'lewis6991/gitsigns.nvim', config = setup('gitsigns') }
        },
        config = setup('feline')
    }

    -- tabline plugin
    use {
        'romgrk/barbar.nvim',
        requires = 'kyazdani42/nvim-web-devicons',
        config = setup('barbar')
    }

    -- gruvbox theme
    use { 'ellisonleao/gruvbox.nvim', requires = 'rktjmp/lush.nvim' }

    -- visualize color codes
    use { 'norcalli/nvim-colorizer.lua', config = setup('colorizer') }

    -- NvimTree alternative to NerdTree
    use {
        'kyazdani42/nvim-tree.lua',
        requires = 'kyazdani42/nvim-web-devicons',
        config = setup('nvim-tree')
    }

    -- Telescope -- modular fuzzy finder
    use {
        'nvim-telescope/telescope.nvim',
        disable = vimrc.disable_telescope,
        requires = {
            { 'nvim-lua/plenary.nvim' },
            { 'nvim-telescope/telescope-fzf-native.nvim', run = 'make' }
        },
        config = setup('telescope')
    }

    -- Neorg note taking plugin
    use {
        'nvim-neorg/neorg',
        disable = vimrc.disable_neorg,
        requires = 'nvim-lua/plenary.nvim',
        config = setup('neorg')
    }

    -- orgmode for nvim
    use {
        'nvim-orgmode/orgmode',
        disable = vimrc.disable_orgmode,
        config = setup('orgmode')
    }

    -- To enable more features from rust-analyzer
    use { 'simrat39/rust-tools.nvim', requires = 'nvim-lua/popup.nvim' }
end)