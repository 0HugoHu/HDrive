#!/bin/bash

set -e

echo "[1/6] Entering frontend directory..."
cd "$(dirname "$0")/frontend"

echo "[2/6] Installing frontend dependencies via pnpm..."
pnpm install

echo "[3/6] Building frontend..."
pnpm run build

echo "[4/6] Copying built dist/ to public/dist..."
cd ..
rm -rf public/dist
mkdir -p public
cp -r frontend/dist public/dist

echo "[5/6] Building Go backend to dist/hdrive..."
appName="hdrive"
buildDir="dist"
mkdir -p "$buildDir"

go build -o "$buildDir/$appName" -ldflags="-w -s" -tags=jsoniter .

echo "[6/6] Committing and pushing to Git..."
git add "$buildDir/$appName"
git commit -m "build: update compiled binary for $appName"
git push

echo "All build steps completed successfully."
