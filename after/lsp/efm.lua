local eslint_d = require('efmls-configs.linters.eslint_d')
local prettier = require('efmls-configs.formatters.prettier')

---@type vim.lsp.Config
return {
    filetypes = { 'typescript', 'html', 'htmlangular' },
    settings = {
        languages = {
            typescript = { eslint_d, prettier },
            html = { prettier },
            htmlangular = { prettier },
        }
    },
    init_options = {
        documentFormatting = true,
        documentRangeFormatting = true,
    },
}
