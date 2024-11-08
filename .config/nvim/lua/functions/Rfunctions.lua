

local M = {}

local function send_to_r_console(text)
  vim.fn["slime#send"](text .. "\n")
end

function M.knit_render()
  local buffer_path = vim.fn.expand "%:p"
  local cmd = "rmarkdown::render('" .. buffer_path .. "')"
  send_to_r_console(cmd)
end

function M.SendTarLoadGlobals()
  send_to_r_console "targets::tar_load_globals()"
end

function M.SendTarMake()
  send_to_r_console "targets::tar_make()"
end

function M.SendTarMakeNoCallr()
  send_to_r_console "targets::tar_make(callr_function = NULL, use_crew = FALSE)"
end

-- Generic function that wraps the current word with the specified function and sends it to the R console
function M.FunctionToWord(fn_name)
  -- Get the current word under the cursor
  local word = vim.fn.expand("<cword>")

  -- Construct the command by wrapping the word with the function
  local command = string.format("%s(%s)", fn_name, word)

  -- Send the constructed command to the R console
  send_to_r_console(command)
end

function M.SendWordToConsole()
  send_to_r_console(vim.fn.expand "<cword>")
end

function M.ClipNames()
    local current_word = vim.fn.expand("<cword>") -- Get the current word under the cursor
    send_to_r_console("clipr::write_clip(paste('#', names(" .. current_word .. ")))") -- Send the summary command with the current word
end

function M.SendClassToConsole()
    local current_word = vim.fn.expand("<cword>") -- Get the current word under the cursor
    send_to_r_console("class(" .. current_word .. ")") -- Send the class command with the current word
end

function M.SendStrToConsole()
    local current_word = vim.fn.expand("<cword>") -- Get the current word under the cursor
    send_to_r_console("str(" .. current_word .. ")") -- Send the str command with the current word
end

function M.SendTableToConsole()
    local current_word = vim.fn.expand("<cword>") -- Get the current word under the cursor
    send_to_r_console("table(" .. current_word .. ")") -- Send the table command with the current word
end

function M.QueryRFunction()
  local current_word = vim.fn.expand("<cword>")
  send_to_r_console("?" .. current_word)
end

function M.SendRAbove() -- use require("nvim-slimetree").goo_move() to execute all code from the start to at least the current line
  local current_line = vim.api.nvim_win_get_cursor(0)[1] -- Get the current line number
  local line_i = 1 -- Initialize the line index
  vim.api.nvim_win_set_cursor(0, {line_i, 0})
  -- Set cursor to the first line
  while line_i < current_line do -- Loop through the lines from the start to the current line
    require("nvim-slimetree").goo_move()
    -- pause for a second
    vim.wait(150)
    line_i = vim.api.nvim_win_get_cursor(0)[1] -- Get the line content
  end
end

function M.r_selection(cmd)
    -- Get the mode to detect if we're in line-wise visual mode
    local mode = vim.fn.mode()
    local bufnr = vim.api.nvim_get_current_buf()
    
    -- Handle line-wise visual mode ('V')
    if mode == 'V' then
        local start_line = vim.fn.line('v')
        local end_line = vim.fn.line('.')
        
        -- Ensure start_line is before end_line
        if start_line > end_line then
            start_line, end_line = end_line, start_line
        end
        
        -- Get the entire lines
        local selection = vim.api.nvim_buf_get_lines(
            bufnr,
            start_line - 1,
            end_line,
            false
        )
        
        -- Join lines
        selection = table.concat(selection, "\n")
        selection = selection:gsub("^%s*(.-)%s*$", "%1")
        
        -- Construct and send the R command
        local r_command = string.format("%s(%s)", cmd, selection)
        send_to_r_console(r_command)
        return
    end
    
    -- Handle character-wise visual mode ('v')
    local start_line, start_col = vim.fn.line('v'), vim.fn.col('v')
    local end_line, end_col = vim.fn.line('.'), vim.fn.col('.')
    
    -- Ensure start position is before end position
    if start_line > end_line or (start_line == end_line and start_col > end_col) then
        start_line, end_line = end_line, start_line
        start_col, end_col = end_col, start_col
    end
    
    -- Get the text
    local selection = vim.api.nvim_buf_get_text(
        bufnr,
        start_line - 1,
        start_col - 1,
        end_line - 1,
        end_col,
        {}
    )
    
    -- Join lines if multiple lines were selected
    selection = table.concat(selection, "\n")
    
    -- Trim whitespace
    selection = selection:gsub("^%s*(.-)%s*$", "%1")
    
    -- Construct and send the R command
    local r_command = string.format("%s(%s)", cmd, selection)
    send_to_r_console(r_command)
end

-- Set up the mapping helper
function M.setup_mapping(cmd, key)
    vim.keymap.set('x', key, function()
        M.r_selection(cmd)
    end, { noremap = true, silent = true })
end


function M.SendTarMakeDebugObj()
  -- Get the word under the cursor
  local target_name = vim.fn.expand "<cword>"
  if target_name == "" then
    vim.notify("No target name found under cursor.", vim.log.levels.ERROR)
    return
  end

  -- Construct the R command
  local r_command =
    string.format('targets::tar_make(names = "%s", callr_function = NULL, use_crew = FALSE)\n', target_name)
  send_to_r_console(r_command)
end

function M.SendTarMakeBackground()
  send_to_r_console "targets::tar_make(callr_function = callr::r_bg)"
end

function M.SendTarMakeProgress()
  send_to_r_console "targets::tar_progress()"
end

function M.BrowserQuit()
  send_to_r_console "Q"
end

function M.StartHttpgd()
  send_to_r_console "httpgd::hgd(silent = TRUE); httpgd::hgd_browse()"
end

function M.InstallRpackages()
  send_to_r_console "devtools::install(force = TRUE, dependencies = FALSE)"
end

function M.DocumentRPackage()
  send_to_r_console "devtools::document()"
end

function M.TarInvalidate()
  send_to_r_console "targets::tar_invalidate(everything())"
end

function M.TarLoadUnderCursor()
  -- Get the word under the cursor using Neovim's API
  local word = vim.fn.expand "<cword>"

  -- Check if a word was found
  if word == "" then
    print "No word under cursor."
    return
  end

  -- Construct the R command string
  local r_command = string.format("targets::tar_load(%s)", word)

  -- Send the command to the R console
  -- Ensure that send_to_r_console is defined and accessible
  send_to_r_console(r_command)
end

-- start target definition function
function M.TarLoadFunctionArguments()
  -- Get current buffer and cursor position
  local bufnr = vim.api.nvim_get_current_buf()
  local cursor = vim.api.nvim_win_get_cursor(0)
  local row = cursor[1] - 1 -- zero-indexed

  -- Search upwards for function definition
  local start_line = row
  while start_line >= 0 do
    local line = vim.api.nvim_buf_get_lines(bufnr, start_line, start_line + 1, false)[1]
    if string.match(line, "%s*[%w._]+%s*<?%-?%s*function%s*%(") then
      break
    end
    start_line = start_line - 1
  end
  if start_line < 0 then
    print "No function definition found."
    return
  end

  -- Function to get the function arguments text
  local function get_function_args(buffer_number, function_start_line)
    local total_lines = vim.api.nvim_buf_line_count(buffer_number)
    local line_num = function_start_line + 1 -- zero-indexed lines
    local paren_count = 0
    local args_text = ""
    local in_args = false
    send_to_r_console "targets::tar_load_globals()"

    while line_num <= total_lines do
      local line = vim.api.nvim_buf_get_lines(buffer_number, line_num - 1, line_num, false)[1]
      local idx = 1
      local skip_processing = false

      if not in_args then
        local s, e = line:find "function%s*%("
        if s then
          in_args = true
          idx = e + 1
        else
          -- Not inside function arguments, set flag to skip processing
          skip_processing = true
        end
      end

      if not skip_processing and in_args then
        -- Process the line if we're inside the function arguments
        while idx <= #line do
          local c = line:sub(idx, idx)
          if c == "(" then
            paren_count = paren_count + 1
          elseif c == ")" then
            if paren_count == 0 then
              -- Found the closing ')', return the collected arguments
              return args_text
            else
              paren_count = paren_count - 1
            end
          end
          args_text = args_text .. c
          idx = idx + 1
        end
        args_text = args_text .. "\n"
      end

      line_num = line_num + 1
    end
    return nil
  end

  -- Function to split arguments handling parentheses
  local function split_arguments(arg_text)
    local args = {}
    local current_arg = ""
    local paren_count = 0
    for i = 1, #arg_text do
      local c = arg_text:sub(i, i)
      if c == "," and paren_count == 0 then
        table.insert(args, current_arg)
        current_arg = ""
      else
        current_arg = current_arg .. c
        if c == "(" then
          paren_count = paren_count + 1
        end
        if c == ")" then
          paren_count = paren_count - 1
        end
      end
    end
    if current_arg ~= "" then
      table.insert(args, current_arg)
    end
    return args
  end

  -- Function to process arguments
  local function process_arguments(args)
    local result = {}
    for _, arg in ipairs(args) do
      local name, value = arg:match "^%s*([^=]+)%s*=%s*(.+)%s*$"
      if name then
        -- Argument with default value
        result[#result + 1] = { name = name, default = value }
      else
        -- Argument without default value
        arg = arg:match "^%s*(.-)%s*$" -- Trim whitespace
        result[#result + 1] = { name = arg }
      end
    end
    return result
  end

  local func_args_text = get_function_args(bufnr, start_line)
  if not func_args_text then
    print "Could not extract function arguments."
    return
  end

  -- Remove newlines
  func_args_text = func_args_text:gsub("\n", " ")

  -- Split arguments
  local args = split_arguments(func_args_text)

  -- Process arguments
  local processed_args = process_arguments(args)

  -- Generate R commands
  for _, arg in ipairs(processed_args) do
    if arg.default then
      local command = string.format("%s <- %s", arg.name, arg.default)
      -- Ensure that send_to_r_console is defined and accessible
      send_to_r_console(command)
    else
      local command = string.format("targets::tar_load(%s)", arg.name)
      -- Ensure that send_to_r_console is defined and accessible
      send_to_r_console(command)
    end
  end
end
-- end tartet definition function

-- rmd block insert
function M.Wrap_rmd_chunk()
  -- Notify that the function has been called (for debugging)
  vim.notify("Wrap_rmd_chunk function called", vim.log.levels.INFO)

  local bufnr = vim.api.nvim_get_current_buf()
  local cursor = vim.api.nvim_win_get_cursor(0)
  local row = cursor[1] -- 1-based index
  local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
  local total = #lines

  -- Get the current line content
  local current_line = lines[row] or ""

  -- Helper functions to identify chunk delimiters
  local function is_chunk_start(line)
    return line:match("^```{%s*r") ~= nil
  end

  local function is_chunk_end(line)
    return line:match("^```$") ~= nil
  end

  -- Function to check if a line is blank
  local function is_blank(line)
    return line:match("^%s*$") ~= nil
  end

  -- Determine if the cursor is inside an existing R code chunk
  local inside_chunk = false
  local start_chunk = nil

  -- Search upwards for the nearest chunk start
  for i = row, 1, -1 do
    if is_chunk_start(lines[i]) then
      start_chunk = i
      break
    elseif is_chunk_end(lines[i]) then
      break
    end
  end

  if start_chunk then
    -- Search downwards for the corresponding chunk end
    for j = start_chunk + 1, total do
      if is_chunk_end(lines[j]) then
        if row <= j then
          inside_chunk = true
        end
        break
      elseif is_chunk_start(lines[j]) then
        break
      end
    end
  end

  if inside_chunk then
    vim.notify("Inside an existing R code chunk. Inserting a new chunk.", vim.log.levels.INFO)
    -- Insert a new R code chunk above the current line
    local new_chunk = { "```{r}", "", "```" }
    vim.api.nvim_buf_set_lines(bufnr, row, row, false, new_chunk)
    -- Move cursor inside the new chunk
    vim.api.nvim_win_set_cursor(0, { row + 1, 0 })
  else
    if is_blank(current_line) then
      vim.notify("Current line is blank. Inserting a new R code chunk.", vim.log.levels.INFO)
      -- Insert a new R code chunk at the cursor position
      local new_chunk = { "```{r}", "", "```" }
      vim.api.nvim_buf_set_lines(bufnr, row, row, false, new_chunk)
      -- Move cursor inside the new chunk
      vim.api.nvim_win_set_cursor(0, { row + 1, 0 })
    else
      vim.notify("Not inside an R code chunk and current line is not blank. Wrapping current block.", vim.log.levels.INFO)
      -- Find the start of the current block (contiguous non-blank lines)
      local start = row
      while start > 1 and not is_blank(lines[start - 1]) do
        start = start - 1
      end
      -- Find the end of the current block
      local finish = row
      while finish < total and not is_blank(lines[finish + 1]) do
        finish = finish + 1
      end
      vim.notify("Wrapping lines " .. start .. " to " .. finish, vim.log.levels.INFO)
      -- Insert the end delimiter first to avoid shifting lines
      vim.api.nvim_buf_set_lines(bufnr, finish, finish, false, { "```" })
      -- Insert the start delimiter
      vim.api.nvim_buf_set_lines(bufnr, start - 1, start - 1, false, { "```{r}" })
      -- Move cursor inside the wrapped chunk
      vim.api.nvim_win_set_cursor(0, { start + 1, 0 })
    end
  end
end

return M
