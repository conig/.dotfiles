return {
  {
    "MagicDuck/grug-far.nvim",
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      require("grug-far").setup {
        -- engine = "astgrep",
      }

      -- Keymap definitions for Find and Replace
      vim.keymap.set("n", "<leader>fr", function()
        require("grug-far").open()
      end, { desc = "Find and Replace" })

      vim.keymap.set("v", "<leader>fr", function()
        require("grug-far").with_visual_selection()
      end, { desc = "Find and Replace with Selection" })
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "grug-far",
        group = vim.api.nvim_create_augroup("GrugFarEnter", { clear = true }),
        callback = function()
          vim.keymap.set("i", "<CR>", function()
            vim.cmd("stopinsert") -- Exit insert mode
            vim.api.nvim_input "j" -- Move to the first result
            vim.api.nvim_input "i"
          end, { buffer = true })
        end,
      })
    end,
  },
}
