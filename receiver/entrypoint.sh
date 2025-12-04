#!/bin/bash

echo "=== Multicast Receiver Pod ==="
echo "Multicast Group: ${MULTICAST_ADDR}"
echo "Port: ${MULTICAST_PORT}"
echo ""
echo "=== Basic Multicast Testing ==="
echo "  1. Listen for multicast messages (Python, with timestamps):"
echo "     /opt/multicast/listen-jboss.sh"
echo ""
echo "  2. Listen for raw multicast messages (Python):"
echo "     /opt/multicast/listen-raw.sh"
echo ""
echo "  3. Capture multicast traffic with tcpdump:"
echo "     /opt/multicast/tcpdump-multicast.sh"
echo ""
echo "=== JGroups/JBoss Testing (Real Protocol) ==="
echo "  4. Receive JGroups protocol messages:"
echo "     /opt/multicast/jgroups-receive.sh"
echo ""
echo "  5. Join a JGroups cluster (most realistic):"
echo "     /opt/multicast/jgroups-cluster.sh"
echo ""
echo "Pod ready. Keeping container alive..."

# Keep the container running
exec tail -f /dev/null
