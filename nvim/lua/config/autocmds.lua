vim.api.nvim_create_autocmd("TermOpen", {
  callback = function()
    vim.cmd("startinsert")
  end,
})

-- Disable line numbers in terminal
vim.api.nvim_create_autocmd("TermOpen", {
  callback = function()
    vim.cmd("setlocal nonumber norelativenumber")
  end,
})

-- Disable sign column in terminal
vim.api.nvim_create_autocmd("TermEnter", {
  callback = function()
    vim.cmd("setlocal signcolumn=no")
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "markdown", "txt" },
  callback = function()
    vim.opt_local.spell = false
  end,
})
