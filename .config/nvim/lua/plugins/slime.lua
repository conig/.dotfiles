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
      vim.g.slime_bracketed_paste = 1
    end,
  },
  {
    "conig/nvim-slimetree",
    ft = { "r", "rmd", "quarto", "lua" },
    dependencies = "jpalardy/vim-slime",
    dev = true,
    dir = "/home/conig/repos/nvim-slimetree/",
    keys = {
      { "<leader>gs", function() require("nvim-slimetree").gootabs.start_goo { "r" }
end, desc = "Start goo", noremap = true, silent = true },
    },
    config = function()
      local st = require "nvim-slimetree"

      -- Slime key mappings
      vim.keymap.set("x", "<CR>", "<Plug>SlimeRegionSend", { remap = true, silent = true })
      vim.keymap.set("n", "<CR>", function()
        st.slimetree.goo_move()
      end, { desc = "Slime and move" })

      vim.keymap.set("n", "<leader>rC", function()
        require("functions.Rfunctions").TerminalInterrupt()
      end, { desc = "Interrupt terminal", noremap = true })

      vim.keymap.set("n", "<leader>rv", function()
        require("functions.Rfunctions").SendInlineToConsole()
      end, { desc = "Send inline to console" })

      vim.keymap.set("n", "<leader>rj", function()
        require("functions.Rfunctions").StartInlineMode()
      end, {desc = "Start inline mode"})

      vim.keymap.set("n", "<leader><CR>", function()
        st.slimetree.goo_move(true)
      end, { desc = "Slime and hold position", noremap = true })

      vim.keymap.set("n", "<C-c><C-c>", function()
        st.slimetree.SlimeCurrentLine()
      end, { desc = "Send current line to Slime" })

      vim.keymap.set("n", "<leader>g1", function()
        st.gootabs.summon_goo(1)
      end, { desc = "Summon goo 1", noremap = true, silent = true })
      vim.keymap.set("n", "<leader>g2", function()
        st.gootabs.summon_goo(2)
      end, { desc = "Summon goo 2", noremap = true, silent = true })
      vim.keymap.set("n", "<leader>g3", function()
        st.gootabs.summon_goo(3)
      end, { desc = "Summon goo 3", noremap = true, silent = true })
      vim.keymap.set("n", "<leader>g4", function()
        st.gootabs.summon_goo(4)
      end, { desc = "Summon goo 4", noremap = true, silent = true })

      -- R-specific key mappings
      vim.keymap.set("n", "<leader>ka", function()
        require("functions.Rfunctions").knit_render()
      end, { desc = "Knit", noremap = true, silent = true })

      vim.keymap.set("n", "<leader>dq", function()
        require("functions.Rfunctions").BrowserQuit()
      end, { desc = "Quit R browser()" })

      vim.keymap.set({ "v", "n" }, "<leader>4", function()
        require("rmdscope.telescope").insert_object_member()
      end, { desc = "Insert object member" })

      vim.keymap.set("n", "<leader>ro", function()
        require("functions.Rfunctions").SendObjectToConsole()
      end, { desc = "Send object to console" })

      vim.keymap.set("n", "<leader>rR", function()
        require("functions.Rfunctions").R_restart()
      end, { desc = "Restart R console", noremap = true })

      vim.keymap.set("n", "<leader>rw", function()
        require("functions.Rfunctions").SendWordToConsole()
      end, { desc = "Send word to console" })

      vim.keymap.set("n", "<leader>rW", function()
        require("functions.Rfunctions").SendWordToConsole(true)
      end)

      vim.keymap.set("n", "<leader>rs", function()
        require("functions.Rfunctions").FunctionToWord "summary"
      end, { desc = "Summarise object under cursor" })

      vim.keymap.set("n", "<leader>rc", function()
        require("functions.Rfunctions").FunctionToWord "class"
      end, { desc = "Print object class" })

      vim.keymap.set("n", "<leader>rr", function()
        require("functions.Rfunctions").FunctionToWord "str"
      end, { desc = "Print object str" })

      vim.keymap.set("n", "<leader>tg", function()
        require("functions.Rfunctions").SendTarLoadGlobals()
      end, { desc = "Load all target globals" })

      vim.keymap.set("n", "<leader>ru", function()
        require("functions.Rfunctions").FunctionToWord "unique"
      end, { desc = "Run unique on word" })

      vim.keymap.set("n", "<leader>rt", function()
        require("functions.Rfunctions").FunctionToWord "table"
      end, { desc = "Run table on word" })
      vim.keymap.set("n", "<leader>rp", function()
        require("functions.Rfunctions").FunctionToWord "plot"
      end, {desc = "Plot word"})
      vim.keymap.set("n", "<leader>ri", function()
        require("functions.Rfunctions").FunctionToWord("pak::pkg_install", true)
      end, { desc = "Install R package under cursor" })

      vim.keymap.set("n", "<leader>r?", function()
        require("functions.Rfunctions").QueryRFunction()
      end, { desc = "Query R Function" })

      vim.keymap.set("n", "<leader>tp", function()
        require("functions.Rfunctions").SendTarMakeProgress()
      end, { desc = "Show Targets progress" })

      vim.keymap.set("n", "<leader>rII", function()
        require("functions.Rfunctions").InstallRpackages()
      end, { desc = "Install R package" })

      vim.keymap.set("n", "<leader>rID", function()
        require("functions.Rfunctions").DocumentRPackage()
      end, { desc = "Document R package" })

      vim.keymap.set("n", "<leader>tl", function()
        require("functions.Rfunctions").TarLoadUnderCursor()
      end, { desc = "Load target under cursor" })

      vim.keymap.set("n", "<leader>ta", function()
        require("functions.Rfunctions").TarLoadFunctionArguments()
      end, { desc = "Load target function arguments" })

      vim.keymap.set("n", "<leader>tI", function()
        require("functions.Rfunctions").TarInvalidate()
      end, { desc = "Invalidate targets" })

      vim.keymap.set("n", "<leader>i", function()
        require("functions.Rfunctions").Wrap_rmd_chunk()
      end, { desc = "Wrap code under cursor in Rmd chunk" })

      vim.keymap.set("n", "<leader>I", function()
        require("functions.Rfunctions").Wrap_rmd_chunk("asis")
      end, { desc = "Wrap code under cursor in asis Rmd chunk" })

      vim.keymap.set("n", "<leader>tm", function()
        require("functions.Rfunctions").SendTarMake()
      end, { desc = "Make targets" })

      vim.keymap.set("n", "<leader>ttd", function()
        require("functions.Rfunctions").SendTarMakeActiveDebug()
      end)

      vim.keymap.set("n", "<leader>ttl", function()
        require("functions.Rfunctions").TarLoadActive()
      end)

      vim.keymap.set("n", "<leader>tM", function()
        require("functions.Rfunctions").SendTarMakeFuture()
      end, { desc = "Tar Make Future" })

      -- Note: The original configuration had <leader>tl twice, once with desc "Load target under cursor" above, and once here again:
      vim.keymap.set("n", "<leader>tl", function()
        require("functions.Rfunctions").TarLoad()
      end)

      vim.keymap.set("n", "<leader>td", function()
        require("functions.Rfunctions").SendTarMakeNoCallr()
      end, { desc = "Debug targets" })

      vim.keymap.set("n", "<leader>to", function()
        require("functions.Rfunctions").SendTarMakeDebugObj()
      end, { desc = "Debug target object" })

      vim.keymap.set("n", "<leader>rk", function()
        require("functions.Rfunctions").SendRAbove()
      end, { desc = "Execute goo move up to the current position" })

      vim.keymap.set("n", "<leader>rn", function()
        require("functions.Rfunctions").FunctionToWord "names"
      end, { desc = "Run names on word" })

      vim.keymap.set("n", "<leader>rN", function()
        require("functions.Rfunctions").ClipNames()
      end, { desc = "Send word names to clipboard" })
    end,
  },
}
