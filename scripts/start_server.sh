#!/bin/bash

cd /home/ubuntu/hdrive/dist || exit 1

chmod +x ./hdrive

echo "Stopping any existing hdrive process..."
pkill -f "./hdrive server"

sleep 2

echo "Starting new hdrive instance..."
nohup ./hdrive server &

echo "hdrive restarted"