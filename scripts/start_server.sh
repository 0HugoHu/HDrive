#!/bin/bash

cd /home/ubuntu/hdrive/dist || exit 1

chmod +x ./hdrive

if pgrep -f "./hdrive server" > /dev/null; then
    echo "hdrive is already running. Skipping start."
else
    echo "Starting hdrive..."
    nohup ./hdrive server > ./hdrive.out 2>&1 &
    echo "hdrive started in background. Logs at ./hdrive.out"
fi
