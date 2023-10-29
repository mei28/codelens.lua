local M = {}

function M.show_references()
  local current_line = vim.api.nvim_win_get_cursor(0)[1]
  local bufnr = vim.api.nvim_get_current_buf()

  -- 現在のカーソル位置を基にパラメータを生成し、includeDeclarationを追加
  local params = vim.lsp.util.make_position_params()
  params.context = { includeDeclaration = false }

  -- カスタムコールバックで参照を取得
  vim.lsp.buf_request(bufnr, 'textDocument/references', params, function(err, result)
    if err then
      print("Error fetching references:", err.message)
      return
    end

    if not result then
      print("No references found")
      return
    end

    local reference_count = #result

    -- 現在の行の一つ上に参照数を表示
    vim.api.nvim_buf_set_virtual_text(0, -1, current_line - 2,
      { { reference_count .. " referenced", "Comment" } }, {})
  end)
end

return M

