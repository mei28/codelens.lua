local M = {}
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

function M.get_word_under_cursor()
  local col = M.get_win_cursor()[2] + 1
  local line = vim.api.nvim_get_current_line()

  -- 単語の左側の境界を探す
  local start_col = col
  while start_col > 0 and not line:sub(start_col, start_col):match("[%s.,=%[%]{}\"'`()<>:]") do
    start_col = start_col - 1
  end
  start_col = start_col + 1

  -- 単語の右側の境界を探す
  local end_col = col + 1
  while end_col <= #line and not line:sub(end_col, end_col):match("[%s.,=%[%]{}\"'`()<>:]") do
    end_col = end_col + 1
  end

  local word = line:sub(start_col, end_col - 1)
  return word, start_col, end_col
end

function M.get_win_cursor()
  return vim.api.nvim_win_get_cursor(0)
end

return M
