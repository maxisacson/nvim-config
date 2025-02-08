local function lsp_client_names()
    local clients = {}
    for _, client in ipairs(vim.lsp.get_clients({ bufnr = 0 })) do
        clients[#clients + 1] = client.name
    end
    return table.concat(clients, ' ')
end

local function git_diff()
    local status = vim.b.gitsigns_status_dict
    if status == nil then
        return nil
    end
    return {
        added = status.added,
        modified = status.changed,
        removed = status.removed
    }
end

local function file_format_and_encoding()
    local encoding = vim.opt.fileencoding:get()
    if encoding == '' then
        encoding = vim.opt.encoding:get()
    end
    local format = vim.opt.fileformat:get()
    return string.format('%s[%s]', encoding, format)
end

local function caps_lock_status()
    local output = vim.system({ 'xset', '-q' }, { text = true }):wait().stdout
    if output == nil then
        return ''
    end

    if output:match("Caps Lock:%s+(%S+)") == 'on' then
        return "[󰌎]"
    end

    return ''
end

local function get_theme()
    if vim.g.colors_name == 'gruvbox' then
        local theme = require('lualine.themes.gruvbox')
        theme.normal.b.fg = theme.normal.c.fg
        theme.insert.c.bg = theme.normal.c.bg

        theme.insert.b.fg = theme.normal.b.fg
        theme.insert.c.fg = theme.normal.c.fg

        theme.visual.b.fg = theme.normal.b.fg
        theme.visual.c.fg = theme.normal.c.fg
        theme.visual.c.bg = theme.normal.c.bg

        theme.replace.b.fg = theme.normal.b.fg
        theme.replace.c.fg = theme.normal.c.fg
        theme.replace.c.bg = theme.normal.c.bg

        theme.command.b.fg = theme.normal.b.fg
        theme.command.c.fg = theme.normal.c.fg
        theme.command.c.bg = theme.normal.c.bg
    end

    return 'auto'
end

require('lualine').setup(
    {
        options = {
            theme = get_theme(),
            section_separators = '',
            component_separators = '',
            ignore_focus = { 'fugitive', 'fugitiveblame', 'NvimTree' },
        },
        sections = {
            lualine_a = {
                'mode'
            },
            lualine_b = {
                {
                    'branch', icon = ''
                },
                {
                    'diff',
                    source = git_diff,
                    padding = { left = 0, right = 1 }
                }
            },
            lualine_c = {
                {
                    'filename',
                    path = 1,
                }
            },
            lualine_x = {
                {
                    caps_lock_status
                },
                {
                    'diagnostics',
                    padding = 0,
                    update_in_insert = true
                },
                {
                    'filetype'
                },
                {
                    lsp_client_names,
                    icon = '',
                    padding = { left = 0, right = 1 }
                }
            },
            lualine_y = {
                file_format_and_encoding
            },
            lualine_z = {
                {
                    '%p%% %LL %l:%c',
                    color = { gui = nil }
                },
            },
        }
    }
)
