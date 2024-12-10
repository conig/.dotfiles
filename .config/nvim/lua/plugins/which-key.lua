return{
  {
  "folke/which-key.nvim",
  event = {"BufReadPre", "BufNewFile"},
  opts = {
     triggers = {
      { "<auto>", mode = { "n", "i", "o", "t", "c" } }, -- Exclude visual and select modes
    },
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
