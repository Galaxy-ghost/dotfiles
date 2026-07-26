return { -- UI 相关插件配置。
  {
    "nvim-lualine/lualine.nvim", -- 状态栏插件。
    opts = function(_, opts) -- 扩展 lualine 默认选项。
      opts.options = opts.options or {} -- 确保 options 表存在。
      opts.options.theme = "auto" -- 自动匹配当前主题。
      opts.options.always_divide_middle = false -- 不强制左右区域分隔。
      opts.options.component_separators = { left = "", right = "" } -- 去掉组件分隔符。
      opts.options.section_separators = { left = "", right = "" } -- 去掉区块分隔符。

      opts.sections = opts.sections or {} -- 确保 sections 表存在。

      opts.sections.lualine_b = { -- 左侧 Git 与诊断区。
        {
          "branch", -- 当前分支。
          icon = "", -- 分支图标。
          color = { fg = "#cba6f7", gui = "bold" }, -- 分支颜色。
        },
        {
          "diff", -- Git diff 统计。
          symbols = { -- diff 图标。
            added = " ", -- 新增。
            modified = " ", -- 修改。
            removed = " ", -- 删除。
          },
          diff_color = { -- diff 颜色。
            added = { fg = "#a6e3a1" }, -- 新增绿色。
            modified = { fg = "#f9e2af" }, -- 修改黄色。
            removed = { fg = "#f38ba8" }, -- 删除红色。
          },
        },
        {
          "diagnostics", -- LSP 诊断统计。
          symbols = { -- 诊断图标。
            error = " ", -- 错误。
            warn = " ", -- 警告。
            info = " ", -- 信息。
            hint = " ", -- 提示。
          },
        },
      }

      local function macro_recording() -- 显示正在录制的宏。
        local reg = vim.fn.reg_recording() -- 获取录制寄存器。
        if reg == "" then
          return "" -- 未录制时不显示。
        end
        return "󰑋 " .. reg -- 录制时显示图标和寄存器。
      end

      opts.sections.lualine_x = opts.sections.lualine_x or {} -- 与上面的防御保持一致。

      table.insert(opts.sections.lualine_x, 1, { -- 插入右侧宏录制状态。
        macro_recording, -- 状态栏组件函数。
        color = { fg = "#1e1e2e", bg = "#f38ba8", gui = "bold" }, -- 红底强调。
        separator = { left = "", right = "" }, -- 圆角分隔。
        padding = 0, -- 不额外留白。
      })
    end,
  },
}
