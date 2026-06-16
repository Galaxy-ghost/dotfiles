return {
  {
    "folke/snacks.nvim",
    opts = function(_, opts)
      require("plugins.snacks.dashboard")(opts)
    end,
  },
}
