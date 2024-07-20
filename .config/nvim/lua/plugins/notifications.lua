return {
  {
    "folke/noice.nvim",
    event = {"VeryLazy"},
    config = function()
      require("noice").setup {
        lsp = {
          -- override markdown rendering so that cmp and other plugins use Treesitter
          override = {
            ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
            ["vim.lsp.util.stylize_markdown"] = true,
            ["cmp.entry.get_documentation"] = true, -- requires hrsh7th/nvim-cmp
          },
          signature = {
            enabled = false,
          },
          hover = {
            enabled = false,
          },
        },
        views = {
          cmdline_popup = {
            border = {
              style = "rounded",
            },
          },
        },
        messages = {
          enabled = true,
          view = "mini",
          view_error = "mini",
          view_warn = "mini",
          view_info = "mini",
        },
        -- you can enable a preset for easier configuration
        presets = {
          bottom_search = true, -- use a classic bottom cmdline for search
          command_palette = false, -- position the cmdline and popupmenu together
          long_message_to_split = true, -- long messages will be sent to a split
          inc_rename = false, -- enables an input dialog for inc-rename.nvim
          lsp_doc_border = false, -- add a border to hover docs and signature help
        },
      }
    end,
    dependencies = {
      "MunifTanjim/nui.nvim",
      "rcarriga/nvim-notify", -- optional, for notification view
    },
  },
  {
    "rcarriga/nvim-notify",
    config = function()
      local notify = require "notify"
      vim.api.nvim_set_keymap("n", "<leader>fn", ":Telescope notify<CR>", { noremap = true, silent = true })
      notify.setup {
        style = "wrapped compact",
        stages = "static",
        max_width = 40,
        timeout = 4000,
      }
    end,
  },
}
