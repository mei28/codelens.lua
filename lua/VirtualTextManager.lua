local M = {}

M.registered_texts = {}

function M.clear_virtual_text(bufnr, line_number)
  if M.registered_texts[bufnr] and M.registered_texts[bufnr][line_number] then
    vim.api.nvim_buf_clear_namespace(bufnr, M.registered_texts[bufnr][line_number], line_number - 1, line_number)
    local namespace_id = M.registered_texts[bufnr][line_number]
    vim.api.nvim_buf_set_virtual_text(bufnr, namespace_id, line_number - 2, { { '', 'Comment' } }, {})
    M.registered_texts[bufnr][line_number] = nil
  end
end

function M.register_virtual_text(bufnr, line_number, text, highlight_group)
  if not M.registered_texts[bufnr] then
    M.registered_texts[bufnr] = {}
  end

  M.clear_virtual_text(bufnr, line_number)
  local namespace_id = vim.api.nvim_create_namespace("virtualtextmanager_" .. math.random())
  M.registered_texts[bufnr][line_number] = namespace_id
  vim.api.nvim_buf_set_virtual_text(bufnr, namespace_id, line_number - 2, { { text, highlight_group } }, {})
end

return M
