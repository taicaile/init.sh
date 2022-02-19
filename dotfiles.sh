#!/bin/bash

SOURCE=DOTFILES

while IFS= read -r -d '' dotfile; do
    echo "create a symlink for $(realpath "$dotfile")"
    ln -sf "$(realpath "$dotfile")" ~/"$(basename "$dotfile")"
done < <(find $SOURCE -type f -print0)
