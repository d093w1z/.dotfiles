#!/bin/bash
set -e

echo "[*] Stowing dotfiles..."

cd "$(dirname "$0")"

for dir in $(ls -d */ | sed 's|/||g'); do
    echo "[*] Stowing $dir"
    stow $dir
done

echo "[✓] Dotfiles applied!"
