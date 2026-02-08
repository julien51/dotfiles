FROM node:20-slim

# Install dependencies including gh CLI
RUN apt-get update && apt-get install -y \
    curl \
    git \
    bash \
    && curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg \
    && chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg \
    && echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | tee /etc/apt/sources.list.d/github-cli.list > /dev/null \
    && apt-get update \
    && apt-get install -y gh \
    && rm -rf /var/lib/apt/lists/*

# Install Claude Code globally
RUN npm install -g @anthropic-ai/claude-code

# Configure git template
RUN mkdir -p /root-template && \
    git config --global credential.helper store && \
    git config --global user.name "Claude" && \
    git config --global user.email "claude@orangepi.local" && \
    cp /root/.gitconfig /root-template/.gitconfig

# Set working directory
WORKDIR /workspace

# Create entrypoint script
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
CMD ["node", "/usr/local/lib/node_modules/@anthropic-ai/claude-code/cli.js", "--dangerously-skip-permissions"]
