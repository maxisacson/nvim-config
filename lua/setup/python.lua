-- Set python3 host program
if vim.g.vimrc.python3_host_prog ~= "" then
    vim.g.python3_host_prog = vim.g.vimrc.python3_host_prog
else
    local venv_path = '~/.venvs/neovim'
    vim.g.python3_host_prog = vim.fn.expand(venv_path .. '/bin/python3')
    require('setup.utils').check_and_prompt_for_neovim_venv(venv_path)
end
