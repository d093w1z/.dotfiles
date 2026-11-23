# ~/.zshrc - optimized, faster, clean

###############################################
# BASIC OPTIONS
###############################################
setopt autocd correct interactivecomments magicequalsubst
setopt nonomatch notify numericglobsort promptsubst
WORDCHARS=${WORDCHARS//\/}
PROMPT_EOL_MARK=""

###############################################
# HISTORY
###############################################
HISTFILE=~/.zsh_history
HISTSIZE=5000
SAVEHIST=5000
setopt hist_expire_dups_first hist_ignore_dups hist_ignore_space hist_verify

alias history="history 0"

###############################################
# KEYBINDINGS
###############################################
bindkey -e
bindkey '^U' backward-kill-line
bindkey '^[[3;5~' kill-word
bindkey '^[[3~' delete-char
bindkey '^H' backward-kill-word
bindkey '^[[1;5C' forward-word
bindkey '^[[1;5D' backward-word
bindkey '^[[5~' beginning-of-buffer-or-history
bindkey '^[[6~' end-of-buffer-or-history
bindkey '^[[H' beginning-of-line
bindkey '^[[F' end-of-line
bindkey '^[[Z' undo

# DO NOT override space widget; autosuggestions need it
# bindkey ' ' magic-space  # disabled

###############################################
# COMPLETION
###############################################
zstyle ':completion:*' menu select
zstyle ':completion:*' auto-description 'specify: %d'
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
zstyle ':completion:*' rehash true
zstyle ':completion:*' verbose true

###############################################
# GIT PROMPT FUNCTIONS
###############################################
parse_git_branch() {
  local branch git_status color=green
  branch=$(git branch --no-color 2>/dev/null | sed -n 's/^\* //p')
  [[ -z $branch ]] && return

  git_status=$(git status --porcelain 2>/dev/null)
  [[ $git_status =~ "^ M" || $git_status =~ "^ A" || $git_status =~ "^\?\?" || $git_status =~ "^ D" ]] && color=yellow

  echo "[%F{$color}${branch}%F{reset}]"
}

update_prompt() {
  PS1="%F{%(#.red.blue)}%n:%1~%F{reset} $(virtualenv_info)$(parse_git_branch) %(!.#.$) "
}

###############################################
# PYTHON VIRTUAL ENV PROMPT FUNCTIONS
###############################################
virtualenv_info() {
  [[ -n "$VIRTUAL_ENV" ]] && echo "(🐍 $(basename "$VIRTUAL_ENV")) "
}
###############################################
# PROMPT CONFIG
###############################################
PROMPT_ALTERNATIVE=gitprompt
NEWLINE_BEFORE_PROMPT=no

configure_prompt() {
  case "$PROMPT_ALTERNATIVE" in
    twoline)
      PROMPT=$'%F{%(#.blue.green)}┌──(%n㉿%m)-[%F{reset}%~%F{%(#.blue.green)}]\n└─%B%(#.%F{red}#.%F{blue}$)%F{reset}%b '
      RPROMPT=$'%(?.. %? %F{red}%B⨯%b%F{reset})%(1j. %j %F{yellow}%B⚙%b%F{reset}.)'
      ;;
    oneline)
	PROMPT='%n:%~$(parse_git_branch) %(!.#.$) '
	RPROMPT='$(virtualenv_info)'
      ;;
    gitprompt)
      update_prompt
      ;;
  esac
}

precmd_functions+=(configure_prompt)

###############################################
# PROMPT TOGGLING
###############################################
toggle_oneline_prompt() {
  case "$PROMPT_ALTERNATIVE" in
    oneline) PROMPT_ALTERNATIVE=twoline ;;
    twoline) PROMPT_ALTERNATIVE=gitprompt ;;
    *) PROMPT_ALTERNATIVE=oneline ;;
  esac
  configure_prompt
  zle reset-prompt
}
zle -N toggle_oneline_prompt
bindkey ^P toggle_oneline_prompt

###############################################
# TERMINAL TITLE
###############################################
case "$TERM" in
  xterm*|rxvt*|gnome*|alacritty)
    TERM_TITLE=$'\e]0;%n@%m: %~\a'
    ;;
esac

precmd() {
  print -Pnr -- "$TERM_TITLE"
}

###############################################
# COLORS & ALIASES
###############################################
if command -v dircolors >/dev/null; then
    eval "$(dircolors -b ~/.dircolors 2>/dev/null || dircolors -b)"
    export LS_COLORS="$LS_COLORS:ow=30;44:"
fi

alias ls='ls --color=auto'
alias ll='ls -l'
alias la='ls -A'
alias l='ls -CF'
alias v='nvim'
alias rmf='rm -rf'

###############################################
# PATH
###############################################
PATH=$PATH:$HOME/.local/bin:$HOME/bin:/snap/bin

###############################################
# FASTFETCH
###############################################
fastfetch

###############################################
# PLUGINS (LOAD ORDER IS CRUCIAL)
###############################################

# 1) Autosuggestions — BEFORE syntax highlighting
if [ -f /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.plugin.zsh ]; then
    . /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.plugin.zsh
    ZSH_AUTOSUGGEST_STRATEGY=history
    ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=#888'
fi

# 1) Autocomplete — BEFORE syntax highlighting
if [ -f /usr/share/zsh/plugins/zsh-autocomplete/zsh-autocomplete.plugin.zsh ]; then
    . /usr/share/zsh/plugins/zsh-autocomplete/zsh-autocomplete.plugin.zsh   # runs compinit itself
else
    autoload -Uz compinit && compinit -d ~/.cache/zcompdump
fi


# 2) Syntax highlighting — MUST BE LAST
if [ -f /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.plugin.zsh ]; then
    . /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.plugin.zsh
fi
