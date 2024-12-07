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
