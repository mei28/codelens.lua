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

function M.get_word_under_cursor()
  local col = M.get_win_cursor()[2] + 1
  local line = vim.api.nvim_get_current_line()
  local start_col = line:sub(1, col):find("%f[%w_]%w*$")
  if not start_col then
    start_col = 1
  end
  local end_col = line:find("%f[%W_]", col) or (#line + 1)

  local word = line:sub(start_col, end_col - 1)
  return word, start_col, end_col
end

function M.get_win_cursor()
  return vim.api.nvim_win_get_cursor(0)
end

return M
