alias e='emacsclient --tty -s tty --alternate-editor='
alias en='emacs -nw'
alias psg='ps aux | grep '
alias _="sudo"
alias c="clear"
alias cm="chezmoi"
alias cmcd="z $HOME/.local/share/chezmoi"
alias ...="z ../.."
alias ....="z ../../.."
alias .....="z ../../../.."
# git commit quic
alias gcq='git commit -m "update"'
alias gcqp='git commit -m "update" && git push'
alias cd='echo use z instead!'


_pager="less"
if (( ${+commands[bat]} )); then
	_pager="bat"
	alias less='bat'
fi

if (( ${+commands[exa]} )); then
	alias ls='exa'
	alias l='ls'
	alias la='ls -a'
	alias ll='exa -l'
	function lll() {
	exa -l --color=always $1 | $_pager
	}
	alias lla='exa -la'
	alias llt='exa -T'
	alias llfu='exa -bghHliS --git'
else
	alias l='ls -1A'         # Lists in one column, hidden files.
	alias ll='ls -lh'        # Lists human readable sizes.
	alias lr='ll -R'         # Lists human readable sizes, recursively.
	alias la='ll -A'         # Lists human readable sizes, hidden files.
	function lm() {
	la --color=always $1 | $_pager # Lists human readable sizes, hidden files through pager.
	}
	alias lx='ll -XB'        # Lists sorted by extension (GNU only).
	alias lk='ll -Sr'        # Lists sorted by size, largest last.
	alias lt='ll -tr'        # Lists sorted by date, most recent last.
	alias lc='lt -c'         # Lists sorted by date, most recent last, shows change time.
	alias lu='lt -u'         # Lists sorted by date, most recent last, shows access time.
fi

# Woopsie
alias sl='ls'
alias dc='cd':w


alias v='nvim'
alias vim='nvim'
alias e='emacsclient --tty -s tty --alternate-editor='
alias editor='$EDITOR'

if [ -f "$HOME/.emacs.d/bin/doom" ]; then
	alias doom="$HOME/.emacs.d/bin/doom"
fi

dotfiles-update() { chezmoi cd && ./install.sh; }

function dotf {
(cd $HOME/dotfiles && make "$1")
}

alias tmux="tmux -u"
