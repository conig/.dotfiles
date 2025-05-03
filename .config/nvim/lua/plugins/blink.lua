-- lua/plugins/blink.lua  (or whichever file you use for Blink)
return {
	{ import = "nvchad.blink.lazyspec" },
	{
		"Saghen/blink.cmp",
		opts = {
			signature = {
				enabled = false,
			},
			completion = {
				accept = { auto_brackets = { enabled = false } },
			},
		},
		config = function(_, opts)
			opts.enabled = function()
				local disabled_filetypes = { "NvimTree", "DressingInput" }
				return not vim.tbl_contains(disabled_filetypes, vim.bo.filetype)
			end
			require("blink.cmp").setup(opts)
		end,
	},
}
