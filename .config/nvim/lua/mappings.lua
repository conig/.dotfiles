require("nvchad.mappings")

local map = vim.keymap.set

map("i", "jk", "<ESC>")
-- R mappings
-- Insert brower()
map(
	"n",
	"<leader>rb",
	[[:call append(line('.') - 1, 'browser()')<CR>]],
	{ noremap = true, silent = true, desc = "insert browser()" }
)
-- open files
vim.keymap.set("n", "<leader>nn", function()
	vim.fn.jobstart({ vim.o.shell, "-c", "open ." }, { detach = true })
end, { desc = "Open files in the current working directory" })

vim.keymap.set("n", "<leader>rP", function()
	vim.fn.jobstart({ vim.o.shell, "-c", "feh ./.last_Rplot.png" }, { detach = true })
end, { desc = "Open last plot with gthumb" })
--  leader l triggers lazy sync
vim.keymap.set("n", "<leader>ls", function()
	-- First, run Lazy sync
	vim.cmd("Lazy sync")
	-- Then, open lazygit
end, { desc = "Lazy sync" })

-- Remove browser()
map(
	"n",
	"<leader>rB",
	[[:g/^\s*browser()$/d<CR>:noh<CR>]],
	{ noremap = true, silent = true, desc = "remove browser()" }
)
function ZoomTmuxPane()
	local tmux_zoom_command = "tmux resize-pane -Z"
	os.execute(tmux_zoom_command)
end
vim.api.nvim_set_keymap("n", "<Tab>", ":lua ZoomTmuxPane()<CR>", { noremap = true, silent = true })
-- Allow tmux swithing in neovim
vim.api.nvim_create_user_command("TmuxSwitch", function()
	vim.cmd("new") -- open a new split for the terminal
	local buf = vim.api.nvim_get_current_buf() -- capture the terminal buffer number

	local opts = {
		on_exit = function(_, exit_code, _)
			vim.schedule(function()
				if vim.api.nvim_buf_is_valid(buf) then
					vim.api.nvim_buf_delete(buf, { force = true })
				end
			end)
		end,
	}
	vim.fn.termopen("zsh -ic 'tmux_switch_or_cd'", opts)
	vim.cmd("startinsert") -- automatically enter insert mode
end, {})

vim.keymap.set("n", "<leader>jj", function()
	vim.cmd("execute 'TmuxSwitch'")
end, { noremap = true, silent = true })

-- map left and right arrow keys to bnext and bprev
map("n", "<Left>", ":bprev<CR>", { noremap = true, silent = true })
map("n", "<Right>", ":bnext<CR>", { noremap = true, silent = true })
map("n", "<M-h>", ":bprev<CR>", { noremap = true, silent = true })
map("n", "<M-l>", ":bnext<CR>", { noremap = true, silent = true })
-- James's mappings
map(
	"n",
	"<leader>cp",
	':lua require("minty.huefy").open()<CR>',
	{ noremap = true, silent = true, desc = "colour picker" }
)
map(
	"n",
	"<leader>cps",
	':lua require("minty.shades").open()<CR>',
	{ noremap = true, silent = true, desc = "colour picker shades" }
)
map("n", "<leader>v", "<cmd> vsplit <cr>")
--
vim.api.nvim_set_keymap(
	"n",
	"<leader>we",
	":silent !thunar . &<CR>",
	{ noremap = true, silent = true, desc = "Open Files Explorer" }
)

-- Toggle completions
vim.api.nvim_set_keymap("n", "<leader>tc", "", {
	noremap = true,
	callback = function()
		vim.b.cmp_enabled = not vim.b.cmp_enabled
		require("cmp").setup.buffer({ enabled = vim.b.cmp_enabled })
	end,
})

-- Disable the command-line window mappings
vim.api.nvim_set_keymap("n", "q:", "<Nop>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "q/", "<Nop>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "q?", "<Nop>", { noremap = true, silent = true })
vim.keymap.del("n", "<leader>h") -- Unmaps <leader>e in normal mode

-- Substitute periods with period + newline
vim.keymap.set("n", "<leader>s.", function()
	local start_line = vim.fn.search("^$", "bnW")
	local end_line = vim.fn.search("^$", "nW")
	if start_line == 0 then
		start_line = 1
	end
	if end_line == 0 then
		end_line = vim.fn.line("$")
	end

	-- Safely attempt substitution
	local ok = pcall(function()
		vim.cmd(string.format("silent! %d,%ds/\\.\\s/\\.\\r/g", start_line, end_line))
	end)

	-- Clear highlights regardless
	vim.cmd("nohlsearch")

	-- Notify quietly if failed
	if not ok then
		vim.notify("Pattern not found.", vim.log.levels.INFO)
	end
end, { noremap = true, silent = true })

-- Substitute commas with comma + newline
vim.keymap.set("n", "<leader>s,", function()
	local start_line = vim.fn.search("^$", "bnW")
	local end_line = vim.fn.search("^$", "nW")
	if start_line == 0 then
		start_line = 1
	end
	if end_line == 0 then
		end_line = vim.fn.line("$")
	end

	-- Safely attempt substitution: comma followed by space → newline
	local ok = pcall(function()
		vim.cmd(string.format("silent! %d,%ds/,\\s/,\\r/g", start_line, end_line))
	end)

	vim.cmd("nohlsearch")

	if not ok then
		vim.notify("Pattern not found.", vim.log.levels.INFO)
	end
end, { noremap = true, silent = true })

-- Helper function to map paste commands to a specific register
local function map_paste(mode, keys, register, command)
	vim.api.nvim_set_keymap(mode, keys, '"' .. register .. command, { noremap = true, silent = true })
end

-- Disable ctrl+z
vim.api.nvim_set_keymap("n", "<C-z>", "<NOP>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("v", "<C-z>", "<NOP>", { noremap = true, silent = true })
-- vim.api.nvim_set_keymap("i", "<C-z>", "<NOP>", { noremap = true, silent = true })

-- Map YY to yank whole file
vim.api.nvim_set_keymap("n", "YY", ":%y<CR>", { noremap = true, silent = true })
-- make yank use the system clipboard
vim.api.nvim_set_keymap("n", "y", '"+y', { noremap = true, silent = true })
vim.api.nvim_set_keymap("v", "y", '"+y', { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "Y", '"+Y', { noremap = true, silent = true })

-- Prioritise visual line movement as default
-- Normal mode mappings
vim.api.nvim_set_keymap("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "gj", "j", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "gk", "k", { noremap = true, silent = true })
-- Visual mode mappings
vim.api.nvim_set_keymap("v", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, noremap = true, silent = true })
vim.api.nvim_set_keymap("v", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, noremap = true, silent = true })
vim.api.nvim_set_keymap("v", "gj", "j", { noremap = true, silent = true })
vim.api.nvim_set_keymap("v", "gk", "k", { noremap = true, silent = true })

-- Insert mode mappings for arrow keys
vim.api.nvim_set_keymap("i", "<Up>", "<C-o>gk", { noremap = true, silent = true })
vim.api.nvim_set_keymap("i", "<Down>", "<C-o>gj", { noremap = true, silent = true })

vim.api.nvim_set_keymap("n", "<Up>", "gk", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<Down>", "gj", { noremap = true, silent = true })

vim.api.nvim_set_keymap("n", "<leader>aa", ":AvanteAsk<CR>i", { noremap = true, silent = true })
vim.api.nvim_set_keymap(
	"n",
	"<leader>ci",
	":set spell!<CR>",
	{ noremap = true, silent = true, desc = "Toggle spell checking" }
)

vim.api.nvim_set_keymap("n", "<A-k>", ":m .-2<CR>==", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<A-j>", ":m .+1<CR>==", { noremap = true, silent = true })
vim.api.nvim_set_keymap("v", "<A-k>", ":m '<-2<CR>gv=gv", { noremap = true, silent = true })
vim.api.nvim_set_keymap("v", "<A-j>", ":m '>+1<CR>gv=gv", { noremap = true, silent = true })

-- In your Neovim configuration file (e.g., init.lua or init.vim)
vim.keymap.set("n", "<leader>cf", function()
	-- Use Tree-sitter to select the current node (expression)
	local ts_utils = require("nvim-treesitter.ts_utils")
	local node = ts_utils.get_node_at_cursor()

	if not node then
		return
	end

	-- Get the range of the node
	local start_row, start_col, end_row, end_col = node:range()

	-- Format the selected range
	require("conform").format({
		range = {
			start = { start_row + 1, start_col }, -- Start line and column (1-based index)
			["end"] = { end_row + 1, end_col }, -- End line and column (1-based index)
		},
	})
end, { noremap = true, silent = true, desc = "Format current node" })

vim.keymap.set("n", "<leader>cF", function()
	-- Format the whole file
	require("conform").format({
		bufnr = 0,
	})
end, { noremap = true, silent = true, desc = "Format whole file" })

vim.api.nvim_set_keymap("i", "<c-p>", "<C-o>a|>", { noremap = true, silent = true })

-- R mappings
vim.keymap.set("n", "<leader>\\", "A |> <Cr>", { desc = "Append '|>' and return to normal mode" })
