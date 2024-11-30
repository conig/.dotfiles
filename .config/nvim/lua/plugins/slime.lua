return {
  {
    "jpalardy/vim-slime",
    ft = { "python", "lua", "zsh", "bash", "rmd", "r", "quarto" },
    config = function()
      -- Configure vim-slime settings here
      vim.g.slime_no_mappings = 1
      vim.g.slime_target = "tmux"
      vim.g.slime_default_config = {
        socket_name = "default",
        target_pane = 1,
      }
      vim.g.slime_dont_ask_default = 1
      vim.g.slime_bracketed_paste = 0
    end,
  },
  {
    "conig/nvim-slimetree",
    ft = { "r", "rmd", "quarto", "lua" },
    dependencies = "jpalardy/vim-slime",
    dev = true,
    dir = "/home/conig/repos/nvim-slimetree/",
    keys = {
      -- Slime key mappings
      { "<CR>", "<Plug>SlimeRegionSend", mode = "x", remap = true, silent = true },
      {
        "<CR>",
        function()
          require("nvim-slimetree").goo_move()
        end,
        desc = "Slime and move",
      },
      {
        "<leader>rC",
        function()
          require("functions.Rfunctions").TerminalInterrupt()
        end,
        desc = "Interrupt terminal",
        noremap = true,
      },
      {
        "<leader>rv",
        function()
          require("functions.Rfunctions").SendInlineToConsole()
        end,
      },
      {
        "<leader>rj",
        function()
          require("functions.Rfunctions").StartInlineMode()
        end,
      },
      {
        "<leader><CR>",
        function()
          require("nvim-slimetree").goo_move(true)
        end,
        desc = "Slime and hold position",
        noremap = true,
      },
      {
        "<C-c><C-c>",
        function()
          require("nvim-slimetree").SlimeCurrentLine()
        end,
        desc = "Send current line to Slime",
      },
      {
        "<leader>gs",
        function()
          require("nvim-slimetree").start_goo "clear && r"
        end,
        desc = "Start goo",
        noremap = true,
        silent = true,
      },
      {
        "<leader>g1",
        function()
          require("nvim-slimetree").summon_goo(1)
        end,
        desc = "Summon goo 1",
        noremap = true,
        silent = true,
      },
      {
        "<leader>g2",
        function()
          require("nvim-slimetree").summon_goo(2)
        end,
        desc = "Summon goo 2",
        noremap = true,
        silent = true,
      },
      {
        "<leader>g3",
        function()
          require("nvim-slimetree").summon_goo(3)
        end,
        desc = "Summon goo 3",
        noremap = true,
        silent = true,
      },
      {
        "<leader>g4",
        function()
          require("nvim-slimetree").summon_goo(4)
        end,
        desc = "Summon goo 4",
        noremap = true,
        silent = true,
      },
      -- R-specific key mappings
      {
        "<leader>ka",
        function()
          require("functions.Rfunctions").knit_render()
        end,
        desc = "Knit",
        noremap = true,
        silent = true,
      },
      {
        "<leader>dq",
        function()
          require("functions.Rfunctions").BrowserQuit()
        end,
        desc = "Quit R browser()",
      },
      {
        "<leader>4",
        function()
          require("rmdscope.telescope").insert_object_member()
        end,
        desc = "Insert object member",
        mode = { "v", "n" },
      },
      {
        "<leader>ro",
        function()
          require("functions.Rfunctions").SendObjectToConsole()
        end,
        desc = "Send object to console",
      },
      {
        "<leader>rR",
        function()
          require("functions.Rfunctions").R_restart()
        end,
        desc = "Restart R console",
        noremap = true,
        mode = "n",
      },
      {
        "<leader>rw",
        function()
          require("functions.Rfunctions").SendWordToConsole()
        end,
        desc = "Send word to console",
      },
      {
        "<leader>rW",
        function()
          require("functions.Rfunctions").SendWordToConsole(true)
        end,
      },
      {
        "<leader>rs",
        function()
          require("functions.Rfunctions").FunctionToWord "summary"
        end,
        desc = "Summarise object under cursor",
      },
      {
        "<leader>rc",
        function()
          require("functions.Rfunctions").FunctionToWord "class"
        end,
        desc = "Print object class",
      },
      {
        "<leader>rr",
        function()
          require("functions.Rfunctions").FunctionToWord "str"
        end,
        desc = "Print object str",
      },
      {
        "<leader>ru",
        function()
          require("functions.Rfunctions").FunctionToWord "unique"
        end,
        desc = "Run unique on word",
        mode = "n",
      },
      {
        "<leader>rt",
        function()
          require("functions.Rfunctions").FunctionToWord "table"
        end,
        desc = "Run table on word",
        mode = "n",
      },
      {
        "<leader>r?",
        function()
          require("functions.Rfunctions").QueryRFunction()
        end,
        desc = "Query R Function",
      },
      {
        "<leader>tp",
        function()
          require("functions.Rfunctions").SendTarMakeProgress()
        end,
        desc = "Show Targets progress",
      },
      {
        "<leader>gd",
        function()
          require("functions.Rfunctions").StartHttpgd()
        end,
        desc = "Start httpgd server",
      },
      {
        "<leader>rI",
        function()
          require("functions.Rfunctions").InstallRpackages()
        end,
        desc = "Install R package",
      },
      {
        "<leader>ri",
        function()
          require("functions.Rfunctions").DocumentRPackage()
        end,
        desc = "Document R package",
      },
      {
        "<leader>tl",
        function()
          require("functions.Rfunctions").TarLoadUnderCursor()
        end,
        desc = "Load target under cursor",
      },
      {
        "<leader>ta",
        function()
          require("functions.Rfunctions").TarLoadFunctionArguments()
        end,
        desc = "Load target function arguments",
      },
      {
        "<leader>tI",
        function()
          require("functions.Rfunctions").TarInvalidate()
        end,
        desc = "Invalidate targets",
      },
      {
        "<leader>i",
        function()
          require("functions.Rfunctions").Wrap_rmd_chunk()
        end,
        desc = "Wrap code under cursor in Rmd chunk",
      },
      {
        "<leader>tm",
        function()
          require("functions.Rfunctions").SendTarMake()
        end,
        desc = "Make targets",
      },
      {
        "<leader>ttd",
        function()
          require("functions.Rfunctions").SendTarMakeActiveDebug()
        end,
      },
      {
        "<leader>ttl",
        function()
          require("functions.Rfunctions").TarLoadActive()
        end,
      },
      {
        "<leader>tM",
        function()
          require("functions.Rfunctions").SendTarMakeFuture()
        end,
        desc = "Tar Make Future",
      },
      {
      "<leader>tl",
      function()
        require("functions.Rfunctions").TarLoad()
      end,
      },
      {
        "<leader>td",
        function()
          require("functions.Rfunctions").SendTarMakeNoCallr()
        end,
        desc = "Debug targets",
      },
      {
        "<leader>to",
        function()
          require("functions.Rfunctions").SendTarMakeDebugObj()
        end,
        desc = "Debug target object",
      },
      {
        "<leader>rk",
        function()
          require("functions.Rfunctions").SendRAbove()
        end,
        desc = "Execute goo move up to the current position",
      },
      {
        "<leader>rn",
        function()
          require("functions.Rfunctions").FunctionToWord "names"
        end,
        desc = "Run names on word",
      },
      {
        "<leader>rN",
        function()
          require("functions.Rfunctions").ClipNames()
        end,
        desc = "Send word names to clipboard",
      },
    },
  },
}
