return 
  {
    "nvim-neo-tree/neo-tree.nvim",

    opts = {
      git_status = {
        symbols = {
          -- Change type
          added     = "✚", -- NOTE: you can set any of these to an empty string to not show them
          deleted   = "✖",
          modified  = "",
          renamed   = "✎",
          -- Status type
          untracked = "",
          ignored   = "",
          unstaged  = "8",
          staged    = "",
          conflict  = "",
        },
        align = "right",
      },
    },
  }
