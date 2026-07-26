return { -- 代码运行器配置。
  {
    "CRAG666/code_runner.nvim", -- code_runner.nvim 插件。

    cmd = { -- 只有执行这些命令时才加载插件。
      "RunCode", -- 按当前文件类型运行。
      "RunFile", -- 运行当前文件。
      "RunProject", -- 运行当前项目。
      "RunClose", -- 关闭运行窗口。
      "CRFiletype", -- 查看/设置文件类型运行器。
      "CRProjects", -- 项目运行配置。
    },

    keys = { -- 运行相关快捷键。
      { "<leader>rr", "<cmd>RunCode<CR>", desc = "Run code" }, -- 按文件类型运行代码。

      { "<leader>rf", "<cmd>RunFile float<CR>", desc = "Run file in float" }, -- 浮窗运行当前文件。

      { "<leader>rp", "<cmd>RunProject float<CR>", desc = "Run project in float" }, -- 浮窗运行当前项目。

      { "<leader>rx", "<cmd>RunClose<CR>", desc = "Close runner" }, -- 关闭运行窗口。
    },

    opts = function() -- 动态生成运行器配置。
      -- 缺工具链时给出明确提示。返回 nil 会被 code_runner 当作「无命令」安静跳过，
      -- 所以这里自己 notify 一句，避免只看到一个空的运行窗口。
      -- （$file / $fileName / $dir 由 code_runner 自己做了 shellescape，无需在此转义。）
      local function needs(exe, build)
        return function()
          if vim.fn.executable(exe) ~= 1 then
            vim.notify(("code_runner: 找不到 %s，无法运行当前文件"):format(exe), vim.log.levels.ERROR)
            return nil -- 交回插件，它会直接返回不做任何事。
          end

          return build()
        end
      end

      local function python_runner() -- Python 运行命令。
        local root = vim.fs.root(0, { "pyproject.toml", "uv.lock" }) -- 查找 Python 项目根。

        if root and vim.fn.executable("uv") == 1 then
          return "cd " .. vim.fn.shellescape(root) .. " && uv run python -u $file" -- uv 项目用 uv run。
        end

        return "python3 -u $file" -- 否则直接用 python3。
      end

      local function go_runner() -- Go 运行命令。
        local root = vim.fs.root(0, { "go.mod" }) -- 查找 Go 模块根。

        if root then
          return "cd " .. vim.fn.shellescape(root) .. " && go run $file" -- 在模块根运行。
        end

        return "cd $dir && go run $fileName" -- 无 go.mod 时在文件目录运行。
      end

      local function temp_executable()
        return vim.fn.shellescape(vim.fn.tempname())
      end

      local function with_cleanup(command, output)
        return command .. "; status=$?; rm -f " .. output .. "; exit $status"
      end

      local c_runner = needs("gcc", function()
        local output = temp_executable()
        return with_cleanup("cd $dir && gcc $fileName -o " .. output .. " && " .. output, output)
      end)

      local cpp_runner = needs("g++", function()
        local output = temp_executable()
        return with_cleanup("cd $dir && g++ $fileName -std=c++17 -Wall -O2 -o " .. output .. " && " .. output, output)
      end)

      local rust_runner = needs("rustc", function()
        local output = temp_executable()
        return with_cleanup("cd $dir && rustc $fileName -o " .. output .. " && " .. output, output)
      end)

      return { -- code_runner 主配置。
        mode = "float", -- 默认用浮窗运行，避免打乱布局。

        focus = true, -- 运行后自动聚焦输出窗口。

        startinsert = false, -- 打开后不自动进入插入模式。

        float = { -- 浮窗样式。
          border = "rounded", -- 圆角边框。

          width = 0.85, -- 宽度占屏幕 85%。

          x = 0.5, -- 水平居中。
          y = 0.5, -- 垂直居中。

          border_hl = "FloatBorder", -- 边框使用浮窗高亮组。
        },

        filetype = { -- 不同文件类型的运行命令。
          python = python_runner, -- Python 使用动态命令。

          go = go_runner, -- Go 使用动态命令。

          lua = "lua $file", -- Lua 文件。
          sh = "bash $file", -- sh 文件。
          bash = "bash $file", -- bash 文件。
          zsh = "zsh $file", -- zsh 文件。

          javascript = needs("node", function()
            return "node $file" -- JavaScript 文件。
          end),

          typescript = needs("tsx", function()
            return "tsx $file" -- TypeScript 文件（需要 npm i -g tsx）。
          end),

          c = c_runner, -- 编译并运行 C，输出到唯一临时文件。

          cpp = cpp_runner, -- 编译并运行 C++，输出到唯一临时文件。

          java = needs("javac", function() -- Java 编译运行命令。
            return table.concat({
              "cd $dir &&", -- 切到文件目录。
              "javac $fileName &&", -- 编译 Java 文件。
              "java $fileNameWithoutExt", -- 运行 class。
            }, " ")
          end),

          rust = rust_runner, -- 编译并运行 Rust，输出到唯一临时文件。
        },
      }
    end,
  },
}
