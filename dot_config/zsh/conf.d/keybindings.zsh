# Custom keybindings after zsh-autocomplete has installed its defaults.
zmodload zsh/complist 2>/dev/null || true

autoload -Uz up-line-or-beginning-search down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search

bindkey -M viins '^[[A' up-line-or-beginning-search
bindkey -M viins '^[[B' down-line-or-beginning-search
bindkey -M vicmd '^[[A' up-line-or-beginning-search
bindkey -M vicmd '^[[B' down-line-or-beginning-search

bindkey -M viins '^[[H' beginning-of-line
bindkey -M viins '^[[F' end-of-line
bindkey -M vicmd '^[[H' beginning-of-line
bindkey -M vicmd '^[[F' end-of-line
bindkey -M viins '^[[1;5D' backward-word
bindkey -M viins '^[[1;5C' forward-word
bindkey -M vicmd '^[[1;5D' backward-word
bindkey -M vicmd '^[[1;5C' forward-word
bindkey -M viins '^?' backward-delete-char

bindkey -M viins '^N' menu-select
bindkey -M viins '^P' menu-select
bindkey -M menuselect '^N' menu-complete
bindkey -M menuselect '^P' reverse-menu-complete
bindkey -M menuselect '^M' .accept-line
bindkey -M menuselect '^[[D' .backward-char
bindkey -M menuselect '^[[C' .forward-char
