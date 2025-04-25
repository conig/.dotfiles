
#!/usr/bin/env bash
#
# set_audio_sink.sh — choose BT first, speakers next
#

# 1. look for any PipeWire sink whose name starts with "bluez_output"
BT_SINK=$(pactl list short sinks \
  | awk '$2 ~ /^bluez_output/ { print $2; exit }')

# 2. define your speakers sink name
SPEAKER_SINK="alsa_output.pci-0000_00_1f.3.analog-stereo"

# 3. choose which one to use
if [ -n "$BT_SINK" ]; then
    DEFAULT_SINK="$BT_SINK"
else
    DEFAULT_SINK="$SPEAKER_SINK"
fi

# 4. apply it
pactl set-default-sink "$DEFAULT_SINK"
pactl set-sink-mute "$DEFAULT_SINK" 0
pactl set-sink-volume "$DEFAULT_SINK" 15%

# 5. optional: play a quick sound so you know it worked
# paplay /usr/share/sounds/freedesktop/stereo/complete.oga &>/dev/null
