return { -- 主题相关配置。
  {
    "catppuccin/nvim", -- Catppuccin 主题插件。
    name = "catppuccin", -- 插件别名。
    priority = 1000, -- 优先加载主题。
    opts = { -- Catppuccin 选项。
      transparent_background = true, -- 启用透明背景。

      float = { -- 浮窗样式。
        transparent = true, -- 浮窗也透明。
      },

      styles = { -- 语法高亮字形风格。
        comments = { "italic" }, -- 注释使用斜体。
        conditionals = { "italic" }, -- if/else 等条件关键字使用斜体。
        loops = { "italic" }, -- for/while 等循环关键字使用斜体。
        keywords = { "italic" }, -- function/return/export 等关键字使用斜体。
        booleans = { "italic" }, -- true/false 等布尔值使用斜体。
      },

      custom_highlights = function(colors) -- 自定义部分高亮。
        return { -- 返回高亮表。
          Comment = { fg = colors.overlay2, italic = true }, -- 普通注释。
          Keyword = { fg = colors.mauve, italic = true }, -- 普通关键字。
          Conditional = { fg = colors.mauve, italic = true }, -- 条件关键字。
          Repeat = { fg = colors.mauve, italic = true }, -- 循环关键字。
          Boolean = { fg = colors.peach, italic = true }, -- 布尔值。
          ["@comment"] = { fg = colors.overlay2, italic = true }, -- Treesitter 注释。
          ["@keyword"] = { fg = colors.mauve, italic = true }, -- Treesitter 通用关键字。
          ["@keyword.import"] = { fg = colors.mauve, italic = true }, -- import/from。
          ["@keyword.conditional"] = { fg = colors.mauve, italic = true }, -- if/else。
          ["@keyword.operator"] = { fg = colors.mauve, italic = true }, -- not/is/in 等关键字运算符。
          ["@keyword.return"] = { fg = colors.mauve, italic = true }, -- return/yield。
          ["@boolean"] = { fg = colors.peach, italic = true }, -- Treesitter 布尔值。
          ["@comment.python"] = { fg = colors.overlay2, italic = true }, -- Python 注释。
          ["@keyword.import.python"] = { fg = colors.mauve, italic = true }, -- Python import/from。
          ["@keyword.conditional.python"] = { fg = colors.mauve, italic = true }, -- Python if/else。
          ["@keyword.operator.python"] = { fg = colors.mauve, italic = true }, -- Python not/is/in。
          ["@keyword.return.python"] = { fg = colors.mauve, italic = true }, -- Python return/yield。
          -- LSP 语义标记会盖住 Treesitter 高亮，这几个组补上同样的斜体。
          ["@lsp.type.comment"] = { fg = colors.overlay2, italic = true }, -- LSP 注释。
          ["@lsp.type.comment.python"] = { fg = colors.overlay2, italic = true }, -- Python LSP 注释。
          ["@lsp.type.keyword"] = { fg = colors.mauve, italic = true }, -- LSP 关键字。
          ["@lsp.type.keyword.python"] = { fg = colors.mauve, italic = true }, -- Python LSP 关键字。
          ["@lsp.type.operator"] = { fg = colors.mauve, italic = true }, -- LSP 运算符关键字。
          ["@lsp.type.operator.python"] = { fg = colors.mauve, italic = true }, -- Python LSP 运算符关键字。
          LineNr = { fg = colors.surface2 }, -- 行号颜色。
          Visual = { bg = colors.overlay0 }, -- 可视选区背景。
          Search = { bg = colors.surface2 }, -- 搜索结果背景。
          IncSearch = { bg = colors.mauve, fg = colors.base }, -- 增量搜索高亮。
          CurSearch = { bg = colors.mauve, fg = colors.base }, -- 当前搜索结果。
          MatchParen = { bg = colors.mauve, fg = colors.base, bold = true }, -- 匹配括号。
        }
      end,

      integrations = { -- 主题插件集成。
        blink_cmp = true, -- blink.cmp 补全。
        gitsigns = true, -- Git 符号。
        mason = true, -- Mason UI。
        noice = true, -- Noice 消息 UI。
        rainbow_delimiters = true, -- 彩虹括号。
        snacks = { -- Snacks 集成。
          enabled = true, -- 启用 Snacks 主题支持。
          indent_scope_color = "flamingo", -- 缩进范围颜色。
        },
        which_key = true, -- which-key。
        flash = true, -- flash 跳转。
        lsp_trouble = true, -- Trouble 诊断。
        dap = true, -- DAP 调试。
        dap_ui = true, -- DAP UI。
      },
    },

    -- catppuccin 的 load() 若先于 setup(opts) 被调用，会用「无用户配置」的默认值
    -- 编译并应用（见其 init.lua: `if not did_setup then M.setup() end`），
    -- 结果 styles / custom_highlights 在启动时全部失效，直到手动 :colorscheme 一次。
    -- 这里显式 setup 后再应用一次，保证启动即生效。
    config = function(_, opts)
      require("catppuccin").setup(opts) -- 先注入用户配置。
      vim.cmd.colorscheme("catppuccin") -- 再应用，此时用的是用户配置。
    end,
  },

  {
    "LazyVim/LazyVim", -- LazyVim 主插件。
    opts = { -- LazyVim 选项。
      colorscheme = "catppuccin", -- 默认使用 Catppuccin。
    },
  },
}
