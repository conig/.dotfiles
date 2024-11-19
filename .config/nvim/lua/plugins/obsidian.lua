return {
  "epwalsh/obsidian.nvim",
  version = "*",
  keys = {
    { "<leader>os", ":ObsidianSearch<CR>", desc = "Search for obsidian note" },
    { "<leader>oww", ":ObsidianWorkspace work<CR>", desc = "Open work workspace" },
    { "<leader>owp", ":ObsidianWorkspace personal<CR>", desc = "Open personal workspace" },
    { "<leader>on", ":ObsidianNew<CR>", desc = "New obsidian note" },
    {"<leader>ot", ":ObsidianTags<CR>", desc = "List tags in obsidian notes"},
  },
  dependencies = {
    -- Required.
    "nvim-lua/plenary.nvim",
  },
  init = function()
    vim.opt.conceallevel = 1
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
    follow_url_func = function(url)
      vim.fn.jobstart({ "wslview", url })
    end,
  },
}
