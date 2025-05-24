#!/bin/sh

set -e

set -euo pipefail

# 1. Install Nix in multi-user mode
echo "Installing Nix (multi-user mode)..."
curl -L https://nixos.org/nix/install | sh -s -- --daemon

# 2. Enable experimental Flakes support
echo "Enabling Nix Flakes..."
sudo mkdir -p /etc/nix
sudo bash -c 'grep -qxF "experimental-features = nix-command flakes" /etc/nix/nix.conf \
  || echo "experimental-features = nix-command flakes" >> /etc/nix/nix.conf'

# 3. Restart the Nix daemon to apply the new config
echo "Restarting nix-daemon..."
sudo systemctl restart nix-daemon.service

# 4. Verify that Flakes are enabled
echo "Verifying Flakes..."
if nix show-config | grep -q flakes; then
  echo "✅ Nix Flakes enabled!"
else
  echo "❌ Failed to enable Nix Flakes."
  exit 1
fi
