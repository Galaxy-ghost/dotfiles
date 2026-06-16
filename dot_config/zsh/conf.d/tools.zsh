# fzf.
if command -v fzf >/dev/null 2>&1; then
  export FZF_DEFAULT_OPTS="${FZF_DEFAULT_OPTS:---height 40% --layout=reverse --border}"

  if command -v fd >/dev/null 2>&1; then
    export FZF_DEFAULT_COMMAND="${FZF_DEFAULT_COMMAND:-fd --type f --hidden --follow --exclude .git --exclude node_modules --exclude .venv}"
    export FZF_CTRL_T_COMMAND="${FZF_CTRL_T_COMMAND:-$FZF_DEFAULT_COMMAND}"
    export FZF_ALT_C_COMMAND="${FZF_ALT_C_COMMAND:-fd --type d --hidden --follow --exclude .git --exclude node_modules --exclude .venv}"

    _fzf_compgen_path() {
      fd --hidden --follow --exclude .git --exclude node_modules --exclude .venv . "$1"
    }

    _fzf_compgen_dir() {
      fd --type d --hidden --follow --exclude .git --exclude node_modules --exclude .venv . "$1"
    }
  fi

  if command -v bat >/dev/null 2>&1; then
    export FZF_PREVIEW_COMMAND='bat --style=numbers --color=always --line-range=:200 {} 2>/dev/null'
  else
    export FZF_PREVIEW_COMMAND='sed -n "1,200p" {} 2>/dev/null'
  fi

  export FZF_COMPLETION_OPTS="
    --height=85%
    --layout=reverse
    --border=rounded
    --preview='$FZF_PREVIEW_COMMAND'
    --preview-window=right:55%:wrap
  "

  [[ "${TERM:-dumb}" != dumb && -t 0 && -t 1 ]] && source <(fzf --zsh)
fi

# atuin: Ctrl-r history search.
if command -v atuin >/dev/null 2>&1; then
  eval "$(atuin init zsh --disable-up-arrow)"
fi

# zoxide: z / zi directory jumping.
if command -v zoxide >/dev/null 2>&1; then
  eval "$(zoxide init zsh)"
  alias j='zi'
  function cdf {
    zi "$@"
  }
fi

if command -v direnv >/dev/null 2>&1; then
  eval "$(direnv hook zsh)"
fi

if command -v mise >/dev/null 2>&1; then
  eval "$(mise activate zsh)"
fi

if [[ -r /usr/share/doc/pkgfile/command-not-found.zsh ]]; then
  source /usr/share/doc/pkgfile/command-not-found.zsh
fi
