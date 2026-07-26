return { -- Python 格式化相关配置。
  {
    "stevearc/conform.nvim", -- 通用格式化插件。
    opts = { -- conform 选项。
      formatters_by_ft = { -- 按文件类型设置格式化器。
        python = { -- Python 文件。
          -- "ruff_fix", -- 可选：自动修复 Ruff 问题。
          -- "ruff_organize_imports", -- 可选：整理 import。
          "ruff_format", -- 只使用 Ruff 格式化。
        },
      },
    },
  },
}
