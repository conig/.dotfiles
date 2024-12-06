return {
  "conig/nvim-target-target",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-telescope/telescope.nvim",
  },
  lazy = true,
  event = "BufReadPre _targets.[rR]",
  dev = true,
  dir = "~/repos/nvim-target-target/",
  keys = {
    {
      "<leader>tta", -- Keybinding for acquiring a target
      function()
        require("target_target").acquire_target()
      end,
      desc = "Acquire Target (target-target)",
    },
    {
      "<leader>ttn", -- Keybinding for getting the active name
      function()
        local active_name = require("target_target").get_active_name()
        if active_name then
          vim.notify("Active Target: " .. active_name, vim.log.levels.INFO)
        else
          vim.notify("No active target set.", vim.log.levels.WARN)
        end
      end,
      desc = "Get Active Target Name (target-target)",
    },
  },
}
