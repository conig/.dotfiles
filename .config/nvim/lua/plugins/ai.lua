return {
  {
    "yetone/avante.nvim",
    event = { "BufReadPost", "BufNewFile" },
    build = "make",
    opts = {
      provider = "copilot",
      hints = { enabled = false },
      -- add any opts here
      copilot = {
        model = "claude-3.5-sonnet",
      },
    },
    dependencies = {
      "stevearc/dressing.nvim",
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      --- The below dependencies are optional,
      "nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
      "zbirenbaum/copilot.lua", -- for providers='copilot'
      {
        -- support for image pasting
        "HakonHarnes/img-clip.nvim",
        event = { "BufReadPost", "BufNewFile" },
        opts = {
          -- recommended settings
          default = {
            embed_image_as_base64 = false,
            prompt_for_file_name = false,
            drag_and_drop = {
              insert_mode = true,
            },
            -- required for Windows users
            use_absolute_path = true,
          },
        },
      },
    },
  },
  {
    "github/copilot.vim",
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      vim.g.copilot_no_tab_map = true
      vim.g.copilot_assume_mapped = true
      vim.g.copilot_tab_fallback = ""
      vim.api.nvim_set_keymap("i", "<C-a>", 'copilot#Accept("<Tab>")', { noremap = true, silent = true, expr = true })
    end,
  },
}
