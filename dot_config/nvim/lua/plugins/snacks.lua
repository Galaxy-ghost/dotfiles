return { -- Snacks 插件扩展配置。
  {
    "folke/snacks.nvim", -- LazyVim 常用 UI/工具集合。
    opts = function(_, opts) -- 合并默认 Snacks 选项。
      require("plugins.snacks.dashboard")(opts) -- 单独加载 dashboard 配置。
    end,
  },
}
