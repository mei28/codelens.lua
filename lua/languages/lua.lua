local M = {}

M.pattern = {
  "function%s+([%w_]+)",
  "local%s+function%s+([%w_]+)",
  "local%s+([%w_]+)%s*=%s*function"
}
return M
