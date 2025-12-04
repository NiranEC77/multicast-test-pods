#!/bin/bash
# Capture all multicast traffic
MULTICAST_ADDR="${1:-${MULTICAST_ADDR:-224.0.1.105}}"

echo "Capturing multicast traffic to $MULTICAST_ADDR..."
echo "Press Ctrl+C to stop"
tcpdump -i any host $MULTICAST_ADDR -vv -n

