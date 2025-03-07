require "nvchad.options"
vim.treesitter.language.register("markdown", "qmd")
vim.treesitter.language.register("markdown", "txt")
vim.treesitter.language.register("bash", "zsh")
vim.treesitter.language.register("markdown", "rmd")
-- add yours here!

local o = vim.o
o.cursorlineopt = "both" -- to enable cursorline!
vim.opt.relativenumber = true
-- -- toggle relative line numbers
vim.api.nvim_set_keymap("n", "\\", ":set relativenumber!<CR>", { noremap = true, silent = true })

-- Set default tab spacing
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "r", "R", "rmd", "Rmd", "qmd", "Qmd" },
  callback = function()
    vim.opt_local.tabstop = 2
    vim.opt_local.shiftwidth = 2
    vim.opt_local.expandtab = true
  end,
})

-- Disable swap & backup to prevent disk I/O lag
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.writebackup = false

-- general options
vim.opt.relativenumber = true
vim.opt.showcmd = false
vim.opt.cmdheight = 0
-- Automatically convert DOS line endings to Unix on save
local group = vim.api.nvim_create_augroup("ConvertDosToUnix", { clear = true })
-- Define the autocmd
vim.api.nvim_create_autocmd("BufWritePre", {
  group = group,
  pattern = "*",
  callback = function()
    -- Step 1: If the entire file is in DOS format, switch to Unix
    if vim.bo.fileformat == "dos" then
      vim.bo.fileformat = "unix"
    end

    -- Step 2: Check if any \r characters exist in the buffer
    -- The 'n' flag prevents the search from moving the cursor
    -- The 'w' flag prevents wrapping around the file
    local has_cr = vim.fn.search("\r", "nw") ~= 0

    -- Step 3: If \r is found, perform the substitution
    if has_cr then
      -- Execute the substitution to remove all \r characters
      vim.cmd [[%s/\r//g]]
    end
  end,
})

