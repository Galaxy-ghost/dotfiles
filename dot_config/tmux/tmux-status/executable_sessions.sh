#!/usr/bin/env bash

current="$1"

tmux list-sessions -F '#S' 2>/dev/null | while read -r name; do
  if [ "$name" = "$current" ]; then
    printf "#[fg=#{@thm_crust},bg=#{@thm_mauve},bold] 󰆍 %s #[fg=#{@thm_mauve},bg=default] " "$name"
  else
    printf "#[fg=#{@thm_overlay_0},bg=default] %s " "$name"
  fi
done
