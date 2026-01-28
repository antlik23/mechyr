#!/bin/bash
set -e

TEST_USER_EMAIL_DEFAULT="patient1@example.com"
TEST_USER_PASSWORD_DEFAULT="test123"

ensure_env_kv() {
  local env_file="$1"
  local key="$2"
  local value="$3"
  if ! grep -qE "^${key}=" "$env_file"; then
    echo "${key}=\"${value}\"" >> "$env_file"
  fi
}

# Create frontend .env if it doesn't exist
if [ ! -f ovladni_mechyr_fe/.env ]; then
  echo "Creating ovladni_mechyr_fe/.env..."
  cat <<EOF > ovladni_mechyr_fe/.env
TEST_USER_EMAIL="${TEST_USER_EMAIL_DEFAULT}"
TEST_USER_PASSWORD="${TEST_USER_PASSWORD_DEFAULT}"

PUBLIC_TEST_USER_EMAIL="${TEST_USER_EMAIL_DEFAULT}"
PUBLIC_TEST_USER_PASSWORD="${TEST_USER_PASSWORD_DEFAULT}"

PUBLIC_API_URL="http://localhost:3000"

PUBLIC_GOOGLE_PLAY_LINK=""
PUBLIC_APPLE_APP_STORE_LINK=""
EOF
else
  # Ensure dev test-user env vars exist (idempotent)
  ensure_env_kv ovladni_mechyr_fe/.env TEST_USER_EMAIL "$TEST_USER_EMAIL_DEFAULT"
  ensure_env_kv ovladni_mechyr_fe/.env TEST_USER_PASSWORD "$TEST_USER_PASSWORD_DEFAULT"
  ensure_env_kv ovladni_mechyr_fe/.env PUBLIC_TEST_USER_EMAIL "$TEST_USER_EMAIL_DEFAULT"
  ensure_env_kv ovladni_mechyr_fe/.env PUBLIC_TEST_USER_PASSWORD "$TEST_USER_PASSWORD_DEFAULT"
fi

echo "Starting Backend and Database with Docker Compose..."
docker-compose up -d --build

echo "Waiting for services to spin up..."
sleep 10

echo "Preparing Database..."
docker-compose exec backend bin/rails db:prepare

echo "Backend is running at http://localhost:3000"

echo "Installing Frontend Dependencies..."
cd ovladni_mechyr_fe
pnpm install

echo "Starting Frontend..."
pnpm dev
