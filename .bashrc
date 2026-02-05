# ABOUTME: Bash configuration file.
# ABOUTME: Cross-platform compatible (macOS and Linux).

#### FIG ENV VARIABLES ####
[ -s ~/.fig/shell/pre.sh ] && source ~/.fig/shell/pre.sh
[ -s ~/.fig/fig.sh ] && source ~/.fig/fig.sh
#### END FIG ENV VARIABLES ####

# Docker Desktop (macOS only)
[ -f "$HOME/.docker/init-bash.sh" ] && source "$HOME/.docker/init-bash.sh"

# NVM
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"
[ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"

# Source local secrets/overrides (not tracked in git)
[ -f ~/.bashrc.local ] && source ~/.bashrc.local
