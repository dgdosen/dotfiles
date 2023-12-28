vim.api.nvim_create_autocmd({"BufRead", "BufNewFile"}, {
    pattern = ".pryrc",
    command = "set filetype=ruby"
})
