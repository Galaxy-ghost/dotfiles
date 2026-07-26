local function augroup(name) -- 创建统一命名的自动命令组。
  return vim.api.nvim_create_augroup("user_" .. name, { clear = true }) -- 每次加载都清理旧命令。
end

local function polish_snacks_mocha() -- 微调 Snacks 在 Mocha 主题下的高亮。
  -- 注意用前缀匹配：实际 colors_name 是 catppuccin-mocha 这种带 flavour 的名字。
  if not (vim.g.colors_name or ""):find("catppuccin", 1, true) then
    return -- 这套硬编码色只对 Catppuccin 成立，换主题时不要污染。
  end

  local c = { -- Catppuccin Mocha 调色板。
    rosewater = "#f5e0dc", -- 玫瑰白。
    flamingo = "#f2cdcd", -- 火烈鸟粉。
    pink = "#f5c2e7", -- 粉色。
    mauve = "#cba6f7", -- 淡紫色。
    red = "#f38ba8", -- 红色。
    maroon = "#eba0ac", -- 暗红色。
    peach = "#fab387", -- 桃色。
    yellow = "#f9e2af", -- 黄色。
    green = "#a6e3a1", -- 绿色。
    teal = "#94e2d5", -- 青绿色。
    sky = "#89dceb", -- 天蓝色。
    sapphire = "#74c7ec", -- 蓝宝石色。
    blue = "#89b4fa", -- 蓝色。
    lavender = "#b4befe", -- 薰衣草色。

    text = "#cdd6f4", -- 主文本色。
    subtext1 = "#bac2de", -- 次级文本色。
    subtext0 = "#a6adc8", -- 更弱文本色。

    overlay2 = "#9399b2", -- 强覆盖色。
    overlay1 = "#7f849c", -- 中覆盖色。
    overlay0 = "#6c7086", -- 弱覆盖色。

    surface2 = "#585b70", -- 强表面色。
    surface1 = "#45475a", -- 中表面色。
    surface0 = "#313244", -- 弱表面色。

    base = "#1e1e2e", -- 基础背景。
    mantle = "#181825", -- 次级背景。
    crust = "#11111b", -- 最深背景。
  }

  --------------------------------------------------------------------------
  -- 1. 主体透明：保留终端 / Noctalia 背景。
  --------------------------------------------------------------------------
  local transparent_groups = { -- 需要背景透明的高亮组。
    "NormalFloat", -- 普通浮窗。
    "FloatTitle", -- 浮窗标题。

    "SnacksPicker", -- Snacks picker 主体。
    "SnacksPickerNormal", -- picker 普通文本。
    "SnacksPickerList", -- picker 列表。
    "SnacksPickerInput", -- picker 输入框。
    "SnacksPickerPreview", -- picker 预览区。
    "SnacksPickerBackdrop", -- picker 背景遮罩。
    "SnacksPickerBox", -- picker 容器。

    "NeoTreeNormal", -- NeoTree 普通窗口。
    "NeoTreeNormalNC", -- NeoTree 非当前窗口。
    "NeoTreeEndOfBuffer", -- NeoTree 末尾填充。
    "NvimTreeNormal", -- NvimTree 普通窗口。
    "NvimTreeNormalNC", -- NvimTree 非当前窗口。
    "NvimTreeEndOfBuffer", -- NvimTree 末尾填充。
  }

  for _, group in ipairs(transparent_groups) do
    vim.api.nvim_set_hl(0, group, { bg = "NONE" }) -- 清掉这些组的背景色。
  end

  --------------------------------------------------------------------------
  -- 2. 边框：Mocha overlay0，低对比但可见。
  --------------------------------------------------------------------------
  local border_groups = { -- 需要统一边框色的高亮组。
    "FloatBorder", -- 通用浮窗边框。
    "SnacksPickerBorder", -- picker 边框。
    "SnacksPickerInputBorder", -- picker 输入框边框。
    "SnacksPickerPreviewBorder", -- picker 预览边框。
  }

  for _, group in ipairs(border_groups) do
    vim.api.nvim_set_hl(0, group, { -- 设置边框高亮。
      fg = c.overlay0, -- 边框颜色。
      bg = "NONE", -- 背景透明。
    })
  end

  --------------------------------------------------------------------------
  -- 3. 当前行：Mocha surface0，高亮但不黑。
  --------------------------------------------------------------------------
  local cursorline_groups = { -- picker 当前行相关高亮组。
    "SnacksPickerCursorLine", -- 通用当前行。
    "SnacksPickerListCursorLine", -- 列表当前行。
    "SnacksPickerTreeCursorLine", -- 树形当前行。
  }

  for _, group in ipairs(cursorline_groups) do
    vim.api.nvim_set_hl(0, group, { -- 设置当前行高亮。
      fg = c.text, -- 当前行文字。
      bg = c.surface0, -- 当前行背景。
      bold = true, -- 加粗强调。
    })
  end

  --------------------------------------------------------------------------
  -- 4. 输入框 / 标题 / prompt。
  --------------------------------------------------------------------------
  vim.api.nvim_set_hl(0, "SnacksPickerInput", { -- picker 输入区。
    fg = c.text, -- 输入文字颜色。
    bg = "NONE", -- 输入区透明。
  })

  vim.api.nvim_set_hl(0, "SnacksPickerPrompt", { -- picker 提示符。
    fg = c.mauve, -- 提示符颜色。
    bg = "NONE", -- 背景透明。
    bold = true, -- 加粗提示符。
  })

  vim.api.nvim_set_hl(0, "SnacksPickerTitle", { -- picker 标题。
    fg = c.lavender, -- 标题颜色。
    bg = "NONE", -- 背景透明。
    bold = true, -- 标题加粗。
  })

  --------------------------------------------------------------------------
  -- 5. 匹配文本：Mocha mauve。
  --------------------------------------------------------------------------
  local match_groups = { -- 搜索匹配相关高亮组。
    "SnacksPickerMatch", -- 匹配文本。
    "SnacksPickerSpecial", -- 特殊匹配。
  }

  for _, group in ipairs(match_groups) do
    vim.api.nvim_set_hl(0, group, { -- 设置匹配文本样式。
      fg = c.mauve, -- 匹配文字颜色。
      bg = "NONE", -- 背景透明。
      bold = true, -- 加粗匹配。
    })
  end

  --------------------------------------------------------------------------
  -- 6. 文件 / 目录 / 路径。
  --------------------------------------------------------------------------
  vim.api.nvim_set_hl(0, "SnacksPickerDir", { -- 目录名。
    fg = c.blue, -- 目录蓝色。
    bg = "NONE", -- 背景透明。
    bold = true, -- 目录加粗。
  })

  vim.api.nvim_set_hl(0, "SnacksPickerFile", { -- 文件名。
    fg = c.text, -- 文件名主文本色。
    bg = "NONE", -- 背景透明。
  })

  vim.api.nvim_set_hl(0, "SnacksPickerPathHidden", { -- 隐藏路径。
    fg = c.overlay0, -- 弱化路径。
    bg = "NONE", -- 背景透明。
  })

  vim.api.nvim_set_hl(0, "SnacksPickerPathIgnored", { -- 被忽略路径。
    fg = c.overlay0, -- 弱化路径。
    bg = "NONE", -- 背景透明。
  })

  --------------------------------------------------------------------------
  -- 7. 图标 / 次要信息。
  --------------------------------------------------------------------------
  vim.api.nvim_set_hl(0, "SnacksPickerIcon", { -- picker 图标。
    fg = c.sky, -- 图标天蓝色。
    bg = "NONE", -- 背景透明。
  })

  vim.api.nvim_set_hl(0, "SnacksPickerDimmed", { -- 弱化信息。
    fg = c.overlay0, -- 弱化颜色。
    bg = "NONE", -- 背景透明。
  })

  vim.api.nvim_set_hl(0, "SnacksPickerDelim", { -- 分隔符。
    fg = c.surface2, -- 分隔符颜色。
    bg = "NONE", -- 背景透明。
  })

  --------------------------------------------------------------------------
  -- 8. 左侧选择条：用 mauve，符合 Mocha 风格。
  --------------------------------------------------------------------------
  vim.api.nvim_set_hl(0, "SnacksPickerListCursorLineSign", { -- 当前行左侧标记。
    fg = c.mauve, -- 标记颜色。
    bg = c.surface0, -- 跟随当前行背景。
    bold = true, -- 加粗标记。
  })

  --------------------------------------------------------------------------
  -- 不动全局 CursorLine，普通编辑区继续使用 Catppuccin 默认值。
  --------------------------------------------------------------------------
end

vim.api.nvim_create_autocmd({ "ColorScheme", "VimEnter" }, { -- 主题变化和启动完成时刷新高亮（高亮是全局的，不必按 buffer 刷）。
  group = augroup("polish_snacks_mocha"), -- 自动命令组。
  callback = function() -- 触发后的回调。
    vim.schedule(polish_snacks_mocha) -- 延迟执行，确保插件高亮已创建。
  end,
})

polish_snacks_mocha() -- 启动时立即应用一次。

-- 代码区斜体高亮（Comment/Keyword/@keyword.*/@lsp.type.*）已统一收到
-- lua/plugins/colorscheme.lua 的 custom_highlights 里，由 Catppuccin 自己应用。
