#!/bin/bash

# Script to count device occurrences in log files and record timestamps
# Appends results to reports/analysis_report.txt

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ACTIVE_LOGS_DIR="$SCRIPT_DIR/hospital_data/active_logs"
REPORT_FILE="$SCRIPT_DIR/hospital_data/reports/analysis_report.txt"

# Check if active_logs directory exists
if [ ! -d "$ACTIVE_LOGS_DIR" ]; then
    echo "Error: Directory not found: $ACTIVE_LOGS_DIR"
    exit 1
fi

# Find all .log files
log_files=("$ACTIVE_LOGS_DIR"/*.log)

if [ ${#log_files[@]} -eq 0 ] || [ ! -e "${log_files[0]}" ]; then
    echo "Error: No .log files found in $ACTIVE_LOGS_DIR"
    exit 1
fi

echo "Found ${#log_files[@]} log file(s)"

# Process each log file
for log_file in "${log_files[@]}"; do
    if [ ! -f "$log_file" ]; then
        continue
    fi
    
    log_filename=$(basename "$log_file")
    
    # Create temporary file for device stats
    temp_stats=$(mktemp)
    
    # Extract devices, count occurrences and get first/last timestamps
    awk '{
        device = $3
        timestamp = $1 " " $2
        if (!(device in devices)) {
            devices[device] = 1
            first[device] = timestamp
        } else {
            devices[device]++
        }
        last[device] = timestamp
    }
    END {
        for (device in devices) {
            print device "|" devices[device] "|" first[device] "|" last[device]
        }
    }' "$log_file" | sort > "$temp_stats"
    
    # Generate report header
    {
        echo ""
        echo "======================================================================"
        echo "Log File Analysis: $log_filename"
        echo "Analysis Date: $(date '+%Y-%m-%d %H:%M:%S')"
        echo "======================================================================"
        echo ""
        printf "%-25s %-10s %-20s %-20s\n" "Device Name" "Count" "First Entry" "Last Entry"
        echo "--------------------------------------------------------------------------"
        
        total_entries=0
        while IFS='|' read -r device count first last; do
            printf "%-25s %-10s %-20s %-20s\n" "$device" "$count" "$first" "$last"
            ((total_entries += count))
        done < "$temp_stats"
        
        echo "--------------------------------------------------------------------------"
        printf "%-25s %-10s\n" "TOTAL ENTRIES" "$total_entries"
        echo ""
    } >> "$REPORT_FILE"
    
    # Count unique devices
    unique_devices=$(wc -l < "$temp_stats")
    total_entries=$(awk -F'|' '{sum+=$2} END {print sum}' "$temp_stats")
    
    echo "Analyzed $log_filename: $unique_devices unique devices, $total_entries total entries"
    
    # Clean up temp file
    rm -f "$temp_stats"
done

echo "Report appended to: $REPORT_FILE"
