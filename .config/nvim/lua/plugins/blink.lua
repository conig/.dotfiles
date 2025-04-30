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
	},
}
