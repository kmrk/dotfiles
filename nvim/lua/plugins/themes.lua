local vim = vim or require("vim")

return {
  {
    "kdheepak/monochrome.nvim",
    config = function()
      vim.cmd.colorscheme("monochrome")
      vim.opt.background = "light"
      vim.cmd([[highlight Normal guibg=#f9f9f9]])
      vim.cmd([[ highlight MatchParen cterm=bold ctermbg=cyan ctermfg=black guibg=cyan guifg=black]])
    end,
  },
  { "projekt0n/github-nvim-theme" },
  {
    "sainnhe/sonokai",
    priority = 1000,

    config = function()
      vim.g.sonokai_enable_italic = false
      vim.g.sonokai_dim_inactive_windows = true
      -- vim.g.sonokai_style = "atlantis"
      vim.g.sonokai_style = "maia"

      --vim.g.sonokai_style = "shusia"
      --vim.g.sonokai_style = "andromeda"
      --vim.g.sonokai_style = "espresso"
      --vim.cmd.colorscheme("github_light_tritanopia")
    end,
  },
}
