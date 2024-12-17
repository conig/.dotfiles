return{{
  "justinmk/vim-sneak",
  event = { "BufReadPre", "BufNewFile" },
  init = function()
    vim.g['sneak#s_next'] = 1
    vim.g['sneak#use_ic_scs'] = 1
  end,
  config = function()
    vim.api.nvim_set_keymap('v', 'S', '<Plug>Sneak_S', { noremap = false, silent = true })
  end
}}
