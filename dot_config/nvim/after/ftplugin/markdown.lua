if vim.b.did_my_ftplugin then -- 防止当前缓冲区重复加载。
  return -- 已加载过就直接退出。
end
vim.b.did_my_ftplugin = true -- 标记当前缓冲区已加载。

local fold_hl_cache = {} -- 折叠高亮组缓存：按颜色去重，避免每折叠一行就新建一个组。

-- 让 Markdown 渲染颜色与 Catppuccin 保持一致。
local function apply_markdown_highlights()
  local ok, colors = pcall(function()
    return require("catppuccin.palettes").get_palette()
  end)
  if not ok then
    return
  end

  local heading_colors = { colors.mauve, colors.blue, colors.sapphire, colors.teal, colors.green, colors.peach }
  for level, color in ipairs(heading_colors) do
    vim.api.nvim_set_hl(0, "RenderMarkdownH" .. level, { fg = color, bold = true })
    vim.api.nvim_set_hl(0, "RenderMarkdownH" .. level .. "Bg", {
      fg = color,
      bg = level == 1 and colors.surface1 or colors.surface0,
      bold = level <= 2,
    })
  end

  vim.api.nvim_set_hl(0, "RenderMarkdownCode", { bg = colors.mantle })
  vim.api.nvim_set_hl(0, "RenderMarkdownCodeBorder", { fg = colors.surface1, bg = colors.mantle })
  vim.api.nvim_set_hl(0, "RenderMarkdownCodeInfo", { fg = colors.sky, bg = colors.mantle, italic = true })
  vim.api.nvim_set_hl(0, "RenderMarkdownCodeInline", { fg = colors.peach, bg = colors.surface0 })
  vim.api.nvim_set_hl(0, "RenderMarkdownBullet", { fg = colors.lavender })
  vim.api.nvim_set_hl(0, "RenderMarkdownDash", { fg = colors.surface2 })
  vim.api.nvim_set_hl(0, "RenderMarkdownQuote", { fg = colors.overlay1 })
  vim.api.nvim_set_hl(0, "RenderMarkdownTableHead", { fg = colors.mauve, bold = true })
  vim.api.nvim_set_hl(0, "RenderMarkdownTableRow", { fg = colors.overlay1 })
  vim.api.nvim_set_hl(0, "MarkdownTaskDone", { fg = colors.overlay0, strikethrough = true })
  vim.api.nvim_set_hl(0, "MarkdownTaskCanceled", { fg = colors.overlay0, strikethrough = true })
end

apply_markdown_highlights()
local highlight_group = vim.api.nvim_create_augroup("MyMarkdownHighlights", { clear = true })
vim.api.nvim_create_autocmd("ColorScheme", {
  group = highlight_group,
  callback = function()
    fold_hl_cache = {} -- 配色变了，折叠高亮组缓存作废。
    apply_markdown_highlights()
  end,
})

vim.lsp.enable("marksman") -- 为 Markdown 启用 marksman LSP。
vim.opt_local.wrap = false -- 仅在 Markdown 中关闭自动折行。
vim.opt_local.conceallevel = 2 -- 仅在 Markdown 中启用符号隐藏渲染。
vim.keymap.set("n", "gx", function() -- 自定义 Markdown 链接打开逻辑。
  local line = vim.fn.getline(".") -- 获取当前行文本。
  local cursor_col = vim.fn.col(".") -- 获取光标列号。
  local pos = 1 -- 从行首开始扫描。
  while pos <= #line do
    local open_bracket = line:find("%[", pos) -- 查找链接文本开始 [。
    if not open_bracket then
      break -- 没有链接文本就结束。
    end
    local close_bracket = line:find("%]", open_bracket + 1) -- 查找链接文本结束 ]。
    if not close_bracket then
      break -- 链接文本不完整就结束。
    end
    local open_paren = line:find("%(", close_bracket + 1) -- 查找 URL 开始 (。
    if not open_paren then
      break -- 没有 URL 就结束。
    end
    local close_paren = line:find("%)", open_paren + 1) -- 查找 URL 结束 )。
    if not close_paren then
      break -- URL 不完整就结束。
    end
    if
      (cursor_col >= open_bracket and cursor_col <= close_bracket)
      or (cursor_col >= open_paren and cursor_col <= close_paren)
    then
      local url = line:sub(open_paren + 1, close_paren - 1) -- 提取 URL。
      if not url:match("^https?://") then
        vim.notify("Blocked non-http(s) URL: " .. url, vim.log.levels.WARN) -- 避免直接触发本地或自定义协议。
        return
      end
      vim.ui.open(url) -- 用系统方式打开链接。
      return -- 打开后结束。
    end
    pos = close_paren + 1 -- 继续找下一个链接。
  end
  -- 没命中 Markdown 链接时走默认 gx 的取值逻辑。
  -- 不能用 normal! gx：gx 本身是 Neovim 的默认「映射」，normal! 会跳过映射，等于什么都不做。
  local ok, urls = pcall(function()
    return require("vim.ui")._get_urls() -- 默认 gx 内部用的就是这个。
  end)
  local target = (ok and urls and urls[1]) or vim.fn.expand("<cfile>") -- 私有 API 失效时退回 <cfile>。
  if target ~= "" then
    vim.ui.open(target) -- 裸 URL / 文件路径交给系统处理。
  end
end, { buffer = true, desc = "URL opener for markdown" }) -- 仅当前 Markdown 缓冲区生效。

local function pad_to_eol(str) -- 把文本补齐到窗口宽度。
  local win_width = vim.api.nvim_win_get_width(0) -- 当前窗口宽度。
  local str_width = vim.fn.strdisplaywidth(str) -- 字符串显示宽度。
  local spaces_needed = win_width - str_width -- 还需要补多少空格。

  if spaces_needed > 0 then
    return str .. string.rep(" ", spaces_needed) -- 宽度不足时补空格。
  else
    return str -- 已够宽则原样返回。
  end
end

local function fold_hl_group(fg, bg) -- 按前景/背景色取（或建）折叠高亮组。
  local name = ("MarkdownFold_%s_%s"):format(fg or "none", bg or "none")

  if not fold_hl_cache[name] then
    vim.api.nvim_set_hl(0, name, { fg = fg, bg = bg }) -- 同一组颜色只定义一次。
    fold_hl_cache[name] = true
  end

  return name
end

local function fold_virt_text(result, start_text, lnum) -- 生成 Markdown 折叠显示文本。
  local function get_hl(name)
    if not name or name == "" then
      return {}
    end

    local ok, hl = pcall(vim.api.nvim_get_hl, 0, { name = name })
    return ok and hl or {}
  end

  local ns_id = vim.api.nvim_get_namespaces()["render-markdown.nvim"] -- 获取 render-markdown 命名空间。
  local extmarks = {}
  if ns_id then
    extmarks = vim.api.nvim_buf_get_extmarks(0, ns_id, { lnum, 0 }, { lnum, 0 }, { details = true }) -- 读取标题渲染标记。
  end

  local last_extmark = extmarks[#extmarks]
  local details = last_extmark and last_extmark[4] or {} -- 取最后一个 extmark 的详情。
  local ext_hl_str = details.hl_group -- 记录 extmark 高亮。

  local ok, captured_highlights = pcall(vim.treesitter.get_captures_at_pos, 0, lnum, 0) -- 获取 Treesitter 捕获。
  captured_highlights = ok and captured_highlights or {}

  local last_capture = captured_highlights[#captured_highlights]
  local ts_hl_str = last_capture and last_capture.capture and ("@" .. last_capture.capture .. ".markdown") or nil -- 拼出 Treesitter 高亮名。
  if ts_hl_str then
    local ok_hl, hl = pcall(vim.api.nvim_get_hl, 0, { name = ts_hl_str, link = true })
    ts_hl_str = ok_hl and (hl.link or ts_hl_str) or ts_hl_str -- 解析链接后的高亮。
  end

  local ext_hl = get_hl(ext_hl_str) -- 获取 render-markdown 高亮。
  local ts_hl = get_hl(ts_hl_str) -- 获取 Treesitter 高亮。

  local fold_hl = fold_hl_group(ts_hl.fg or ext_hl.fg, ext_hl.bg) -- 每个标题保留自己的颜色，同色共用一个组。
  table.insert(result, { pad_to_eol(start_text), fold_hl }) -- 插入折叠虚拟文本。
end

function _G.markdown_foldtext() -- 全局折叠文本函数。
  local start_text = vim.fn.getline(vim.v.foldstart):gsub("\t", string.rep(" ", vim.o.tabstop)) -- 取折叠起始行。
  local result = {} -- 虚拟文本结果。
  fold_virt_text(result, start_text, vim.v.foldstart - 1) -- 生成折叠文本。
  return result -- 返回给 foldtext。
end
vim.opt_local.foldtext = "v:lua.markdown_foldtext()" -- 使用自定义折叠文本。
vim.opt_local.fillchars = [[eob: ,fold: ,foldopen: ,foldsep: ,foldclose: ]] -- 隐藏折叠相关填充符。

local function fold_markdown_headings(levels) -- 批量折叠多个标题级别。
  local saved_view = vim.fn.winsaveview() -- 保存当前视图。
  local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false) -- 一次读全篇，取代逐行 getline。

  local by_level = {} -- 按标题级别分桶存行号。
  for _, level in ipairs(levels) do
    by_level[level] = {}
  end

  for lnum, line in ipairs(lines) do -- 只扫一遍全篇，而不是每个级别扫一遍。
    local hashes = line:match("^(#+)%s") -- 行首连续 # 且后跟空白才算标题。
    if hashes and by_level[#hashes] then
      table.insert(by_level[#hashes], lnum)
    end
  end

  for _, level in ipairs(levels) do -- 保持传入顺序（由深到浅），保证嵌套折叠正确。
    for _, lnum in ipairs(by_level[level]) do
      if vim.fn.foldlevel(lnum) > 0 and vim.fn.foldclosed(lnum) == -1 then
        vim.api.nvim_win_set_cursor(0, { lnum, 0 }) -- 移到标题行且不写入跳转列表。
        vim.cmd("normal! za") -- 若当前未折叠，则切换为折叠。
      end
    end
  end

  vim.cmd("nohlsearch") -- 清除搜索高亮。
  vim.fn.winrestview(saved_view) -- 恢复原视图。
end

vim.keymap.set("n", "zM", function() -- 重写 Markdown 的 zM 折叠行为。
  vim.cmd("normal! zR") -- 先展开全部折叠。
  fold_markdown_headings({ 6, 5, 4, 3, 2 }) -- 折叠 2 级及以下标题。
  vim.cmd("normal! zz") -- 把光标行居中。
end, { buffer = true, desc = "Fold Markdown headings (level 2+)" }) -- 仅在 Markdown 中重写 zM。
