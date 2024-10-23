return {
  -- Racket 语法高亮与基本功能
  {
    "wlangstroth/vim-racket",
    ft = "racket", -- 仅在 Racket 文件类型时加载
  },

  -- Neovim 的 Racket REPL 插件

  -- Racket LSP 配置
  {
    "neovim/nvim-lspconfig",
    config = function()
      require("lspconfig").racket_langserver.setup({})
    end,
  },
}
