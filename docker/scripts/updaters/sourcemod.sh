#!/bin/bash
# SourceMod Auto-Update Script
# Downloads and installs SourceMod from AlliedMods

source /utils/logging.sh
source /utils/updater_common.sh

update_sourcemod() {
    local OUTPUT_DIR="./csgo/addons"

    if [ ! -d "$OUTPUT_DIR/sourcemod" ]; then
        log_message "Installing SourceMod..." "info"
    fi

    # The user specifically requested this version.
    local full_url="https://sm.alliedmods.net/smdrop/1.12/sourcemod-1.12.0-git6929-linux.tar.gz"
    local new_version="1.12.0-git6929"
    local current_version=$(get_current_version "SourceMod")

    # Check if update is needed
    if [ -n "$current_version" ]; then
        if [ "$new_version" == "$current_version" ]; then
            log_message "SourceMod is up-to-date ($current_version)" "info"
            return 0
        fi
    fi

    log_message "Update available for SourceMod: $new_version (current: ${current_version:-none})" "info"

    if handle_download_and_extract "$full_url" "$TEMP_DIR/sourcemod.tar.gz" "$TEMP_DIR/sourcemod" "tar.gz"; then
        cp -rf "$TEMP_DIR/sourcemod/addons/." "$OUTPUT_DIR/" && \
        cp -rf "$TEMP_DIR/sourcemod/cfg/." "./csgo/cfg/" && \
        update_version_file "SourceMod" "$new_version" && \
        log_message "SourceMod updated to $new_version" "success"
        return 0
    fi

    return 1
}

# Run if executed directly
if [ "${BASH_SOURCE[0]}" = "${0}" ]; then
    mkdir -p "$TEMP_DIR"
    update_sourcemod
fi
