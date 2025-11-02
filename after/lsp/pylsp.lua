---@type vim.lsp.Config
return {
    settings = {
        pylsp = {
            plugins = {
                pycodestyle = { ignore = { 'E501', 'E231', 'E226', 'E402' } },
            }
        }
    },
}
