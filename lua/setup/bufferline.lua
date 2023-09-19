local fg = require('setup.utils').fg

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

require('bufferline').setup({
    options = {
        numbers = function(opts) return string.format('%s', opts.ordinal) end,
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
        close_command = function(bufnr) require('bufdelete').bufdelete(bufnr, true) end,
        middle_mouse_command = function(bufnr) require('bufdelete').bufdelete(bufnr, true) end,
        right_mouse_command = nil,
    },
    highlights = {
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
})

local function nmap(lhs, rhs)
    vim.keymap.set('n', lhs, rhs, { silent = true })
end

nmap('<Leader>1', function() require('bufferline').go_to(1, true) end)
nmap('<Leader>2', function() require('bufferline').go_to(2, true) end)
nmap('<Leader>3', function() require('bufferline').go_to(3, true) end)
nmap('<Leader>4', function() require('bufferline').go_to(4, true) end)
nmap('<Leader>5', function() require('bufferline').go_to(5, true) end)
nmap('<Leader>6', function() require('bufferline').go_to(6, true) end)
nmap('<Leader>7', function() require('bufferline').go_to(7, true) end)
nmap('<Leader>8', function() require('bufferline').go_to(8, true) end)
nmap('<Leader>9', function() require('bufferline').go_to(9, true) end)
nmap('<Leader>0', function() require('bufferline').go_to( -1, true) end)
nmap('<Leader>qq', function() require('bufdelete').bufdelete(0, false) end)
nmap('<Leader>qQ', function() require('bufdelete').bufdelete(0, true) end)

nmap('<Leader>w', ':BufferLineCyclePrev<CR>')
nmap('<Leader>e', ':BufferLineCycleNext<CR>')

nmap('<Leader>W', ':BufferLineMovePrev<CR>')
nmap('<Leader>E', ':BufferLineMoveNext<CR>')
