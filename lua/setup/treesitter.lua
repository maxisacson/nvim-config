local nts = require('nvim-treesitter')

-- list of parsers which name does to match the filetype
-- https://github.com/nvim-treesitter/nvim-treesitter/blob/master/lua/nvim-treesitter/parsers.lua
local parser_list = {
    automake = "make",
    javascriptreact = "javascript",
    ecma = "javascript",
    jsx = "javascript",
    gyp = "python",
    html_tags = "html",
    ["typescript.tsx"] = "tsx",
    ["terraform-vars"] = "terraform",
    ["html.handlebars"] = "glimmer",
    systemverilog = "verilog",
    dosini = "ini",
    confini = "ini",
    svg = "xml",
    xsd = "xml",
    xslt = "xml",
    expect = "tcl",
    mysql = "sql",
    sbt = "scala",
    neomuttrc = "muttrc",
    clientscript = "runescript",
    --- short-hand list from https://github.com/helix-editor/helix/blob/master/languages.toml
    rs = "rust",
    ex = "elixir",
    js = "javascript",
    ts = "typescript",
    ["c-sharp"] = "csharp",
    hs = "haskell",
    py = "python",
    erl = "erlang",
    typ = "typst",
    pl = "perl",
    uxn = "uxntal",
}

for ft, lang in pairs(parser_list) do
    vim.treesitter.language.register(lang, ft)
end

local ignore_lang = {
    'c', 'lua', 'markdown', 'markdown_inline', 'query', 'vim', 'vimdoc'
}

local filetypes = vim.iter(vim.tbl_map(
        function(lang)
            if vim.tbl_contains(ignore_lang, lang) then
                return nil
            end
            return vim.treesitter.language.get_filetypes(lang)
        end, nts.get_available())
    ):flatten():totable()

vim.api.nvim_create_autocmd('FileType', {
    pattern = filetypes,
    group = vim.api.nvim_create_augroup('TreesitterSetup', { clear = true }),
    callback = function(ev)
        local ft = ev.match
        local lang = vim.treesitter.language.get_lang(ft)

        local installed = nts.get_installed()
        if not vim.tbl_contains(installed, lang) then
            nts.install(lang):wait(300000)
        end

        vim.treesitter.start()
        vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
    end
})
