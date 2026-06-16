# Command aliases, guarded so the shell still starts cleanly if a tool is missing.
if command -v eza >/dev/null 2>&1; then
  alias ls='eza --icons=auto --group-directories-first'
  alias ll='eza -lah --icons=auto --group-directories-first'
  alias la='eza -a --icons=auto'
  alias lt='eza --tree --icons=auto --level=2'
else
  alias ls='ls --color=auto'
  alias ll='ls -lah --color=auto'
  alias la='ls -A --color=auto'
fi

command -v bat >/dev/null 2>&1 && alias cat='bat --style=plain --paging=never'
command -v fd >/dev/null 2>&1 && alias ff='fd'
command -v btop >/dev/null 2>&1 && alias top='btop'
command -v lazygit >/dev/null 2>&1 && alias lg='lazygit'
command -v yazi >/dev/null 2>&1 && alias yz='yazi'

alias g='git'
alias c='clear'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
