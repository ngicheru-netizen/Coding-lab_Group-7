#!/usr/bin/env python3
"""
Script to count device occurrences in log files and record timestamps.
Appends results to reports/analysis_report.txt
"""

import os
from datetime import datetime
from pathlib import Path
from collections import defaultdict


def analyze_log_file(log_file_path):
    """
    Analyze a log file and count device occurrences with first/last timestamps.
    
    Args:
        log_file_path: Path to the log file to analyze
        
    Returns:
        Dictionary with device statistics
    """
    device_stats = defaultdict(lambda: {"count": 0, "first_timestamp": None, "last_timestamp": None})
    
    try:
        with open(log_file_path, 'r') as f:
            for line in f:
                line = line.strip()
                if not line:
                    continue
                
                parts = line.split()
                if len(parts) >= 3:
                    timestamp = f"{parts[0]} {parts[1]}"
                    device = parts[2]
                    
                    device_stats[device]["count"] += 1
                    
                    if device_stats[device]["first_timestamp"] is None:
                        device_stats[device]["first_timestamp"] = timestamp
                    
                    device_stats[device]["last_timestamp"] = timestamp
    
    except FileNotFoundError:
        print(f"Error: File not found: {log_file_path}")
        return None
    
    return device_stats


def generate_report(log_file_path):
    """
    Generate a report for device occurrences and append to analysis_report.txt
    
    Args:
        log_file_path: Path to the log file to analyze
    """
    stats = analyze_log_file(log_file_path)
    
    if stats is None:
        return
    
    report_dir = Path(log_file_path).parent.parent / "reports"
    report_file = report_dir / "analysis_report.txt"
    
    log_filename = Path(log_file_path).name
    report_lines = [
        f"\n{'='*70}",
        f"Log File Analysis: {log_filename}",
        f"Analysis Date: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}",
        f"{'='*70}\n"
    ]
    
    report_lines.append(f"{'Device Name':<25} {'Count':<10} {'First Entry':<20} {'Last Entry':<20}")
    report_lines.append("-" * 75)
    
    for device in sorted(stats.keys()):
        device_info = stats[device]
        count = device_info["count"]
        first = device_info["first_timestamp"]
        last = device_info["last_timestamp"]
        
        report_lines.append(f"{device:<25} {count:<10} {first:<20} {last:<20}")
    
    # Calculate total entries
    total_entries = sum(device_info["count"] for device_info in stats.values())
    report_lines.append("-" * 75)
    report_lines.append(f"{'TOTAL ENTRIES':<25} {total_entries:<10}")
    report_lines.append("")
    
    # Append to report file
    with open(report_file, 'a') as f:
        f.write('\n'.join(report_lines))
    
    print(f"Report appended to: {report_file}")
    print(f"Analyzed {log_filename}: {len(stats)} unique devices, {total_entries} total entries")


def main():
    """Main function to process all log files or a selected one"""
    hospital_data_dir = Path(__file__).parent / "hospital_data"
    active_logs_dir = hospital_data_dir / "active_logs"
    
    if not active_logs_dir.exists():
        print(f"Error: Directory not found: {active_logs_dir}")
        return
    
    # Find all .log files
    log_files = sorted(active_logs_dir.glob("*.log"))
    
    if not log_files:
        print(f"No .log files found in {active_logs_dir}")
        return
    
    print(f"Found {len(log_files)} log file(s):")
    for i, log_file in enumerate(log_files, 1):
        print(f"{i}. {log_file.name}")
    
    # Process all log files
    for log_file in log_files:
        generate_report(str(log_file))


if __name__ == "__main__":
    main()
