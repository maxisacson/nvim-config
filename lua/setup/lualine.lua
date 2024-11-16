local function lsp_client_names()
    local clients = {}
    for _, client in ipairs(vim.lsp.get_clients({ bufnr = 0 })) do
        clients[#clients + 1] = client.name
    end
    return table.concat(clients, ' ')
end

local function file_format()
    local ff = vim.bo.fileformat
    if ff == '' then
        ff = vim.o.fileformat
    end
    if ff ~= '' then
        ff = '[' .. ff .. ']'
    end
    return ff
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

local function file_location()
    local line = vim.fn.line('.')
    local lines = vim.fn.line('$')
    local col = vim.fn.col('.')
    local percent = vim.fn.round(100 * line / lines)
    return string.format('%d%%%% %d ☰ %d:%d', percent, lines, line, col)
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
            lualine_a = { 'mode' },
            lualine_b = {
                { 'branch', icon = '' },
                {
                    'diff',
                    source = git_diff,
                    padding = { left = 0, right = 1 }
                }
            },
            lualine_c = {
                {
                    'filetype',
                    icon_only = true,
                    padding = { left = 1, right = 0 }
                },
                {
                    'filename',
                    padding = { left = 0, right = 1 }
                }
            },
            lualine_x = {
                { 'diagnostics', padding = 0 },
                'bo:filetype',
                {
                    lsp_client_names,
                    icon = '',
                    padding = { left = 0, right = 1 }
                }
            },
            lualine_y = {
                {
                    'encoding',
                    padding = { left = 1, right = 0, }
                },
                {
                    file_format,
                    padding = { left = 0, right = 1, }
                },
            },
            lualine_z = {
                { file_location, color = { gui = nil } },
            },
        }
    }
)
