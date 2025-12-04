#!/bin/bash
set -e

NODE_ROLE="${node_role}"
CONTROL_PLANE_IP="${control_plane_ip}"




# Download the actual bootstrap script
cat <<'EOF' > /tmp/kubernetes_cluster_bootstrap.sh
${bootstrap_script}
EOF

# Run the script with arguments
bash /tmp/kubernetes_cluster_bootstrap.sh "$NODE_ROLE" "$CONTROL_PLANE_IP"

