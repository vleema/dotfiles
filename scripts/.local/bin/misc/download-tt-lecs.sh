#!/bin/sh

URL="https://www.tsouanas.org/teaching/tt/2025.1/docs/tt-2025.1-lecs.pdf"
DEST_DIR="$HOME/Public/OneDrive/Cave/Projects/2025.1-ufrn/tt/resources"
FILENAME="tt-2025.1-lecs.pdf"

if [ ! -d "$DEST_DIR" ]; then
  echo "Error: directory '$DEST_DIR' doesn't exist"
  exit 1
fi

echo "Downloading $FILENAME to $DEST_DIR..."

if ! wget -q --show-progress "$URL" -O "$DEST_DIR/$FILENAME"; then
  echo "Error: Download failed."
  exit 1
fi
