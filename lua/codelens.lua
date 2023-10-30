local M = {}

local function get_symbols_from_line(line_content)
  -- この関数で行からシンボルを取得する。例として単語を取得している。
  -- 必要に応じてパターンを変更すること。
  local symbols = {}
  local pattern = "def%s+([a-zA-Z_][a-zA-Z0-9_]*)%s*%("
  for word in line_content:gmatch(pattern) do
    table.insert(symbols, word)
  end
  return symbols
end


function M.show_references_for_all_symbols()
  local bufnr = vim.api.nvim_get_current_buf() -- ここでバッファ番号を取得
  local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)

  local function process_symbol(symbol, line_number)
    local line_content = lines[line_number]
    local params = {
      textDocument = vim.lsp.util.make_text_document_params(),
      position = { line = line_number - 1, character = line_content:find(symbol) - 1 },
      context = { includeDeclaration = false }
    }

    vim.lsp.buf_request(bufnr, 'textDocument/references', params, function(err, result)
      if err then
        print("Error fetching references:", err.message)
        return
      end

      if not result then
        return
      end

      local reference_count = #result
      print(reference_count .. " references found for symbol " .. symbol)
      print("bufnr: " .. bufnr)
      print("line_number: " .. line_number)


      local namespace_id = vim.api.nvim_create_namespace("codelens_" .. math.random())
      vim.api.nvim_buf_set_virtual_text(bufnr, namespace_id, line_number - 2,
        { { reference_count .. " referenced", "Comment" } }, {})
    end)
  end

  for line_number, line_content in ipairs(lines) do
    local symbols = get_symbols_from_line(line_content)
    for _, symbol in pairs(symbols) do
      process_symbol(symbol, line_number)
    end
  end
end

return M
