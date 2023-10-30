local utils = require('utils')
local M = {}

local function relative_to_seconds(unit, value)
  local units_in_seconds = {
    year = 365 * 24 * 60 * 60,
    month = 30 * 24 * 60 * 60,
    week = 7 * 24 * 60 * 60,
    day = 24 * 60 * 60,
    hour = 60 * 60,
    minute = 60,
    second = 1
  }

  return value * (units_in_seconds[unit] or 0)
end

local function date_to_relative(date)
  local current_time = os.time()
  local given_time = os.time { year = date:sub(1, 4), month = date:sub(6, 7), day = date:sub(9, 10) }
  local diff_in_seconds = current_time - given_time

  local units = { "year", "month", "week", "day", "hour", "minute", "second" }
  for _, unit in ipairs(units) do
    local unit_in_seconds = relative_to_seconds(unit, 1)
    if diff_in_seconds >= unit_in_seconds then
      local value = math.floor(diff_in_seconds / unit_in_seconds)
      return string.format("%d %s%s ago", value, unit, value > 1 and "s" or "")
    end
  end
  return "just now"
end

local function get_git_blame_info(filename, line_number)
  local cmd = string.format("git blame -L %d,%d -- %s", line_number, line_number, filename)
  local result = vim.fn.system(cmd)

  -- 正規表現のパターンを調整して、authorと日付情報を取得
  local pattern = "^.-%(([^%)]+)%s(%d%d%d%d%-%d%d%-%d%d)"
  local author, date = result:match(pattern)

  -- nilチェック
  if not author or not date then
    print("Error: Unable to extract git blame info.")
    return nil, nil
  end

  return author, date
end

function M.show_git_info_for_current_line()
  local bufnr = vim.api.nvim_get_current_buf()
  local filename = vim.fn.expand('%:p') -- 現在のファイルの絶対パスを取得
  local line_number = vim.fn.line('.')  -- 現在の行番号を取得

  local author, date = get_git_blame_info(filename, line_number)
  if not author or not date then return end

  local relative_date = date_to_relative(date)
  -- local message = string.format("Last edited by %s %s", author, relative_date)
  local message = string.format("%s, %s", author, relative_date)
  print(message)
end

function M.get_git_info_for_all_symbols(bufnr, lines, pattern)
  for line_number, line_content in ipairs(lines) do
    local symbols = utils.get_symbols_from_line(line_content, pattern)
    for _, symbol in ipairs(symbols) do
      local author, date = get_git_blame_info(vim.fn.expand('%:p'), line_number)
      if author and date then
        local relative_date = date_to_relative(date)
        local text_to_display = string.format("%s, %s", author, relative_date)

        local namespace_id = vim.api.nvim_create_namespace("gitblame_" .. math.random())
        vim.api.nvim_buf_set_virtual_text(bufnr, namespace_id, line_number - 2, { { text_to_display, "Comment" } }, {})
      end
    end
  end
end

return M
