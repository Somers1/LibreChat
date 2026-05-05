#!/usr/bin/env bash
# rotate-librechat-env.sh
# Copies .env.example to .env and replaces all known LibreChat secrets
# with freshly generated random values. Run from the LibreChat repo root.

EXAMPLE_FILE=".env.example"
ENV_FILE=".env"

# Sanity check: are we in the right directory?
if [[ ! -f "$EXAMPLE_FILE" ]]; then
  echo "Error: $EXAMPLE_FILE not found. Run this from the LibreChat repo root." >&2
  exit 1
fi

# Don't clobber an existing .env without explicit confirmation
if [[ -f "$ENV_FILE" ]]; then
  read -p "$ENV_FILE already exists. Overwrite? [y/N] " -n 1 -r
  echo
  if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Aborted."
    exit 0
  fi
fi

cp "$EXAMPLE_FILE" "$ENV_FILE"

# Generate fresh secrets
NEW_CREDS_KEY=$(openssl rand -hex 32)
NEW_CREDS_IV=$(openssl rand -hex 16)
NEW_JWT_SECRET=$(openssl rand -hex 32)
NEW_JWT_REFRESH_SECRET=$(openssl rand -hex 32)
NEW_MEILI_MASTER_KEY=$(openssl rand -hex 32)

# Portable in-place replacement (sed -i syntax differs Mac vs Linux, so use perl)
replace_var() {
  local var="$1"
  local value="$2"
  perl -i -pe "s|^${var}=.*|${var}=${value}|" "$ENV_FILE"
}

replace_var "CREDS_KEY" "$NEW_CREDS_KEY"
replace_var "CREDS_IV" "$NEW_CREDS_IV"
replace_var "JWT_SECRET" "$NEW_JWT_SECRET"
replace_var "JWT_REFRESH_SECRET" "$NEW_JWT_REFRESH_SECRET"
replace_var "MEILI_MASTER_KEY" "$NEW_MEILI_MASTER_KEY"

echo "✓ Created $ENV_FILE with rotated secrets:"
echo "  - CREDS_KEY"
echo "  - CREDS_IV"
echo "  - JWT_SECRET"
echo "  - JWT_REFRESH_SECRET"
echo "  - MEILI_MASTER_KEY"
