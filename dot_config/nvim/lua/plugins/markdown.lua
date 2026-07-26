local function callout(raw, rendered, highlight, category)
  return {
    raw = raw,
    rendered = rendered,
    highlight = highlight,
    category = category,
  }
end

return {
  {
    "MeanderingProgrammer/render-markdown.nvim",
    opts = {
      sign = { enabled = false },
      heading = {
        icons = { "󰎤 ", "󰎧 ", "󰎪 ", "󰎭 ", "󰎱 ", "󰎳 " },
        position = "inline",
        width = { "full", "block" },
        left_pad = 1,
        right_pad = 1,
        min_width = 30,
        border = false,
      },
      code = {
        width = "block",
        min_width = 45,
        border = "thin",
        left_pad = 1,
        right_pad = 1,
        position = "right",
        language_icon = true,
        language_name = true,
        language_info = true,
        highlight_inline = "RenderMarkdownCodeInline",
      },
      bullet = {
        icons = { "●", "○", "◆", "◇" },
        right_pad = 1,
      },
      checkbox = {
        enabled = true,
        unchecked = {
          icon = "󰄱 ",
          highlight = "RenderMarkdownUnchecked",
        },
        checked = {
          icon = "󰱒 ",
          highlight = "RenderMarkdownChecked",
          scope_highlight = "MarkdownTaskDone",
        },
        custom = {
          question = { raw = "[?]", rendered = " ", highlight = "RenderMarkdownWarn" },
          todo = { raw = "[>]", rendered = "󰦖 ", highlight = "RenderMarkdownInfo" },
          canceled = {
            raw = "[-]",
            rendered = " ",
            highlight = "RenderMarkdownCodeFallback",
            scope_highlight = "MarkdownTaskCanceled",
          },
          important = { raw = "[!]", rendered = " ", highlight = "RenderMarkdownWarn" },
          favorite = { raw = "[~]", rendered = " ", highlight = "RenderMarkdownMath" },
        },
      },
      quote = {
        icon = "▋",
        repeat_linebreak = true,
      },
      dash = {
        icon = "─",
        width = 0.8,
        left_margin = 0.1,
      },
      pipe_table = {
        preset = "round",
        cell = "padded",
        padding = 1,
        alignment_indicator = "━",
      },
      callout = {
        abstract = callout("[!ABSTRACT]", "󰨸 Abstract", "RenderMarkdownInfo", "obsidian"),
        summary = callout("[!SUMMARY]", "󰨸 Summary", "RenderMarkdownInfo", "obsidian"),
        tldr = callout("[!TLDR]", "󰨸 TL;DR", "RenderMarkdownInfo", "obsidian"),
        todo = callout("[!TODO]", "󰗡 Todo", "RenderMarkdownInfo", "obsidian"),
        wip = callout("[!WIP]", "󰦖 In progress", "RenderMarkdownHint", "obsidian"),
        done = callout("[!DONE]", "󰄬 Done", "RenderMarkdownSuccess", "obsidian"),
        attention = callout("[!ATTENTION]", "󰀪 Attention", "RenderMarkdownWarn", "obsidian"),
        warning = callout("[!WARNING]", "󰀪 Warning", "RenderMarkdownWarn", "github"),
        failure = callout("[!FAILURE]", "󰅖 Failure", "RenderMarkdownError", "obsidian"),
        fail = callout("[!FAIL]", "󰅖 Fail", "RenderMarkdownError", "obsidian"),
        missing = callout("[!MISSING]", "󰅖 Missing", "RenderMarkdownError", "obsidian"),
        danger = callout("[!DANGER]", "󱐌 Danger", "RenderMarkdownError", "obsidian"),
        error = callout("[!ERROR]", "󱐌 Error", "RenderMarkdownError", "obsidian"),
        bug = callout("[!BUG]", "󰨰 Bug", "RenderMarkdownError", "obsidian"),
        quote = callout("[!QUOTE]", "󱆨 Quote", "RenderMarkdownQuote", "obsidian"),
        cite = callout("[!CITE]", "󱆨 Cite", "RenderMarkdownQuote", "obsidian"),
      },
      link = {
        wiki = {
          icon = "󱗖 ",
          highlight = "RenderMarkdownWikiLink",
          scope_highlight = "RenderMarkdownWikiLink",
        },
        image = "󰥶 ",
        hyperlink = "󰌹 ",
        custom = {
          github = { pattern = "github%.com", icon = "󰊤 " },
          gitlab = { pattern = "gitlab%.com", icon = "󰮠 " },
          youtube = { pattern = "youtu[^.]*%.", icon = "󰗃 " },
          cern = { pattern = "cern%.ch", icon = " " },
        },
      },
      anti_conceal = {
        ignore = {
          code_background = true,
          head_background = true,
        },
      },
      win_options = {
        concealcursor = { rendered = "vc" },
        showbreak = { default = "", rendered = "  " },
        breakindent = { default = false, rendered = true },
      },
      completions = {
        blink = { enabled = true },
        lsp = { enabled = true },
      },
    },
  },
}
