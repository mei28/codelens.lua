local M = {}

M.registered_texts = {}

local function get_namespace_id(bufnr, line_number)
  return M.registered_texts[bufnr] and M.registered_texts[bufnr][line_number] or nil
end

function M.clear_virtual_text(bufnr, line_number)
  local namespace_id = get_namespace_id(bufnr, line_number)
  if namespace_id then
    vim.api.nvim_buf_clear_namespace(bufnr, namespace_id, 0, -1) -- Clear from start to end of buffer
    M.registered_texts[bufnr][line_number] = nil
  end
end

function M.register_virtual_text(bufnr, line_number, text, highlight_group)
  -- Clear existing text if any
  M.clear_virtual_text(bufnr, line_number)

  -- Create a new namespace ID
  local namespace_id = vim.api.nvim_create_namespace("virtualtextmanager_" .. tostring(os.time()))

  -- Store the namespace ID for the buffer and line
  if not M.registered_texts[bufnr] then
    M.registered_texts[bufnr] = {}
  end
  M.registered_texts[bufnr][line_number] = namespace_id

  -- Set the virtual text for the buffer using the namespace ID
  vim.api.nvim_buf_set_virtual_text(bufnr, namespace_id, line_number - 2, { { text, highlight_group } }, {})
end

return M
