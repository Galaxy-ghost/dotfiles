return {
  {
    "saghen/blink.cmp",
    opts = {
      keymap = {
        preset = "default",

        ["<C-n>"] = { "select_next", "fallback" },
        ["<C-p>"] = { "select_prev", "fallback" },
        ["<C-d>"] = { "scroll_documentation_down", "fallback" },
        ["<C-u>"] = { "scroll_documentation_up", "fallback" },

        ["<Tab>"] = { "accept", "fallback" },

        -- Enter：接受补全
        ["<CR>"] = {
          function(cmp)
            return cmp.accept()
          end,
          "fallback",
        },

        -- Shift+Enter：关闭补全菜单，然后正常换行
        ["<S-CR>"] = {
          function(cmp)
            cmp.hide()
            return false
          end,
          "fallback",
        },
      },

      appearance = {
        nerd_font_variant = "normal",
      },

      completion = {
        menu = {
          border = "rounded",
          max_height = 15,

          draw = {
            columns = {
              { "kind_icon" },
              { "label", "label_description", gap = 1 },
              { "source_name" },
            },

            components = {
              source_name = {
                width = { max = 12 },
                text = function(ctx)
                  return "[" .. ctx.source_name .. "]"
                end,
                highlight = "BlinkCmpSource",
              },
            },
          },
        },

        documentation = {
          auto_show = true,
          auto_show_delay_ms = 300,

          window = {
            border = "rounded",
            max_width = 100,
            max_height = 20,
            scrollbar = true,
          },
        },

        ghost_text = {
          enabled = true,
        },
      },

      signature = {
        enabled = true,
        window = {
          border = "rounded",
          max_width = 100,
          max_height = 10,
        },
      },
    },
  },
}
