#!/bin/bash
set -e

# Create frontend .env if it doesn't exist
if [ ! -f ovladni_mechyr_fe/.env ]; then
  echo "Creating ovladni_mechyr_fe/.env..."
  cat <<EOF > ovladni_mechyr_fe/.env
TEST_USER_EMAIL=""
TEST_USER_PASSWORD=""

PUBLIC_API_URL="http://localhost:3000"

PUBLIC_GOOGLE_PLAY_LINK=""
PUBLIC_APPLE_APP_STORE_LINK=""
EOF
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
