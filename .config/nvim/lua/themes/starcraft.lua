-- StarCraft Dark Pastel Theme for base46
-- Prioritises readability, reserves red strictly for errors,
-- and uses dark, muted pastel tones inspired by SC1 aesthetics.

-- ⚠️ DO NOT use raw hex codes in highlight definitions.
-- Always refer to M.base_30 for consistency, maintainability, and palette control.

local M = {}

M.base_30 = {
  -- Base Greys and Neutrals
  white           = "#CDD6D9",   -- Desaturated light blue-grey
  darker_black    = "#282a36",   -- Slightly warmer than SC1's #3C3C3C
  black           = "#2b2f3a",
  black2          = "#313542",
  one_bg          = "#343847",
  one_bg2         = "#3a3f4f",
  one_bg3         = "#404659",
  grey            = "#5e6472",
  grey_fg         = "#6c7380",
  grey_fg2        = "#7a8291",
  light_grey      = "#8891a2",

  -- Pastel Accents
  red             = "#F40404",   -- Reserved for errors only
  baby_pink       = "#b0889b",   -- Dusty rose
  pink            = "#FFC4E4",   -- Muted lilac
  green           = "#86b49c",   -- Pastel moss
  vibrant_green   = "#a4d6b7",   -- Pale mint
  nord_blue       = "#6c8ec1",   -- Muted steel blue
  blue            = "#0C48CC",   -- Soft Terran-blue UI
  yellow          = "#FCFC38",   -- Worn ochre
  sun             = "#e6dbb2",   -- Light parchment
  purple          = "#9e8fb2",   -- Soft muted purple
  dark_purple     = "#88409C",   -- Desaturated plum
  teal            = "#5db0a6",   -- Pastel Zerg‐y teal
  soft_orange     = "#c2976b",   -- Muted Terran‐soft_orange
  orange          = "#F88C14",
  cyan            = "#2CB494",   -- Soft cyan

  -- UI Specific
  statusline_bg   = "#2b2f3a",
  lightbg         = "#313542",
  pmenu_bg        = "#6dbfcc",  -- cyan
  folder_bg       = "#6c8ec1",
  line            = "#3b3f4a",

  -- Extended for base16
  lighter_white   = "#dee5e7",
  pure_white      = "#ffffff",
  rustic_brown    = "#a36e5f",
}

M.base_16 = {
  base00 = M.base_30.black,
  base01 = M.base_30.one_bg,
  base02 = M.base_30.one_bg2,
  base03 = M.base_30.one_bg3,
  base04 = M.base_30.grey,
  base05 = M.base_30.white,
  base06 = M.base_30.lighter_white,
  base07 = M.base_30.pure_white,
  base08 = M.base_30.red,          -- errors only
  base09 = M.base_30.soft_orange,
  base0A = M.base_30.sun,
  base0B = M.base_30.green,
  base0C = M.base_30.teal,
  base0D = M.base_30.nord_blue,
  base0E = M.base_30.purple,
  base0F = M.base_30.rustic_brown,
}

M.polish_hl = {
  treesitter = {
    ["@comment"]         = { fg = M.base_30.grey_fg, italic = true },
    ["@string"]          = { fg = M.base_30.white },
    ["@variable"]          = { fg = M.base_30.pink },
    ["@function.call"] = {fg = M.base_30.dark_purple},
    ["@number"]          = { fg = M.base_30.yellow },
    ["@keyword"]         = { fg = M.base_30.orange, italic = true },
    ["@keyword.function"]  = { fg = M.base_30.orange, italic = true },
    ["@constant"]        = { fg = M.base_30.baby_pink },
    ["@function"]        = { fg = M.base_30.cyan },
    ["@function.builtin"]= { fg = M.base_30.vibrant_green },
    ["@type"]            = { fg = M.base_30.dark_purple },
    ["@parameter"]       = { fg = M.base_30.baby_pink, italic = true },
    ["@operator"]        = { fg = M.base_30.yellow },
    ["@property"]        = { fg = M.base_30.pink },
    ["@tag"]             = { fg = M.base_30.teal },
    ["@attribute"]       = { fg = M.base_30.yellow },
    ["@namespace"]       = { fg = M.base_30.dark_purple },
    ["@character"]      = { fg = M.base_30.cyan },  -- << ADDED LINE
    ["Identifier"]     = { fg = M.base_30.cyan},
    ["@tag.attribute"] = { fg = M.base_30.teal },
    ["@function.macro"] = { fg = M.base_30.cyan},
    ["@variable.parameter"] = { fg = M.base_30.cyan},
    ["@variable.member"] = { fg = M.base_30.cyan},
    ["@module"] = {fg = M.base_30.white},
    ["@markup.raw"] = {fg = M.base_30.dark_purple},
  },

  lsp = {
    DiagnosticVirtualTextError = { fg = M.base_30.red },
    DiagnosticVirtualTextWarn  = { fg = M.base_30.yellow },
    DiagnosticVirtualTextInfo  = { fg = M.base_30.cyan },
    DiagnosticVirtualTextHint  = { fg = M.base_30.teal },
  },

  syntax = {
    Include = { fg = M.base_30.purple },
    Tag     = { fg = M.base_30.teal },
  },

  defaults = {
    IncSearch = { fg = M.base_30.black, bg = M.base_30.yellow, standout = true },
  }
}

M.type = "dark"

M = require("base46").override_theme(M, "StarCraft")

return M
