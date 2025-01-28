# Use the lightweight Alpine Linux base image
FROM alpine:latest

# Install dependencies: git, curl, jq, GitHub CLI
RUN apk add --no-cache \
    git \
    curl \
    jq \
    && curl -fsSL https://github.com/cli/cli/releases/download/v2.65.0/gh_2.65.0_linux_amd64.tar.gz | tar -xz -C /usr/local/bin --strip-components=2 gh_2.65.0_linux_amd64/bin/gh \
    && chmod +x /usr/local/bin/gh

# Set environment variables
ENV REPO_ROOT=/repos
#ENV GITHUB_USER= # GitHub username (required)
#ENV GITHUB_TOKEN= # GitHub Personal Access Token (required)

# Create work directory
RUN mkdir -p $REPO_ROOT
WORKDIR $REPO_ROOT

# Copy the repository management script to the container
COPY backup.sh /usr/local/bin/backup.sh
RUN chmod +x /usr/local/bin/backup.sh

# Entry point
ENTRYPOINT ["/usr/local/bin/backup.sh"]