return {
	{
  "folke/noice.nvim",
  event = { "BufReadPost", "BufNewFile" },
  keys = { ":" },
  opts = {
    lsp = {
      signature = {
        enabled = false,
      },
      -- overrides apply here too
      override = {
        ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
        ["vim.lsp.util.stylize_markdown"] = true,
        ["vim.lsp.buf.hover"] = true,
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
    presets = {
      bottom_search = true,
      command_palette = false,
      long_message_to_split = true,
      inc_rename = false,
      lsp_doc_border = false,
    },
  },
  dependencies = {
    "MunifTanjim/nui.nvim",
    "rcarriga/nvim-notify",
    "nvim-treesitter/nvim-treesitter",
  },
},
	{
		"rcarriga/nvim-notify",
		config = function()
			local notify = require("notify")
			vim.api.nvim_set_keymap("n", "<leader>fn", ":Telescope notify<CR>", { noremap = true, silent = true })
			notify.setup({
				style = "wrapped compact",
				stages = "static",
				max_width = 40,
				timeout = 4000,
			})
		end,
	},
}
