return {
	{
		"hrsh7th/nvim-cmp",
		lazy = true,
		event = { "BufReadPost", "BufNewFile" },
    enabled = true,
		dependencies = {
			{ "hrsh7th/cmp-nvim-lsp", after = "nvim-cmp" }, -- LSP completion source
			{ "hrsh7th/cmp-path", after = "nvim-cmp" }, -- Path completion source
			{ "hrsh7th/cmp-cmdline", after = "nvim-cmp" },
			-- Add other sources if needed
		},
		config = function()
			local cmp = require("cmp")

			-- Default setup for all filetypes
			cmp.setup({
        performance = {
          max_view_entries = 5,
          debounce = 1000,
          throttle = 400,
          fetching_timeout = 100,
        },
        matching = {
          disallow_fuzzy_matching = true,
          disallow_fullfuzzy_matching = true,
          disallow_partial_fuzzy_matching = true,
          disallow_partial_matching = false,
          disallow_prefix_unmatching = true,
        },
				sources = {
					{ name = "nvim_lsp" },
					{ name = "path" },
					{ name = "cmdline" },
					-- Include other sources here
				},
				mapping = {
					["<C-p>"] = cmp.mapping.select_prev_item(),
					["<C-n>"] = cmp.mapping.select_next_item(),
					["<C-d>"] = cmp.mapping.scroll_docs(-4),
					["<C-f>"] = cmp.mapping.scroll_docs(4),
					["<C-Space>"] = cmp.mapping.complete(),
					["<C-e>"] = cmp.mapping.close(),

					["<CR>"] = cmp.mapping.confirm({
						behavior = cmp.ConfirmBehavior.Insert,
						select = true,
					}),
					["<Tab>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_next_item()
						elseif require("luasnip").expand_or_jumpable() then
							require("luasnip").expand_or_jump()
						else
							fallback()
						end
					end, { "i", "s" }),

					["<S-Tab>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_prev_item()
						elseif require("luasnip").jumpable(-1) then
							require("luasnip").jump(-1)
						else
							fallback()
						end
					end, { "i", "s" }),
				},
			})
			-- Override setup for specific filetypes
			cmp.setup.filetype({ "rmd", "markdown", "r", "quarto" }, {
				sources = {
					{
						name = "nvim_lsp",
						entry_filter = function(entry)
							local client_name = entry.source.source.client.name
							return client_name == "r_language_server"
						end,
					},
					{ name = "path" },
					{ name = "cmdline" },
				},
			})

			-- Command-line completion setup
			cmp.setup.cmdline({ "/", "?" }, {
				mapping = cmp.mapping.preset.cmdline(),
				sources = {
					{ name = "buffer" },
				},
			})

			cmp.setup.cmdline(":", {
				mapping = cmp.mapping.preset.cmdline(),
				sources = cmp.config.sources({
					{ name = "path" },
				}, {
					{
						name = "cmdline",
						option = {
							ignore_cmds = { "Man", "!" },
						},
					},
				}),
			})
		end,
	},
}
