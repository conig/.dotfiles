#!/usr/bin/env bash
#
# ~/.config/i3/set_audio_sink.sh
# — favour BT first, then auto-detect speakers

# grab all sink names in order
mapfile -t SINKS < <(pactl list short sinks | awk '{print $2}')

# 1. look for a Bluetooth sink (bluez_output…)
for s in "${SINKS[@]}"; do
  [[ "$s" == bluez_output* ]] && { BT_SINK="$s"; break; }
done

# 2. look for a speaker sink: first one that isn’t BT and isn’t USB
for s in "${SINKS[@]}"; do
  if [[ "$s" != bluez_output* && "$s" != *usb-* ]]; then
    FALLBACK_SINK="$s"
    break
  fi
done

# 3. choose default
if [[ -n "$BT_SINK" ]]; then
  DEFAULT_SINK=$BT_SINK
else
  DEFAULT_SINK=$FALLBACK_SINK
fi

# 5. optional: play a quick sound so you know it worked
# paplay /usr/share/sounds/freedesktop/stereo/complete.oga &>/dev/null
# 4. apply it
pactl set-default-sink "$DEFAULT_SINK"
pactl set-sink-mute "$DEFAULT_SINK" 0
pactl set-sink-volume "$DEFAULT_SINK" 19%
