-- Utility functions

local M = {}

function M.check_and_prompt_for_neovim_venv(venv_path)
    if vim.fn.isdirectory(vim.fn.expand(venv_path)) ~= 0 then
        return
    end

    local choice = vim.fn.input('Neovim venv not found (' .. venv_path .. '). Create it? [y/N]: ')
    if string.lower(choice) == 'y' then
        vim.fn.system({'python', '-m', 'venv', vim.fn.expand(venv_path)})
        vim.fn.system({vim.fn.expand(venv_path .. '/bin/python3'), '-m', 'pip', 'install', '-U', 'pynvim'})
    end
end

function M.hl(group)
    return vim.api.nvim_get_hl_by_name(group, 1)
end

function M.fg(group)
    return string.format('#%06x', M.hl(group).foreground)
end

function M.bg(group)
    return string.format('#%06x', M.hl(group).background)
end

return M
