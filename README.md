# Multicast Test Pods for JBoss Legacy App Testing

Container images and Kubernetes manifests for testing multicast communication, commonly used by JBoss/WildFly for cluster discovery and communication via JGroups.

## Container Images

| Image | Description |
|-------|-------------|
| `ghcr.io/niranec77/multicast-transmitter:latest` | Multicast sender for testing |
| `ghcr.io/niranec77/multicast-receiver:latest` | Multicast receiver for testing |

## Prerequisites

⚠️ **Important**: Multicast must be enabled in your Kubernetes cluster/CNI. Not all CNI plugins support multicast by default.

### CNI Plugins that support Multicast:
- **Antrea**: Native multicast support (recommended for VMware environments)
- **Calico**: Requires `ipip` mode or proper configuration
- **Flannel**: Works with VXLAN backend
- **Weave Net**: Native multicast support
- **Cilium**: May require configuration

## Quick Start

### 1. Deploy the Pods

```bash
# Deploy both pods
kubectl apply -f multicast-transmitter.yaml
kubectl apply -f multicast-receiver.yaml

# Verify pods are running
kubectl get pods -l app=multicast-test
```

### 2. Start the Receiver (Terminal 1)

```bash
# Exec into receiver pod
kubectl exec -it multicast-receiver -- /bin/bash

# Start listening for multicast messages (with timestamps)
/opt/multicast/listen-jboss.sh

# Or use raw listener
/opt/multicast/listen-raw.sh
```

### 3. Send from Transmitter (Terminal 2)

```bash
# Exec into transmitter pod
kubectl exec -it multicast-transmitter -- /bin/bash

# Send a test message
echo "Hello from JBoss Cluster Node" | socat - UDP4-DATAGRAM:224.0.1.105:45688,so-broadcast

# Or send continuous heartbeats (like JBoss cluster)
/opt/multicast/send-jboss-heartbeat.sh
```

## Environment Variables

Both pods support these environment variables:

| Variable | Default | Description |
|----------|---------|-------------|
| `MULTICAST_ADDR` | `224.0.1.105` | Multicast group address |
| `MULTICAST_PORT` | `45688` | UDP port |
| `INTERVAL` | `2` | Heartbeat interval (transmitter only) |

### Custom Configuration Example

```yaml
env:
- name: MULTICAST_ADDR
  value: "228.6.7.8"
- name: MULTICAST_PORT
  value: "45700"
```

## JBoss/JGroups Specific Testing

### Common JBoss Multicast Addresses

| Purpose | Address | Default Port |
|---------|---------|--------------|
| JBoss Cluster (default) | 224.0.1.105 | 45688 |
| JGroups MPING | 228.6.7.8 | 45700 |
| Modcluster | 224.0.1.105 | 23364 |
| JBoss Messaging | 231.7.7.7 | Various |

## Building the Images

### Build locally

```bash
# Build transmitter
cd transmitter
docker build -t ghcr.io/niranec77/multicast-transmitter:latest .

# Build receiver
cd ../receiver
docker build -t ghcr.io/niranec77/multicast-receiver:latest .
```

### Push to GHCR

```bash
# Login to GHCR
echo $GITHUB_TOKEN | docker login ghcr.io -u NiranEC77 --password-stdin

# Push images
docker push ghcr.io/niranec77/multicast-transmitter:latest
docker push ghcr.io/niranec77/multicast-receiver:latest
```

## Technical Notes

### Why Python instead of socat for receiving?

The receiver uses Python for multicast group membership due to a bug in socat 1.8.x where the `ip-add-membership` option incorrectly parses environment variables as interface names. The transmitter still uses socat for sending (which works correctly).

## Troubleshooting

### No messages received?

1. **Check if multicast is supported:**
   ```bash
   kubectl exec -it multicast-receiver -- cat /proc/net/igmp
   ```

2. **Check if pods are on same network:**
   ```bash
   kubectl get pods -o wide -l app=multicast-test
   ```

3. **Use tcpdump to verify traffic:**
   ```bash
   kubectl exec -it multicast-receiver -- /opt/multicast/tcpdump-multicast.sh
   ```

4. **Check security/network policies:**
   ```bash
   kubectl get networkpolicies
   ```

### Test basic connectivity first

```bash
# Get transmitter pod IP
TX_IP=$(kubectl get pod multicast-transmitter -o jsonpath='{.status.podIP}')

# Ping from receiver
kubectl exec -it multicast-receiver -- ping -c 3 $TX_IP
```

## Available Scripts

### Transmitter (`/opt/multicast/`)
- `send-jboss-heartbeat.sh` - Continuous heartbeat sender
- `send-single.sh [ADDR] [PORT] [MSG]` - Send single message

### Receiver (`/opt/multicast/`)
- `listen-jboss.sh` - Listen with timestamps (uses Python)
- `listen-raw.sh [ADDR] [PORT]` - Raw listener (uses Python)
- `tcpdump-multicast.sh [ADDR]` - Capture traffic

## Cleanup

```bash
kubectl delete -f multicast-transmitter.yaml
kubectl delete -f multicast-receiver.yaml
```

## Security Considerations

These pods require `NET_ADMIN` and `NET_RAW` capabilities to:
- Join multicast groups
- Send/receive raw network packets
- Use tcpdump for debugging

For production testing, consider using a dedicated namespace with appropriate RBAC.

## License

MIT
