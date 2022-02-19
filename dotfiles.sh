#!/bin/bash

SOURCE=DOTFILES

while IFS= read -r -d '' dotfile; do
    realpath "$dotfile"
    # ln -sf "$(realpath "$dotfile")" ~/"$(basename "$dotfile")"
done < <(find $SOURCE -type f -print0)
