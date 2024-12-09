return {
  "sindrets/diffview.nvim",
  event = "VeryLazy",
  config = function()
    require("diffview").setup {
      -- Keymap to toggle Diffview
      vim.keymap.set("n", "<leader>gd", function()
        local lib = require "diffview.lib"
        local view = lib.get_current_view()

        if view then
          -- If Diffview is already open, close it
          vim.cmd "DiffviewClose"
        else
          -- Otherwise, open it
          vim.cmd "DiffviewOpen"
        end
      end, { silent = true, noremap = true, desc = "Toggle Diffview" }),
      -- Define custom highlights for diff mode
    }
  end,
}
