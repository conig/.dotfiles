-- File: ~/.config/nvim/lua/your_config/start_goo.lua

-- Initialize a global flag to track execution
_G.goo_started = false

-- Define the list of desired filetypes
local desired_filetypes = { "r", "rmd", "quarto", "qmd" }

-- Create an autocmd group to prevent duplicate autocmds
local group = vim.api.nvim_create_augroup("StartGooGroup", { clear = true })

-- Create an autocmd for the FileType event
vim.api.nvim_create_autocmd("FileType", {
  group = group,
  pattern = desired_filetypes,
  callback = function()
    local Scripts = require "nvim-slimetree"
    -- Check if Scripts.start_goo has already been executed
    if not _G.goo_started then
      -- Ensure Scripts.start_goo exists and is callable
      if type(Scripts) == "table" and type(Scripts.start_goo) == "function" then
        local R_norm = "clear && R"
        local R_radian = "clear && r"
        Scripts.start_goo { R_norm, R_norm, R_norm, R_radian}
        -- os.execute("sleep " .. tonumber(1))  -- Give it a moment to start
        Scripts.summon_goo(1)
        -- Set the flag to true to prevent future executions in this session
        _G.goo_started = true
        -- vim.notify("Scripts.start_goo(\"r\") executed successfully!", vim.log.levels.INFO)
      else
        vim.notify("Error: Scripts.start_goo function not found!", vim.log.levels.ERROR)
      end
    end
  end,
  desc = "Trigger Scripts.start_goo for R, Rmd, Quarto, and Qmd files once per session",
})

-- Create an autocmd for the VimLeave event to run end_goo when Neovim exits
vim.api.nvim_create_autocmd("VimLeavePre", {
  group = group,
  callback = function()
    local Scripts = require "nvim-slimetree"
    -- Check if goo was started
    if _G.goo_started then
      -- Ensure Scripts.end_goo exists and is callable
      if type(Scripts) == "table" and type(Scripts.end_goo) == "function" then
        Scripts.end_goo()
      else
      end
    end
  end,
  desc = "Trigger Scripts.end_goo when Neovim exits if goo session was started",
})
