M = {}
M.get_word = function()
  -- Attempt to use Tree-sitter
  local ts = vim.treesitter
  if ts then
    -- Get the current buffer and cursor position
    local bufnr = vim.api.nvim_get_current_buf()
    local cursor = vim.api.nvim_win_get_cursor(0) -- {row, col}
    local row = cursor[1] - 1 -- 0-indexed
    local col = cursor[2]

    -- Get the parser for the current buffer
    local parser = ts.get_parser(bufnr)
    if parser then
      -- Get the syntax tree
      local tree = parser:parse()[1]
      if tree then
        local root = tree:root()
        if root then
          -- Find the node at the cursor position
          local node = root:named_descendant_for_range(row, col, row, col)
          if node then
            -- Function to check if a node is an 'extract_operator'
            local is_extract_operator = function(n)
              return n and n:type() == "extract_operator" -- Adjust this to match your language's actual operator type
            end

            local is_namespace_operator = function(n)
              return n and n:type() == "namespace_operator" -- Adjust this to match your language's actual operator type
            end

            -- Traverse up the tree while the parent is an 'extract_operator'
            while node and is_extract_operator(node:parent()) do
              node = node:parent()
            end
            -- If the parent is a namespace_operator, node is parent
            if node and is_namespace_operator(node:parent()) then
              node = node:parent()
            end

            if node then
              -- Get the start and end positions of the node
              local start_row, start_col, end_row, end_col = node:range()

              -- Adjust end_row for single-line nodes
              if end_row == start_row then
                end_row = end_row + 1
              end

              -- Extract the text corresponding to the node
              local lines = vim.api.nvim_buf_get_lines(bufnr, start_row, end_row, false)
              if #lines == 0 then
                -- Fallback if no lines are retrieved
                vim.notify("Failed to retrieve lines using Tree-sitter; falling back to cword.", vim.log.levels.WARN)
                return vim.fn.expand "<cword>"
              end

              -- Handle single-line and multi-line nodes
              if #lines == 1 then
                return string.sub(lines[1], start_col + 1, end_col) -- Lua strings are 1-indexed
              else
                lines[1] = string.sub(lines[1], start_col + 1)
                lines[#lines] = string.sub(lines[#lines], 1, end_col)
                return table.concat(lines, "\n")
              end
            end
          end
        end
      end
    end

    -- If any of the above steps fail, notify and fallback
    vim.notify("Tree-sitter could not retrieve the word; falling back to cword.", vim.log.levels.WARN)
  else
    -- Tree-sitter not available
    vim.notify("Tree-sitter not available; using cword instead.", vim.log.levels.WARN)
  end

  -- Fallback to cword
  return vim.fn.expand "<cword>"
end
return M
