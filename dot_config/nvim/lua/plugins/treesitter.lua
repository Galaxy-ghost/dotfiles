return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
        "python",
        "lua",
        "vim",
        "vimdoc",
        "bash",
        "json",
        "yaml",
        "toml",
        "markdown",
        "markdown_inline",
        "html",
        "css",
        "javascript",
        "typescript",
        "tsx",
        "c",
        "cpp",
      })

      opts.highlight = opts.highlight or {}
      opts.highlight.enable = true

      opts.indent = opts.indent or {}
      opts.indent.enable = true

      opts.auto_install = true
      opts.sync_install = false
    end,
  },
}
