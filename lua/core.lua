local M = {}
local languages = require('languages')
local references = require('references')

local function get_symbols_from_line(line_content, pattern)
  local symbols = {}
  for word in line_content:gmatch(pattern) do
    table.insert(symbols, word)
  end
  return symbols
end


local function is_lsp_connected()
  local lsp_clients = vim.lsp.buf_get_clients()
  if #lsp_clients == 0 then
    print("Error: No LSP client is connected.")
    return false
  end
  return true
end

local function get_language_config()
  local lang_config = languages.get_config_for_filetype(vim.bo.filetype)
  if not lang_config or not lang_config.pattern then
    print("Error: Language configuration for " .. vim.bo.filetype .. " is missing or incomplete.")
    return nil
  end
  return lang_config
end


function M.show_references_for_all_symbols()
  local bufnr = vim.api.nvim_get_current_buf()
  local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)

  if not is_lsp_connected() then return end

  local lang_config = get_language_config()
  if not lang_config then return end
  local pattern = lang_config.pattern or ""

  references.get_references_for_all_symbols(bufnr, lines, pattern)
end

return M
