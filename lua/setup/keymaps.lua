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
map('n', '<Leader>+', '<C-w>+')
map('n', '<Leader>-', '<C-w>-')
map('n', '<Leader>>', '<C-w>>')
map('n', '<Leader><', '<C-w><')

-- Buffer management
map('n', '<Leader><Leader>', '<C-^>')

-- mappings for quickfix list apart from tab
map('n', '<Leader>qn', ':cnext<CR>')
map('n', '<Leader>qp', ':cprev<CR>')
map('n', '<Leader>qf', ':cfirst<CR>')
map('n', '<Leader>ql', ':clast<CR>')
map('n', '<Leader>qc', ':cclose<CR>')
map('n', '<Leader>qo', ':copen<CR>')

-- mappings for location list apart from tab
map('n', '<Leader>ln', ':lnext<CR>')
map('n', '<Leader>lp', ':lprev<CR>')
map('n', '<Leader>lf', ':lfirst<CR>')
map('n', '<Leader>ll', ':llast<CR>')
map('n', '<Leader>lc', ':lclose<CR>')
map('n', '<Leader>lo', ':lopen<CR>')

-- command line editing
map('c', '<C-a>', '<Home>') -- start of line
map('c', '<C-e>', '<End>') -- end of line
map('c', '<C-f>', '<Right>') -- forward one character
map('c', '<C-b>', '<Left>') -- back one character
map('c', '<C-d>', '<Del>') -- delete character under cursor
map('c', '<A-b>', '<S-Left>') -- back one word
map('c', '<A-f>', '<S-Right>') -- forward one word

-- move selected line/block down/up/right/left
map('v', 'J', ":m '>+1<CR>gv=gv")
map('v', 'K', ":m '<-2<CR>gv=gv")
map('v', '>', ">gv")
map('v', '<', "<gv")
