vim.bo.textwidth = 120

local function set_makeprg()
    if vim.fn.filereadable('CMakeLists.txt') == 1 and vim.fn.isdirectory('build') == 1 then
        vim.bo.makeprg = 'make --no-print-directory -C build/'
    end
end

set_makeprg()
