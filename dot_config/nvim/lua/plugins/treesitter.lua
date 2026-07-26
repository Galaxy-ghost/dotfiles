return { -- Treesitter 语法解析配置。
  {
    "nvim-treesitter/nvim-treesitter", -- Treesitter 插件。
    -- LazyVim 声明了 opts_extend = { "ensure_installed" }，所以这里是追加而不是覆盖。
    -- highlight / indent / folds 已由 LazyVim 默认开启；auto_install 与 sync_install
    -- 属于旧 master 分支 API，当前 main 分支不认，故不再设置。
    opts = {
      ensure_installed = { -- 确保安装这些解析器。
        "python", -- Python。
        "lua", -- Lua。
        "vim", -- Vimscript。
        "vimdoc", -- Vim 帮助文档。
        "bash", -- Bash。
        "json", -- JSON。
        "yaml", -- YAML。
        "toml", -- TOML。
        "markdown", -- Markdown。
        "markdown_inline", -- Markdown 行内语法。
        "html", -- HTML。
        "css", -- CSS。
        "javascript", -- JavaScript。
        "typescript", -- TypeScript。
        "tsx", -- TSX。
        "c", -- C。
        "cpp", -- C++。
      },
    },
  },
}
