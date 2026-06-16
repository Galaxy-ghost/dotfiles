return {
  {
    "nvim-lualine/lualine.nvim",
    opts = function(_, opts)
      opts.options = opts.options or {}
      opts.options.theme = "auto"
      opts.options.always_divide_middle = false
      opts.options.component_separators = { left = "", right = "" }
      opts.options.section_separators = { left = "", right = "" }

      opts.sections = opts.sections or {}

      -- Git section
      opts.sections.lualine_b = {
        {
          "branch",
          icon = "",
          color = { fg = "#cba6f7", gui = "bold" },
        },
        {
          "diff",
          symbols = {
            added = " ",
            modified = " ",
            removed = " ",
          },
          diff_color = {
            added = { fg = "#a6e3a1" },
            modified = { fg = "#f9e2af" },
            removed = { fg = "#f38ba8" },
          },
        },
        {
          "diagnostics",
          symbols = {
            error = " ",
            warn = " ",
            info = " ",
            hint = " ",
          },
        },
      }
      -- 显示正在录制的宏，例如 q a 录制时显示：󰑋 a
      local function macro_recording()
        local reg = vim.fn.reg_recording()
        if reg == "" then
          return ""
        end
        return "󰑋 " .. reg
      end

      -- 在右侧状态栏最前面插入 macro 状态
      table.insert(opts.sections.lualine_x, 1, {
        macro_recording,
        color = { fg = "#1e1e2e", bg = "#f38ba8", gui = "bold" },
        separator = { left = "", right = "" },
        padding = 0,
      })

      -- 简化分隔符，更干净
      opts.options.component_separators = { left = "", right = "" }
      opts.options.section_separators = { left = "", right = "" }

      -- 不强制中间分割，更紧凑
      opts.options.always_divide_middle = false
    end,
  },
}
