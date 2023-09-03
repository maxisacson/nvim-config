local dap = require('dap')

dap.adapters.codelldb = {
    type = 'server',
    port = '${port}',
    executable = {
        command = 'codelldb',
        args = { '--port', '${port}' },
    },
}

dap.configurations.cpp = {
    {
        type = 'codelldb',
        request = 'launch',
        name = '[LLDB] Launch executable',
        program = function()
            return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
        end,
        cwd = '${workspaceFolder}',
        stopOnEntry = false,
        args = {},
    },
    {
        type = 'codelldb',
        request = 'launch',
        name = '[LLDB] Launch executable with args',
        program = function()
            return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
        end,
        cwd = '${workspaceFolder}',
        stopOnEntry = false,
        args = function()
            return { vim.fn.input('Args: ') }
        end,
    }
}

dap.configurations.c = dap.configurations.cpp

local function launchjs_path()
    local cwd = vim.fn.getcwd()

    local path = cwd .. "/launch.json"
    if vim.fn.filereadable(path) == 1 then
        return path
    end

    path = cwd .. "/.launch.json"
    if vim.fn.filereadable(path) == 1 then
        return path
    end

    return nil
end
require('dap.ext.vscode').load_launchjs(launchjs_path(), { codelldb = { 'c', 'cpp' } })

require('dapui').setup()

dap.listeners.after.event_initialized["dapui_config"] = function()
    require('dapui').open({})
end
dap.listeners.before.event_terminated["dapui_config"] = function()
    require('dapui').close({})
end
dap.listeners.before.event_exited["dapui_config"] = function()
    require('dapui').close({})
end

require('telescope').load_extension('dap')
require('nvim-dap-virtual-text').setup({})
require('dap-python').setup(require('setup.utils').python_interpreter())

vim.api.nvim_create_user_command("DapuiOpen", function() require('dapui').open() end, {})
vim.api.nvim_create_user_command("DapuiClose", function() require('dapui').close() end, {})
vim.api.nvim_create_user_command("DapuiToggle", function() require('dapui').toggle() end, {})
