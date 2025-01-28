# GitHub repository backup
Repository which backs up all GitHub repositories for a user.

## Usage

Mount a volume to /repos/ where the repository data should be persisted.  
Configure environment variables for GITHUB_USER AND GITHUB_TOKEN.  GITHUB_TOKEN must have read access to all repositories.  
Build the Docker image using the Dockerfile and run via Docker.
