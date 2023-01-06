local path = vim.env['HOME'] .. "/git/dotfiles/nvim"
package.path = path .. "/?.lua;" .. package.path
require('init').setup({ path = path })
