return { -- 项目根目录自动切换。
  {
    "airblade/vim-rooter", -- 根据项目标志切换 cwd。
    event = { "BufReadPost", "BufNewFile" }, -- 读文件或新建文件后加载。
    init = function() -- 插件初始化前设置全局变量。
      vim.g.rooter_patterns = { -- 根目录识别标志。
        ".git", -- Git 仓库。
        "pyproject.toml", -- Python 项目。
        "uv.lock", -- uv 项目。
        "package.json", -- Node 项目。
        "go.mod", -- Go 项目。
        "Cargo.toml", -- Rust 项目。
        "Makefile", -- Make 项目。
      }

      vim.g.rooter_cd_cmd = "cd" -- 自动切换当前工作目录。

      vim.g.rooter_silent_chdir = 1 -- 静默切换目录。
    end,
  },
}
