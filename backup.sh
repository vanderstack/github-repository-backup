#!/bin/sh

# Configuration
REPO_ROOT="/repos"
GITHUB_USER=${GITHUB_USER}  # GitHub username (required)
GITHUB_TOKEN=${GITHUB_TOKEN}  # GitHub Personal Access Token (required)

# Ensure required environment variables are set
if [ -z "$GITHUB_USER" ] || [ -z "$GITHUB_TOKEN" ]; then
    echo "Error: GITHUB_USER and GITHUB_TOKEN must be set as environment variables."
    exit 1
fi

# Ensure GitHub CLI is installed
if ! command -v gh >/dev/null 2>&1; then
    echo "Error: GitHub CLI (gh) is not installed."
    exit 1
fi

# Clone or pull repositories
mkdir -p "$REPO_ROOT"
cd "$REPO_ROOT" || exit 1

# Fetch list of repositories using GitHub CLI
echo "Fetching repository list for user: $GITHUB_USER..."
REPOS=$(gh repo list "$GITHUB_USER" --json name --jq '.[].name')

# Process each repository
echo "$REPOS" | while read -r repo; do
    if [ -d "$repo" ]; then
        echo "Updating $repo..."
        cd "$repo" || continue
        git pull || echo "Failed to pull $repo. Ensure you have not exceeded the rate limit of 5000 requests per hour."
        cd ..
    else
        echo "Cloning $repo..."
        git clone "https://$GITHUB_USER:$GITHUB_TOKEN@github.com/$GITHUB_USER/$repo.git" || echo "Failed to clone $repo. Ensure you have not exceeded the rate limit of 5000 requests per hour."
    fi
done

echo "All repositories have been processed."
