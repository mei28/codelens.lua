local utils = require('utils')
local VirtualTextManager = require('VirtualTextManager')
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
    VirtualTextManager.register_virtual_text(bufnr, line_number - 2, text_to_display, "Comment")
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

function M.get_reference_count_for_symbol(bufnr, symbol, line_number, line_content)
  local symbol_start_position = line_content:find(symbol) - 1 or 0

  local params = {
    textDocument = vim.lsp.util.make_text_document_params(),
    position = { line = line_number - 1, character = symbol_start_position },
    context = { includeDeclaration = false }
  }


  local results = vim.lsp.buf_request_sync(bufnr, 'textDocument/references', params, 1000)

  for _, result in pairs(results or {}) do
    local resp = result.result
    if resp then
      return #resp
    end
  end

  return nil
end

function M.get_reference_info_for_line(bufnr, symbol, line_number, line_content)
  local reference_count = M.get_reference_count_for_symbol(bufnr, symbol, line_number, line_content)
  if reference_count == nil then return "Failed to get references" end
  return (reference_count == 0 and "Not" or tostring(reference_count)) .. " referenced"
end

return M
