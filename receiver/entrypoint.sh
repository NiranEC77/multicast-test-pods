#!/bin/bash

echo "=== Multicast Receiver Pod ==="
echo "Multicast Group: ${MULTICAST_ADDR}"
echo "Port: ${MULTICAST_PORT}"
echo ""
echo "Available commands:"
echo "  1. Listen for multicast messages (with timestamps):"
echo "     /opt/multicast/listen-jboss.sh"
echo ""
echo "  2. Listen for raw multicast messages:"
echo "     /opt/multicast/listen-raw.sh"
echo ""
echo "  3. Capture multicast traffic with tcpdump:"
echo "     /opt/multicast/tcpdump-multicast.sh"
echo ""
echo "Pod ready. Keeping container alive..."

# Keep the container running
exec tail -f /dev/null
