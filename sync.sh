#!/bin/bash
# ABOUTME: Syncs dotfiles from git and copies files to Docker config if present.
# ABOUTME: Run this after pulling changes or set up as a cron job.

set -e

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"

cd "$DOTFILES_DIR"
git pull

echo "Dotfiles synced!"
