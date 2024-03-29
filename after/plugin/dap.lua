local map = function(mode, lhs, rhs, desc)
    vim.keymap.set(mode, lhs, rhs, { silent = true, desc = '[DAP] ' .. desc })
end

map('n', '<F5>', function() require('dap').continue() end, 'Continue')
map('n', '<S-F5>', function() require('dap').terminate() end, 'Terminate')
map('n', '<F17>', function() require('dap').terminate() end, 'Terminate')
map('n', '<F10>', function() require('dap').step_over() end, 'Step over')
map('n', '<C-F10>', function() require('dap').run_to_cursor() end, 'Run to cursor')
map('n', '<F11>', function() require('dap').step_into() end, 'Step into')
map('n', '<S-F11>', function() require('dap').step_out() end, 'Step out')
map('n', '<F9>', function() require('dap').toggle_breakpoint() end, 'Toggle breakpoint')

map('n', '<Leader>dc', function() require('dap').continue() end, 'Continue')
map('n', '<Leader>dq', function() require('dap').terminate() end, 'Terminate')
map('n', '<Leader>ds', function() require('dap').step_over() end, 'Step over')
map('n', '<Leader>dC', function() require('dap').run_to_cursor() end, 'Run to cursor')
map('n', '<Leader>di', function() require('dap').step_into() end, 'Step into')
map('n', '<Leader>do', function() require('dap').step_out() end, 'Step out')
map('n', '<Leader>db', function() require('dap').toggle_breakpoint() end, 'Toggle breakpoint')
map('n', '<Leader>dB', function() require('dap').set_breakpoint(vim.fn.input('Breakpoint condition: ')) end,
    'Set conditional breakpoint')
map('n', '<Leader>dg', function() require('dap').set_breakpoint(nil, nil, vim.fn.input('Log point message: ')) end,
    'Set log point')
map('n', '<Leader>dr', function() require('dap').repl.open() end, 'Open REPL')
map('n', '<Leader>dl', function() require('dap').run_last() end, 'Run last')

vim.fn.sign_define('DapBreakpoint', { text = '●', texthl = 'DapBreakpointSymbol', linehl = '', numhl = '' })
vim.fn.sign_define('DapBreakpointCondition', { text = '■', texthl = 'DapBreakpointSymbol', linehl = '', numhl = '' })
vim.fn.sign_define('DapLogPoint', { text = '◆', texthl = 'SignColumn', linehl = '', numhl = '' })
vim.fn.sign_define('DapStopped', { text = '▶', texthl = 'DapStoppedSymbol', linehl = '', numhl = '' })
vim.fn.sign_define('DapBreakpointRejected', { text = '◌', texthl = 'DapBreakpointSymbol', linehl = '', numhl = '' })
