return {
  {
    "knubie/vim-kitty-navigator",
    lazy = false,
    init = function()
      -- 关闭插件默认的 Ctrl-h/j/k/l 映射
      vim.g.kitty_navigator_no_mappings = 1

      -- 只有你真的想在 stacked layout 里也能跳隐藏窗口时再开
      -- vim.g.kitty_navigator_enable_stack_layout = 1
    end,
    config = function()
      local map = vim.keymap.set
      local opts = { noremap = true, silent = true }

      map("n", "<A-h>", "<Cmd>KittyNavigateLeft<CR>", opts)
      map("n", "<A-j>", "<Cmd>KittyNavigateDown<CR>", opts)
      map("n", "<A-k>", "<Cmd>KittyNavigateUp<CR>", opts)
      map("n", "<A-l>", "<Cmd>KittyNavigateRight<CR>", opts)
    end,
  },
}