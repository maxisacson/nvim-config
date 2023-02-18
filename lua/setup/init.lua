local M = {}
function M.setup(opt)
    require('setup.globals').setup(opt)
    require('setup.utils')
    require('setup.options')
    require('setup.keymaps')
    require('setup.plugins')
    require('setup.python')
    require('setup.terminal')
    require('setup.custom')
end
return M
