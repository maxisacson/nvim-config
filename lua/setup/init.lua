local function setup(mod)
    return require('setup.' .. mod)
end

local M = {}
function M.setup(opt)
    setup('globals').setup(opt)
    setup('utils')
    setup('plugins')
    setup('common')
    setup('colorscheme')
    setup('python')
    setup('terminal')
    setup('custom')
end
return M
