#!/bin/bash
cd /home/ubuntu/hdrive/dist
chmod +x ./hdrive
nohup ./hdrive server > hdrive.log 2>&1 &
