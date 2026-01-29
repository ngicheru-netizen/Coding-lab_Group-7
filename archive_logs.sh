#!/bin/bash

ACTIVE="hospital_data/active_logs"
ARCHIVE="hospital_data/archived_logs"

echo "Select log to archive:"
echo "1) Heart Rate"
echo "2) Temperature"
echo "3) Water Usage"
read -p "Enter choice (1-3): " choice

TIME=$(date +"%Y-%m-%d_%H:%M:%S")

case $choice in
  1)
    LOG="heart_rate.log"
    DEST="$ARCHIVE/heart_data_archive"
    NAME="heart_rate"
    ;;
  2)
    LOG="temperature.log"
    DEST="$ARCHIVE/temperature_data_archive"
    NAME="temperature"
    ;;
  3)
    LOG="water_usage.log"
    DEST="$ARCHIVE/water_usage_data_archive"
    NAME="water_usage"
    ;;
  *)
    echo "Invalid choice"
    exit 1
    ;;
esac

if [ ! -f "$ACTIVE/$LOG" ]; then
  echo "Log file not found"
  exit 1
fi

mkdir -p "$DEST"

mv "$ACTIVE/$LOG" "$DEST/${NAME}_${TIME}.log"
touch "$ACTIVE/$LOG"


echo "Archiving $LOG . . ."
echo "Successfully archived to $DEST/${NAME}_${TIME}.log"

