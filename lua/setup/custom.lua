-- Custom commands, autocommands, mappings, and functions not fitting anywhere else

P = function(v)
    print(vim.inspect(v))
    return v
end

R = function(name)
    require('plenary.reload').reload_module(name)
    return require(name)
end

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
    group = vim.api.nvim_create_augroup("NoTrailingWhitespace", { clear = true }),
    pattern = "*",
    callback = trim_white_space,
    desc = "Delete trailing white space"
})

-- Auto set cursor line on winenter/winleave. This fixed some issue I can't remember right now
local ag_clear = vim.api.nvim_create_augroup("AutoClearCursorline", { clear = true })
vim.api.nvim_create_autocmd("WinEnter", { group = ag_clear, pattern = "*", command = "setlocal cursorline", })
vim.api.nvim_create_autocmd("WinLeave", { group = ag_clear, pattern = "*", command = "setlocal nocursorline", })

-- Highlight yanked text
local ag_yank = vim.api.nvim_create_augroup("HighlightYank", { clear = true })
vim.api.nvim_create_autocmd("TextYankPost", {
    group = ag_yank,
    pattern = "*",
    callback = function()
        vim.highlight.on_yank({
            higroup = "Visual",
        })
    end
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
local ag_whitespace = vim.api.nvim_create_augroup("InsertModeListChars", { clear = true })
vim.api.nvim_create_autocmd("InsertEnter", {
    group = ag_whitespace,
    pattern = "*",
    callback = function()
        local spaces = vim.opt.tabstop:get()
        vim.opt_local.listchars:append({ leadmultispace = '┆' .. string.rep(' ', spaces-1)})
    end,
    desc = 'Show whitespace when entering insert mode'
})
vim.api.nvim_create_autocmd("InsertLeave", {
    group = ag_whitespace,
    pattern = "*",
    callback = function()
        vim.opt_local.listchars:remove('leadmultispace')
    end,
    desc = 'Hide whitespace when entering insert mode'
})

vim.cmd([[
    " Function to format math expressions inline
    function! PrettifyMath()
        " remove whitespace around *, /, and ^
        s/\s*\(\*\|\/\|\^\|(\|)\)\s*/\1/ge

        " padd +, - and = with whitespace
        s/\(+\|-\|=\)/ \1 /ge

        " remove unnecessary trailing 0's
        s/0\+$/0/ge

        " remove unnecessary whitespace
        s/\s\+/ /ge
        s/^\s\+//ge
        s/\(\d\+\)\s\+\(\d\+\)\+/\1\2/ge

        " make sure negative numbers are written correctly
        s/\(^\|=\s\)-\s/\1-/ge
    endfunction
    " Evaluate current line using bc and make it pretty
    nnoremap <Leader>= :s/=.*$//ge<CR>yypkA=<Esc>j:.!bc -l<CR>kJ:call PrettifyMath()<CR>
    " Evaluate current selection using bc and make it pretty
    vnoremap <Leader>= y'>p:'[,']s/^.*=//ge<CR>:'[,']-1s/\n/+/ge<CR>:s/+$//ge<CR>:.!bc -l<CR>I= <Esc>:'<,'>call PrettifyMath()<CR>j
]])
