local vim = vim or require("vim")

return {
  {
    "Mofiqul/vscode.nvim",
    opts = {
      style = "light",
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
}
