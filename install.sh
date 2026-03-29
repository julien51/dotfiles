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

# Use token in URL if available (for private repos)
if [ -n "$GITHUB_TOKEN" ]; then
    PRIVATE_BASE="https://oauth2:${GITHUB_TOKEN}@github.com/julien51"
else
    PRIVATE_BASE="https://github.com/julien51"
fi

clone_or_pull "${PRIVATE_BASE}/dotclaude.git" "$HOME/.claude"
clone_or_pull "${PRIVATE_BASE}/claude-docker.git" "$HOME/claude-docker"

# Install Claude CLI if missing
if ! command -v claude &> /dev/null; then
    if command -v npm &> /dev/null; then
        echo "Installing Claude CLI..."
        npm install -g @anthropic-ai/claude-code
    elif command -v node &> /dev/null; then
        echo "Installing npm and Claude CLI..."
        curl -qL https://www.npmjs.com/install.sh | sh
        npm install -g @anthropic-ai/claude-code
    else
        echo "Warning: node/npm not found — install Node.js then run: npm install -g @anthropic-ai/claude-code"
    fi
fi

# Install Claude plugins
if command -v claude &> /dev/null; then
    while IFS= read -r plugin; do
        [[ -z "$plugin" || "$plugin" == \#* ]] && continue
        echo "Installing Claude plugin: $plugin"
        claude plugin install "$plugin" || echo "Warning: failed to install $plugin"
    done < "$HOME/.claude/plugins.txt"
else
    echo "Skipping plugin installation (claude CLI not available)"
fi

echo "Done! You may need to restart your shell."
