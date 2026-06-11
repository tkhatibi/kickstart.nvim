#!/bin/sh

set -e

# set -euo pipefail

# Ensure ~/.nix-profile/bin is in PATH
export PATH="$HOME/.nix-profile/bin:$PATH"

# 1. Install Neovim via nix-env
echo "Installing Neovim with Nix..."
nix-env -iA nixpkgs.neovim

# 2. Set up empty init.lua
NVIM_CONFIG_DIR="$HOME/.config/nvim"
echo "Creating Neovim config directory at $NVIM_CONFIG_DIR..."
mkdir -p "$NVIM_CONFIG_DIR"
echo "-- init.lua (empty)" > "$NVIM_CONFIG_DIR/init.lua"
echo "✅ Created empty init.lua"

# 3. Verify installation
echo "Verifying Neovim..."
if command -v nvim >/dev/null 2>&1; then
  echo "✅ Neovim installed: $(nvim --version | head -n1)"
else
  echo "❌ Neovim installation failed."
  exit 1
fi
