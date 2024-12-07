local M = {}

local function inner_callback(obj)
    if obj.code == 0 then
        local lines = {}
        for line in string.gmatch(obj.stdout, "[^\r\n]+") do
            table.insert(lines, line)
        end
        if #lines > 1 then
            local s = lines[2]
            if string.match(s, "Your branch is up to date with") == nil then
                vim.notify(s, vim.log.levels.WARN, { title = M.title })
            end
        end
    end
end

function M.check_for_updates()
    local cmd = { "git", "remote", "update" }
    local opts = {
        cwd = M.config_path,
        text = true,
    }
    vim.system(cmd, opts, function(obj)
        if obj.code ~= 0 then
            vim.notify(obj.stderr, vim.log.levels.ERROR, { title = M.title })
            return
        end

        local cmd2 = { "git", "status", "-uno" }
        vim.system(cmd2, opts, inner_callback)
    end)
end

function M.setup()
    M.config_path = vim.fn.stdpath("config")
    M.title = "Nvim Config Checker"

    if vim.v.vim_did_enter == 1 then
        M:check_for_updates()
    else
        local group = vim.api.nvim_create_augroup("NvimConfigChecker", { clear = true })
        vim.api.nvim_create_autocmd("VimEnter", {
            group = group,
            pattern = "*",
            callback = function() M:check_for_updates() end,
        })
    end
end

M.setup()
