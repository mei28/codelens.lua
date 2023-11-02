local utils = require('utils')
local VirtualTextManager = require('VirtualTextManager')
local M = {}

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
  if reference_count == nil then reference_count = 0 end
  return (reference_count == 0 and "Not" or tostring(reference_count)) .. " referenced"
end

return M
