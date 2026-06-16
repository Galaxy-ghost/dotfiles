# zsh config layout

`~/.zshenv` sets `ZDOTDIR=$HOME/.config/zsh`.

`~/.config/zsh/.zshrc` is the interactive entrypoint. It loads the files in
`conf.d/` in the order listed there, then optionally loads `local.zsh`.

Module order:

- `environment.zsh`: XDG, PATH, editor, pager, colors
- `options.zsh`: history and shell options
- `vi-mode.zsh`: vi mode and cursor shape
- `completion.zsh`: completion and autocomplete styles
- `plugins.zsh`: zinit, zsh-completions, zsh-autocomplete
- `keybindings.zsh`: custom keybindings
- `tools.zsh`: fzf, atuin, zoxide, direnv, mise, command-not-found
- `aliases.zsh`: aliases
- `functions.zsh`: helper functions
- `prompt.zsh`: starship
- `vendor.zsh`: vendor shell hooks
- `final-plugins.zsh`: autosuggestions and syntax highlighting
