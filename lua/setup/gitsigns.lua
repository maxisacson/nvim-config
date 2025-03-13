local gitsigns = require('gitsigns')

local map = function(mode, lhs, rhs, bufnr, desc)
    vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, silent = true, desc = '[GitSigns] ' .. desc })
end

local on_attach = function(bufnr)
    map('n', '<leader>gl', function() gitsigns.blame_line({ full = true }) end, bufnr, "Blame current line")
    map('n', '<leader>gb', gitsigns.toggle_current_line_blame, bufnr, "Toggle line blame")
    map('n', '<leader>gs', gitsigns.stage_hunk, bufnr, "Stage/unstage hunk under cursor")
    map('n', '<leader>gS', gitsigns.stage_buffer, bufnr, "Stage all hunks in buffer")
    map('n', '<leader>gp', gitsigns.preview_hunk, bufnr, "Preview hunk")
    map('n', '<leader>gr', gitsigns.reset_hunk, bufnr, "Reset hunk")

    map('n', ']c', function() gitsigns.nav_hunk('next') end, bufnr, "Goto next hunk")
    map('n', '[c', function() gitsigns.nav_hunk('prev') end, bufnr, "Goto next hunk")
end

gitsigns.setup {
    current_line_blame = false,
    current_line_blame_opts = {
        delay = 250,
    },
    on_attach = on_attach
}
