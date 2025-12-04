FROM alpine:3.19

LABEL org.opencontainers.image.source="https://github.com/NiranEC77/multicast-test-pods"
LABEL org.opencontainers.image.description="Multicast receiver for JBoss/JGroups testing"
LABEL org.opencontainers.image.licenses="MIT"

# Install required packages
# Note: Using Python for multicast receiving due to socat 1.8.x bug with ip-add-membership
RUN apk add --no-cache \
    python3 \
    socat \
    iproute2 \
    iputils \
    bash \
    tcpdump \
    && rm -rf /var/cache/apk/*

# Copy scripts
COPY scripts/ /opt/multicast/

# Make scripts executable
RUN chmod +x /opt/multicast/*.sh

# Set working directory
WORKDIR /opt/multicast

# Default environment variables
ENV MULTICAST_ADDR=224.0.1.105
ENV MULTICAST_PORT=45688

# Entrypoint script
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]

