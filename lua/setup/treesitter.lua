require 'nvim-treesitter.configs'.setup {
    ensure_installed = { "lua", "vim", "vimdoc", "c", "cpp", "python", "bash" },
    ignore_install =  { "dockerfile", "tmux" },
    auto_install = true,
    highlight = {
        enable = true,
    },
    indent = {
        enable = false,
    },
}

require 'nvim-treesitter.install'.compilers = { "clang", "gcc" }
