#!/bin/bash

REMOTE="proton:"
LOCAL_PATH="$HOME"/proton
REMOTE_PATH=""
BISYNC_WORKDIR="$HOME"/.local/state/rclone-bisync
LOG_FILE="$BISYNC_WORKDIR"/rclone-bisync.log
BLOCKING=${1:-false}
CLEAN_SYNC_DIR=${2:-false}
EXCLUDE_DIRS='{.lake/**,target/**,.git/**,ssd-*/**,*venv/**,.ruff-cache/**}'

notify() {
  notify-send -u "$2" "Rclone Sync" "$1"
}

log() {
  echo "[$(date +'%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

if [ "$CLEAN_SYNC_DIR" = "true" ]; then
  rm -rf "$BISYNC_WORKDIR"
  exit 0
fi

if [ ! -d "$BISYNC_WORKDIR" ] || [ -z "$(ls -A "$BISYNC_WORKDIR")" ]; then
  mkdir -p "$BISYNC_WORKDIR"

  log "Starting rclone bisync (blocking: $BLOCKING)"

  log "First run detected, performing initial resync"
  notify "Performing intial sync setup..." "normal"

  rclone bisync "$LOCAL_PATH" "${REMOTE}${REMOTE_PATH}" \
    --resync \
    --workdir "$BISYNC_WORKDIR" \
    --links \
    --verbose \
    --exclude "$EXCLUDE_DIRS" \
    --create-empty-src-dirs \
    --protondrive-replace-existing-draft=true \
    2>&1 | tee -a "$LOG_FILE"

  if [ "${PIPESTATUS[0]}" -eq 0 ]; then
    log "Initial resync completed successfully"
    notify "Initial sync completed successfully" "normal"
  else
    log "Initial resync failed"
    notify "Initial sync failed! Check logs at $LOG_FILE" "critical"
    [ "$BLOCKING" = "true" ] && exit 1
  fi
  exit 0
fi

log "Starting rclone bisync (blocking: $BLOCKING)"

rclone bisync "$LOCAL_PATH" "${REMOTE}${REMOTE_PATH}" \
  --workdir "$BISYNC_WORKDIR" \
  --links \
  --verbose \
  --force \
  --create-empty-src-dirs \
  --exclude "$EXCLUDE_DIRS" \
  --resilient \
  --recover \
  --conflict-suffix "sync-conflict-{DateOnly}" \
  --protondrive-replace-existing-draft=true \
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

  [ "$BLOCKING" = "true" ] && exit 1 || exit 0
fi
