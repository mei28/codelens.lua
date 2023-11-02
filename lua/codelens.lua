local M = {}
local core = require('core')
local VirtualTextManager = require('VirtualTextManager')

M.core = require('core')
M.git = require('git')
M.languages = require('languages.init')

local config = {
  show_git = true,
  show_references = true,
  is_enabled = false
}

function M.setup(opts)
  config.show_git = opts.show_git or config.show_git
  config.show_references = opts.show_references or config.show_references
end

local function update_display()
  if config.is_enabled then
    M.show_all_info()
  else
    M.clear_info()
  end
end

function M.enable()
  config.is_enabled = true
  update_display()
end

function M.disable()
  config.is_enabled = false
  update_display()
end

function M.toggle()
  config.is_enabled = not config.is_enabled
  update_display()
end

function M.show_all_info()
  if not config.is_enabled then return end
  core.show_info_for_all_symbols(config)
  config.is_enabled = true
end

function M.clear_info()
  local bufnr = vim.api.nvim_get_current_buf()
  local line_count = vim.api.nvim_buf_line_count(bufnr)
  for i = 1, line_count do
    VirtualTextManager.clear_virtual_text(bufnr, i)
  end
  config.is_enabled = false
end

return M
