local M = {}

M.pattern = {
  "function!%s+([%w_:]+)",
  "function!%s+s:([%w_]+)",
  "function!%s+g:([%w_]+)"
}

return M
