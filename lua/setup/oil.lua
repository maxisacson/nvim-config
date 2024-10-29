require('oil').setup({
    default_file_explorer = true,
    keymaps = {
        ["<C-v>"] = { "actions.select", opts = { vertical = true }, desc = "Open the entry in a vertical split" },
        ["<C-x>"] = { "actions.select", opts = { horizontal = true }, desc = "Open the entry in a horizontal split" },
    },
})

vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "[Oil] Open parent directory" })
