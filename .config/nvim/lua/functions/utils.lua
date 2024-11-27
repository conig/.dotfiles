M = {}
M.get_word = function(use_cword)
  use_cword = use_cword or false
  -- Attempt to use Tree-sitter
  if use_cword then
    return vim.fn.expand "<cword>"
  end
  local ts = vim.treesitter
  if ts then
    -- Get the current buffer
    local bufnr = vim.api.nvim_get_current_buf()

    -- Get the node at the cursor position, considering language injections
    local node = vim.treesitter.get_node { ignore_injections = false }

    if node then
      -- vim.notify("Start node is: " .. node:type(), vim.log.levels.INFO)
      -- Function to check if a node is an 'extract_operator'
      local is_extract_operator = function(n)
        return n and n:type() == "extract_operator"
      end

      local is_namespace_operator = function(n)
        return n and n:type() == "namespace_operator"
      end

      -- Traverse up the tree while the parent is an 'extract_operator'
      while node and is_extract_operator(node:parent()) do
        node = node:parent()
        -- vim.notify("Parent node is: " .. node:type(), vim.log.levels.INFO)
      end

      -- If the parent is a namespace_operator, move up to that node
      if node and is_namespace_operator(node:parent()) then
        node = node:parent()
        -- vim.notify("Parent parent node is: " .. node:type(), vim.log.levels.INFO)
      end

      if node then
        -- vim.notify("Node is: " .. node:type(), vim.log.levels.INFO)
        -- Get the start and end positions of the node
        local start_row, start_col, end_row, end_col = node:range()

        -- Extract the text corresponding to the node
        local lines = vim.api.nvim_buf_get_lines(bufnr, start_row, end_row + 1, false)
        if #lines == 0 then
          -- Fallback if no lines are retrieved
          vim.notify("Failed to retrieve lines using Tree-sitter; falling back to cword.", vim.log.levels.WARN)
          return vim.fn.expand "<cword>"
        end

        -- Handle single-line and multi-line nodes
        if #lines == 1 then
          return string.sub(lines[1], start_col + 1, end_col)
        else
          lines[1] = string.sub(lines[1], start_col + 1)
          lines[#lines] = string.sub(lines[#lines], 1, end_col)
          return table.concat(lines, "\n")
        end
      end
    else
      -- vim.notify("No node found at cursor position; falling back to cword.", vim.log.levels.WARN)
      return vim.fn.expand "<cword>"
    end
  else
    vim.notify("Tree-sitter not available; using cword instead.", vim.log.levels.WARN)
  end

  -- Fallback to cword
  return vim.fn.expand "<cword>"
end
return M
