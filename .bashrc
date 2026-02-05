# ABOUTME: Bash configuration file.
# ABOUTME: Cross-platform compatible (macOS and Linux).

# Docker Desktop (macOS only)
[ -f "$HOME/.docker/init-bash.sh" ] && source "$HOME/.docker/init-bash.sh"

# NVM
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"
[ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"

# Source local secrets/overrides (not tracked in git)
[ -f ~/.bashrc.local ] && source ~/.bashrc.local
