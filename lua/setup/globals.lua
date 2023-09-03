local M = {}

function M.build_config(opt)
    opt = opt or {}

    local default_opt = {
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
    }

    local user_opt = default_opt
    for k,v in pairs(opt) do
        if user_opt[k] ~= nil then
            user_opt[k] = v
        else
            error('unknown opt: ' .. k)
        end
    end

    return user_opt
end

function M.setup(opt)
    vim.g.vimrc = M.build_config(opt)
end

return M
