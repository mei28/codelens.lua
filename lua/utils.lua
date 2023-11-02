local M = {}
-- 与えられた行の内容からシンボルを取得します。
function M.get_symbols_from_line(line_content, pattern)
  local symbols = {}
  local unique_symbols = {}
  for _, p in ipairs(pattern) do
    for word in line_content:gmatch(p) do
      if not unique_symbols[word] then
        unique_symbols[word] = true
        table.insert(symbols, word)
      end
    end
  end
  return symbols
end

function M.is_lsp_connected()
  local lsp_clients = vim.lsp.buf_get_clients()
  if #lsp_clients == 0 then
    print("Error: No LSP client is connected.")
    return false
  end
  return true
end

function M.get_current_line_number()
  return vim.api.nvim_win_get_cursor(0)[1]
end

function M.get_current_buf()
  return vim.api.nvim_get_current_buf()
end

function M.get_lines_from_buf()
  local bufnr = M.get_current_buf()
  return vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
end

return M
