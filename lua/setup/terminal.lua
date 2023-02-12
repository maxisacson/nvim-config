local map = vim.keymap.set

map('t', '<Esc>', '<C-\\><C-n>', {})
map('t', '<C-h>', '<C-\\><C-n><C-w>h', {})
map('t', '<C-j>', '<C-\\><C-n><C-w>j', {})
map('t', '<C-k>', '<C-\\><C-n><C-w>k', {})
map('t', '<C-l>', '<C-\\><C-n><C-w>l', {})

-- Open split term
map('n', '<Leader>ts', '<Cmd>split | terminal<CR>', {})

local g = vim.api.nvim_create_augroup('TermOpenConfig', { clear = true })
vim.api.nvim_create_autocmd('TermOpen',
    {
        group = g,
        pattern = '*',
        callback = function(opts)
            vim.cmd [[set nobuflisted ]]
            vim.cmd [[setlocal scrolloff=0]]
            vim.cmd [[setlocal sidescrolloff=0]]
            vim.cmd [[setlocal nonumber]]
            vim.cmd [[setlocal norelativenumber]]
            vim.cmd [[setlocal signcolumn=auto]]
            if opts.file:match('dap%-terminal') then
                return
            end
            vim.cmd [[startinsert]]
        end
    })

vim.api.nvim_create_autocmd('BufEnter',
    {
        group = g,
        pattern = 'term://*',
        callback = function(opts)
            vim.cmd[[setlocal scrolloff=0]]
            vim.cmd[[setlocal sidescrolloff=0]]
            if opts.file:match('dap%-terminal') then
                return
            end
            vim.cmd[[startinsert]]
        end
    })
