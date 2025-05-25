#!/bin/bash

cd /opt/n8n || exit

echo "[$(date)] Checking for updates..." >> /opt/n8n/deploy.log

# Pull and capture output
PULL_OUTPUT=$(git pull origin main 2>&1)

# Log pull result
echo "$PULL_OUTPUT" >> /opt/n8n/deploy.log

# Only deploy if there were actual changes
if [[ "$PULL_OUTPUT" != "Already up to date." ]]; then
  echo "[$(date)] Changes detected. Rebuilding..." >> /opt/n8n/deploy.log
  docker compose down >> /opt/n8n/deploy.log 2>&1
  docker compose up --build -d >> /opt/n8n/deploy.log 2>&1
  echo "[$(date)] Deployment complete." >> /opt/n8n/deploy.log
else
  echo "[$(date)] No changes. Skipping deploy." >> /opt/n8n/deploy.log
fi

