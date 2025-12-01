#!/bin/bash

# AeroSpace Monitor Configuration Switcher
# This script helps switch between single and dual monitor setups

AEROSPACE_CONFIG="/Users/gabrielpaura/.config/aerospace/aerospace.toml"

show_usage() {
    echo "Usage: $0 [single|dual|status]"
    echo ""
    echo "Commands:"
    echo "  single  - Configure for single monitor (MacBook only)"
    echo "  dual    - Configure for dual monitor setup"
    echo "  status  - Show current configuration"
    echo ""
}

get_current_setup() {
    if grep -q "^[[:space:]]*\[workspace-to-monitor-force-assignment\]" "$AEROSPACE_CONFIG"; then
        if grep -A5 "^[[:space:]]*\[workspace-to-monitor-force-assignment\]" "$AEROSPACE_CONFIG" | grep -q "secondary"; then
            echo "dual"
        else
            echo "single"
        fi
    else
        echo "none"
    fi
}

switch_to_single() {
    echo "Switching to single monitor configuration..."

    # Comment out dual monitor section
    sed -i '' '/^# === DUAL MONITOR SETUP ===/,/^# 5 = .secondary.*Media/ s/^# \[workspace-to-monitor-force-assignment\]/# [workspace-to-monitor-force-assignment]/' "$AEROSPACE_CONFIG"
    sed -i '' '/^# === DUAL MONITOR SETUP ===/,/^# 5 = .secondary.*Media/ s/^# [0-9]/# [0-9]/' "$AEROSPACE_CONFIG"

    # Uncomment single monitor section
    sed -i '' '/^# === SINGLE MONITOR SETUP/,/^5 = .main.*Media/ s/^# \[workspace-to-monitor-force-assignment\]/[workspace-to-monitor-force-assignment]/' "$AEROSPACE_CONFIG"
    sed -i '' '/^# === SINGLE MONITOR SETUP/,/^5 = .main.*Media/ s/^# \([0-9]\)/\1/' "$AEROSPACE_CONFIG"

    # Reload AeroSpace configuration
    aerospace reload-config
    echo "✅ Switched to single monitor setup"
}

switch_to_dual() {
    echo "Switching to dual monitor configuration..."

    # Comment out single monitor section
    sed -i '' '/^# === SINGLE MONITOR SETUP/,/^5 = .main.*Media/ s/^\[workspace-to-monitor-force-assignment\]/# [workspace-to-monitor-force-assignment]/' "$AEROSPACE_CONFIG"
    sed -i '' '/^# === SINGLE MONITOR SETUP/,/^5 = .main.*Media/ s/^[0-9]/# [0-9]/' "$AEROSPACE_CONFIG"

    # Uncomment dual monitor section
    sed -i '' '/^# === DUAL MONITOR SETUP ===/,/^# 5 = .secondary.*Media/ s/^# \[workspace-to-monitor-force-assignment\]/[workspace-to-monitor-force-assignment]/' "$AEROSPACE_CONFIG"
    sed -i '' '/^# === DUAL MONITOR SETUP ===/,/^# 5 = .secondary.*Media/ s/^# \([0-9]\)/\1/' "$AEROSPACE_CONFIG"

    # Reload AeroSpace configuration
    aerospace reload-config
    echo "✅ Switched to dual monitor setup"
}

show_status() {
    current=$(get_current_setup)
    echo "Current AeroSpace monitor configuration: $current"

    if [ "$current" = "single" ]; then
        echo "📱 All workspaces assigned to main display (MacBook)"
    elif [ "$current" = "dual" ]; then
        echo "🖥️  Workspaces distributed across main and secondary displays"
        echo "   • Workspace 1 (Browsers): Secondary monitor"
        echo "   • Workspace 2 (Development): Main monitor (MacBook)"
        echo "   • Workspace 3 (Communication): Secondary monitor"
        echo "   • Workspace 4 (Productivity): Main monitor (MacBook)"
        echo "   • Workspace 5 (Media): Secondary monitor"
    else
        echo "❌ No monitor configuration found"
    fi
}

# Main script logic
case "$1" in
    "single")
        switch_to_single
        ;;
    "dual")
        switch_to_dual
        ;;
    "status")
        show_status
        ;;
    "")
        show_status
        echo ""
        show_usage
        ;;
    *)
        echo "❌ Invalid option: $1"
        show_usage
        exit 1
        ;;
esac