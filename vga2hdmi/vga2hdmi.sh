#!/bin/bash

set -e

# Primary display: 1366x768
# External display: 1920x1080 (Connected using VGA to HDMI adapter)

# (0, 0)        (1366, 0)       (1366+1920, 0)
#                    |--------------------|
#   |---------------||                    |
#   |               ||                    |
#   |    Primary    ||      External      |
#   |               ||                    |
#   |---------------||                    |
#                    |--------------------|
# (0, 1080)     (1366, 1080)    (1366+1920, 1080)

PRIMARY_DISPLAY="LVDS-1"
PRIMARY_WIDTH=1366
PRIMARY_HEIGHT=768
PRIMARY_RESOLUTION="${PRIMARY_WIDTH}x${PRIMARY_HEIGHT}"

EXTERNAL_DISPLAY="VGA-1"
EXTERNAL_WIDTH=1920
EXTERNAL_HEIGHT=1080
EXTERNAL_RESOLUTION="${EXTERNAL_WIDTH}x${EXTERNAL_HEIGHT}"
# EXTERNAL_MODELINE=$(cvt -r 1920 1080 60 | grep Mode | sed -e 's/.*"/1920x1080/')
# or
# Connect to external 1080p display using VGA to get modeline:
# xrandr --verbose
EXTERNAL_MODELINE="1920x1080 148.50 1920 2008 2052 2200 1080 1084 1089 1125 +hsync +vsync"

# Primary display position (top left corner):  (0, (1080-768)/2 = 156)
PRIMARY_POSITION="0x$(((${EXTERNAL_HEIGHT}-${PRIMARY_HEIGHT})/2))"

# External display position (top left corner): (1366, 0)
EXTERNAL_POSITION="${PRIMARY_WIDTH}x0"

echo "---Setting primary display's resolution to $PRIMARY_RESOLUTION..."
echo "---Setting external display's resolution to $EXTERNAL_RESOLUTION..."

xrandr --newmode ${EXTERNAL_MODELINE}
xrandr --addmode ${EXTERNAL_DISPLAY} ${EXTERNAL_RESOLUTION}
xrandr \
  --output ${PRIMARY_DISPLAY} --mode ${PRIMARY_RESOLUTION} --pos ${PRIMARY_POSITION} --primary \
  --output ${EXTERNAL_DISPLAY} --mode ${EXTERNAL_RESOLUTION} --pos ${EXTERNAL_POSITION}

echo "---Done!"
