---@type vim.lsp.Config
return {
    cmd = { "clangd",
        "--background-index",
        "--compile-commands-dir=build",
        "--clang-tidy",
        "--clang-tidy-checks='" ..
        "-*," ..
        "clang-analyzer-*," ..
        "modernize-*," ..
        "readability-*," ..
        "performance-*," ..
        "cppcoreguidelines-*," ..
        "bugprone-*," ..
        "cert-*," ..
        "hicpp-*," ..
        "-cppcoreguidelines-pro-bounds-constant-array-index," ..
        "-cppcoreguidelines-pro-bounds-array-to-pointer-decay," ..
        "-cppcoreguidelines-avoid-magic-numbers," ..
        "-readability-braces-around-statements," ..
        "-readability-magic-numbers," ..
        "-hicpp-braces-around-statements," ..
        "-hicpp-no-array-decay," ..
        "-hicpp-uppercase-literal-suffix," ..
        "-readability-uppercase-literal-suffix," ..
        "-modernize-use-trailing-return-type," ..
        "'" }
}
