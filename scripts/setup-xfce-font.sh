#!/bin/sh

set -e

# Script to download, install Fira Code Nerd Font, and configure Xfce Terminal

# Set variables
font_url="https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/FiraCode.zip"
font_zip="FiraCode.zip"
font_dir="$HOME/.fonts"
xfce_config_file="$HOME/.config/xfce4/terminal/terminalrc" # Xfce terminal config file

# Check if required commands are installed
command -v wget >/dev/null 2>&1 || { echo >&2 "wget is required but not installed.  Aborting."; exit 1; }
command -v unzip >/dev/null 2>&1 || { echo >&2 "unzip is required but not installed.  Aborting."; exit 1; }
command -v fc-cache >/dev/null 2>&1 || { echo >&2 "fc-cache is required but not installed.  Aborting."; exit 1; }


# Create font directory if it doesn't exist
mkdir -p "$font_dir"

# Download the font zip file
if ! wget -q "$font_url" -O "$font_zip"; then
  echo "Failed to download font archive."
  exit 1
fi

# Unzip the font files
unzip -q "$font_zip" -d "$font_dir"
if [ $? -ne 0 ]; then
  echo "Failed to extract font archive."
  exit 1
fi

# Remove the zip file
rm "$font_zip"

# Update font cache
fc-cache -f -v

# Configure Xfce Terminal
if [ -f "$xfce_config_file" ]; then
  echo "Found Xfce Terminal config file: $xfce_config_file"
else
  echo "Xfce Terminal config file not found. It should be located at $xfce_config_file.  Please ensure Xfce Terminal is installed.  Aborting."
  exit 1
fi

# Check if the font is already configured
if grep -q "FontName=FiraCode Nerd Font" "$xfce_config_file"; then
    echo "FiraCode Nerd Font already configured in $xfce_config_file. Skipping."
else
    echo "Adding FiraCode Nerd Font configuration to $xfce_config_file"
    # Use sed to add the font configuration.  This is safer than just appending.
    sed -i "s/FontName=Monospace 12/FontName=FiraCode Nerd Font Mono 12/g" "$xfce_config_file" # Change Monospace 12 to your current font.
fi

echo "Fira Code Nerd Font installed and Xfce Terminal configured. Please restart Xfce Terminal."
exit 0

