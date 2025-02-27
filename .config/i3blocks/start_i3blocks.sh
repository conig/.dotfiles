#!/usr/bin/env bash

# Sleep until seconds == 00
sleep $((60 - 10#$(date +%S)))
# Then start i3blocks
i3blocks

