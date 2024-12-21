return {
  {
    "kdheepak/lazygit.nvim",
    lazy = true,
    cmd = {
      "LazyGit",
    },
    -- optional for floating window border decoration
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    -- setting the keybinding for LazyGit with 'keys' is recommended in
    -- order to load the plugin when the command is run for the first time
    keys = {
      { "<leader>gg", "<cmd>LazyGit<cr>", desc = "LazyGit" },
    },
  },
  {
    "eandrju/cellular-automaton.nvim",
    config = function()
      vim.keymap.set("n", "<leader>fml", "<cmd>CellularAutomaton make_it_rain<CR>")
    end,
  },
  { "nvchad/volt", lazy = true, event = { "BufReadPost", "BufNewFile" } },
  { "nvchad/minty", lazy = true, event = { "BufReadPost", "BufNewFile" } },
  {
    "conig/rmdscope",
    branch = "devel",
    dev = true,
    dir = "/home/conig/repos/rmdscope/",
    dependencies = {
      "nvim-telescope/telescope.nvim",
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-tree.lua",
      "MunifTanjim/nui.nvim",
    },
    keys = {
      {
        "<leader>ks", -- Key combination
        function()
          require("rmdscope.telescope").templates()
        end,
        desc = "Rmd templates",
        mode = "n", -- Mode: 'n' for normal mode
        noremap = true,
        silent = true,
      },
    },
  },
  {
    "nvim-treesitter/playground",
  },
  { "akinsho/git-conflict.nvim", version = "*", config = true },
  {
    "jake-stewart/multicursor.nvim",
    events = { "BufReadPost", "BufNewFile" },
    keys = {
      {
        "<esc>",
        mode = { "n" },
        function()
          local mc = require "multicursor-nvim"
          if not mc.cursorsEnabled() then
            mc.enableCursors()
          elseif mc.hasCursors() then
            mc.clearCursors()
          else
            vim.cmd "nohlsearch"
            -- vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<Esc>', true, false, true), 'n', true)
            -- Default <esc> handler.
          end
        end,
      },
      {
        "<leader>'",
        mode = { "n", "v" },
        function()
          local mc = require "multicursor-nvim"
          mc.matchAddCursor(1)
        end,
      },
    },
    config = function()
      local mc = require "multicursor-nvim"

      mc.setup()

      -- Customize how cursors look.
      local hl = vim.api.nvim_set_hl
      hl(0, "MultiCursorCursor", { link = "Cursor" })
      hl(0, "MultiCursorVisual", { link = "Visual" })
      hl(0, "MultiCursorSign", { link = "SignColumn" })
      hl(0, "MultiCursorDisabledCursor", { link = "Visual" })
      hl(0, "MultiCursorDisabledVisual", { link = "Visual" })
      hl(0, "MultiCursorDisabledSign", { link = "SignColumn" })
    end,
  },
  {
    "NvChad/NvChad",
    lazy = false,
    branch = "v2.5",
    import = "nvchad.plugins",
    keys = {
      { "<Tab>", mode = { "n" }, false },
    },
    config = function()
      require "options"
    end,
  },
  { import = "plugins" },
  {
    "shortcuts/no-neck-pain.nvim",
    version = "*",
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      require("no-neck-pain").setup {
        mappings = {
          enabled = true,
        },
      }
    end,
  },
  {
    "quarto-dev/quarto-nvim",
    dependencies = {
      "jmbuhr/otter.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    config = function()
      require("quarto").setup {}
    end,
    lazy = true,
  },

  {
    "shellRaining/hlchunk.nvim",
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      require("hlchunk").setup {
        chunk = {
          enable = true,
          use_treesitter = true,
          delay = 0,
          style = {
            "#757575",
          },
        },
        indent = {
          enable = false,
        },
        line_num = {
          enable = true,
          style = {
            "#ababab",
          },
        },
        blank = {
          enable = false,
        },
      }
    end,
  },

  {
    "nvim-treesitter/nvim-treesitter",
    run = ":TSUpdate",
    config = function()
      require("nvim-treesitter.configs").setup {
        ensure_installed = { "markdown", "markdown_inline", "r", "regex", "yaml", "bash", "python", "julia" },
        highlight = { enable = true },
      }
    end,
  },
  {
    "HiPhish/rainbow-delimiters.nvim",
    config = function()
      vim.g.rainbow_delimiters = {
        highlight = {
          "RainbowDelimiterCyan",
          "RainbowDelimiterViolet",
          "RainbowDelimiterGreen",
          "RainbowDelimiterOrange",
          "RainbowDelimiterBlue",
          "RainbowDelimiterYellow",
          "RainbowDelimiterRed",
        },
      }
    end,
  },
  {
    "stevearc/conform.nvim",
    enabled = true,
    config = function()
      local conform = require "conform"

      conform.setup {
        notify_on_error = true,
        formatters_by_ft = {
          css = { "prettier" },
          scss = { "prettier" },
          lua = { "stylua" },
          python = { "isort", "black" },
          quarto = { "injected", "prettier" },
          rmd = { "injected", "prettier" },
          bash = { "shfmt" },
          r = { "mystyler" },
          latex = { "latexindent" },
          sql = { "sqlformatter" },
          markdown = { "prettier" },
          toml = { "taplo" },
          yaml = { "prettier" },
          html = { "prettier" },
        },
        formatters = {
          mystylua = {
            command = "stylua",
            args = {
              "--indent-type",
              "Spaces",
              "--indent-width",
              "4",
              "-",
              "--quote-style",
              "AutoPreferDouble",
            },
          },
          mystyler = {
            command = "R",
            args = { "-s", "-e", "styler::style_file(commandArgs(TRUE)[1])", "--args", "$FILENAME" },
            stdin = false,
          },
          sqlformatter = {
            command = "sql-formatter",
            args = {
              "-l=bigquery",
              '--config={"tabWidth": 2, "keywordCase":"upper", "expressionWidth":80, "linesBetweenQueries":2}',
            },
          },
        },
      }

      -- Customize the "injected" formatter
      conform.formatters.injected = {
        options = {
          ignore_errors = false,
          lang_to_ext = {
            bash = "sh",
            c_sharp = "cs",
            elixir = "exs",
            javascript = "js",
            julia = "jl",
            latex = "tex",
            markdown = "md",
            python = "py",
            ruby = "rb",
            rust = "rs",
            teal = "tl",
            r = "r",
            typescript = "ts",
          },
          lang_to_formatters = {},
        },
      }

      require("conform").formatters.prettier = {
        options = {
          ft_parsers = {
            quarto = "markdown",
            rmd = "markdown",
          },
        },
      }
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    after = "nvim-treesitter",
    lazy = true,
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      require("nvim-treesitter.configs").setup {
        textobjects = {
          select = {
            enable = true,
            lookahead = true,
            keymaps = {
              ["af"] = "@function.outer",
              ["if"] = "@function.inner",
              ["ac"] = "@class.outer",
              ["ic"] = "@class.inner",
              ["il"] = "@loop.inner",
              ["al"] = "@loop.outer",
              ["ib"] = "@block.inner",
              ["ab"] = "@block.outer",
            },
          },
          swap = {
            enable = true,
            swap_next = {
              ["<leader>a"] = "@parameter.inner",
            },
            swap_previous = {
              ["<leader>A"] = "@parameter.inner",
            },
          },
          move = {
            enable = true,
            set_jumps = true,
            goto_next_start = {
              ["]m"] = "@function.outer",
              ["]]"] = "@class.outer",
            },
            goto_previous_start = {
              ["[m"] = "@function.outer",
              ["[["] = "@class.outer",
            },
          },
        },
      }
    end,
  },
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("telescope").setup {
        defaults = {
          vimgrep_arguments = {
            "rg",
            "--color=never",
            "--no-heading",
            "--with-filename",
            "--line-number",
            "--column",
            "--smart-case",
            "--hidden",
            "--glob",
            "!.git/*",
          },
          file_ignore_patterns = { "node_modules" },
        },
        pickers = {
          find_files = {
            theme = "dropdown",
            hidden = true,
            find_command = { "rg", "--files", "--hidden", "--glob", "!.git/*" },
          },
        },
      }
    end,
  },
  {
    "MeanderingProgrammer/render-markdown.nvim",
    ft = { "Avante", "rmd", "qmd", "md", "markdown" },
    opts = {
      file_types = { "Avante", "rmd", "md", "qmd", "markdown" },
    },
    config = function()
      require("render-markdown").setup {
        heading = {
          enabled = true,
          icons = { "# ", "## ", "### ", "#### ", "##### ", "###### " }, -- Standard markdown headings
          border = true, -- No borders
          above = "",
          below = "󰼮",
        },
        bullet = {
          -- Turn on / off list bullet rendering
          enabled = true,
          -- Replaces '-'|'+'|'*' of 'list_item'
          -- How deeply nested the list is determines the 'level' which is used to index into the list using a cycle
          -- The item number in the list is used to index into the value using a clamp if the value is also a list
          -- If the item is a 'checkbox' a conceal is used to hide the bullet instead
          icons = { "●", "○", "◆", "◇" },
          -- Replaces 'n.'|'n)' of 'list_item'
          -- How deeply nested the list is determines the 'level' which is used to index into the list using a cycle
          -- The item number in the list is used to index into the value using a clamp if the value is also a list
          ordered_icons = {},
          -- Padding to add to the left of bullet point
          left_pad = 0,
          -- Padding to add to the right of bullet point
          right_pad = 1,
          -- Highlight for the bullet icon
          highlight = "RenderMarkdownBullet",
        },
      }
    end,
  },
}
