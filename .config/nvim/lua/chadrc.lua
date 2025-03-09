-- This file needs to have same saructure as nvconfig.luachar
-- https://github.com/NvChad/ui/blob/v2.5/lua/nvconfig.lua

local M = {}

M.base46 = {
  theme = "everforest",
  transparency = true,
  hl_override = {
    DiffDelete = {
      -- bg = "dark_purple",
      -- fg = "white",
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
    order = { "treeOffset", "buffers", "tabs" },
  },
  statusline = {
    enabled = true,
    theme = "vscode_colored", -- default/vscode/vscode_colored/minimal,
    separator_style = "block", -- block/arrow/round/
    order = { "mode", "file", "git", "%=", "lsp_msg", "%=", "diagnostics", "cursor", "cwd" },
    modules = {
      encoding = function()
        local function gen_block(icon, txt, sep_l_hlgroup, iconHl_group, txt_hl_group)
          return sep_l_hlgroup .. iconHl_group .. icon .. " " .. txt_hl_group .. txt
        end
        local encoding = vim.trim(vim.bo.fileencoding)
        -- If 'fileencoding' is not set, fallback to 'encoding' (default)
        if encoding == "" then
          encoding = vim.o.encoding
        end
        encoding = vim.trim(encoding):upper()
        return gen_block("", encoding, "%#grey#", " ", "%#pink#")
      end,
    },
  },
  cmp = {
    style = "atom",
  },
  hl_override = {},
}

return M
