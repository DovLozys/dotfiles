# --- PATH ---
export PATH="$HOME/.local/bin:$PATH"

command -v mise >/dev/null && eval "$(mise activate zsh)"

# Tab completion with daily cache
autoload -Uz compinit
if [[ -n ${ZDOTDIR:-$HOME}/.zcompdump(#qN.mh+24) ]]; then
  compinit
else
  compinit -C
fi

# --- Prompt ---
fish_pwd() {
  local p="${PWD/#$HOME/~}"
  local -a parts
  parts=("${(@s:/:)p}")
  local n=${#parts[@]}
  if (( n <= 1 )); then
    print -r -- "$p"
    return
  fi
  local i
  for (( i=1; i < n; i++ )); do
    [[ -n ${parts[i]} ]] && parts[i]="${parts[i][1]}"
  done
  print -r -- "${(j:/:)parts[1,-2]}/${parts[-1]}"
}
setopt PROMPT_SUBST
PROMPT=$'%F{cyan}%n@%m%f %F{yellow}$(fish_pwd)%f\n$ '

# --- Machine-specific (untracked) ---
[[ -f ~/.zshrc.local ]] && source ~/.zshrc.local
