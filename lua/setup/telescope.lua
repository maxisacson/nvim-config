-- Configuration for telescope.nvim
local builtin = require('telescope.builtin')
local actions = require 'telescope.actions'
local telescope = require('telescope')

local telescope_project_files = function()
    local topts = {} -- define here if you want to define something
    local ok = pcall(builtin.git_files, topts)
    if not ok then builtin.find_files(topts) end
end

local map = function(mode, lhs, rhs, desc)
    vim.keymap.set(mode, lhs, rhs, { silent = true, desc = '[Telescope] ' .. desc })
end

map('n', '<leader>sf', builtin.find_files, 'Find files')
map('n', '<leader>sv', builtin.git_files, 'Git files')
map('n', '<leader>sg', builtin.live_grep, 'Live grep')
map('n', '<leader>ss', builtin.grep_string, 'Grep string')
map('v', '<leader>ss', builtin.grep_string, 'Grep string')
map('n', '<leader>sb', builtin.buffers, 'Buffers')
map('n', '<leader>sh', builtin.help_tags, 'Help tags')
map('n', '<leader>sk', builtin.keymaps, 'Keymaps')
map('n', '<leader>se', telescope.extensions.file_browser.file_browser, 'File Browser')
map('n', '<leader>sr', builtin.resume, 'Resume picker')

map('n', '<C-p>', telescope_project_files, 'Project files')
map('n', '<C-Space>', builtin.buffers, 'Buffers')

map('n', '<leader>sF', function() builtin.find_files({ no_ignore = true }) end, 'Find files (all)')
map('n', '<leader>sG', function() builtin.live_grep({ additional_args = { '--no-ignore' } }) end, 'Live grep (all)')
map('n', '<leader>sS', function() builtin.grep_string({ additional_args = { '--no-ignore' } }) end, 'Grep string (all)')
map('v', '<leader>sS', function() builtin.grep_string({ additional_args = { '--no-ignore' } }) end, 'Grep string (all)')
map('n', '<leader>sE', function() telescope.extensions.file_browser.file_browser({ path = '%:p:h' }) end,
    'File Browser (from current)')

local fb_actions = require('telescope').extensions.file_browser.actions
telescope.setup {
    defaults = {
        mappings = {
            i = {
                ['<C-j>'] = actions.move_selection_next,
                ['<C-k>'] = actions.move_selection_previous,
            }
        }
    },
    extensions = {
        fzf = {
            fuzzy = true,                   -- false will only do exact matching
            override_generic_sorter = true, -- override the generic sorter
            override_file_sorter = true,    -- override the file sorter
            case_mode = "smart_case",       -- or "ignore_case" or "respect_case"
        },
        ['ui-select'] = {
            require('telescope.themes').get_dropdown {}
        },
    }
}

telescope.load_extension('fzf')
telescope.load_extension('ui-select')
telescope.load_extension('file_browser')
