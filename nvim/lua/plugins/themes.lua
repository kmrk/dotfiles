--return {
--
--  { "folke/tokyonight.nvim", name = "tokyonight" },
--  -- { "catppuccin/nvim", name = "catppuccin" },
--  -- { "ellisonleao/gruvbox.nvim" },
--  {
--    "LazyVim/LazyVim",
--    opts = {
--      --   colorscheme = "gruvbox",
--      --   colorscheme = "catppuccin",
--      colorscheme = "tokyonight",
--      style = "night",
--      ----style = "day", --"moon", -- "day" -- "night"
--    },
--  },
--}
return {
  "folke/tokyonight.nvim",
  lazy = true,
  opts = { style = "moon" },
}
