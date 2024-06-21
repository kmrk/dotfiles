local vim = vim or require("vim")

return {
  {
    "Mofiqul/vscode.nvim",
    opts = {
      style = "light",
      transparent = false, --true,
      color_overrides = {
        vscBack = "#fafafa",
        vscPopupBack = "#f3f3f3",
      },
    },
  },
  {
    "sainnhe/sonokai",
    priority = 1000,
    config = function()
      vim.g.sonokai_enable_italic = false
      vim.g.sonokai_style = "atlantis"
      vim.cmd.colorscheme("sonokai")
    end,
  },
  {
    "comfysage/evergarden",
    priority = 1000, -- Colorscheme plugin is loaded first before any other plugins
    opts = {
      transparent_background = false, --true,
      contrast_dark = "medium", -- 'hard'|'medium'|'soft'
      overrides = {}, -- add custom overrides
    },
  },
  { "jacoborus/tender.vim" },
}
