# Proxy helpers.
typeset -g PROXY_URL="${PROXY_URL:-http://127.0.0.1:7897}"

function proxy-on {
  export http_proxy="$PROXY_URL"
  export https_proxy="$PROXY_URL"
  export HTTP_PROXY="$http_proxy"
  export HTTPS_PROXY="$https_proxy"
  export all_proxy="${ALL_PROXY_URL:-$PROXY_URL}"
  export ALL_PROXY="$all_proxy"
  echo "Proxy enabled: $http_proxy"
}

function proxy-off {
  unset http_proxy https_proxy HTTP_PROXY HTTPS_PROXY all_proxy ALL_PROXY
  echo "Proxy disabled"
}

function proxy-status {
  env | command grep -i '_proxy'
}

# Editor and config helpers.
unalias zc zs nr kc sc 2>/dev/null

function edit-preferred {
  local -a editor editor_args
  local first_target workdir

  if command -v nvim >/dev/null 2>&1; then
    editor=(nvim)
  elif command -v code >/dev/null 2>&1; then
    editor=(code --wait)
  else
    editor=(nano)
  fi

  if (( $# == 0 )); then
    "${editor[@]}" .
    return
  fi

  first_target="$1"
  if [[ -d "$first_target" ]]; then
    workdir="${first_target:A}"
    editor_args=(.)
  else
    workdir="${first_target:h}"
    [[ "$workdir" == "$first_target" ]] && workdir="."
    workdir="${workdir:A}"

    if (( $# == 1 )); then
      editor_args=("${first_target:t}")
    else
      local target
      for target in "$@"; do
        editor_args+=("${target:A}")
      done
    fi
  fi

  if [[ ! -d "$workdir" ]]; then
    echo "Directory not found: $workdir" >&2
    return 1
  fi

  (cd "$workdir" && "${editor[@]}" "${editor_args[@]}")
}

function zu {
  if typeset -f zinit >/dev/null 2>&1; then
    zinit self-update
    zinit update
  else
    echo "zinit is not loaded" >&2
    return 1
  fi
}

function zc {
  edit-preferred "$ZSH_CONFIG_HOME"
}

function ze {
  edit-preferred "$ZSH_CONFIG_HOME/.zshrc"
}

function zs {
  exec zsh
}

function zreload {
  source "$ZSH_CONFIG_HOME/.zshrc"
}

function nr {
  edit-preferred ~/.config/niri/config.kdl
}

function kc {
  edit-preferred ~/.config/kitty/kitty.conf
}

function sc {
  edit-preferred ~/.config/starship.toml
}

function mkcd {
  [[ -n "$1" ]] || {
    echo "usage: mkcd <dir>" >&2
    return 2
  }
  mkdir -p -- "$1" && cd -- "$1"
}

function loadconda {
  local conda_hook=/opt/miniconda3/etc/profile.d/conda.sh
  if [[ -r "$conda_hook" ]]; then
    source "$conda_hook"
  else
    echo "Conda hook not found: $conda_hook" >&2
    return 1
  fi
}

# SSH key helper.
function set-ssh-key {
  if [[ -z "$1" ]]; then
    echo "usage: set-ssh-key <key-name-or-path>" >&2
    echo "Available keys:" >&2
    command ls ~/.ssh/*.pub 2>/dev/null | sed 's|.*/|  |; s|\.pub$||' >&2
    return 2
  fi

  local key="$1"
  [[ "$key" = /* ]] || key="$HOME/.ssh/$key"

  if [[ ! -f "$key" ]]; then
    echo "Key not found: $key" >&2
    echo "Available keys:" >&2
    command ls ~/.ssh/*.pub 2>/dev/null | sed 's|.*/|  |; s|\.pub$||' >&2
    return 1
  fi

  ssh-add -D 2>/dev/null
  ssh-add "$key"
  echo "Active SSH key: ${key:t}"
}

# AI helpers.
function _llm_or_warn {
  if ! command -v llm >/dev/null 2>&1; then
    echo "llm command not found" >&2
    return 127
  fi
  llm "$@"
}

function ai {
  _llm_or_warn "$*"
}

function aix {
  _llm_or_warn "请用简洁中文解释这条 Linux 命令，说明每个参数的作用、风险和替代写法：$*"
}

function aic {
  _llm_or_warn "你是 Linux/CachyOS 终端助手。根据我的需求生成一条或多条可执行命令。只输出命令和必要注释，不要执行。需求：$*"
}

function ailast {
  if ! command -v llm >/dev/null 2>&1; then
    echo "llm command not found" >&2
    return 127
  fi
  fc -ln -1 | llm "请解释这条 shell 命令的作用、每个管道阶段、潜在风险："
}
