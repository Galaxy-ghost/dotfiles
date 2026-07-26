local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim" -- lazy.nvim 安装目录。
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git" -- lazy.nvim 仓库地址。
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath }) -- 未安装时自动克隆稳定分支。
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({ -- 克隆失败时给出可读错误。
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" }, -- 错误标题。
      { out, "WarningMsg" }, -- git 输出。
      { "\nPress any key to exit..." }, -- 等待确认。
    }, true, {}) -- 立即显示消息。
    vim.fn.getchar() -- 按任意键后继续。
    os.exit(1) -- 退出 Neovim。
  end
end
vim.opt.rtp:prepend(lazypath) -- 把 lazy.nvim 加入运行时路径。

require("lazy").setup({ -- 初始化插件管理器。
  spec = {
    { "LazyVim/LazyVim", import = "lazyvim.plugins" }, -- 加载 LazyVim 默认插件集。
    { import = "plugins" }, -- 加载 lua/plugins 下的自定义插件。
  },
  defaults = {
    lazy = false, -- 自定义插件默认启动加载。
    version = false, -- 使用最新 git 提交，避免旧 release 破坏配置。
    -- version = "*", -- 若插件支持语义版本，可改为稳定版本。
  },
  install = { colorscheme = { "tokyonight", "habamax" } }, -- 首次安装失败时可用的备用主题。
  checker = {
    enabled = true, -- 定期检查插件更新。
    notify = false, -- 有更新时不弹通知。
  },
  performance = {
    rtp = {
      disabled_plugins = { -- 禁用不常用内置插件以加快启动。
        "gzip", -- gzip 文件支持。
        -- "matchit", -- 扩展 % 匹配。
        -- "matchparen", -- 括号匹配高亮。
        -- "netrwPlugin", -- 内置文件浏览器。
        "tarPlugin", -- tar 文件支持。
        "tohtml", -- 转 HTML 命令。
        "tutor", -- Vim 教程。
        "zipPlugin", -- zip 文件支持。
      },
    },
  },
})
