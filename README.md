# Multicast Test Pods for JBoss/JGroups Testing

Container images and Kubernetes manifests for testing multicast communication, commonly used by JBoss/WildFly for cluster discovery and communication via JGroups.

**Now includes real JGroups protocol testing!**

## Container Images

| Image | Description |
|-------|-------------|
| `ghcr.io/niranec77/multicast-transmitter:latest` | Multicast sender with JGroups support |
| `ghcr.io/niranec77/multicast-receiver:latest` | Multicast receiver with JGroups support |

## Features

- **Basic multicast testing** - Simple send/receive for connectivity verification
- **JGroups protocol testing** - Real JBoss/WildFly cluster protocol simulation
- **Cluster formation testing** - Watch nodes discover each other like real JBoss clusters
- **Network debugging** - tcpdump integration for packet capture

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

### 2. Basic Multicast Test

**Terminal 1 - Start Receiver:**
```bash
kubectl exec -it multicast-receiver -- /bin/bash
/opt/multicast/listen-jboss.sh
```

**Terminal 2 - Send Messages:**
```bash
kubectl exec -it multicast-transmitter -- /bin/bash
/opt/multicast/send-jboss-heartbeat.sh
```

### 3. JGroups Protocol Test (Real JBoss Simulation)

This tests the actual JGroups protocol used by JBoss/WildFly clusters.

**Terminal 1 - JGroups Receiver:**
```bash
kubectl exec -it multicast-receiver -- /bin/bash
/opt/multicast/jgroups-receive.sh
```

**Terminal 2 - JGroups Sender:**
```bash
kubectl exec -it multicast-transmitter -- /bin/bash
/opt/multicast/jgroups-send.sh
```

### 4. Cluster Formation Test (Most Realistic)

This simulates actual JBoss cluster discovery and formation. Run on both pods:

**Terminal 1 - First Cluster Member:**
```bash
kubectl exec -it multicast-receiver -- /bin/bash
/opt/multicast/jgroups-cluster.sh
```

**Terminal 2 - Second Cluster Member:**
```bash
kubectl exec -it multicast-transmitter -- /bin/bash
/opt/multicast/jgroups-cluster.sh
```

You should see output like:
```
-------------------------------------------------------------------
GMS: address=multicast-receiver-xxxxx, cluster=jboss-cluster, physical address=192.168.1.10:7800
-------------------------------------------------------------------
** view: [multicast-receiver-xxxxx|1] (2) [multicast-receiver-xxxxx, multicast-transmitter-xxxxx]
```

This confirms nodes can discover each other via multicast - exactly like a real JBoss cluster!

## Environment Variables

Both pods support these environment variables:

| Variable | Default | Description |
|----------|---------|-------------|
| `MULTICAST_ADDR` | `224.0.1.105` | Multicast group address |
| `MULTICAST_PORT` | `45688` | UDP port |
| `INTERVAL` | `2` | Heartbeat interval (transmitter only) |
| `CLUSTER_NAME` | `jboss-cluster` | JGroups cluster name |

### Custom Configuration Example

```yaml
env:
- name: MULTICAST_ADDR
  value: "228.6.7.8"
- name: MULTICAST_PORT
  value: "45700"
- name: CLUSTER_NAME
  value: "my-jboss-cluster"
```

## JBoss/JGroups Specific Testing

### Common JBoss Multicast Addresses

| Purpose | Address | Default Port |
|---------|---------|--------------|
| JBoss Cluster (default) | 224.0.1.105 | 45688 |
| JGroups MPING | 228.6.7.8 | 45700 |
| Modcluster | 224.0.1.105 | 23364 |
| JBoss Messaging | 231.7.7.7 | Various |

### What the JGroups Tests Simulate

| Script | What it tests |
|--------|---------------|
| `jgroups-receive.sh` | Receiving JGroups multicast discovery messages |
| `jgroups-send.sh` | Sending JGroups multicast discovery messages |
| `jgroups-cluster.sh` | Full cluster formation with membership view updates |

## Available Scripts

### Transmitter (`/opt/multicast/`)

| Script | Description |
|--------|-------------|
| `send-jboss-heartbeat.sh` | Continuous heartbeat sender (basic) |
| `send-single.sh [ADDR] [PORT] [MSG]` | Send single message (basic) |
| `jgroups-send.sh` | JGroups protocol sender |
| `jgroups-cluster.sh` | Join cluster as member |

### Receiver (`/opt/multicast/`)

| Script | Description |
|--------|-------------|
| `listen-jboss.sh` | Listen with timestamps (Python) |
| `listen-raw.sh [ADDR] [PORT]` | Raw listener (Python) |
| `tcpdump-multicast.sh [ADDR]` | Capture traffic |
| `jgroups-receive.sh` | JGroups protocol receiver |
| `jgroups-cluster.sh` | Join cluster as member |

## Building the Images

### Build locally

```bash
# Build transmitter
cd transmitter
docker build --platform linux/amd64 -t ghcr.io/niranec77/multicast-transmitter:latest .

# Build receiver
cd ../receiver
docker build --platform linux/amd64 -t ghcr.io/niranec77/multicast-receiver:latest .
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

The receiver uses Python for basic multicast group membership due to a bug in socat 1.8.x where the `ip-add-membership` option incorrectly parses environment variables as interface names. The transmitter still uses socat for basic sending (which works correctly).

### JGroups Version

These containers include JGroups 5.3.1.Final, which is compatible with:
- WildFly 26+
- JBoss EAP 7.4+
- Infinispan 14+

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

### JGroups cluster not forming?

1. **Check JGroups logs for errors:**
   ```bash
   # Look for bind address issues or multicast disabled messages
   ```

2. **Verify both pods can reach multicast address:**
   ```bash
   kubectl exec -it multicast-receiver -- ping -c 3 224.0.1.105
   ```

3. **Check if CNI supports IGMP:**
   ```bash
   kubectl exec -it multicast-receiver -- cat /proc/net/igmp | grep -i 224
   ```

### Test basic connectivity first

```bash
# Get transmitter pod IP
TX_IP=$(kubectl get pod multicast-transmitter -o jsonpath='{.status.podIP}')

# Ping from receiver
kubectl exec -it multicast-receiver -- ping -c 3 $TX_IP
```

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
