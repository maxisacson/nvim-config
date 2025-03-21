local globals = require('setup.globals')

require('mason').setup()
require('mason-lspconfig').setup({
    ensure_installed = {
        'pylsp', 'cmake', 'lua_ls', 'marksman'
    }
})
require('fidget').setup({})
require('neodev').setup({})

local lspconfig = require('lspconfig')
local telescope_ok, telescope = pcall(require, 'telescope.builtin')

vim.diagnostic.config({
    signs = {
        text = {
            [vim.diagnostic.severity.ERROR] = '󰅚 ',
            [vim.diagnostic.severity.WARN] = '󰀪 ',
            [vim.diagnostic.severity.INFO] = '󰋽 ',
            [vim.diagnostic.severity.HINT] = '󰌶 ',
        }
    }
})

local on_attach = function(client, bufnr)
    vim.bo.omnifunc = 'v:lua.vim.lsp.omnifunc'

    -- Mappings.
    local map = function(mode, lhs, rhs, desc)
        vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = '[LSP] ' .. desc })
    end

    map('n', 'gD', vim.lsp.buf.declaration, 'Goto declaration')
    map('n', 'K', vim.lsp.buf.hover, 'Hover')
    map('n', '<leader>wa', vim.lsp.buf.add_workspace_folder, 'Add workspace folder')
    map('n', '<leader>wr', vim.lsp.buf.remove_workspace_folder, 'Remove workspace folder')
    map('n', '<leader>wl', function() print(vim.inspect(vim.lsp.buf.list_workspace_folders())) end,
        'List workspace folders')
    map('n', '<leader>rn', vim.lsp.buf.rename, 'Rename symbol')
    map('n', '<leader>e', vim.diagnostic.open_float, 'Open diagnostics under cursor')
    map('n', '[d', vim.diagnostic.goto_prev, 'Goto prev diagnostic')
    map('n', ']d', vim.diagnostic.goto_next, 'Goto next diagnostic')
    map('n', '<leader>a', vim.lsp.buf.code_action, 'Code action')

    if telescope_ok then
        map('n', 'gr', telescope.lsp_references, 'Goto reference')
        map('n', 'gd', telescope.lsp_definitions, 'Goto definition')
        map('n', 'gs', function() telescope.lsp_definitions({ jump_type = 'vsplit' }) end, 'Goto definition (vsplit)')
        map('n', '<leader>D', telescope.lsp_type_definitions, 'Goto type definition')
        map('n', 'gi', telescope.lsp_implementations, 'Goto implementation')
        map('n', '<leader>ds', telescope.lsp_document_symbols, 'List document symbols')
        map('n', '<leader>ws', telescope.lsp_dynamic_workspace_symbols, 'List workspace symbols')
        map('n', '<leader>dq', function() telescope.diagnostics({ bufnr = 0 }) end, 'Open document diagnostics')
        map('n', '<leader>wq', telescope.diagnostics, 'Open workspace diagnostics')
        map('n', '<leader>dQ', function() telescope.diagnostics({ bufnr = 0, severity = "error" }) end,
            'Open document diagnostics (errors)')
        map('n', '<leader>wQ', function() telescope.diagnostics({ severity = "error" }) end,
            'Open document diagnostics (errors)')
    else
        map('n', 'gr', vim.lsp.buf.references, 'Goto reference')
        map('n', 'gd', vim.lsp.buf.definition, 'Goto definition')
        map('n', 'gs', ':vsplit | lua vim.lsp.buf.definition()<CR>', 'Goto definition (vsplit)')
        map('n', '<leader>D', vim.lsp.buf.type_definition, 'Goto type definition')
        map('n', 'gi', vim.lsp.buf.implementation, 'Goto implementation')
        map('n', '<leader>ds', vim.lsp.buf.document_symbol, 'List document symbols')
        map('n', '<leader>ws', vim.lsp.buf.workspace_symbol, 'List workspace symbols')
        map('n', '<leader>dq', vim.diagnostic.setqflist, 'Open diagnostics')
        map('n', '<leader>wq', vim.diagnostic.setqflist, 'Open diagnostics')
    end

    -- Set some keybinds conditional on server capabilities
    if client.server_capabilities.documentFormattingProvider then
        map('n', '<leader>f', function() vim.lsp.buf.format({ async = true }) end, 'Format document')
    end

    if client.server_capabilities.documentRangeFormattingProvider then
        map('v', '<leader>f', function() vim.lsp.buf.format({ async = true }) end, 'Format selection')
    end

    local hi = function(...)
        vim.api.nvim_set_hl(0, ...)
    end

    local bg = require('setup.utils').bg

    hi('LspDiagnosticsUnderlineError', { undercurl = 1, sp = 'Red' })
    hi('LspDiagnosticsUnderlineWarning', { undercurl = 1, sp = 'Orange' })
    hi('LspDiagnosticsUnderlineInformation', { undercurl = 1, sp = 'LightBlue' })
    hi('LspDiagnosticsUnderlineHint', { undercurl = 1, sp = 'LightGrey' })
    hi('LspReferenceRead', { bg = bg('Visual') })
    hi('LspReferenceWrite', { bg = bg('Visual') })
    hi('LspReferenceText', { bg = bg('Visual') })

    -- Set autocommands conditional on server_capabilities
    if client.server_capabilities.documentHighlightProvider then
        vim.opt.updatetime = 250

        local g = vim.api.nvim_create_augroup("LspDocumentHighlight", { clear = true })
        vim.api.nvim_create_autocmd('CursorHold',
            { group = g, buffer = bufnr, callback = vim.lsp.buf.document_highlight })
        vim.api.nvim_create_autocmd('CursorMoved', { group = g, buffer = bufnr, callback = vim.lsp.buf.clear_references })
        vim.api.nvim_create_autocmd('CursorHold', {
            group = g,
            buffer = bufnr,
            callback = function()
                vim.diagnostic.open_float({ show_header = false, focusable = false })
            end
        })
    end
end

vim.lsp.handlers['textDocument/publishDiagnostics'] = vim.lsp.with(
    vim.lsp.diagnostic.on_publish_diagnostics, {
        signs = true,
        underline = true,
        update_in_insert = true,
    })

local capabilities = require('cmp_nvim_lsp').default_capabilities()

-- Servers that don't require special setup
local servers = { 'cmake', 'ts_ls', 'gopls', 'marksman' }
for _, lsp in ipairs(servers) do
    lspconfig[lsp].setup {
        on_attach = on_attach,
        capabilities = capabilities
    }
end

-- Servers that do require special setup

-- NOTE: To install pylsp-mypy run
--          :PylspInstall pylsp-mypy
lspconfig.pylsp.setup {
    on_attach = on_attach,
    capabilities = capabilities,
    settings = {
        pylsp = {
            plugins = {
                pycodestyle = { ignore = { 'E501', 'E231', 'E226', 'E402' } },
            }
        }
    },
}

-- require('rust-tools').setup {
--     server = {
--         on_attach = on_attach,
--         capabilities = capabilities
--     }
-- }

lspconfig.clangd.setup {
    on_attach = on_attach,
    capabilities = capabilities,

    cmd = { "clangd",
        "--background-index",
        "--compile-commands-dir=build",
        "--clang-tidy",
        "--clang-tidy-checks='" ..
        "-*," ..
        "clang-analyzer-*," ..
        "modernize-*," ..
        "readability-*," ..
        "performance-*," ..
        "cppcoreguidelines-*," ..
        "bugprone-*," ..
        "cert-*," ..
        "hicpp-*," ..
        "-cppcoreguidelines-pro-bounds-constant-array-index," ..
        "-cppcoreguidelines-pro-bounds-array-to-pointer-decay," ..
        "-cppcoreguidelines-avoid-magic-numbers," ..
        "-readability-braces-around-statements," ..
        "-readability-magic-numbers," ..
        "-hicpp-braces-around-statements," ..
        "-hicpp-no-array-decay," ..
        "-hicpp-uppercase-literal-suffix," ..
        "-readability-uppercase-literal-suffix," ..
        "-modernize-use-trailing-return-type," ..
        "'" }
}

-- local runtime_path = vim.split(package.path, ';')
-- table.insert(runtime_path, 'lua/?.lua')
-- table.insert(runtime_path, 'lua/?/init.lua')

-- lspconfig.lua_ls.setup {
--     on_attach = on_attach,
--     capabilities = capabilities,
--     settings = {
--         Lua = {
--             runtime = {
--                 version = "LuaJIT",
--                 path = runtime_path
--             },
--             diagnostics = {
--                 globals = { 'vim' }
--             },
--             workspace = {
--                 library = vim.api.nvim_get_runtime_file('', true),
--                 checkThirdParty = false,
--             },
--             telemetry = {
--                 enable = false
--             }
--         }
--     }
-- }

lspconfig.lua_ls.setup {
    on_attach = on_attach,
    capabilities = capabilities,
    settings = {
        Lua = {
            workspace = { checkThirdParty = false, },
            telemetry = { enable = false }
        }
    }
}

lspconfig.arduino_language_server.setup {
    on_attach = on_attach,
    capabilities = capabilities,
    cmd = {
        globals.arduinolsp_cmd,
        '-cli-config', globals.arduinocli_config,
        '-fqbn', globals.arduinolsp_fqbn
    }
}

lspconfig.zls.setup {
    on_attach = on_attach,
    capabilities = capabilities,
    settings = {
        zls = {
            enable_build_on_save = true,
        }
    }
}
