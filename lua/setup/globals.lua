local M = {
    -- Default values
    disable_telescope = false,
    disable_lsp = false,
    disable_treesitter = false,
    disable_nvim_cmp = false,
    disable_lsp_signature = false,
    disable_clang_format = true,
    disable_nerdcommenter = true,
    disable_commentnvim = false,

    python3_host_prog = "", -- empty for default

    arduinolsp_cmd = 'arduino-language-server',
    arduinolsp_fqbn = 'arduino:avr:uno',
    arduinocli_config = vim.env['HOME'] .. '/.arduino15/arduino-cli.yaml',

    cpp_guard_add_trailing_underline = true,
}

local merge
merge = function(t1, t2)
    for k, v in pairs(t2) do
        if t1[k] ~= nil then
            if type(v) == 'table' then
                merge(t1[k], v)
            else
                t1[k] = v
            end
        else
            error('unknown key: ' .. k)
        end
    end
end

function M.setup(opt)
    opt = opt or {}
    merge(M, opt)
end

return M
