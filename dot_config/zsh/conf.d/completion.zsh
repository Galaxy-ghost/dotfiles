# Completion styles. zsh-autocomplete runs compinit, so do not call compinit here.
zstyle '*:compinit' arguments -d "$ZSH_CACHE_DIR/zcompdump"

zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path "$ZSH_CACHE_DIR/zcompcache"
zstyle ':completion:*' verbose yes
zstyle ':completion:*' group-name ''
zstyle ':completion:*' menu select
zstyle ':completion:*' squeeze-slashes true
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' matcher-list \
  'm:{a-zA-Z}={A-Za-z}' \
  '+r:|[._-]=** r:|=**'
zstyle ':completion:*:descriptions' format '%F{yellow}-- %d --%f'
zstyle ':completion:*:warnings' format '%F{red}No matches for: %d%f'
zstyle ':completion:*:*:kill:*:processes' command 'ps -u $USER -o pid,user,comm -w -w'
zstyle ':completion:*:cd:*' tag-order local-directories directory-stack path-directories
zstyle ':completion:*:git-checkout:*' sort false

zstyle ':autocomplete:*' delay 0.05
zstyle ':autocomplete:*' min-input 2
zstyle ':autocomplete:*complete*:*' insert-unambiguous yes
zstyle ':autocomplete:*history*:*' insert-unambiguous yes
zstyle ':autocomplete:history-incremental-search-backward:*' list-lines 8
zstyle -e ':autocomplete:*:*' list-lines 'reply=( $(( LINES / 3 )) )'
