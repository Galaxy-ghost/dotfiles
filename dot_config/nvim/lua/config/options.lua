-- 选项会在 lazy.nvim 启动前自动加载。
-- LazyVim 默认值见：https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- 这里放额外的个人设置。

-- 这个文件由 LazyVim 核心自动加载。
vim.g.mapleader = " " -- 全局 Leader 键设为空格。
vim.g.maplocalleader = "\\" -- 本地 Leader 键设为反斜杠。

vim.g.autoformat = true -- 启用 LazyVim 自动格式化。

vim.g.snacks_animate = true -- 启用 Snacks 动画。

vim.g.lazyvim_picker = "auto" -- 自动选择可用的 picker。

vim.g.lazyvim_cmp = "auto" -- 自动选择可用的补全引擎。

vim.g.ai_cmp = true -- 支持时把 AI 接入补全菜单。

vim.g.root_spec = { "cwd" } -- 以当前工作目录作为项目根目录。

-- LazyVim.terminal.setup("pwsh") -- 可选：把终端 shell 设置为 PowerShell。

vim.g.root_lsp_ignore = { "copilot" } -- 根目录检测时忽略 Copilot LSP。

vim.g.deprecation_warnings = false -- 隐藏弃用警告。

vim.g.trouble_lualine = true -- 在 lualine 中显示 Trouble 当前位置。

local opt = vim.opt -- 缩短 vim.opt 写法。

opt.autowrite = true -- 切换缓冲区前自动保存。
opt.clipboard = "unnamedplus" -- 与系统剪贴板同步。
opt.completeopt = "menu,menuone,noselect" -- 补全菜单样式。
opt.conceallevel = 2 -- 隐藏 Markdown 等标记字符。
opt.confirm = true -- 退出未保存文件前确认。
opt.cursorline = true -- 高亮当前行。
opt.expandtab = true -- Tab 转为空格。
opt.fillchars = { -- 设置界面填充字符。
  foldopen = "", -- 折叠打开图标。
  foldclose = "", -- 折叠关闭图标。
  fold = " ", -- 折叠区空白填充。
  foldsep = " ", -- 折叠分隔符。
  diff = "╱", -- diff 填充符。
  eob = " ", -- 隐藏文件末尾波浪线。
}
opt.foldlevel = 99 -- 默认展开大多数折叠。
opt.foldmethod = "indent" -- 按缩进生成折叠。
opt.foldtext = "" -- 使用默认/插件折叠文本。
opt.formatexpr = "v:lua.LazyVim.format.formatexpr()" -- 使用 LazyVim 格式表达式。
opt.formatoptions = "jcroqlnt" -- 控制自动换行和注释格式。
opt.grepformat = "%f:%l:%c:%m" -- 解析 grep 输出格式。
opt.grepprg = "rg --vimgrep" -- 用 ripgrep 搜索。
opt.ignorecase = true -- 搜索默认忽略大小写。
opt.inccommand = "nosplit" -- 替换命令实时预览。
opt.jumpoptions = "view" -- 跳转时尽量保留视图。
opt.laststatus = 3 -- 使用全局状态栏。
opt.linebreak = true -- 在合适位置软换行。
opt.list = true -- 显示部分不可见字符。
opt.mouse = "a" -- 启用鼠标。
opt.number = true -- 显示绝对行号。
opt.pumblend = 10 -- 弹出菜单半透明。
opt.pumheight = 10 -- 限制弹出菜单高度。
opt.relativenumber = true -- 显示相对行号。
opt.ruler = false -- 关闭默认标尺。
opt.scrolloff = 4 -- 光标上下保留 4 行。
opt.sessionoptions = { "buffers", "curdir", "tabpages", "winsize", "help", "globals", "skiprtp", "folds" } -- 会话保存内容。
opt.shiftround = true -- 缩进取整到 shiftwidth。
opt.shiftwidth = 2 -- 每级缩进 2 空格。
opt.shortmess:append({ W = true, I = true, c = true, C = true }) -- 精简提示消息。
opt.showmode = false -- 状态栏已显示模式，隐藏默认模式提示。
opt.sidescrolloff = 8 -- 横向滚动保留 8 列。
opt.signcolumn = "yes" -- 始终显示符号列，避免文本抖动。
opt.smartcase = true -- 搜索含大写时区分大小写。
opt.smartindent = true -- 自动智能缩进。
opt.smoothscroll = true -- 启用平滑滚动。
opt.spelllang = { "en" } -- 拼写检查语言设为英文。
opt.splitbelow = true -- 新横分窗口放下方。
opt.splitkeep = "screen" -- 分屏时保持屏幕视图。
opt.splitright = true -- 新竖分窗口放右侧。
opt.statuscolumn = [[%!v:lua.LazyVim.statuscolumn()]] -- 使用 LazyVim 状态列。
opt.tabstop = 2 -- Tab 显示为 2 空格。
opt.termguicolors = true -- 启用真彩色。
opt.timeoutlen = vim.g.vscode and 1000 or 300 -- 缩短快捷键等待时间。
opt.undofile = true -- 持久化撤销历史。
opt.undolevels = 10000 -- 增加撤销层数。
opt.updatetime = 200 -- 更快触发 CursorHold 等事件。
opt.virtualedit = "block" -- 块选择可移动到无字符处。
opt.wildmode = "longest:full,full" -- 命令行补全模式。
opt.winminwidth = 5 -- 窗口最小宽度。
opt.wrap = false -- 关闭自动折行。

vim.g.markdown_recommended_style = 0 -- 禁用 Markdown 默认缩进风格。

vim.g.lazyvim_python_lsp = "pyright" -- Python LSP 使用 pyright。

vim.g.lazyvim_python_ruff = "ruff" -- Python lint/format 使用 Ruff。

-- 指定 Neovim Python 解释器。原先指向 ~/.local/share/nvim/venv/bin/python，
-- 但该 venv 不存在，会让 :checkhealth provider 报错。需要 python3 provider 时
-- 先建好环境再取消注释：
--   uv venv ~/.local/share/nvim/venv && ~/.local/share/nvim/venv/bin/python -m pip install pynvim
-- vim.g.python3_host_prog = vim.fn.expand("~/.local/share/nvim/venv/bin/python")
