if vim.o.background == 'dark' then
  local s = {
    guishade0 = "#282629",
    guishade1 = "#474247",
    guishade2 = "#656066",
    guishade3 = "#847E85",
    guishade4 = "#A29DA3",
    guishade5 = "#C1BCC2",
    guishade6 = "#E0DCE0",
    guishade7 = "#FFFCFF",
    guiaccent0 = "#FF4050",
    guiaccent1 = "#F28144",
    guiaccent2 = "#FFD24A",
    guiaccent3 = "#A4CC35",
    guiaccent4 = "#26C99E",
    guiaccent5 = "#66BFFF",
    guiaccent6 = "#CC78FA",
    guiaccent7 = "#F553BF",
    ctermshade0 = 59,
    ctermshade1 = 59,
    ctermshade2 = 102,
    ctermshade3 = 139,
    ctermshade4 = 145,
    ctermshade5 = 188,
    ctermshade6 = 188,
    ctermshade7 = 231,
    ctermaccent0 = 204,
    ctermaccent1 = 215,
    ctermaccent2 = 221,
    ctermaccent3 = 149,
    ctermaccent4 = 79,
    ctermaccent5 = 117,
    ctermaccent6 = 177,
    ctermaccent7 = 212
  }
elseif vim.o.background == 'light' then
  local s = {
    guishade0 = "#FFFCFF",
    guishade1 = "#E0DCE0",
    guishade2 = "#C1BCC2",
    guishade3 = "#A29DA3",
    guishade4 = "#847E85",
    guishade5 = "#656066",
    guishade6 = "#474247",
    guishade7 = "#666666",
    guiaccent0 = "#000000",
    guiaccent1 = "#190900",
    guiaccent2 = "#5E5E5E",
    guiaccent3 = "#474247",
    guiaccent4 = "#615900",
    guiaccent5 = "#000000",
    guiaccent6 = "#121212",
    guiaccent7 = "#333333",
    ctermshade0 = 231,
    ctermshade1 = 188,
    ctermshade2 = 188,
    ctermshade3 = 145,
    ctermshade4 = 139,
    ctermshade5 = 102,
    ctermshade6 = 59,
    ctermshade7 = 241,
    ctermaccent0 = 16,
    ctermaccent1 = 16,
    ctermaccent2 = 240,
    ctermaccent3 = 59,
    ctermaccent4 = 100,
    ctermaccent5 = 16,
    ctermaccent6 = 233,
    ctermaccent7 = 236
  }
end

vim.cmd('highlight clear')
vim.cmd('syntax reset')
vim.g.colors_name = "ThemerMyColorSet"

-- Normal highlight
vim.cmd('highlight Normal guifg=' .. s.guishade6 .. ' guibg=' .. s.guishade0)
vim.cmd('highlight Normal ctermfg=' .. s.ctermshade6 .. ' ctermbg=' .. s.ctermshade0)

-- Syntax groups
vim.cmd('highlight Comment guifg=' .. s.guishade2)
vim.cmd('highlight Comment ctermfg=' .. s.ctermshade2)
vim.cmd('highlight Constant guifg=' .. s.guiaccent3)
vim.cmd('highlight Constant ctermfg=' .. s.ctermaccent3)
vim.cmd('highlight Character guifg=' .. s.guiaccent4)
vim.cmd('highlight Character ctermfg=' .. s.ctermaccent4)
vim.cmd('highlight Identifier guifg=' .. s.guiaccent2 .. ' gui=none')
vim.cmd('highlight Identifier ctermfg=' .. s.ctermaccent2 .. ' cterm=none')
vim.cmd('highlight Statement guifg=' .. s.guiaccent5)
vim.cmd('highlight Statement ctermfg=' .. s.ctermaccent5)
vim.cmd('highlight PreProc guifg=' .. s.guiaccent6)
vim.cmd('highlight PreProc ctermfg=' .. s.ctermaccent6)
vim.cmd('highlight Type guifg=' .. s.guiaccent7)
vim.cmd('highlight Type ctermfg=' .. s.ctermaccent7)
vim.cmd('highlight Special guifg=' .. s.guiaccent4)
vim.cmd('highlight Special ctermfg=' .. s.ctermaccent4)
vim.cmd('highlight Underlined guifg=' .. s.guiaccent5)
vim.cmd('highlight Underlined ctermfg=' .. s.ctermaccent5)
vim.cmd('highlight Error guifg=' .. s.guiaccent0 .. ' guibg=' .. s.guishade1)
vim.cmd('highlight Error ctermfg=' .. s.ctermaccent0 .. ' ctermbg=' .. s.ctermshade1)
vim.cmd('highlight Todo guifg=' .. s.guiaccent0 .. ' guibg=' .. s.guishade1)
vim.cmd('highlight Todo ctermfg=' .. s.ctermaccent0 .. ' ctermbg=' .. s.ctermshade1)
vim.cmd('highlight Function guifg=' .. s.guiaccent1)
vim.cmd('highlight Function ctermfg=' .. s.ctermaccent1)

-- GitGutter
vim.cmd('highlight GitGutterAdd guifg=' .. s.guiaccent3)
vim.cmd('highlight GitGutterAdd ctermfg=' .. s.ctermaccent3)
vim.cmd('highlight GitGutterChange guifg=' .. s.guiaccent2)
vim.cmd('highlight GitGutterChange ctermfg=' .. s.ctermaccent2)
vim.cmd('highlight GitGutterChangeDelete guifg=' .. s.guiaccent2)
vim.cmd('highlight GitGutterChangeDelete ctermfg=' .. s.ctermaccent2)
vim.cmd('highlight GitGutterDelete guifg=' .. s.guiaccent0)
vim.cmd('highlight GitGutterDelete ctermfg=' .. s.ctermaccent0)

-- fugitive
vim.cmd('highlight gitcommitComment guifg=' .. s.guishade3)
vim.cmd('highlight gitcommitComment ctermfg=' .. s.ctermshade3)
vim.cmd('highlight gitcommitOnBranch guifg=' .. s.guishade3)
vim.cmd('highlight gitcommitOnBranch ctermfg=' .. s.ctermshade3)
vim.cmd('highlight gitcommitHeader guifg=' .. s.guishade5)
vim.cmd('highlight gitcommitHeader ctermfg=' .. s.ctermshade5)
vim.cmd('highlight gitcommitHead guifg=' .. s.guishade3)
vim.cmd('highlight gitcommitHead ctermfg=' .. s.ctermshade3)
vim.cmd('highlight gitcommitSelectedType guifg=' .. s.guiaccent3)
vim.cmd('highlight gitcommitSelectedType ctermfg=' .. s.ctermaccent3)
vim.cmd('highlight gitcommitSelectedFile guifg=' .. s.guiaccent3)
vim.cmd('highlight gitcommitSelectedFile ctermfg=' .. s.ctermaccent3)
vim.cmd('highlight gitcommitDiscardedType guifg=' .. s.guiaccent2)
vim.cmd('highlight gitcommitDiscardedType ctermfg=' .. s.ctermaccent2)
vim.cmd('highlight gitcommitDiscardedFile guifg=' .. s.guiaccent2)
vim.cmd('highlight gitcommitDiscardedFile ctermfg=' .. s.ctermaccent2)
vim.cmd('highlight gitcommitUntrackedFile guifg=' .. s.guiaccent0)
vim.cmd('highlight gitcommitUntrackedFile ctermfg=' .. s.ctermaccent0)

-- Highlighting Groups
vim.cmd('highlight ColorColumn guibg=' .. s.guishade1)
vim.cmd('highlight ColorColumn ctermbg=' .. s.ctermshade1)
vim.cmd('highlight Conceal guifg=' .. s.guishade2)
vim.cmd('highlight Conceal ctermfg=' .. s.ctermshade2)
vim.cmd('highlight Cursor guifg=' .. s.guishade0)
vim.cmd('highlight Cursor ctermfg=' .. s.ctermshade0)
vim.cmd('highlight CursorColumn guibg=' .. s.guishade1)
vim.cmd('highlight CursorColumn ctermbg=' .. s.ctermshade1)
vim.cmd('highlight CursorLine guibg=' .. s.guishade1)
vim.cmd('highlight CursorLine ctermbg=' .. s.ctermshade1 .. ' cterm=none')
vim.cmd('highlight Directory guifg=' .. s.guiaccent5)
vim.cmd('highlight Directory ctermfg=' .. s.ctermaccent5)
vim.cmd('highlight DiffAdd guifg=' .. s.guiaccent3 .. ' guibg=' .. s.guishade1)
vim.cmd('highlight DiffAdd ctermfg=' .. s.ctermaccent3 .. ' ctermbg=' .. s.ctermshade1)
vim.cmd('highlight DiffChange guifg=' .. s.guiaccent2 .. ' guibg=' .. s.guishade1)
vim.cmd('highlight DiffChange ctermfg=' .. s.ctermaccent2 .. ' ctermbg=' .. s.ctermshade1)
vim.cmd('highlight DiffDelete guifg=' .. s.guiaccent0 .. ' guibg=' .. s

