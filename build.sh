#!/bin/bash
# build.sh: Build frontend, copy to public, build backend (Linux target), push to Git

set -e

echo "[1/6] Entering frontend directory..."
cd "$(dirname "$0")/frontend"

echo "[2/6] Installing frontend dependencies via pnpm..."
pnpm install

echo "[3/6] Building frontend..."
pnpm run build

echo "[4/6] Copying built dist/ to public/dist..."
cd ..
if [ -d "public/dist" ]; then
    echo "Removing old public/dist..."
    rm -rf public/dist
fi
echo "Copying frontend/dist to public/dist..."
cp -r frontend/dist public/dist

echo "[5/6] Building Go backend for Linux (GOOS=linux GOARCH=amd64)..."
appName="hdrive"
buildDir="dist"
mkdir -p "$buildDir"

# Ensure required tools are present
if ! command -v gcc > /dev/null; then
    echo "Error: gcc is not installed. Please run 'sudo apt install build-essential libsqlite3-dev'"
    exit 1
fi

export GOOS=linux
export GOARCH=amd64
export CGO_ENABLED=1

go build -o "$buildDir/$appName" -ldflags="-w -s" -tags=jsoniter .

echo "[6/6] Committing to Git..."
git add "$buildDir/$appName"
git commit -m "build: update compiled binary for $appName"
#git push

echo "All build steps completed successfully."
