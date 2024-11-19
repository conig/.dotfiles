local options = {
  formatters_by_ft = {
    lua = { "stylua" },
    r = { "lsp" },
    rmd = {"lsp"},
    qmd = {"lsp"},
  },
  async = true,
}

return options
