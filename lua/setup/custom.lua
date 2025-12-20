-- Custom commands, autocommands, mappings, and functions not fitting anywhere else

P = function(v)
    print(vim.inspect(v))
    return v
end

R = function(name)
    require('plenary.reload').reload_module(name)
    return require(name)
end

local augroup = vim.api.nvim_create_augroup("CustomAutoCommands", { clear = true })

vim.api.nvim_create_user_command("Reload",
    function(args) return R(args.args) end,
    { force = true, nargs = 1, desc = 'Reload lua module' })

-- Reload vimrc
vim.api.nvim_create_user_command("ReloadVimrc", "so $MYVIMRC | echom 'Reloaded' . $MYVIMRC | redraw", { force = true })

-- Remove all trailing whitespace on write
local trim_white_space = function()
    local cursor_pos = vim.fn.getpos('.')
    vim.cmd([[keeppatterns %s/\s\+$//e]])
    vim.fn.setpos('.', cursor_pos)
end
vim.api.nvim_create_autocmd("BufWrite", {
    group = augroup,
    pattern = "*",
    callback = trim_white_space,
    desc = "Delete trailing white space"
})

-- Auto set cursor line when moving between splits
vim.api.nvim_create_autocmd({ "WinEnter", "BufEnter" }, { group = augroup, pattern = "*", command = "setlocal cursorline", })
vim.api.nvim_create_autocmd({ "WinLeave", "BufLeave" }, { group = augroup, pattern = "*", command = "setlocal nocursorline", })

-- Highlight yanked text
vim.api.nvim_create_autocmd("TextYankPost", {
    group = augroup,
    pattern = "*",
    callback = function()
        vim.highlight.on_yank({
            higroup = "Visual",
        })
    end,
    desc = "Highlight on yank"
})

-- Function to insert include guards in cpp headers
local insert_cpp_include_guard = function()
    local f = vim.fn
    local guard = f.substitute(f.toupper(f.expand('%:t')), '\\.', '_', 'g')
    if require('setup.globals').cpp_guard_add_trailing_underline == true then
        guard = guard .. '_'
    end
    vim.api.nvim_buf_set_lines(0, 0, 0, true, {
        '#ifndef ' .. guard,
        '#define ' .. guard,
        '',
    })
    vim.api.nvim_buf_set_lines(0, -1, -1, true, {
        '',
        '#endif /* ' .. guard .. ' */',
    })
end
vim.api.nvim_create_user_command("CppGuard", insert_cpp_include_guard, { force = true })

-- execute current line as lua code and append the result
local lua_exec_and_append_current_line = function()
    local line = vim.api.nvim_get_current_line()

    local row = vim.fn.line('.') - 1
    local col = string.len(line)

    local result = table.concat(vim.fn.split(vim.fn.execute('lua =' .. line), '\n'), '\\n ')
    local commentstring = vim.opt.commentstring:get()
    local ft = vim.opt.filetype:get()
    if ft == nil or ft == "" or ft == "txt" or ft == "markdown" then
        result = '= ' .. result
    else
        result = vim.fn.substitute(commentstring, '%s', ' = ' .. result, 'g')
    end
    vim.api.nvim_buf_set_text(0, row, col, row, col, { ' ' .. result })
end
vim.keymap.set('n', '<Leader>x', lua_exec_and_append_current_line, { desc = 'Execute current line in Lua and append result' })

-- execute current line as lua code and append insert below
local lua_exec_and_insert_line = function()
    local line = vim.api.nvim_get_current_line()
    local row = vim.fn.line('.')
    local result = vim.fn.split(vim.fn.execute('lua =' .. line), '\n')
    vim.api.nvim_buf_set_lines(0, row, row, true, result)
end
vim.keymap.set('n', '<Leader>X', lua_exec_and_insert_line, { desc = 'Execute current line in Lua and insert result below)' })

-- show whitespace in insert mode
vim.api.nvim_create_autocmd("InsertEnter", {
    group = augroup,
    pattern = "*",
    callback = function()
        local spaces = vim.opt.tabstop:get()
        vim.opt_local.listchars:append({ leadmultispace = '┆' .. string.rep(' ', spaces-1)})
    end,
    desc = 'Show whitespace when entering insert mode'
})
vim.api.nvim_create_autocmd("InsertLeave", {
    group = augroup,
    pattern = "*",
    callback = function()
        vim.opt_local.listchars:remove('leadmultispace')
    end,
    desc = 'Hide whitespace when entering insert mode'
})

local saved_signcolumn = nil
vim.keymap.set('n', '<leader>ge', function()
    if saved_signcolumn == nil then
        saved_signcolumn = vim.wo.signcolumn
    end

    if vim.wo.signcolumn == saved_signcolumn then
        vim.wo.signcolumn = "yes:2"
    elseif vim.wo.signcolumn ~= saved_signcolumn then
        vim.wo.signcolumn = saved_signcolumn
    end
end, { desc = "Expand sign column" })
vim.api.nvim_create_autocmd({ "BufDelete", "BufUnload" }, {
    pattern = '*',
    group = augroup,
    callback = function()
        if saved_signcolumn ~= nil then
            vim.wo.signcolumn = saved_signcolumn
        end
    end,
    desc = "Reset signcolumn on exit"
})

local function cmd_delete_buffer(args)
    local force = args.bang
    local buf = nil

    if #args.fargs >= 1 then
        buf = tonumber(args.fargs[1])
    else
        buf = buf or vim.api.nvim_get_current_buf()
    end

    require('setup.utils').delete_buffer(buf, force)
end

vim.api.nvim_create_user_command("DeleteBuffer", cmd_delete_buffer, { bang = true, nargs = '?' })
vim.keymap.set('n', '<M-q>', ':DeleteBuffer<CR>', { silent = true, desc = '[Buffer] Close buffer' })
vim.keymap.set('n', '<M-Q>', ':DeleteBuffer!<CR>', { silent = true, desc = '[Buffer] Force close buffer' })

vim.api.nvim_create_autocmd('BufReadPre', {
    pattern = '*',
    group = augroup,
    desc = "Reset cursor position",
    callback = function(args)
        vim.api.nvim_create_autocmd('FileType', {
            buffer = args.buf,
            once = true,
            callback = function()
                local line = vim.fn.line([['"]])
                local ft = vim.bo.filetype
                if line >= 1 and line <= vim.fn.line("$")
                    and string.match(ft, 'commit') == nil
                    and ft ~= 'xxd' and ft ~= 'gitrebase' then

                    vim.cmd[[normal! g`"]]
                end
            end
        })
    end
})
