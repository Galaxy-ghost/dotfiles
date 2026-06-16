# XDG, PATH, and default applications.
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
export XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"
export XDG_STATE_HOME="${XDG_STATE_HOME:-$HOME/.local/state}"
export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"

typeset -U path fpath
path=("$HOME/.local/bin" "$HOME/.npm-global/bin" $path)

[[ -d "$ZSH_CONFIG_HOME/functions" ]] && fpath=("$ZSH_CONFIG_HOME/functions" $fpath)
[[ -d "$ZSH_CONFIG_HOME/completions" ]] && fpath=("$ZSH_CONFIG_HOME/completions" $fpath)

export TERMINAL="${TERMINAL:-kitty}"
export BROWSER="${BROWSER:-zen-browser}"

if command -v nvim >/dev/null 2>&1; then
  export EDITOR="${EDITOR:-nvim}"
else
  export EDITOR="${EDITOR:-nano}"
fi

if command -v code >/dev/null 2>&1; then
  export VISUAL="${VISUAL:-code --wait}"
else
  export VISUAL="${VISUAL:-$EDITOR}"
fi

export BAT_THEME="${BAT_THEME:-Catppuccin Mocha}"
export LESS="${LESS:--R}"
export PAGER="${PAGER:-less}"

if command -v dircolors >/dev/null 2>&1; then
  eval "$(dircolors -b 2>/dev/null)"
fi
