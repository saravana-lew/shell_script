#!/bin/bash

# Configuration
SOURCE_DIR="/path/to/source"
DEST_DIR="/path/to/destination"
LOG_FILE="/var/log/file_transfer.log"
ERROR_LOG="/var/log/file_transfer_error.log"

# Ensure destination directory exists
mkdir -p "$DEST_DIR"

# Logging function
log_message() {
    echo "$(date): $1" | tee -a "$LOG_FILE"
}

# Error logging function
log_error() {
    echo "$(date): ERROR - $1" | tee -a "$ERROR_LOG"
}

# File transfer function
transfer_files() {
    for file in "$SOURCE_DIR"/*; do
        if [ -f "$file" ]; then
            filename=$(basename "$file")
            log_message "Starting transfer of $filename"
            mv "$file" "$DEST_DIR/" 2>>"$ERROR_LOG"
            if [ $? -eq 0 ]; then
                log_message "Successfully transferred $filename"
            else
                log_error "Failed to transfer $filename"
            fi
        fi
    done
}

# Main workflow
log_message "Starting file transfer workflow"

# Check if source directory is empty
if [ "$(ls -A $SOURCE_DIR 2>/dev/null)" ]; then
    transfer_files
else
    log_message "No files to transfer in $SOURCE_DIR"
fi

log_message "File transfer workflow completed"