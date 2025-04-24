return {

	{
		"crispgm/telescope-heading.nvim",
		dependencies = { "nvim-telescope/telescope.nvim", "nvim-treesitter/nvim-treesitter" },
		keys = {
			{
				"<leader>fhh",
				function()
					require("telescope").extensions.heading.heading()
				end,
				desc = "Find Heading",
				mode = "n",
			},
		},
config = function()
  -- Alias the 'rmd' formatter to the markdown one
  package.loaded["telescope._extensions.heading.format.rmd"] =
      require("telescope._extensions.heading.format.markdown")

  local telescope = require('telescope')
  telescope.setup({
    extensions = {
      heading = { treesitter = true },
    },
  })
  telescope.load_extension('heading')
end,
	},
}
