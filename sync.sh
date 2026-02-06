#!/bin/bash
# ABOUTME: Syncs dotfiles from git and copies files to Docker config if present.
# ABOUTME: Run this after pulling changes or set up as a cron job.

set -e

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"

cd "$DOTFILES_DIR"
git pull

# Copy CLAUDE.md to Docker config if it exists (for containerized Claude)
DOCKER_CLAUDE_DIR="$HOME/claude-docker/claude-config/.claude"
if [ -d "$DOCKER_CLAUDE_DIR" ]; then
    cp "$DOTFILES_DIR/.claude/CLAUDE.md" "$DOCKER_CLAUDE_DIR/CLAUDE.md"
    echo "Copied CLAUDE.md to Docker config"
fi

echo "Dotfiles synced!"
