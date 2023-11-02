local M = {}
M.pattern = {
  "fn%s+([%w_]+)%s*%(",
  "struct%s+([%w_]+)",
  "fn%s+([%w_]+)%s*%(",
  "trait%s+([%w_]+)"
}

return M
