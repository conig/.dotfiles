return {
  "epwalsh/obsidian.nvim",
  version = "*",
  keys = {
    { "<leader>os", ":ObsidianSearch<CR>", desc = "Search for obsidian note" },
    { "<leader>oww", ":ObsidianWorkspace work<CR>", desc = "Open work workspace" },
    { "<leader>owp", ":ObsidianWorkspace personal<CR>", desc = "Open personal workspace" },
    { "<leader>on", ":ObsidianNew<CR>", desc = "New obsidian note" },
    { "<leader>ot", ":ObsidianTags<CR>", desc = "List tags in obsidian notes" },
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
      vim.fn.jobstart({ "open", url })
    end,
    note_id_func = function(title)
      -- Create note IDs in a Zettelkasten format with a timestamp and a suffix.
      -- In this case a note with the title 'My new note' will be given an ID that looks
      -- like '1657296016-my-new-note', and therefore the file name '1657296016-my-new-note.md'
      local suffix = ""
      if title ~= nil then
        -- If title is given, transform it into valid file name.
        suffix = title:gsub(" ", "-"):gsub("[^A-Za-z0-9-]", ""):lower()
      else
        -- If title is nil, just add 4 random uppercase letters to the suffix.
        for _ = 1, 4 do
          suffix = suffix .. string.char(math.random(65, 90))
        end
      end
      return tostring(os.time()) .. "-" .. suffix
    end,
  },
}
