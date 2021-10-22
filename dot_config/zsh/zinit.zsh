#!/usr/bin/env zsh

if [[ ! -f $ZINIT[HOME_DIR]/bin/zinit.zsh ]]; then
    echo -e "y" | ZINIT_HOME="$ZINIT[HOME_DIR]" sh -c "$(curl -fsSL https://raw.githubusercontent.com/zdharma/zinit/master/doc/install.sh)"
fi

source "$ZINIT[HOME_DIR]/bin/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

# Load a few important annexes, without Turbo
# (this is currently required for annexes)
zinit light-mode for \
    zinit-zsh/z-a-rust \
    zinit-zsh/z-a-as-monitor \
    zinit-zsh/z-a-patch-dl \
    zinit-zsh/z-a-bin-gem-node

### End of Zinit's installer chunk

zinit ice wait lucid
zinit snippet OMZ::plugins/colored-man-pages
zinit ice wait lucid
zinit snippet OMZ::plugins/colorize
zinit ice wait lucid
zinit snippet OMZ::plugins/command-not-found
zinit ice wait lucid
zinit snippet OMZ::plugins/copydir
zinit ice wait lucid
zinit snippet OMZ::plugins/copyfile
zinit ice wait lucid
zinit snippet OMZ::plugins/cp
zinit ice wait lucid
zinit snippet OMZ::plugins/debian
zinit ice wait lucid
zinit snippet OMZ::plugins/dircycle
zinit ice wait lucid
zinit snippet OMZ::plugins/extract
zinit ice wait lucid
zinit snippet OMZ::plugins/jump
zinit ice wait lucid
zinit snippet OMZ::plugins/mercurial
zinit ice wait lucid
zinit snippet OMZ::plugins/rsync
zinit ice wait lucid
zinit snippet OMZ::plugins/safe-paste

# # Bundles from external repos
zinit ice wait lucid
zinit load Tarrasch/zsh-bd
zinit ice wait lucid
zinit load djui/alias-tips
zinit ice wait lucid
zinit load hlissner/zsh-autopair
zinit ice wait lucid
zinit load mdumitru/fancy-ctrl-z
zinit ice wait lucid
zinit load rutchkiwi/copyzshell
zinit ice wait lucid
zinit load wfxr/forgit
zinit ice wait lucid
zinit load redxtech/zsh-show-path
# zinit load kutsan/zsh-system-clipboard
zinit ice wait lucid
zinit load zsh-users/zsh-completions

# Do not turbo mode (ice wait) these packages
zinit load jeffreytse/zsh-vi-mode # problems with fzf Ctrl+R, Ctrl+Z, Ctrl+T bindings if turbo
zinit ice svn pick"tmux.plugin.zsh"
zinit snippet OMZ::plugins/tmux
zinit load Aloxaf/fzf-tab
zinit snippet OMZ::plugins/fzf # after fzf-tab
zinit load davidde/git
zinit snippet OMZ::plugins/common-aliases # if turbo, replaces my aliases
unalias zi
zinit snippet OMZ::plugins/zoxide # so the function "zi" replaces the "zinit" alias "zi" properly

# Direnv hook into zsh
# https://zdharma.github.io/zinit/wiki/Direnv-explanation/
zinit from"gh-r" as"program" mv"direnv* -> direnv" \
    atclone'./direnv hook zsh > zhook.zsh' atpull'%atclone' \
    pick"direnv" src="zhook.zsh" for \
        direnv/direnv

# LS_COLORS managed by zinit
# https://zdharma.github.io/zinit/wiki/LS_COLORS-explanation/
#
zinit ice atclone"dircolors -b LS_COLORS > clrs.zsh" \
    atpull'%atclone' pick"clrs.zsh" nocompile'!' \
    atload'zstyle ":completion:*" list-colors “${(s.:.)LS_COLORS}”'
zinit light trapd00r/LS_COLORS

# # # Order important
zinit ice wait"1" lucid
zinit load zsh-users/zsh-syntax-highlighting # last

zicompinit; zicdreplay

# # # Theme
zinit ice depth="1"
zinit load romkatv/powerlevel10k
