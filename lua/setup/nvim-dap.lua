local dap = require('dap')

dap.adapters.codelldb = {
    type = 'server',
    port = '${port}',
    executable = {
        command = 'codelldb',
        args = { '--port', '${port}' },
    },
}

dap.adapters.cppdbg = {
    id = 'cppdbg',
    type = 'executable',
    command = 'OpenDebugAD7'
}

dap.configurations.cpp = {
    {
        type = 'codelldb',
        request = 'launch',
        name = '[LLDB] Launch executable',
        program = function()
            return vim.fn.input({ prompt = 'Path to executable: ', default = vim.fn.getcwd() .. '/', completion = 'file' })
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
            return vim.fn.input({ prompt = 'Path to executable: ', default = vim.fn.getcwd() .. '/', completion = 'file' })
        end,
        cwd = '${workspaceFolder}',
        stopOnEntry = false,
        args = function()
            return { vim.fn.input({ prompt = 'Args: ', default = '', completion = 'file' }) }
        end,
    },
    {
        type = 'cppdbg',
        request = 'launch',
        name = '[CppDbg] Launch executable',
        program = function()
            return vim.fn.input({ prompt = 'Path to executable: ', default = vim.fn.getcwd() .. '/', completion = 'file' })
        end,
        cwd = '${workspaceFolder}',
        stopOnEntry = false,
        args = {},
        setupCommands = {
            {
                text = '-enable-pretty-printing',
                description = 'enable pretty printing',
                ignoreFailures = false,
            },
        }
    },
    {
        type = 'cppdbg',
        request = 'launch',
        name = '[CppDbg] Launch executable with args',
        program = function()
            return vim.fn.input({ prompt = 'Path to executable: ', default = vim.fn.getcwd() .. '/', completion = 'file' })
        end,
        cwd = '${workspaceFolder}',
        stopOnEntry = false,
        args = function()
            return { vim.fn.input({ prompt = 'Args: ', default = '', completion = 'file' }) }
        end,
        setupCommands = {
            {
                text = '-enable-pretty-printing',
                description = 'enable pretty printing',
                ignoreFailures = false,
            },
        }
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
require('dap.ext.vscode').load_launchjs(launchjs_path(), { codelldb = { 'c', 'cpp' }, cppdbg = {'c', 'cpp'} })

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
dap.listeners.before.disconnect["dapui_config"] = function()
    require('dapui').close({})
end

require('telescope').load_extension('dap')
require('nvim-dap-virtual-text').setup({})
require('dap-python').setup()

vim.api.nvim_create_user_command("DapuiOpen", function() require('dapui').open() end, {})
vim.api.nvim_create_user_command("DapuiClose", function() require('dapui').close() end, {})
vim.api.nvim_create_user_command("DapuiToggle", function() require('dapui').toggle() end, {})
