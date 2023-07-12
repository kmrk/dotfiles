return {
  {

    --"marko-cerovac/material.nvim",
    -- --"tanvirtin/monokai.nvim",
    "cpea2506/one_monokai.nvim",
    --"navarasu/onedark.nvim",
    opts = {
      transparent = false, -- true, -- enable transparent window
      colors = {
        lmao = "#282c34", -- add new color
        pink = "#ec6075", -- replace default color
      },
      themes = function(colors)
        -- change highlight of some groups,
        -- the key and value will be passed respectively to "nvim_set_hl"
        return {
          Delimiter = { fg = colors.light_gray },
          PmenuSel = { fg = colors.white, bg = colors.cyan:darken(0.7) },
          Error = { fg = colors.red, underline = true },
          ["@variable"] = { fg = colors.aqua },
        }
      end,
      italics = false, -- disable italics
    },
    -- "catppuccin/nvim",
  },
}

--
--return {
--  -- { "folke/tokyonight.nvim", name = "tokyonight" },
--  -- { "catppuccin/nvim", name = "catppuccin" },
--  -- { "ellisonleao/gruvbox.nvim" },
--  -- { "patstockwell/vim-monokai-tasty" },
--  -- {
--  --   "tanvirtin/monokai.nvim",
--  --   opts = {
--  --     transparent = true,
--  --     styles = {
--  --       sidebars = "transparent",
--  --       floats = "transparent",
--  --     },
--  --   },
--  -- },
--  -- {
--  --   "LazyVim/LazyVim",
--  --   opts = {
--  --     --colorscheme = "vim-monokai-tasty",
--  --     -- colorscheme = "gruvbox",
--  --     --colorscheme = "catppuccin",
--  --     colorscheme = "monokai",
--  --     --colorscheme = "tokyonight",
--  --     ----style = "day", --"moon", -- "day" -- "night"
--  --   },
--  -- },
--  --
--  {
--
--    -- "catppuccin/nvim",
--    --"ellisonleao/gruvbox.nvim",
--    --opts = {},
--    --"folke/tokyonight.nvim",
--    --
--    --"cpea2506/one_monokai.nvim",
--    "tanvirtin/monokai.nvim",
--    opts = {},
--    --
--    --
--    --
--    --#region
--    --"marko-cerovac/material.nvim",
--    --opts = function(_, opts)
--    --  vim.g.material_style = "palenight"
--    --  vim.cmd("colorscheme material")
--    --  opts.transparent = false
--    --end,
--
--    --style = "palenight", --"deep ocean",
--    --transparent = true, -- enable transparent window
--    --colors = {
--    --  lmao = "#ffffff", -- add new color
--    --  pink = "#ec6075", -- replace default color
--    -- },
--    -- themes = function(colors)
--    --   -- change highlight of some groups,
--    --   -- the key and value will be passed respectively to "nvim_set_hl"
--    --   return {
--    --     Normal = { bg = colors.lmao },
--    --     ErrorMsg = { fg = colors.pink, bg = "#ec6075", standout = true },
--    --     ["@lsp.type.keyword"] = { link = "@keyword" },
--    --  }
--    --end,
--
--    ----
--    --transparent = true,
--    --  style = "night", --"moon", -- "day" -- "night"
--    --[[styles = {
--        sidebars = "transparent",
--        floats = "transparent",
--      },]]
--    --},
--  },
--
--  --[[{
--    "rcarriga/nvim-notify",
--    opts = {
--      background_colour = "#000000",
--    },
--  },]]
--}
