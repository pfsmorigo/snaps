#!/bin/bash

# Exit on error for critical steps, but provide custom messages
set -o pipefail

# Ensure the target directory exists in the common area
mkdir -p "$SNAP_USER_COMMON/ProgramasRFB"

# Map ~/ProgramasRFB to the common area via symlink for persistence across refreshes
if [ -d "$HOME/ProgramasRFB" ] && [ ! -L "$HOME/ProgramasRFB" ]; then
    echo "Migrating existing data to persistent area..."
    if cp -a "$HOME/ProgramasRFB/." "$SNAP_USER_COMMON/ProgramasRFB/"; then
        rm -rf "$HOME/ProgramasRFB"
    else
        echo "Error: Failed to migrate data to $SNAP_USER_COMMON/ProgramasRFB" >&2
        exit 1
    fi
fi

if [ ! -L "$HOME/ProgramasRFB" ]; then
    ln -sf "$SNAP_USER_COMMON/ProgramasRFB" "$HOME/ProgramasRFB"
fi

# In a snap, the app expects ~/ProgramasRFB.
TARGET_DIR="$HOME/ProgramasRFB/IRPF2026"
ZIP_URL="https://downloadirpf.receita.fazenda.gov.br/irpf/2026/irpf/arquivos/IRPF2026-1.2.zip"

# Bootstrap (if missing)
if [ ! -d "$TARGET_DIR" ]; then
    echo "Initializing IRPF in $TARGET_DIR..."
    TEMP_ZIP=$(mktemp /tmp/irpf-XXXXXX.zip)

    if curl -L "$ZIP_URL" -o "$TEMP_ZIP"; then
        unzip -o "$TEMP_ZIP" -d "$HOME/ProgramasRFB"
        rm -f "$TEMP_ZIP"
    else
        echo "Error: Failed to download IRPF from $ZIP_URL" >&2
        rm -f "$TEMP_ZIP"
        exit 1
    fi
fi

# Dynamic JAR Discovery
JAR_PATH=$(find "$TARGET_DIR" -name "IRPF*.jar" | head -n 1)

if [ -z "$JAR_PATH" ] || [ ! -f "$JAR_PATH" ]; then
    echo "Error: IRPF JAR not found in $TARGET_DIR" >&2
    exit 1
fi

echo "Launching IRPF: $JAR_PATH"
exec java -jar "$JAR_PATH" "$@"
