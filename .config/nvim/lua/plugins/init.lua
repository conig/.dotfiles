return {
  {
    "stevearc/conform.nvim",
    event = {'BufWritePre', "BufNewFile"}, -- uncomment for format on save
    opts = require "configs.conform",
  },
  {
    "neovim/nvim-lspconfig",
    config = function()
      require "configs.lspconfig"
    end,
  },
}
