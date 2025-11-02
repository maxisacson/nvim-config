local M = {}
function M.setup(opt)
    require('setup.globals').setup(opt)
    require('setup.options')
    require('setup.keymaps')
    require('setup.lazy')
    require('setup.terminal')
    require('setup.custom')
    require('setup.lsp')
end
return M
