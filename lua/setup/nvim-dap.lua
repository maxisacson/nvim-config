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
    }
}

dap.configurations.c = dap.configurations.cpp

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
