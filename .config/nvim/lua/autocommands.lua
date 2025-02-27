-- format with conform

vim.api.nvim_create_autocmd("BufWritePost", {
  pattern = { "*.lua", "*.R" },
  callback = function(args)
    -- require("conform").format { bufnr = args.buf }
  end,
})
-- Display macro recording start
vim.api.nvim_create_autocmd("RecordingEnter", {
  callback = function()
    local msg = string.format("Recording Macro: {%s}", vim.fn.reg_recording())
    _MACRO_RECORDING_STATUS = true
    vim.schedule(function()
      vim.cmd("echohl ModeMsg | echo '" .. msg .. "' | echohl None")
    end)
  end,
  group = vim.api.nvim_create_augroup("NoiceMacroNotification", { clear = true }),
})
-- Display macro recording end
vim.api.nvim_create_autocmd("RecordingLeave", {
  callback = function()
    _MACRO_RECORDING_STATUS = false
    vim.schedule(function()
      vim.cmd "echohl ModeMsg | echo 'Macro Recorded' | echohl None"
    end)
  end,
  group = vim.api.nvim_create_augroup("NoiceMacroNotificationDismiss", { clear = true }),
})
-- open pdf in zathura
vim.api.nvim_create_autocmd("BufEnter", {
    pattern = "*.pdf",
    callback = function()
        local file = vim.fn.expand("%:p")
        vim.cmd("silent !zathura " .. vim.fn.shellescape(file) .. " &")

        vim.defer_fn(function()
            if vim.fn.bufexists(file) == 1 then
                vim.cmd("bdelete!")

                -- Check if NvimTree is open before closing it
                local tree_is_open = false
                for _, win in ipairs(vim.api.nvim_list_wins()) do
                    local bufname = vim.api.nvim_buf_get_name(vim.api.nvim_win_get_buf(win))
                    if bufname:match("NvimTree") then
                        tree_is_open = true
                        break
                    end
                end

                -- Only close and reopen if NvimTree was actually open
                if tree_is_open then
                    vim.cmd("NvimTreeClose")
                    vim.cmd("NvimTreeOpen")
                end
            end
        end, 100)  -- Short delay to allow Zathura to launch
    end,
})

-- open .html in browser
vim.api.nvim_create_autocmd('BufReadPost', {
  pattern = '*.html',
  callback = function()
    local file = vim.fn.expand('%:p')  -- Get the full file path
    vim.fn.jobstart({'xdg-open', file}, {detach = true})  -- Opens file in your default browser (use 'open' on macOS or adjust for Windows)
    vim.cmd('bdelete!')  -- Closes the buffer
  end,
})


--Don't worry about meta-data updates on /mnt/onedrive/
vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter" }, {
  pattern = "*",
  callback = function()
    local filename = vim.fn.expand("%:p")
    if filename:match("^/mnt/onedrive/") then
      -- Ignore external changes for rclone mount
      vim.opt.autoread = false
    else
      -- Default behavior: reload if unchanged
      vim.opt.autoread = true
      if vim.bo.modified == false then
        vim.cmd("checktime")
      end
    end
  end,
})

