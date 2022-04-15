-- FZF config
vim.cmd([[
    let $FZF_DEFAULT_COMMAND='rg --files --hidden'

    function! IsGitRepo()
        let root = system('git rev-parse --show-toplevel')
        return v:shell_error == 0
    endfunction

    " noremap <C-Space> :Files<CR>
    let s:gfiles_opts = ''
    noremap <expr> <C-Space> (IsGitRepo() ? ':GFiles --cached --others --exclude-standard<CR>' : ':Files<CR>')
]])
