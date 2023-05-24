return {
  -- { "folke/tokyonight.nvim", name = "tokyonight" },
  -- { "catppuccin/nvim", name = "catppuccin" },
  -- { "ellisonleao/gruvbox.nvim" },
  -- { "patstockwell/vim-monokai-tasty" },
  -- {
  --   "tanvirtin/monokai.nvim",
  --   opts = {
  --     transparent = true,
  --     styles = {
  --       sidebars = "transparent",
  --       floats = "transparent",
  --     },
  --   },
  -- },
  -- {
  --   "LazyVim/LazyVim",
  --   opts = {
  --     --colorscheme = "vim-monokai-tasty",
  --     -- colorscheme = "gruvbox",
  --     --colorscheme = "catppuccin",
  --     colorscheme = "monokai",
  --     --colorscheme = "tokyonight",
  --     --style = "moon",
  --     ----style = "day", --"moon", -- "day" -- "night"
  --   },
  -- },
  --
  {

    -- "catppuccin/nvim",
    -- "ellisonleao/gruvbox.nvim",
    -- "folke/tokyonight.nvim",
    "tanvirtin/monokai.nvim",
    opts = {
      transparent = true,
      styles = {
        sidebars = "transparent",
        floats = "transparent",
      },
    },
  },

  {
    "rcarriga/nvim-notify",
    opts = {
      background_colour = "#000000",
    },
  },
}
