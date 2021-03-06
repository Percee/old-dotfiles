#!/usr/bin/env bash

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
. "$DIR/../base.sh"
. "$DIR/../ansi"

ASDF_DIR=${ASDF_DIR:="$HOME/.local/asdf"}
. "$ASDF_DIR/asdf.sh"
ASDF_INSTALL_DIR="$ASDF_DIR/installs"

PKG_DIR="$CHEZMOI_DIR/package-lists/"
PACKAGES="$PKG_DIR/asdf.packages"

ZSH_DIR="$HOME/.config/zsh"
ZSH_DIRENV_HOOK_FILE="$ZSH_DIR/direnv-zhook.zsh"
ZSH_ZOXIDE_HOOK_FILE="$ZSH_DIR/zoxide-zhook.zsh"

installed_plugins_list=$(asdf plugin list)
function asdf_install_or_update_plugin() {
    plugin=$1
    if [[ $installed_plugins_list == *"$plugin"* ]]; then
        asdf plugin update $1
    else
        asdf plugin add $1
    fi
}

function asdf_get_latest_package_version_available() {
    package=$1
    all_versions=$(asdf list all $package)
    latest_version=$(echo $all_versions | awk '{print $NF}')
    echo $latest_version
}

function pre_fzf_install_hook() {
    fzf="$HOME/.local/fzf"
    fzf_shim="$HOME/.local/asdf/shims/fzf"
    echo "$(ansi --green Removing $fzf and $fzf_shim)"
    rm -rf "$fzf" "$fzf_shim"
}

function post_fzf_install_hook() {
    fzf_installed_version=$1
    # echo "$(ansi --green Launching fzf install script)"
    FZF_INSTALL_DIR="$ASDF_INSTALL_DIR/fzf/$fzf_installed_version"
    # "$FZF_INSTALL_DIR/install" --completion --key-bindings --no-update-rc
    FZF_LINK="$HOME/.local/fzf"

    ln -s "$FZF_INSTALL_DIR" "$FZF_LINK"
}

function post_direnv_install_hook() {
    direnv_installed_version=$1
    DIRENV_BIN="$ASDF_INSTALL_DIR/direnv/$direnv_installed_version/bin/direnv"
    echo "$(ansi --green Generating direnv hook for zsh in $DIRENV_ZSH_HOOK_FILE)"
    "$DIRENV_BIN" hook zsh > "$ZSH_DIRENV_HOOK_FILE"
}

function pre_package_install_hook() {
    func_name=pre_$1_install_hook
    type $func_name &>/dev/null && $func_name $2
}

function post_package_install_hook() {
    func_name=post_$1_install_hook
    type $func_name &>/dev/null && $func_name $2
}

function asdf_install_package_version_if_needed() {
    package=$1
    version=$2
    if [[ $version == "latest" ]]; then
        version=$(asdf_get_latest_package_version_available $package)
    fi
    installed_versions=$(asdf list $package)


    if [[ ! $installed_versions == *"$version"* ]]; then
        pre_package_install_hook $package $version
        echo "$(ansi --yellow Installing $package $version)"
        asdf install $package $version
        post_package_install_hook $package $version
    else
        echo "$(ansi --green $package $version is already installed)"
    fi
}

function is_package_used() {
    package=$1
    if [[ $package == "python" && $CHEZMOI_USE_ASDF_PYTHON != 1 ]]; then
        false
        return
    fi
    if [[ $package == "cmake" && $CHEZMOI_USE_ASDF_CMAKE != 1 ]]; then
        false
        return
    fi
    true
    return
}

while read -r line; do
    package=$(echo "$line" | awk '{print $1}')
    version=$(echo "$line" | awk '{print $2}')
    repo_url=$(echo "$line" | awk '{print $3}')
    if is_package_used $package; then
        echo "$(ansi --yellow ====checking $package====)"
        asdf_install_or_update_plugin $package
        asdf_install_package_version_if_needed $package $version
        asdf global $package $version
        echo "$(ansi --yellow ====$package done====)"
        echo ""
    fi
done < "$PACKAGES"

echo "$(ansi --yellow Checking for missing zsh hook files...)"
if [ ! -f "$ZSH_DIRENV_HOOK_FILE" ]; then
    echo "$(ansi --yellow Direnv hook file is missing, creating it in $ZSH_DIRENV_HOOK_FILE...)"
    direnv hook zsh > "$ZSH_DIRENV_HOOK_FILE"
fi
if [ ! -f "$ZSH_ZOXIDE_HOOK_FILE" ]; then
    echo "$(ansi --yellow Zoxide hook file is missing, creating it in $ZSH_ZOXIDE_HOOK_FILE...)"
    zoxide init zsh > "$ZSH_ZOXIDE_HOOK_FILE"
fi

# Regenerate asdf-direnv cached environment
touch "$HOME/.envrc"

