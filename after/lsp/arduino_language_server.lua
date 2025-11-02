---@type vim.lsp.Config
return {
    cmd = {
        require('setup.globals').arduinolsp_cmd,
        '-cli-config', require('setup.globals').arduinocli_config,
        '-fqbn', require('setup.globals').arduinolsp_fqbn
    }
}
