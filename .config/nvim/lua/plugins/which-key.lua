return{
  {
  "folke/which-key.nvim",
  event = {"BufReadPre", "BufNewFile"},
  opts = {
     triggers = {"<leader>"},
  },
  keys = {
    {
      "<leader>?",
      function()
        require("which-key").show({ global = false })
      end,
      desc = "Buffer Local Keymaps (which-key)",
    },
  },
}
}
