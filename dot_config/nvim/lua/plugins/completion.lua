return { -- 补全插件配置。
  {
    "saghen/blink.cmp", -- blink.cmp 补全引擎。

    dependencies = { -- 补全相关依赖。
      "fang2hou/blink-copilot", -- 把 Copilot 接入 blink.cmp。
    },

    opts = function(_, opts) -- 合并 blink.cmp 选项。
      opts.keymap = opts.keymap or {} -- 确保 keymap 表存在。
      opts.appearance = opts.appearance or {} -- 确保外观表存在。
      opts.sources = opts.sources or {} -- 确保补全源表存在。
      opts.sources.providers = opts.sources.providers or {} -- 确保 provider 表存在。
      opts.completion = opts.completion or {} -- 确保补全菜单表存在。
      opts.signature = opts.signature or {} -- 确保签名帮助表存在。

      ----------------------------------------------------------------------
      -- Helpers：小工具函数。
      ----------------------------------------------------------------------

      local function in_comment() -- 判断光标是否在注释里。
        local ok, node = pcall(vim.treesitter.get_node) -- 安全获取当前 Treesitter 节点。

        if not ok or not node then
          return false -- 没有节点就当作非注释。
        end

        while node do
          local node_type = node:type() -- 当前节点类型。

          if node_type == "comment" or node_type == "line_comment" or node_type == "block_comment" then
            return true -- 命中注释节点。
          end

          node = node:parent() -- 继续检查父节点。
        end

        return false -- 没找到注释节点。
      end

      ----------------------------------------------------------------------
      -- Keymaps：补全菜单按键。
      ----------------------------------------------------------------------

      opts.keymap = vim.tbl_deep_extend("force", opts.keymap, { -- 覆盖/补充默认按键。
        -- 不覆盖 preset：LazyVim 已设为 "enter"，其中 <CR> = { accept, fallback }。

        ["<C-n>"] = { "select_next", "fallback" }, -- 选择下一项。
        ["<C-p>"] = { "select_prev", "fallback" }, -- 选择上一项。

        ["<C-d>"] = { "scroll_documentation_down", "fallback" }, -- 文档向下滚动。
        ["<C-u>"] = { "scroll_documentation_up", "fallback" }, -- 文档向上滚动。

        -- Tab：菜单可见时接受补全，否则跳到下一个 snippet 占位符（preset 原本的行为）。
        ["<Tab>"] = { "accept", "snippet_forward", "fallback" },

        ["<S-CR>"] = { -- Shift+Enter：关闭菜单再换行。
          "hide", -- 先隐藏补全菜单。
          "fallback", -- 再执行默认行为。
        },
      })

      ----------------------------------------------------------------------
      -- Appearance：补全外观。
      ----------------------------------------------------------------------

      opts.appearance = vim.tbl_deep_extend("force", opts.appearance, { -- 合并外观配置。
        nerd_font_variant = "normal", -- 使用普通 Nerd Font 图标。

        kind_icons = { -- 自定义类型图标。
          Copilot = " ", -- Copilot 图标。
        },
      })

      ----------------------------------------------------------------------
      -- Sources：补全来源。
      ----------------------------------------------------------------------

      opts.sources.default = function() -- 动态决定补全源。
        if in_comment() then
          return { "buffer" } -- 注释里只用 buffer，避免 Copilot/LSP 刷屏。
        end

        return { -- 正常代码区补全顺序。
          "copilot", -- AI 建议。
          "lsp", -- 语言服务器。
          "path", -- 文件路径。
          "snippets", -- 代码片段。
          "buffer", -- 当前缓冲区文本。
        }
      end

      opts.sources.providers.copilot = { -- Copilot 补全源。
        name = "copilot", -- 源名称。
        module = "blink-copilot", -- provider 模块。

        score_offset = 100, -- 提高 Copilot 排序权重。

        async = true, -- 异步请求，避免卡输入。

        opts = { -- blink-copilot 选项。
          max_completions = 2, -- 最多返回 2 条建议。
          max_attempts = 3, -- 最多尝试 3 次。

          kind_name = "Copilot", -- 类型名称。
          kind_icon = " ", -- 类型图标。
          kind_hl = "BlinkCmpKindCopilot", -- 类型高亮。

          debounce = 250, -- 防抖时间。

          auto_refresh = { -- 自动刷新建议。
            backward = true, -- 向前移动时刷新。
            forward = true, -- 向后移动时刷新。
          },
        },
      }
      opts.sources.providers.lsp = vim.tbl_deep_extend("force", opts.sources.providers.lsp or {}, { -- LSP 排序设置。
        score_offset = 80, -- LSP 权重次于 Copilot。
      })

      opts.sources.providers.path = vim.tbl_deep_extend("force", opts.sources.providers.path or {}, { -- 路径排序设置。
        score_offset = 20, -- 路径权重。
      })

      opts.sources.providers.snippets = vim.tbl_deep_extend("force", opts.sources.providers.snippets or {}, { -- 片段排序设置。
        score_offset = 10, -- snippets 权重。
      })

      opts.sources.providers.buffer = vim.tbl_deep_extend("force", opts.sources.providers.buffer or {}, { -- buffer 排序设置。
        score_offset = -20, -- buffer 权重较低。
      })
      ----------------------------------------------------------------------
      -- Completion menu：补全菜单。
      ----------------------------------------------------------------------

      opts.completion = vim.tbl_deep_extend("force", opts.completion, { -- 合并补全菜单配置。
        menu = { -- 候选项菜单。
          border = "rounded", -- 圆角边框。
          max_height = 15, -- 最大高度。

          draw = { -- 菜单绘制方式。
            columns = { -- 菜单列布局。
              { "kind_icon" }, -- 类型图标列。
              { "label", "label_description", gap = 1 }, -- 候选文本列。
              { "source_name" }, -- 来源名称列。
            },

            components = { -- 自定义绘制组件。
              source_name = { -- 来源名称组件。
                width = { max = 12 }, -- 来源名最大宽度。
                text = function(ctx)
                  return "[" .. ctx.source_name .. "]" -- 显示为 [source]。
                end,
                highlight = "BlinkCmpSource", -- 来源名高亮。
              },
            },
          },
        },

        documentation = { -- 文档弹窗。
          auto_show = true, -- 自动显示文档。
          auto_show_delay_ms = 300, -- 延迟 300ms 显示。

          window = { -- 文档窗口样式。
            border = "rounded", -- 圆角边框。
            max_width = 100, -- 最大宽度。
            max_height = 20, -- 最大高度。
            scrollbar = true, -- 显示滚动条。
          },
        },

        ghost_text = { -- 行内幽灵文本。
          enabled = false, -- Copilot 已进菜单，关闭 ghost text。
        },
      })

      ----------------------------------------------------------------------
      -- Signature help：函数签名提示。
      ----------------------------------------------------------------------

      opts.signature = vim.tbl_deep_extend("force", opts.signature, { -- 合并签名提示配置。
        enabled = true, -- 启用签名提示。

        window = { -- 签名窗口样式。
          border = "rounded", -- 圆角边框。
          max_width = 100, -- 最大宽度。
          max_height = 10, -- 最大高度。
        },
      })
    end,

    init = function() -- 插件初始化时设置高亮。
      local function set_highlights() -- 定义补全相关高亮。
        vim.api.nvim_set_hl(0, "BlinkCmpKindCopilot", { -- Copilot 类型高亮。
          fg = "#cba6f7", -- Catppuccin Mocha mauve。
        })

        vim.api.nvim_set_hl(0, "BlinkCmpSource", { -- 来源名称高亮。
          fg = "#6c7086", -- 低对比灰紫色。
        })
      end

      set_highlights() -- 启动时应用一次。

      vim.api.nvim_create_autocmd("ColorScheme", { -- 换主题后重新设置。
        callback = set_highlights, -- 刷新自定义高亮。
      })
    end,
  },
}
