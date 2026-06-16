# Plugin manager and completion-facing plugins.
typeset -g ZINIT_HOME="${XDG_DATA_HOME:-$HOME/.local/share}/zinit/zinit.git"

if [[ -r "$ZINIT_HOME/zinit.zsh" ]]; then
  source "$ZINIT_HOME/zinit.zsh"
  autoload -Uz _zinit
  (( ${+_comps} )) && _comps[zinit]=_zinit
else
  print -P "%F{yellow}[zinit]%f not found: $ZINIT_HOME"
fi

if typeset -f zinit >/dev/null 2>&1; then
  zinit ice depth"1" lucid
  zinit light zsh-users/zsh-completions
fi

if [[ "${TERM:-dumb}" != dumb ]]; then
  if typeset -f zinit >/dev/null 2>&1; then
    zinit ice depth"1" lucid
    zinit light marlonrichert/zsh-autocomplete
  elif [[ -r /usr/share/zsh/plugins/zsh-autocomplete/zsh-autocomplete.plugin.zsh ]]; then
    source /usr/share/zsh/plugins/zsh-autocomplete/zsh-autocomplete.plugin.zsh
  fi
fi
