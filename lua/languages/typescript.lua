local M = {}

M.pattern = {
  -- JavaScript & TypeScript patterns
  "function%s+([%w_]+)%s*%(",             -- 通常の関数宣言
  "(%w+)%s*=%s*function%s*%(",            -- 関数式
  "(%w+)%s*:%s*function%s*%(",            -- オブジェクトリテラル内のメソッド
  "(%w+)%s*=%s*%([^)]*%)%s*=>",           -- アロー関数
  "class%s+([%w_]+)",                     -- クラス宣言
  "class%s+%w+%s+extends%s+([%w_]+)",     -- クラス継承
  "(%w+)%s*%([^)]*%)%s*{",                -- ショートハンドメソッド定義
  "async%s+(%w+)%s*%([^)]*%)",            -- 非同期関数
  -- TypeScript specific patterns
  "public%s+(%w+)%s*%(",                  -- 公開メソッド
  "private%s+(%w+)%s*%(",                 -- 非公開メソッド
  "protected%s+(%w+)%s*%(",               -- 保護メソッド
  "static%s+(%w+)%s*%(",                  -- 静的メソッド
  "(%w+)%s*<[^>]+>%s*=%s*%([^)]*%)%s*=>", -- ジェネリックを含むアロー関数
}

return M
