local M = {}

M.configs = {
  python = require('languages.python')
}

function M.get_config_for_filetype(filetype)
  return M.configs[filetype] or {}
end

return M
