-- format with conform

vim.api.nvim_create_autocmd("BufWritePost", {
  pattern = { "*.lua", "*.R" },
  callback = function(args)
    require("conform").format { bufnr = args.buf }
  end,
})
