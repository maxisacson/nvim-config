local fg = require('setup.utils').fg

local function get_highlights()
    if vim.g.colors_name == 'gruvbox' then
        local bg0    = fg("GruvboxBg0")
        local bg1    = fg("GruvboxBg1")
        local bg2    = fg("GruvboxBg2")
        local bg4    = fg("GruvboxBg4")
        local fg1    = fg("GruvboxFg1")
        local fg4    = fg("GruvboxFg4")
        local red    = fg("GruvboxRed")
        local orange = fg("GruvboxOrange")
        local blue   = fg("GruvboxBlue")
        local yellow = fg("GruvboxYellow")
        local purple = fg("GruvboxPurple")
        local aqua   = fg("GruvboxAqua")
        local green  = fg("GruvboxGreen")
        local gray   = fg("GruvboxGray")

        return {
            fill = {
                fg = fg4,
                bg = bg1,
            },
            background = {
                fg = bg4,
                bg = bg1,
            },
            buffer_visible = {
                fg = blue,
                bg = bg1,
            },
            buffer_selected = {
                fg = fg1,
                bg = bg2,
                bold = true,
                italic = false,
            },
            numbers = {
                fg = bg4,
                bg = bg1,
            },
            numbers_visible = {
                fg = blue,
                bg = bg1,
            },
            numbers_selected = {
                fg = fg4,
                bg = bg2,
                bold = true,
                italic = false,
            },
            modified = {
                fg = yellow,
                bg = bg1,
            },
            modified_visible = {
                fg = yellow,
                bg = bg1,
            },
            modified_selected = {
                fg = yellow,
                bg = bg2,
            },
            indicator_selected = {
                fg = bg2,
                bg = bg2,
            },
            indicator_visible = {
                fg = bg1,
                bg = bg1,
            },
            duplicate = {
                fg = bg4,
                bg = bg1,
                italic = false,
            },
            duplicate_visible = {
                fg = blue,
                bg = bg1,
                italic = false,
            },
            duplicate_selected = {
                fg = fg1,
                bg = bg2,
                bold = true,
                italic = false,
            },
        }
    end

    return {}
end

require('bufferline').setup({
    options = {
        numbers = function(opts) return string.format('%s', opts.ordinal) end,
        show_buffer_icons = false,
        show_buffer_close_icons = false,
        show_close_icon = false,
        indicator = {
            style = 'none'
        },
        separator_style = { '', '' },
        tab_size = 0,
        name_formatter = function(buf)
            local name = buf.name
            if (name == nil or name == '') then
                if string.match(buf.path, 'fugitive://') ~= nil then
                    name = '[Git]'
                elseif buf.bufnr ~= nil then
                    name = string.format("[buffer %s]", buf.bufnr)
                end
            end
            return name
        end,
        close_command = function(bufnr) require('setup.utils').delete_buffer(bufnr, true) end,
        middle_mouse_command = function(bufnr) require('setup.utils').delete_buffer(bufnr, true) end,
        right_mouse_command = nil,
        max_name_length = 32,
    },
    highlights = get_highlights()
})

local function nmap(lhs, rhs, desc)
    vim.keymap.set('n', lhs, rhs, { silent = true, desc = '[Buffer] ' .. desc })
end

nmap('<M-1>', function() require('bufferline').go_to(1, true) end, 'Go to 1')
nmap('<M-2>', function() require('bufferline').go_to(2, true) end, 'Go to 2')
nmap('<M-3>', function() require('bufferline').go_to(3, true) end, 'Go to 3')
nmap('<M-4>', function() require('bufferline').go_to(4, true) end, 'Go to 4')
nmap('<M-5>', function() require('bufferline').go_to(5, true) end, 'Go to 5')
nmap('<M-6>', function() require('bufferline').go_to(6, true) end, 'Go to 6')
nmap('<M-7>', function() require('bufferline').go_to(7, true) end, 'Go to 7')
nmap('<M-8>', function() require('bufferline').go_to(8, true) end, 'Go to 8')
nmap('<M-9>', function() require('bufferline').go_to(9, true) end, 'Go to 9')
nmap('<M-0>', function() require('bufferline').go_to(-1, true) end, 'Go to last')

nmap('<M-i>', ':BufferLineCyclePrev<CR>', 'Cycle previous')
nmap('<M-o>', ':BufferLineCycleNext<CR>', 'Cycle next')
nmap('<M-I>', ':BufferLineMovePrev<CR>', 'Move previous')
nmap('<M-O>', ':BufferLineMoveNext<CR>', 'Move next')
