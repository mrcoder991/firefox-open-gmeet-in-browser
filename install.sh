#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
SOURCE_DIR="$SCRIPT_DIR/native-host"

# Install native host to a TCC-safe location (~/Documents is protected on macOS)
INSTALL_DIR="$HOME/.local/share/open-meet-in-browser"
NMH_DIR="$HOME/Library/Application Support/Mozilla/NativeMessagingHosts"
MANIFEST_NAME="open_in_browser.json"

mkdir -p "$INSTALL_DIR"
mkdir -p "$NMH_DIR"

cp "$SOURCE_DIR/open_in_browser.py" "$INSTALL_DIR/open_in_browser.py"
chmod +x "$INSTALL_DIR/open_in_browser.py"

# Create the shell wrapper at the install location
cat > "$INSTALL_DIR/open_in_browser.sh" <<'WRAPPER'
#!/bin/bash
DIR="$(cd "$(dirname "$0")" && pwd)"
/usr/bin/python3 -u "$DIR/open_in_browser.py"
WRAPPER
chmod +x "$INSTALL_DIR/open_in_browser.sh"

# Write the native messaging host manifest pointing to the installed wrapper
cat > "$NMH_DIR/$MANIFEST_NAME" <<EOF
{
  "name": "open_in_browser",
  "description": "Opens URLs in an external browser for the Open Meet In... extension",
  "path": "$INSTALL_DIR/open_in_browser.sh",
  "type": "stdio",
  "allowed_extensions": ["udaygirhepunje41open-meet-in@gmail.com"]
}
EOF

echo ""
echo "=== Installation complete ==="
echo ""
echo "Native host installed to:"
echo "  $INSTALL_DIR/"
echo ""
echo "Manifest registered at:"
echo "  $NMH_DIR/$MANIFEST_NAME"
echo ""
echo "Next steps:"
echo "  1. Open Zen Browser and go to:  about:debugging#/runtime/this-firefox"
echo "  2. Click 'Load Temporary Add-on...'"
echo "  3. Select:  $SCRIPT_DIR/extension/manifest.json"
echo "  4. Click the extension icon in the toolbar to pick your browser"
echo "  5. Open any meet.google.com link — it will redirect automatically"
echo ""
echo "Note: This also works with Firefox since Zen uses the same engine."
echo ""
