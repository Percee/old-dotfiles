#!/usr/bin/env bash

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
. "$DIR/../base.sh"

ASDF_DIR=${ASDF_DIR:="$HOME/.local/asdf"}

if [ ! -d "$ASDF_DIR" ]; then
    git clone https://github.com/asdf-vm/asdf.git "$ASDF_DIR" --branch v0.8.1
    . ~/.local/asdf/asdf.sh
    . "$DIR/update_asdf_plugins.sh"

    # Create ~/.envrc for asdf-direnv
    touch "$HOME/.envrc"
fi