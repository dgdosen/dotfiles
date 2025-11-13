#!/bin/bash

# Install app wrappers by symlinking them to ~/Applications/
# This allows macOS to grant permissions to the app bundles

APPS_DIR="$HOME/.dotfiles/apps"
INSTALL_DIR="$HOME/Applications"

# Ensure ~/Applications exists
mkdir -p "$INSTALL_DIR"

# Find all .app bundles and symlink them
for app in "$APPS_DIR"/*.app; do
    if [ -d "$app" ]; then
        app_name=$(basename "$app")
        target="$INSTALL_DIR/$app_name"

        # Remove existing symlink or directory
        if [ -L "$target" ] || [ -e "$target" ]; then
            echo "Removing existing: $target"
            rm -rf "$target"
        fi

        # Create symlink
        echo "Linking: $app_name -> $INSTALL_DIR/"
        ln -s "$app" "$target"
    fi
done

echo ""
echo "Apps installed to ~/Applications/"
echo "You can now grant permissions to these apps in System Settings"
