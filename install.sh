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

# Claude config (dotclaude repo)
clone_or_pull() {
    local repo="$1"
    local dest="$2"
    if [ -d "$dest/.git" ]; then
        echo "Updating $dest..."
        git -C "$dest" pull --ff-only
    else
        echo "Cloning $repo -> $dest..."
        git clone "$repo" "$dest"
    fi
}

clone_or_pull "https://github.com/julien51/dotclaude.git" "$HOME/.claude"
clone_or_pull "https://github.com/julien51/claude-docker.git" "$HOME/claude-docker"

# Install Claude plugins
if command -v claude &> /dev/null; then
    while IFS= read -r plugin; do
        [[ -z "$plugin" || "$plugin" == \#* ]] && continue
        echo "Installing Claude plugin: $plugin"
        claude plugin install "$plugin" || echo "Warning: failed to install $plugin"
    done < "$HOME/.claude/plugins.txt"
else
    echo "claude CLI not found — skipping plugin installation"
fi

echo "Done! You may need to restart your shell."
