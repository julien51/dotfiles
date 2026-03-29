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
    echo "Installing Claude CLI..."
    curl -fsSL https://claude.ai/install.sh | bash
    export PATH="$HOME/.local/bin:$PATH"
fi

# Install Claude plugins
if command -v claude &> /dev/null; then
    # Register marketplaces first
    claude plugin marketplace add obra/superpowers-marketplace 2>/dev/null || true
    # Install plugins
    while IFS= read -r plugin; do
        [[ -z "$plugin" || "$plugin" == \#* ]] && continue
        echo "Installing Claude plugin: $plugin"
        claude plugin install "$plugin" || echo "Warning: failed to install $plugin"
    done < "$HOME/.claude/plugins.txt"
else
    echo "Skipping plugin installation (claude CLI not available)"
fi

# Set dark theme in ~/.claude.json (avoids first-launch theme prompt)
# Must run after plugin commands so Claude doesn't reinitialize the file
if command -v python3 &> /dev/null; then
    python3 - <<'EOF'
import json, os
path = os.path.expanduser("~/.claude.json")
data = {}
if os.path.exists(path):
    with open(path) as f:
        data = json.load(f)
data["theme"] = "dark"
with open(path, "w") as f:
    json.dump(data, f, indent=2)
EOF
    echo "Set dark theme in ~/.claude.json"
fi

echo "Done! You may need to restart your shell."
