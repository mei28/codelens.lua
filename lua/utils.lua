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


return M
