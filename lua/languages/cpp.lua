local M = {}
M.pattern = {
  "[%w_:%*]+%s+%*?([%w_]+)%s*%([^%)]*%)",
  "class%s+([%w_]+)",
  "struct%s+([%w_]+)",
  "template%s*<.->%s*class%s+([%w_]+)",
  "template%s*<.->%s*[%w_:%*]+%s+%*?([%w_]+)%s*%([^%)]*%)",
}

return M
