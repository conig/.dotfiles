-- Check if Neovim is running inside tmux
if os.getenv("TMUX") then
  -- Function to get the current tmux session name
  local function get_tmux_session()
    local handle = io.popen("tmux display-message -p '#{session_name}'")
    local result = handle:read("*a") or nil
    handle:close()
    -- Trim any trailing newline or whitespace
    return result:match("^%s*(.-)%s*$")
  end

  -- Function to set tmux status bar
  local function set_tmux_status(state)
    local session = get_tmux_session()
    if session ~= nil and session ~= "" then
      os.execute("tmux set-option -t " .. session .. " status " .. state)
    else
      -- Optional: Handle cases where session name couldn't be determined
      vim.notify("tmux session name not found. Cannot toggle status bar.", vim.log.levels.WARN)
    end
  end

  -- Autocommand to hide tmux status bar on VimEnter
  vim.api.nvim_create_autocmd("VimEnter", {
    callback = function()
      set_tmux_status("off")
    end,
  })

  -- Autocommand to show tmux status bar on VimLeave
  vim.api.nvim_create_autocmd("VimLeavePre", {
    callback = function()
      set_tmux_status("on")
    end,
  })
  -- add mapping to turn back on and off
vim.keymap.set('n', '<leader>bb', function()
  set_tmux_status('on')
end, { noremap = true, silent = true })

vim.keymap.set('n', '<leader>bB', function()
  set_tmux_status('off')
end, { noremap = true, silent = true })

end
