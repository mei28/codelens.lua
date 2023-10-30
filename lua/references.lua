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
    local namespace_id = vim.api.nvim_create_namespace("codelens_" .. math.random())
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

function M.get_reference_info_for_line(bufnr, line_number, pattern)
  local filename = vim.fn.expand('%:p') -- 現在のファイルの絶対パスを取得
  local line_content = vim.api.nvim_buf_get_lines(bufnr, line_number - 1, line_number, false)[1]
  local symbols = utils.get_symbols_from_line(line_content, pattern)

  if not symbol then return nil end

  local params = {
    textDocument = vim.lsp.util.make_text_document_params(),
    position = { line = line_number - 1, character = line_content:find(symbol) - 1 },
    context = { includeDeclaration = false }
  }

  local reference_count
  vim.lsp.buf_request_sync(bufnr, 'textDocument/references', params, 1)
  for _, resp in pairs(vim.lsp.buf_get_clients(bufnr)) do
    if resp and resp.result then
      reference_count = #resp.result
    end
  end

  if not reference_count then return nil end
  return (reference_count == 0 and "Not" or reference_count) .. " referenced"
end

return M
