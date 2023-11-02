local M = {}
local languages = require('languages')
local references = require('references')
local git = require('git')
local utils = require('utils')
local VirtualTextManager = require('VirtualTextManager')

local function get_all_info_for_line(bufnr, line_number, symbol, line_content)
  local git_info = git.get_git_info_for_line(bufnr, line_number)
  local reference_info = references.get_reference_info_for_line(bufnr, symbol, line_number, line_content)


  return git_info, reference_info
end

local function get_language_config()
  local lang_config = languages.get_config_for_filetype(vim.bo.filetype)
  if not lang_config or not lang_config.pattern then
    print("Error: Language configuration for " .. vim.bo.filetype .. " is missing or incomplete.")
    return nil
  end
  return lang_config
end


function M.show_info_for_all_symbols(config)
  if not config.is_enabled then return end

  local bufnr = utils.get_current_buf()
  local lines = utils.get_lines_from_buf()
  local lang_config = get_language_config()
  if not lang_config then return end

  for line_number, line_content in ipairs(lines) do
    VirtualTextManager.clear_virtual_text(bufnr, line_number)
    local symbols = utils.get_symbols_from_line(line_content, lang_config.pattern)
    for _, symbol in pairs(symbols) do
      local combined_info = "🔍 "

      if config.show_git then
        local git_info = git.get_git_info_for_line(bufnr, line_number)
        combined_info = combined_info .. (git_info or "Unknown Git Info")
      end

      if config.show_references then
        local reference_info = references.get_reference_info_for_line(bufnr, symbol, line_number, line_content)
        combined_info = combined_info .. " | " .. (reference_info or "Unknown Reference Info")
      end

      VirtualTextManager.register_virtual_text(bufnr, line_number, combined_info, "Comment")
    end
  end
end

function M.show_info_for_word_under_cursor(config)
  local bufnr = vim.api.nvim_get_current_buf()
  local symbol, start_col, end_col = utils.get_word_under_cursor()
  local line_number = vim.api.nvim_win_get_cursor(0)[1]
  if not symbol then return end

  -- バーチャルテキストをクリアする
  VirtualTextManager.clear_virtual_text(bufnr, line_number)

  -- 言語の設定を取得する
  local lang_config = get_language_config()
  if not lang_config then return end


  local combined_info = "🔍 [" .. symbol .. "] "
  -- 参照情報を取得して結合する
  if config.show_references then
    local lines = utils.get_lines_from_buf()
    local line_content = lines[line_number]
    local reference_info = references.get_reference_info_for_line(bufnr, symbol, line_number, line_content)
    combined_info = combined_info  .. (reference_info or "Unknown Reference Info")
  end

  -- バーチャルテキストとして情報を登録する
  VirtualTextManager.register_virtual_text(bufnr, line_number, combined_info, "Comment")
end

return M
