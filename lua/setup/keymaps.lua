local function map(...) vim.keymap.set(...) end

-- Window movement bindings
map('n', '<C-Left>', '<C-w>h')
map('n', '<C-Right>', '<C-w>l')
map('n', '<C-Up>', '<C-w>k')
map('n', '<C-Down>', '<C-w>j')
map('n', '<C-h>', '<C-w>h')
map('n', '<C-l>', '<C-w>l')
map('n', '<C-k>', '<C-w>k')
map('n', '<C-j>', '<C-w>j')
-- convenience mapping for CTRL_W
map('n', '`', '<C-w>')
map('n', '§', '<C-w>')


-- Window resize bindings
map('n', '<Leader>+', '<C-w>5+')
map('n', '<Leader>-', '<C-w>5-')
map('n', '<Leader>>', '<C-w>5>')
map('n', '<Leader><', '<C-w>5<')

-- Buffer management
map('n', '<Leader><Leader>', '<C-^>')

-- mappings for quickfix list
map('n', '<M-n>', ':cnext<CR>')
map('n', '<M-p>', ':cprev<CR>')
map('n', '<M-N>', ':clast<CR>')
map('n', '<M-P>', ':cfirst<CR>')
map('n', '<Leader>qc', ':cclose<CR>')
map('n', '<Leader>qo', ':copen<CR>')

-- mappings for location list
map('n', ']l', ':lnext<CR>')
map('n', '[l', ':lprev<CR>')
map('n', ']L', ':llast<CR>')
map('n', '[L', ':lfirst<CR>')
map('n', '<Leader>lc', ':lclose<CR>')
map('n', '<Leader>lo', ':lopen<CR>')

-- command line editing
map('c', '<C-a>', '<Home>')    -- start of line
map('c', '<C-e>', '<End>')     -- end of line
map('c', '<C-f>', '<Right>')   -- forward one character
map('c', '<C-b>', '<Left>')    -- back one character
map('c', '<C-d>', '<Del>')     -- delete character under cursor
map('c', '<M-b>', '<S-Left>')  -- back one word
map('c', '<M-f>', '<S-Right>') -- forward one word

-- move selected line/block down/up/right/left
map('v', 'J', ":m '>+1<CR>gv=gv")
map('v', 'K', ":m '<-2<CR>gv=gv")
map('v', '>', ">gv")
map('v', '<', "<gv")
