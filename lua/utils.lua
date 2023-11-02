local M = {}
-- 与えられた行の内容からシンボルを取得します。
function M.get_symbols_from_line(line_content, pattern)
  local symbols = {}
  for word in line_content:gmatch(pattern) do
    table.insert(symbols, word)
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
