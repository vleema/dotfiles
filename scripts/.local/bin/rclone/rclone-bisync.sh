#!/bin/bash

REMOTE="gdrive:sync"
LOCAL_PATH="$HOME"/cloud
REMOTE_PATH=""
BISYNC_WORKDIR="$HOME"/.local/state/rclone-bisync
LOG_FILE="$BISYNC_WORKDIR"/rclone-bisync.log
EXCLUDE_DIRS='{.lake/**,target/**,.git/**,ssd-*/**,*venv/**,.ruff-cache/**}'
RESYNC=$1

notify() {
  notify-send -u "$2" "Rclone Sync" "$1"
}

log() {
  echo "[$(date +'%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

log "Starting rclone bisync"

rclone bisync "$LOCAL_PATH" "${REMOTE}${REMOTE_PATH}" \
  --links \
  --verbose \
  --force \
  --create-empty-src-dirs \
  --exclude "$EXCLUDE_DIRS" \
  --resilient \
  --recover \
  --conflict-resolve newer \
  --conflict-suffix "sync-conflict-{DateOnly}" \
  $RESYNC \
  # --protondrive-replace-existing-draft=true \
  2>&1 | tee -a "$LOG_FILE"

if [ "${PIPESTATUS[0]}" -eq 0 ]; then
  log "Bisync completed successfully"
  if tail -50 "$LOG_FILE" | grep -q "sync-conflict"; then
    notify "Sync completed with conflicts - check conflict files" "normal"
  else
    notify "Sync completed successfully" "normal"
  fi
  exit 0
else
  EXIT_CODE=$?
  log "Bisync failed with exit code $EXIT_CODE"
  notify "Sync failed! Check logs at $LOG_FILE" "critical"
fi
