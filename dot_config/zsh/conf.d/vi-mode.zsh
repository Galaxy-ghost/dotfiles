# Vi mode and cursor shape.
bindkey -v
export KEYTIMEOUT=10

function _set_cursor_block() {
  printf '\e[2 q'
}

function _set_cursor_beam() {
  printf '\e[6 q'
}

function _set_cursor_underline() {
  printf '\e[4 q'
}

function zle-keymap-select {
  case $KEYMAP in
    vicmd)
      _set_cursor_block
      ;;
    viins|main)
      _set_cursor_beam
      ;;
    *)
      _set_cursor_beam
      ;;
  esac
}

function zle-line-init {
  _set_cursor_beam
}

function zle-line-finish {
  _set_cursor_beam
}

zle -N zle-keymap-select
zle -N zle-line-init
zle -N zle-line-finish
