local utils = require('utils')
local M = {}


-- 各シンボルに対して参照情報を取得する関数
function M.process_symbol(bufnr, lines, symbol, line_number)
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
    local text_to_display = (reference_count == 0 and "Not" or reference_count) .. " referenced"
    local namespace_id = vim.api.nvim_create_namespace("codelens_" .. math.random())
    vim.api.nvim_buf_set_virtual_text(bufnr, namespace_id, line_number - 2,
      { { text_to_display, "Comment" } }, {})
  end)
end

function M.get_references_for_all_symbols(bufnr, lines, pattern)
  for line_number, line_content in ipairs(lines) do
    local symbols = utils.get_symbols_from_line(line_content, pattern)
    for _, symbol in pairs(symbols) do
      M.process_symbol(bufnr, lines, symbol, line_number)
    end
  end
end

return M
