return {
	{
		"nvim-telescope/telescope-bibtex.nvim",
		dependencies = { "nvim-telescope/telescope.nvim" },
		keys = {
			{ "<leader>kr", "<cmd>Telescope bibtex<CR>", desc = "Open Telescope bibtex", mode = "n" },
			{
				"<C-\\>",
				function()
					local keys = vim.api.nvim_replace_termcodes("<Esc>:Telescope bibtex<CR>", true, false, true)
					vim.api.nvim_feedkeys(keys, "n", false)
				end,
				desc = "Open Telescope bibtex",
				mode = "i",
			},
		},
		config = function()
			require("telescope").setup({
				extensions = {
					bibtex = {
						context = true,
            depth = 3,
						context_fallback = true,
					},
				},
			})
			require("telescope").load_extension("bibtex")
		end,
	},
}
