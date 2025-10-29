-- Utility functions

local M = {}

function M.check_and_prompt_for_neovim_venv(venv_path)
    if vim.fn.isdirectory(vim.fn.expand(venv_path)) ~= 0 then
        return
    end

    local choice = vim.fn.input('Neovim venv not found (' .. venv_path .. '). Create it? [y/N]: ')
    if string.lower(choice) == 'y' then
        vim.fn.system({ 'python', '-m', 'venv', vim.fn.expand(venv_path) })
        vim.fn.system({ vim.fn.expand(venv_path .. '/bin/python3'), '-m', 'pip', 'install', '-U', 'pynvim' })
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

function M.delete_buffer(buf, force)
    if buf == 0 or buf == nil then
        buf = vim.api.nvim_get_current_buf()
    end

    local buftype = vim.bo[buf].buftype
    if buftype == "terminal" or buftype == "help" then
        vim.cmd.bdelete { buf, bang = force }
        return
    end

    local new = nil
    if not vim.bo[buf].modified then
        for _, win in ipairs(vim.fn.win_findbuf(buf)) do
            vim.api.nvim_win_call(win, function()
                local alt = vim.fn.bufnr('#')
                if alt ~= -1 and alt ~= buf and vim.bo[alt].buflisted then
                    vim.api.nvim_win_set_buf(win, alt)
                    return
                end

                if pcall(vim.cmd.bprevious) and buf ~= vim.api.nvim_get_current_buf() then
                    return
                end

                new = new or vim.api.nvim_create_buf(true, false)
                vim.api.nvim_win_set_buf(win, new)
            end)
        end
    end

    if vim.bo[buf].buflisted then
        vim.cmd.bdelete { buf, bang = force }
    end
end

return M
