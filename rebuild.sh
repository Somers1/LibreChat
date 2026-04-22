#!/usr/bin/env bash
set -euo pipefail

COMPOSE_FILE="${COMPOSE_FILE:-deploy-compose.yml}"
SERVICE="${1:-api}"

git pull --ff-only
docker compose -f "$COMPOSE_FILE" build "$SERVICE"
docker compose -f "$COMPOSE_FILE" up -d "$SERVICE"
