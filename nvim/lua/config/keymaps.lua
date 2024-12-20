local function map(mode, lhs, rhs, opts)
  local keys = require("lazy.core.handler").handlers.keys
  ---@cast keys LazyKeysHandler
  -- do not create the keymap if a lazy keys handler exists
  if not keys.active[keys.parse({ lhs, mode = mode }).id] then
    opts = opts or {}
    opts.silent = opts.silent ~= false
    if opts.remap and not vim.g.vscode then
      opts.remap = nil
    end
    vim.keymap.set(mode, lhs, rhs, opts)
  end
end

vim.opt_local.spell = false


vim.keymap.set("i", "<C-x>", "<Nop>", { noremap = true, silent = true })
map({ "n", "i", "v" }, "<C-x><C-s>", "<cmd>update<cr><esc>", { desc = "Emacs style save" })
map({ "n" }, "<leader>_", "<cmd>10split<cr>", { desc = "Splite H keep same keyseq with Vertical" })
