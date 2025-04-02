return{
  {
  "folke/which-key.nvim",
  event = {"BufReadPre", "BufNewFile"},
  opts = {
     triggers = {"<leader>"},
     delay=1000
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
