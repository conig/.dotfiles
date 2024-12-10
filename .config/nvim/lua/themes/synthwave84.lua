-- Credits to original SynthWave84 theme
-- Converted to Base46 format without alpha channels

---@type Base46Table
local M = {}

-- Base30: Primary and Accent Colors
M.base_30 = {
  -- Primary Colors
  white = "#ffffff",
  darker_black = "#1f212b",
  black = "#262335",
  black2 = "#241b2f",
  one_bg = "#2a2139",
  one_bg2 = "#232530",
  one_bg3 = "#34294f",
  grey = "#495495",
  grey_fg = "#47585E",
  grey_fg2 = "#4F6369",
  light_grey = "#586E75",

  -- Accent Colors
  red = "#fe4450",
  baby_pink = "#ff7edb",
  pink = "#f97e72",
  green = "#72f1b8",
  vibrant_green = "#2ee2fa",
  nord_blue = "#03edf9",
  blue = "#268bd3",
  yellow = "#fede5d",
  sun = "#f3e70f",
  purple = "#ff7edb",
  dark_purple = "#fe4450",
  teal = "#36f9f6",
  orange = "#fe4450",
  cyan = "#72f1b8",

  -- UI Specific
  statusline_bg = "#1f212b",
  lightbg = "#2a2139",
  pmenu_bg = "#f97e72",
  folder_bg = "#268bd3",
  line = "#022736", -- Added 'line' as per the original example
}

-- Base16: Color Scheme Mapping
M.base_16 = {
  base00 = M.base_30.black,
  base01 = M.base_30.one_bg,
  base02 = M.base_30.one_bg2,
  base03 = M.base_30.one_bg3,
  base04 = "#1b4651",
  base05 = M.base_30.white,
  base06 = "#eee8d5",
  base07 = "#fdf6e3",
  base08 = "#268bd2",
  base09 = M.base_30.red,
  base0A = M.base_30.sun,
  base0B = "#29a298",
  base0C = "#c94c16",
  base0D = M.base_30.nord_blue,
  base0E = M.base_30.yellow,
  base0F = "#c94c16",
}

-- Polish Highlights: Syntax and UI Enhancements
M.polish_hl = {
  treesitter = {
    ["@comment"] = { fg = "#848bbd", italic = true },
    ["@string"] = { fg = "#ff8b39" },
    ["@punctuation.delimiter"] = { fg = "#b6b1b1" },
    ["@variable"] = { fg = "#ff7edb" },
    ["@constant"] = { fg = "#f97e72" },
    ["@keyword"] = { fg = "#fede5d" },
    ["@function"] = { fg = "#36f9f6" },
    ["@call"] = {fg = "#36f9f6"},
    ["@type"] = { fg = "#fe4450" },
    ["@boolean"] = { fg = "#f97e72" },
    ["@operator"] = { fg = "#fede5d" },
    ["@namespace"] = { fg = "#ff7edb" },
    ["@tag"] = { fg = "#72f1b8" },
    ["@attribute"] = { fg = "#fede5d" },
    ["@punctuation.bracket"] = { fg = "#fede5d" },
    ["@parameter"] = { fg = M.base_30.baby_pink, italic = true },
    ["@function.builtin"] = { fg = "#c94c16" },
    ["@variable.parameter"] = { fg = M.base_30.baby_pink, italic = true },
    ["@constant.builtin"] = { fg = "#f97e72" },
    ["@property"] = { fg = "#ff7edb" },
  },

  syntax = {
    Include = { fg = "#fede5d" },
    Tag = { fg = "#72f1b8" },
     },

  defaults = {
    IncSearch = { fg = "#c94c16", bg = "none", standout = true },
  },

  lsp = {
    DiagnosticVirtualTextError = {fg = M.base_30.red }, -- Removed alpha
    DiagnosticVirtualTextWarn = { fg = M.base_30.yellow }, -- Removed alpha
    DiagnosticVirtualTextInfo = { fg = M.base_30.cyan }, -- Removed alpha
    DiagnosticVirtualTextHint = { fg = M.base_30.teal }, -- Removed alpha
  },
}

-- Theme Type
M.type = "dark"

-- Override and Return the Theme
M = require("base46").override_theme(M, "synthwave84")

return M
