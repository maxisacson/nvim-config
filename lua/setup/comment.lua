-- config for Comment.nvim
require('Comment').setup({
    toggler = {
        line = '<Leader>c',
        block = '<Leader>bc'
    },
    opleader = {
        line = '<Leader>c',
        block = '<Leader>bc'
    },
    extra = {
        above = '<Leader>OC',
        below = '<Leader>oc',
        eol = '<Leader>C',
    }
})
