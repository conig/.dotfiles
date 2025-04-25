#!/usr/bin/env bash

echo "=== AUDIO DEBUG SCRIPT ==="
echo "Date: $(date)"
echo "User: $(whoami)"
echo "Hostname: $(hostname)"
echo "Uptime:"
uptime
echo

echo "=== SYSTEM INFORMATION ==="
uname -a
echo

echo "=== WHICH AUDIO SERVER IS RUNNING? ==="
if pgrep -x pipewire >/dev/null; then
    echo "-> PipeWire is running"
else
    echo "-> PipeWire not running"
fi

if pgrep -x pulseaudio >/dev/null; then
    echo "-> PulseAudio is running"
else
    echo "-> PulseAudio not running"
fi
echo

echo "=== AUDIO GROUPS ==="
groups
echo

echo "=== LIST SINKS (Audio Output Devices) ==="
pactl list short sinks
echo

echo "=== DEFAULT SINK ==="
pactl get-default-sink
echo

echo "=== CURRENT VOLUME & MUTE STATUS ==="
pactl list sinks | grep -E 'Name:|Mute:|Volume:'
echo

echo "=== LIST SOURCES (Audio Input Devices) ==="
pactl list short sources
echo

echo "=== ALSA: LIST SOUND CARDS ==="
aplay -l
echo

echo "=== ALSA: ARE MODULES LOADED? ==="
lsmod | grep snd
echo

echo "=== PULSE/PIPEWIRE CLIENTS ==="
pactl list short clients
echo

echo "=== BLUETOOTH DEVICES ==="
bluetoothctl devices
echo

echo "=== RECENT JOURNAL LOGS (Audio) ==="
journalctl --since "10 minutes ago" | grep -iE "audio|alsa|pulseaudio|pipewire" | tail -n 50
echo

echo "=== DEFAULT AUDIO PROFILES ==="
pactl list cards | grep -E 'Name:|Profile:|Active Profile:'
echo

echo "=== END OF REPORT ==="
