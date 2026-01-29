#!/bin/bash

LOG_DIR="hospital_data/active_logs"
REPORT_DIR="reports"
REPORT_FILE="$REPORT_DIR/analysis_report.txt"

# make sure reports folder exists
mkdir -p "$REPORT_DIR"

echo "Select log file to analyze:"
echo "1) Heart Rate (heart_rate.log)"
echo "2) Temperature (temperature.log)"
echo "3) Water Usage (water_usage.log)"
read -p "Enter choice (1-3): " choice

case $choice in
  1)
    LOG_FILE="$LOG_DIR/heart_rate.log"
    TITLE="Heart Rate"
    ;;
  2)
    LOG_FILE="$LOG_DIR/temperature.log"
    TITLE="Temperature"
    ;;
  3)
    LOG_FILE="$LOG_DIR/water_usage.log"
    TITLE="Water Usage"
    ;;
  *)
    echo "❌ Invalid choice"
    exit 1
    ;;
esac

# check if log exists
if [ ! -f "$LOG_FILE" ]; then
  echo "❌ Log file not found"
  exit 1
fi

echo "Analyzing $TITLE log..."

echo "===================================" >> "$REPORT_FILE"
echo "Log Type: $TITLE" >> "$REPORT_FILE"
echo "Analysis Date: $(date)" >> "$REPORT_FILE"
echo "" >> "$REPORT_FILE"

echo "Device counts:" >> "$REPORT_FILE"
awk '{print $2}' "$LOG_FILE" | sort | uniq -c >> "$REPORT_FILE"

echo "" >> "$REPORT_FILE"
echo "First entry:" >> "$REPORT_FILE"
head -n 1 "$LOG_FILE" >> "$REPORT_FILE"

echo "" >> "$REPORT_FILE"
echo "Last entry:" >> "$REPORT_FILE"
tail -n 1 "$LOG_FILE" >> "$REPORT_FILE"

echo "" >> "$REPORT_FILE"

echo "✅ Analysis completed and saved to $REPORT_FILE"
