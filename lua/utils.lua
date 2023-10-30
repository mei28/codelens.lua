local M = {}
-- 与えられた行の内容からシンボルを取得します。
function M.get_symbols_from_line(line_content, pattern)
  local symbols = {}
  for word in line_content:gmatch(pattern) do
    table.insert(symbols, word)
  end
  return symbols
end

return M
