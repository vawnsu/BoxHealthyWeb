#!/usr/bin/env bash
set -euo pipefail

APP_NAME="boxhealthy"
PROJECT_DIR="$HOME/BoxHealthyWeb"

cd "$PROJECT_DIR"

git pull

if [ ! -f .env ]; then
  echo "Missing .env file. Create it before deploying."
  exit 1
fi

sudo docker rm -f "$APP_NAME" >/dev/null 2>&1 || true
sudo docker build -t "$APP_NAME" .
sudo docker run -d \
  --name "$APP_NAME" \
  --restart unless-stopped \
  --env-file .env \
  -p 127.0.0.1:8080:8080 \
  "$APP_NAME"

sudo docker ps --filter "name=$APP_NAME"
