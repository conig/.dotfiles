return {
  "epwalsh/obsidian.nvim",
  version = "*", -- recommended, use latest release instead of latest commit
  -- Replace the above line with this if you only want to load obsidian.nvim for markdown files in your vault:
  keys = {
    { "<leader>os", ":ObsidianSearch<CR>", desc = "Search for obsidian note" },
    { "<leader>oww", ":ObsidianWorkspace work<CR>", desc = "Open work workspace" },
    { "<leader>owp", ":ObsidianWorkspace personal<CR>", desc = "Open personal workspace" },
    { "<leader>on", ":ObsidianNew<CR>", desc = "New obsidian note" },
  },
  dependencies = {
    -- Required.
    "nvim-lua/plenary.nvim",
  },
  init = function()
    vim.opt.conceallevel = 2
  end,
  opts = {
    workspaces = {
      {
        name = "work",
        path = "~/.vaults/work",
      },
      {
        name = "personal",
        path = "~/.vaults/personal",
      },
    },
  },
}
