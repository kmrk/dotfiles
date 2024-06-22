if vim.g.vscode then -- do nothing config
else
  require("config.lazy")
  vim.g.FVimCursorSmoothMove = true
  vim.g.FVimCursorSmoothBlink = true
  vim.g.cursor_movement_animation = false
  vim.filetype.add({ extension = { purs = "purescript" } })
  local parser_config = require("nvim-treesitter.parsers").get_parser_configs()
  parser_config.fsharp = {
    install_info = {
      url = "https://github.com/Nsidorenco/tree-sitter-fsharp",
      branch = "develop",
      files = { "src/scanner.cc", "src/parser.c" },
      generate_requires_npm = true,
      requires_generate_from_grammar = true,
    },
    filetype = "fsharp",
  }
end
require("config.lazy")
