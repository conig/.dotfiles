require "nvchad.mappings"

local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")
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
  ":silent !explorer.exe .<CR>",
  { noremap = true, silent = true, desc = "Open Windows Explorer" }
)

-- Toggle completions
vim.api.nvim_set_keymap("n", "<leader>tc", "", {
  noremap = true,
  callback = function()
    vim.b.cmp_enabled = not vim.b.cmp_enabled
    require("cmp").setup.buffer { enabled = vim.b.cmp_enabled }
  end,
})

-- disable cmdwin
-- Disable the command-line window mappings
vim.api.nvim_set_keymap("n", "q:", "<Nop>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "q/", "<Nop>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "q?", "<Nop>", { noremap = true, silent = true })

-- Substitute periods with period + newline
vim.keymap.set("n", "<leader>s.", function()
  local start_line = vim.fn.search("^$", "bnW")
  local end_line = vim.fn.search("^$", "nW")
  if start_line == 0 then
    start_line = 1
  end
  if end_line == 0 then
    end_line = vim.fn.line "$"
  end
  vim.cmd(string.format("%d,%ds/\\.\\s\\?/\\.\\r/g", start_line, end_line))
end, { noremap = true, silent = true })

-- Substitute commas with comma + newline
vim.keymap.set("n", "<leader>s,", function()
  local start_line = vim.fn.search("^$", "bnW")
  local end_line = vim.fn.search("^$", "nW")
  if start_line == 0 then
    start_line = 1
  end
  if end_line == 0 then
    end_line = vim.fn.line "$"
  end
  vim.cmd(string.format("%d,%ds/,\\s\\?/,\\r/g", start_line, end_line))
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

-- Normal mode mappings
vim.api.nvim_set_keymap("n", "j", "gj", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "k", "gk", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "gj", "j", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "gk", "k", { noremap = true, silent = true })
-- Visual mode mappings
vim.api.nvim_set_keymap("v", "j", "gj", { noremap = true, silent = true })
vim.api.nvim_set_keymap("v", "k", "gk", { noremap = true, silent = true })
vim.api.nvim_set_keymap("v", "gj", "j", { noremap = true, silent = true })
vim.api.nvim_set_keymap("v", "gk", "k", { noremap = true, silent = true })

-- Insert mode mappings for arrow keys
vim.api.nvim_set_keymap("i", "<Up>", "<C-o>gk", { noremap = true, silent = true })
vim.api.nvim_set_keymap("i", "<Down>", "<C-o>gj", { noremap = true, silent = true })

vim.api.nvim_set_keymap("n", "<Up>", "gk", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<Down>", "gj", { noremap = true, silent = true })

vim.api.nvim_set_keymap("n", "<leader>fg", ":Telescope live_grep<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<leader>fb", ":Telescope buffers<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<leader>fh", ":Telescope help_tags<CR>", { noremap = true, silent = true })
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
  local ts_utils = require "nvim-treesitter.ts_utils"
  local node = ts_utils.get_node_at_cursor()

  if not node then
    return
  end

  -- Get the range of the node
  local start_row, start_col, end_row, end_col = node:range()

  -- Format the selected range
  require("conform").format {
    range = {
      start = { start_row + 1, start_col }, -- Start line and column (1-based index)
      ["end"] = { end_row + 1, end_col }, -- End line and column (1-based index)
    },
  }
end, { noremap = true, silent = true, desc = "Format current node" })

vim.keymap.set("n", "<leader>cF", function()
  -- Format the whole file
  require("conform").format {
    bufnr = 0,
  }
end, { noremap = true, silent = true, desc = "Format whole file" })

-- Require Harpoon
local harpoon = require "harpoon"

-- Initialize Harpoon with default settings
harpoon.setup()

-- basic telescope configuration
local conf = require("telescope.config").values
local function toggle_telescope(harpoon_files)
  local file_paths = {}
  for _, item in ipairs(harpoon_files.items) do
    table.insert(file_paths, item.value)
  end

  require("telescope.pickers")
    .new({}, {
      prompt_title = "Harpoon",
      finder = require("telescope.finders").new_table {
        results = file_paths,
      },
      previewer = conf.file_previewer {},
      sorter = conf.generic_sorter {},
    })
    :find()
end

-- Define key mappings

vim.keymap.set("n", "<C-e>", function()
  harpoon.ui:toggle_quick_menu(harpoon:list())
end)

vim.keymap.set("n", "<leader>aj", function()
  harpoon:list():add()
end, { desc = "Harpoon" })

vim.keymap.set("n", "<leader>fj", function()
  toggle_telescope(harpoon:list())
end, { desc = "Open harpoon window" })

vim.api.nvim_set_keymap("i", "<c-p>", "<C-o>a|>", { noremap = true, silent = true })
