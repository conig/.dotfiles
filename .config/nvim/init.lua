vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.g.base46_cache = vim.fn.stdpath("data") .. "/base46/"
vim.opt.directory = os.getenv("HOME") .. "/.local/share/nvim/swap//"


-- bootstrap lazy and all plugins
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not vim.uv.fs_stat(lazypath) then
	local repo = "https://github.com/folke/lazy.nvim.git"
	vim.fn.system({ "git", "clone", "--filter=blob:none", repo, "--branch=stable", lazypath })
end

vim.opt.rtp:prepend(lazypath)

local lazy_config = require("configs.lazy")

-- load plugins
require("lazy").setup({
	{
		"NvChad/NvChad",
		lazy = false,
		branch = "v2.5",
		import = "nvchad.plugins",
	},
	{ import = "plugins" },
}, lazy_config)

-- load theme
dofile(vim.g.base46_cache .. "defaults")
dofile(vim.g.base46_cache .. "statusline")

require("options")
require("nvchad.autocmds")
require("start_goo")
require("autocommands")
require("tmux")

vim.schedule(function()
	require("mappings")
end)

vim.opt.spelllang = "en_au"
vim.g.python3_host_prog = vim.fn.expand("~/.venv/neovim/bin/python")
-- set up providers
vim.g.loaded_python3_provider = nil
-- If you also need other providers, you can do:
local enable_providers = {
  "python3_provider",
  "node_provider",
  -- add more if needed
}
for _, provider in ipairs(enable_providers) do
  vim.g["loaded_" .. provider] = nil
  vim.cmd("runtime " .. provider)
end

