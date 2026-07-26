local copilot_proxy = "http://127.0.0.1:7897"
local copilot_no_proxy = "localhost,127.0.0.1,::1"
local copilot_node_command = vim.fn.expand("~/.local/share/nvim/nodejs/node22/bin/node")

local function is_sensitive_file(bufname) -- 接收 bufname，任何 buffer 都能判断。
  local name = vim.fs.basename(bufname or vim.api.nvim_buf_get_name(0)):lower()

  return name:match("^%.env") ~= nil
    or name == ".envrc"
    or name:match("%.env%.") ~= nil
    or name:match("%.local%.") ~= nil
    or name:match("secret") ~= nil
    or name:match("token") ~= nil
    or name:match("credential") ~= nil
end

return { -- AI 相关插件。
  {
    "zbirenbaum/copilot.lua", -- GitHub Copilot 插件。
    cmd = "Copilot", -- 执行 :Copilot 时加载。
    event = "InsertEnter", -- 进入插入模式时加载。
    init = function()
      vim.g.copilot_proxy = copilot_proxy -- 兼容 github/copilot.vim 和部分代理读取逻辑。
    end,

    opts = function(_, opts) -- Copilot 配置。
      opts.server_opts_overrides = opts.server_opts_overrides or {}
      opts.server_opts_overrides.cmd_env = vim.tbl_extend("force", opts.server_opts_overrides.cmd_env or {}, {
        HTTP_PROXY = copilot_proxy,
        HTTPS_PROXY = copilot_proxy,
        ALL_PROXY = copilot_proxy,

        http_proxy = copilot_proxy,
        https_proxy = copilot_proxy,
        all_proxy = copilot_proxy,

        NO_PROXY = copilot_no_proxy,
        no_proxy = copilot_no_proxy,

        NODE_USE_ENV_PROXY = "1", -- 让新版 Node 原生读取 HTTP_PROXY / HTTPS_PROXY。
        NODE_TLS_REJECT_UNAUTHORIZED = "", -- 避免继承 shell 里关闭 TLS 校验的设置。
      })

      opts.suggestion = vim.tbl_deep_extend("force", opts.suggestion or {}, {
        enabled = false, -- 关闭 Copilot 自带行内建议。
        auto_trigger = false, -- 不自动触发行内建议。
        hide_during_completion = true, -- 补全菜单出现时隐藏建议。
      })

      opts.panel = vim.tbl_deep_extend("force", opts.panel or {}, {
        enabled = false, -- 关闭 Copilot 面板。
      })

      -- 敏感文件在 attach 层拦截：对所有 filetype 生效，且能拿到正确的 bufnr。
      -- （filetypes 的函数形式只能逐 ft 挂，也不接收 bufnr，只能读当前 buffer。）
      opts.should_attach = function(bufnr, bufname)
        if not vim.bo[bufnr].buflisted or vim.bo[bufnr].buftype ~= "" then
          return false -- 保留插件默认的 buflisted / buftype 检查。
        end

        return not is_sensitive_file(bufname) -- 命中敏感文件名就不 attach。
      end

      opts.filetypes = vim.tbl_deep_extend("force", opts.filetypes or {}, { -- 指定 Copilot 启用/禁用的文件类型。
        markdown = true, -- Markdown 启用。
        help = true, -- 帮助文件启用。
        gitcommit = false, -- Git 提交信息可能包含私有上下文，默认禁用。

        python = true, -- Python 启用。
        lua = true, -- Lua 启用。
        sh = true, -- shell 脚本启用；敏感文件由 should_attach 统一拦截。

        env = false, -- .env / .env.production / production.env 都是这个 filetype，一律禁用。
        toml = false, -- TOML 禁用。
        yaml = false, -- YAML 禁用。
      })

      opts.logger = vim.tbl_deep_extend("force", opts.logger or {}, { -- 日志设置。
        file_log_level = vim.log.levels.OFF, -- 关闭文件日志。
        print_log_level = vim.log.levels.WARN, -- 只放过警告及以上：代理挂掉时至少有提示，不至于完全静默失败。
        trace_lsp = "off", -- 关闭 LSP trace。
        log_lsp_messages = false, -- 关闭 LSP 消息打印。
      })

      opts.server = vim.tbl_deep_extend("force", opts.server or {}, { -- Copilot 服务端设置。
        type = "nodejs", -- 使用 Node.js 服务端。
      })

      opts.copilot_node_command = copilot_node_command -- 使用给 Copilot 单独安装的 Node 22，避免 InsertEnter 时 npx 阻塞 Neovim。
    end,
  },
}
