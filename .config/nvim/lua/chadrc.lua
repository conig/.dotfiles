-- This file needs to have same structure as nvconfig.lua
-- https://github.com/NvChad/ui/blob/v2.5/lua/nvconfig.lua

local M = {}

M.base46 = {
  theme = "gruvchad",
  transparency = false,
  hl_override = {
    DiffAdd = {
      --   bg = "#4c4c4c",
      fg = "pink",
    },
    DiffChange = {
      --   bg = "one_bg2",
      fg = "blue",
    },
    DiffDelete = {
      --   bg = "one_bg3",
      fg = "cyan",
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

--   header = {
--       "                                   ",
--       "                           conig.jh",
--       "   ⣴⣶⣤⡤⠦⣤⣀⣤⠆     ⣈⣭⣿⣶⣿⣦⣼⣆          ",
--       "    ⠉⠻⢿⣿⠿⣿⣿⣶⣦⠤⠄⡠⢾⣿⣿⡿⠋⠉⠉⠻⣿⣿⡛⣦       ",
--       "          ⠈⢿⣿⣟⠦ ⣾⣿⣿⣷    ⠻⠿⢿⣿⣧⣄     ",
--       "           ⣸⣿⣿⢧ ⢻⠻⣿⣿⣷⣄⣀⠄⠢⣀⡀⠈⠙⠿⠄    ",
--       "          ⢠⣿⣿⣿⠈    ⣻⣿⣿⣿⣿⣿⣿⣿⣛⣳⣤⣀⣀   ",
--       "   ⢠⣧⣶⣥⡤⢄ ⣸⣿⣿⠘  ⢀⣴⣿⣿⡿⠛⣿⣿⣧⠈⢿⠿⠟⠛⠻⠿⠄  ",
--       "  ⣰⣿⣿⠛⠻⣿⣿⡦⢹⣿⣷   ⢊⣿⣿⡏  ⢸⣿⣿⡇ ⢀⣠⣄⣾⠄   ",
--       " ⣠⣿⠿⠛ ⢀⣿⣿⣷⠘⢿⣿⣦⡀ ⢸⢿⣿⣿⣄ ⣸⣿⣿⡇⣪⣿⡿⠿⣿⣷⡄  ",
--       " ⠙⠃   ⣼⣿⡟  ⠈⠻⣿⣿⣦⣌⡇⠻⣿⣿⣷⣿⣿⣿ ⣿⣿⡇ ⠛⠻⢷⣄ ",
--       "      ⢻⣿⣿⣄   ⠈⠻⣿⣿⣿⣷⣿⣿⣿⣿⣿⡟ ⠫⢿⣿⡆     ",
--       "       ⠻⣿⣿⣿⣿⣶⣶⣾⣿⣿⣿⣿⣿⣿⣿⣿⡟⢀⣀⣤⣾⡿⠃     ",
--       "                                   ",
--   }
}
--
M.ui = {
  telescope = {style = "bordered"},
  tabufline = {
    enabled = true,
  },
  statusline = {
    theme = "default", -- default/vscode/vscode_colored/minimal,
    separator_style = "round",
    order = nil,
    modules = nil,
  },

  -- hl_override = {
  -- 	Comment = { italic = true },
  -- 	["@comment"] = { italic = true },
  -- },
}

return M
