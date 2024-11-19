return {
  {
    "kylechui/nvim-surround",
    version = "*",
    event = { "BufRead", "BufNewFile" },
    opts = {
      keymaps = {
        visual = "x",
        visual_line = "X",
      },
    },
  },
}
