vim.bo.expandtab = false
vim.opt_local.listchars = { tab = '  ', trail = '∙', nbsp = '␣', extends = '»', precedes = '«', lead = '∙' }

local ag_autoformat = vim.api.nvim_create_augroup('AutoFormatGoFile', { clear = true })
vim.api.nvim_create_autocmd('BufWrite', {
    group = ag_autoformat,
    buffer = 0,
    callback = function() vim.lsp.buf.format({ async = true }) end
})
