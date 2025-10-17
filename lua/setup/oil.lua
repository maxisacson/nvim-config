require('oil').setup({
    default_file_explorer = true,
    keymaps = {
        ["<C-v>"] = { "actions.select", opts = { vertical = true }, desc = "Open the entry in a vertical split" },
        ["<C-x>"] = { "actions.select", opts = { horizontal = true }, desc = "Open the entry in a horizontal split" },
        ["gd"] = {
            function()
                require("oil").set_columns({ "icon", "permissions", "size", "mtime" })
            end,
            desc = "Show details",
        },
    },
})

vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "[Oil] Open parent directory" })
