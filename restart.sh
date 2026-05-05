COMPOSE_FILE="${COMPOSE_FILE:-deploy-compose.yml}"

docker compose -f "$COMPOSE_FILE" down
docker compose -f "$COMPOSE_FILE" up -d
