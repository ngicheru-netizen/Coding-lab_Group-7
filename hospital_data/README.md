# Hospital Data Monitoring System

A comprehensive hospital data monitoring solution that collects, processes, and analyzes data from multiple medical devices including heart rate monitors, temperature sensors, and water consumption meters.

## Project Overview

This project provides real-time monitoring capabilities for hospital equipment and utilities. It collects telemetry data from various devices, maintains active and archived log files, and generates detailed analysis reports.

## Directory Structure

```
hospital_data/
├── heart_monitor.py           # Heart rate monitoring script
├── temp_sensor.py             # Temperature sensor monitoring script
├── water_meter.py             # Water consumption monitoring script
├── README.md                  # This file
├── active_logs/               # Current live log files
│   ├── heart_rate_log.log     # HeartRate_Monitor_A/B entries
│   ├── temperature_log.log    # Temp_Recorder_A/B entries
│   └── water_usage_log.log    # Water_Consumption_Meter entries
├── archived_logs/             # Historical archived data
│   ├── heart_data_archive/
│   ├── temperature_data_archive/
│   └── water_usage_data_archive/
└── reports/
    └── analysis_report.txt    # Generated analysis and statistics
```

## Scripts

### Monitoring Scripts

- **heart_monitor.py** - Captures and logs heart rate data from monitors
- **temp_sensor.py** - Records temperature readings from sensors
- **water_meter.py** - Tracks water consumption metrics

### Analysis Script

- **count_devices.sh** - Device occurrence counter and report generator
  - Analyzes all log files in `active_logs/`
  - Counts total occurrences per device
  - Records first and last entry timestamps
  - Appends results to `reports/analysis_report.txt`

## Usage

### Running the Device Analysis

```bash
./count_devices.sh
```

This will analyze all `.log` files and append a detailed report showing:

- Device name and total entry count
- First occurrence timestamp
- Last occurrence timestamp
- Grand total of all entries

### Log File Format

All log files follow this format:

```
YYYY-MM-DD HH:MM:SS DEVICE_NAME VALUE
```

Example:

```
2026-01-29 12:14:53 HeartRate_Monitor_A 88
2026-01-29 12:14:53 HeartRate_Monitor_B 89
```

## Devices Monitored

### Heart Rate Monitors

- HeartRate_Monitor_A
- HeartRate_Monitor_B

### Temperature Recorders

- Temp_Recorder_A
- Temp_Recorder_B

### Water Consumption Meters

- Water_Consumption_Meter

## Output

The `analysis_report.txt` contains formatted analysis reports with:

- Log file name and analysis timestamp
- Device statistics table
- First/last entry timestamps for each device
- Total entry counts

## Requirements

- Bash shell (for count_devices.sh)
- Python 3.x (for monitoring scripts)
- Standard Unix utilities (awk, grep, sed)

## Contributors

Nadiv
Junior
Sam E
Sam O
Davis
