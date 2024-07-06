local vim = vim or require("vim")

return {
  {
    "Mofiqul/vscode.nvim",
    opts = {
      style = "light",
      transparent = false, --true,
      color_overrides = {
        vscBack = "#f9f9f9",
        vscPopupBack = "#e8e8e8",
        vscSplitDark = "#6699cc",
      },
    },
  },
  {
    "sainnhe/sonokai",
    priority = 1000,

    config = function()
      vim.g.sonokai_enable_italic = false
      vim.g.sonokai_dim_inactive_windows = true
      --vim.g.sonokai_style = "atlantis"
      vim.g.sonokai_style = "maia"
      --vim.g.sonokai_style = "shusia"
      --vim.g.sonokai_style = "andromeda"
      --vim.g.sonokai_style = "espresso"
      vim.cmd.colorscheme("vscode")
    end,
  },
  { "Shatur/neovim-ayu" },
  { "joshdick/onedark.vim" },
  {
    "uloco/bluloco.nvim",
    lazy = false,
    priority = 1000,
    dependencies = { "rktjmp/lush.nvim" },
    config = function()
      -- your optional config goes here, see below.
    end,
  },
}
