return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    opts = {
      transparent_background = true,

      float = {
        transparent = true,
      },

      custom_highlights = function(colors)
        return {
          LineNr = { fg = colors.surface2 },
          Visual = { bg = colors.overlay0 },
          Search = { bg = colors.surface2 },
          IncSearch = { bg = colors.mauve, fg = colors.base },
          CurSearch = { bg = colors.mauve, fg = colors.base },
          MatchParen = { bg = colors.mauve, fg = colors.base, bold = true },
        }
      end,

      integrations = {
        blink_cmp = true,
        gitsigns = true,
        mason = true,
        noice = true,
        rainbow_delimiters = true,
        snacks = {
          enabled = true,
          indent_scope_color = "flamingo",
        },
        which_key = true,
        flash = true,
        lsp_trouble = true,
        dap = true,
        dap_ui = true,
      },
    },
  },

  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "catppuccin",
    },
  },
}
