return {
	{
		"ThePrimeagen/harpoon",
		branch = "harpoon2",
		dependencies = { "nvim-lua/plenary.nvim" },
		lazy = true,
		keys = {
			{
				"<C-e>",
				function()
					local harpoon = require("harpoon")
					harpoon.ui:toggle_quick_menu(harpoon:list())
				end,
				desc = "Toggle Harpoon quick menu",
			},
			{
				"<leader>aj",
				function()
					local harpoon = require("harpoon")
					harpoon:list():add()
				end,
				desc = "Add file to Harpoon list",
			},
			{
				"<leader>fj",
				function()
					local bufnr = vim.api.nvim_get_current_buf()

					local function open_harpoon_telescope()
						local harpoon = require("harpoon")
						local conf = require("telescope.config").values
						local file_paths = {}

						for _, item in ipairs(harpoon:list().items) do
							table.insert(file_paths, item.value)
						end

						require("telescope.pickers")
							.new({}, {
								prompt_title = "Harpoon",
								finder = require("telescope.finders").new_table({
									results = file_paths,
								}),
								previewer = conf.file_previewer({}),
								sorter = conf.generic_sorter({}),
							})
							:find()
					end

					if vim.api.nvim_buf_is_loaded(bufnr) then
						open_harpoon_telescope()
					else
						vim.api.nvim_create_autocmd("BufReadPost", {
							buffer = bufnr,
							once = true,
							callback = open_harpoon_telescope,
						})
					end
				end,
				desc = "Open Harpoon in Telescope",
			},
		},
		config = function()
			local harpoon = require("harpoon")
			harpoon.setup()
		end,
	},
}
