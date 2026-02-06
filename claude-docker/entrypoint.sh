#\!/bin/sh
set -e

# Initialize /root on first boot of this session volume.
# /shared-config/ is a read-only bind mount with shared config files.
# /root-template/ has defaults baked into the image.

if [ \! -f /root/.initialized ]; then
  echo "[INIT] Setting up session home directory..." >&2

  # 1. Copy shared config if the bind mount exists
  if [ -d /shared-config ]; then
    # .gitconfig
    if [ -f /shared-config/.gitconfig ]; then
      cp /shared-config/.gitconfig /root/.gitconfig
    fi

    # .claude.json (account/settings seed)
    if [ -f /shared-config/.claude.json ]; then
      cp /shared-config/.claude.json /root/.claude.json
    fi

    # claude-code config
    if [ -f /shared-config/.config/claude-code/config.json ]; then
      mkdir -p /root/.config/claude-code
      cp /shared-config/.config/claude-code/config.json /root/.config/claude-code/config.json
    fi

    # .claude credentials
    if [ -f /shared-config/.claude/.credentials.json ]; then
      mkdir -p /root/.claude
      cp /shared-config/.claude/.credentials.json /root/.claude/.credentials.json
    fi

    # .claude CLAUDE.md
    if [ -f /shared-config/.claude/CLAUDE.md ]; then
      mkdir -p /root/.claude
      cp /shared-config/.claude/CLAUDE.md /root/.claude/CLAUDE.md
    fi

    # .claude settings.json
    if [ -f /shared-config/.claude/settings.json ]; then
      mkdir -p /root/.claude
      cp /shared-config/.claude/settings.json /root/.claude/settings.json
    fi

    # .claude projects (settings, not session data)
    if [ -d /shared-config/.claude/projects ]; then
      mkdir -p /root/.claude/projects
      cp -r /shared-config/.claude/projects/. /root/.claude/projects/
    fi

    # .claude plugins
    if [ -d /shared-config/.claude/plugins ]; then
      mkdir -p /root/.claude/plugins
      cp -r /shared-config/.claude/plugins/. /root/.claude/plugins/
    fi

    echo "[INIT] Copied shared config into session." >&2
  fi

  # 2. Fall back to /root-template/ for anything still missing
  if [ \! -f /root/.config/claude-code/config.json ]; then
    mkdir -p /root/.config/claude-code
    cp /root-template/.config/claude-code/config.json /root/.config/claude-code/config.json
    echo "[INIT] Used template for claude-code config." >&2
  fi

  if [ \! -f /root/.gitconfig ]; then
    cp /root-template/.gitconfig /root/.gitconfig
    echo "[INIT] Used template for .gitconfig." >&2
  fi

  # 3. Mark session as initialized
  touch /root/.initialized
  echo "[INIT] Session initialized." >&2
fi

# Add all /workspace subdirectories as git safe directories
for dir in /workspace/*/; do
  if [ -d "$dir" ]; then
    # Strip trailing slash for git compatibility
    dir="${dir%/}"
    git config --global --add safe.directory "$dir"
  fi
done
# Also add /workspace itself
git config --global --add safe.directory /workspace

# Sync shared config files on every boot (credentials, CLAUDE.md, settings)
if [ -d /shared-config/.claude ]; then
  mkdir -p /root/.claude
  cp /shared-config/.claude/.credentials.json /root/.claude/.credentials.json 2>/dev/null || true
  cp /shared-config/.claude/CLAUDE.md /root/.claude/CLAUDE.md 2>/dev/null || true
  cp /shared-config/.claude/settings.json /root/.claude/settings.json 2>/dev/null || true
  echo "[INIT] Synced credentials, CLAUDE.md and settings.json from shared config." >&2
fi

# Fetch skills from dotfiles repo (always get latest)
echo "[INIT] Fetching skills from dotfiles..." >&2
DOTFILES_DIR="/tmp/dotfiles"
if [ -d "$DOTFILES_DIR" ]; then
  git -C "$DOTFILES_DIR" pull --ff-only 2>/dev/null || true
else
  git clone --depth 1 https://github.com/julien51/dotfiles.git "$DOTFILES_DIR" 2>/dev/null || true
fi
if [ -d "$DOTFILES_DIR/.claude/skills" ]; then
  mkdir -p /root/.claude
  rm -rf /root/.claude/skills
  cp -r "$DOTFILES_DIR/.claude/skills" /root/.claude/skills
  echo "[INIT] Skills installed from dotfiles." >&2
fi

# Upgrade Claude CLI to latest
echo "[INIT] Upgrading Claude CLI..." >&2
npm update -g @anthropic-ai/claude-code 2>/dev/null || true

# Pull latest for all git repos in /workspace
for dir in /workspace/*/; do
  if [ -d "$dir/.git" ]; then
    dir="${dir%/}"
    echo "[INIT] Pulling latest: $dir" >&2
    git -C "$dir" pull --ff-only 2>/dev/null || true
  fi
done

# Authenticate gh with token if provided
if [ -n "$GITHUB_TOKEN" ]; then
  echo "$GITHUB_TOKEN" | gh auth login --with-token 2>/dev/null || true
fi

exec "$@"
