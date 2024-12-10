-- This file needs to have same ktructure as nvconfig.lua
-- https://github.com/NvChad/ui/blob/v2.5/lua/nvconfig.lua

local M = {}

M.base46 = {
  theme = "solarized_osaka",
  transparency = true,
  hl_override = {
    DiffDelete = {
      bg = "dark_purple",
      fg = "white",
    },
  },
}
M.nvdash = {
  load_on_startup = true,
  header = {
    "░░░░░░░░░░░░░░▄▌░░░",
    "░░░░░░░▄▄▄░░▄██▄░░░",
    "░░░░░░▐▀█▀▌░░░░▀█▄░",
    "░░░░░░▐█▄█▌░░░░░░▀█",
    "░░░░░░░▀▄▀░░░▄▄▄▄▄▀",
    "░░░░░▄▄▄██▀▀▀▀░░░░░",
    "░░░░█▀▄▄▄█░▀▀░░░░░░",
    "░░░░▌░▄▄▄▐▌▀▀▀░░░░░",
    "░▄░▐░░░▄▄░█░▀▀░░░░░",
    "░▀█▌░░░▄░▀█▀░▀░░░░░",
    "░░░░░░░░▄▄▐▌▄▄░░░░░",
    "░░░░░░░░▀███▀█░▄░░░",
    "░░░░░░░▐▌▀▄▀▄▀▐▄░░░",
    "░░░░░░░▐▀░░░░░░▐▌░░",
    "░░░░░░░█░░░░░░░░█░░",
    "░░░░░░▐▌░░░░░░░░░█░",
    "                   ",
    "",
    "",
  },
}
M.telescope = {
  style = "bordered",
}

M.ui = {
  tabufline = {
    enabled = true,
  },
  statusline = {
    theme = "minimal", -- default/vscode/vscode_colored/minimal,
    separator_style = "block", -- block/arrow/round/
    order = nil,
    modules = nil,
  },
  cmp = {
    style = "atom",
  },
  -- hl_override = {
  -- 	Comment = { italic = true },
  -- 	["@comment"] = { italic = true },
  -- },
}

return M
