#!/bin/bash

echo "=== Multicast Receiver Pod ==="
echo "Multicast Group: ${MULTICAST_ADDR}"
echo "Port: ${MULTICAST_PORT}"
echo ""
echo "Available commands:"
echo "  1. Listen for multicast messages:"
echo "     socat UDP4-RECVFROM:${MULTICAST_PORT},ip-add-membership=${MULTICAST_ADDR}:0.0.0.0,fork -"
echo ""
echo "  2. Listen with timestamps:"
echo "     /opt/multicast/listen-jboss.sh"
echo ""
echo "  3. Capture multicast traffic with tcpdump:"
echo "     /opt/multicast/tcpdump-multicast.sh"
echo ""
echo "Pod ready. Keeping container alive..."

# Keep the container running
exec tail -f /dev/null

