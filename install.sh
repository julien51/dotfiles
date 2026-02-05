#!/bin/bash
# ABOUTME: Installs dotfiles by creating symlinks from home directory to this repo.
# ABOUTME: Run this script after cloning the dotfiles repo on a new machine.

set -e

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"

link_file() {
    local src="$1"
    local dest="$2"

    if [ -e "$dest" ] && [ ! -L "$dest" ]; then
        echo "Backing up existing $dest to $dest.backup"
        mv "$dest" "$dest.backup"
    fi

    mkdir -p "$(dirname "$dest")"
    ln -sf "$src" "$dest"
    echo "Linked $dest -> $src"
}

# Shell configs
link_file "$DOTFILES_DIR/.zshrc" "$HOME/.zshrc"
link_file "$DOTFILES_DIR/.bashrc" "$HOME/.bashrc"

# Git
link_file "$DOTFILES_DIR/.gitconfig" "$HOME/.gitconfig"
link_file "$DOTFILES_DIR/.config/git/ignore" "$HOME/.config/git/ignore"

# Claude
link_file "$DOTFILES_DIR/.claude/CLAUDE.md" "$HOME/.claude/CLAUDE.md"
link_file "$DOTFILES_DIR/.claude/settings.json" "$HOME/.claude/settings.json"

echo "Done! You may need to restart your shell."
