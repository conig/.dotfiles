#!/usr/local/venvs/i3statusenv/bin/python3

import time
import os
import re
import requests
import pytz

from ics import Calendar
from datetime import datetime, timezone, timedelta
# === CONFIGURATION ===

# Replace with your actual ICS feed URL
CACHE_FILE = os.path.expanduser('~/.cache/calendar/ltu.ics')
# Fixed offset correction (ideally 0 when timezone conversion is correct)
FIX_OFFSET_HOURS = 0

# Mapping Windows time zone names to IANA time zones.
WIN_TZ_TO_IANA = {
    "AUS Eastern Standard Time": "Australia/Sydney",
    "AUS Central Standard Time": "Australia/Darwin",
    "Cen. Australia Standard Time": "Australia/Adelaide",
    "Tasmania Standard Time": "Australia/Hobart",
    "E. Australia Standard Time": "Australia/Brisbane",  # Typically no DST
    "W. Australia Standard Time": "Australia/Perth",
    "GMT Standard Time": "Europe/London",
    "Greenwich Standard Time": "Europe/London",
    "W. Europe Standard Time": "Europe/Berlin",
    "Central Europe Standard Time": "Europe/Budapest",
    "Romance Standard Time": "Europe/Paris",
    "E. Europe Standard Time": "Europe/Athens",
    "Russian Standard Time": "Europe/Moscow",
    "Eastern Standard Time": "America/New_York",
    "Central Standard Time": "America/Chicago",
    "Mountain Standard Time": "America/Denver",
    "Pacific Standard Time": "America/Los_Angeles",
    "China Standard Time": "Asia/Shanghai",
    "Tokyo Standard Time": "Asia/Tokyo",
    "Singapore Standard Time": "Asia/Singapore",
    "India Standard Time": "Asia/Kolkata",
    "Arabian Standard Time": "Asia/Dubai",
}

def fetch_calendar(url):
    response = requests.get(url)
    response.raise_for_status()
    return response.text

def load_cached_calendar():
    if os.path.exists(CACHE_FILE):
        with open(CACHE_FILE, 'r') as f:
            return f.read()
    return None

def get_ics_data():
    data = load_cached_calendar()
    if not data:
        return None

    # Replace Windows-style TZIDs with IANA TZIDs in the raw ICS text.
    for win_tz, iana_tz in WIN_TZ_TO_IANA.items():
        data = re.sub(f'TZID={re.escape(win_tz)}', f'TZID={iana_tz}', data)
    return data

def get_event_start(event):
    # We now use the parsed datetime from the ics library directly.
    dt = event.begin.datetime

    # If the datetime is naive, assume it is in local time.
    if dt.tzinfo is None:
        # Use the system's local timezone.
        local_tz = datetime.now().astimezone().tzinfo
        dt = dt.replace(tzinfo=local_tz)

    # At this point dt should be timezone-aware. Convert to UTC.
    event_start = dt.astimezone(timezone.utc)

    if FIX_OFFSET_HOURS:
        event_start -= timedelta(hours=FIX_OFFSET_HOURS)
    return event_start

def parse_next_event(ics_data):
    cal = Calendar(ics_data)
    now_utc = datetime.now(timezone.utc)
    upcoming = []

    for event in cal.events:
        if event.name and event.name.lower().startswith("canceled:"):
            continue
        if getattr(event, 'status', '').upper() == 'CANCELLED':
            continue

        event_start = get_event_start(event)
        if event_start > now_utc:
            upcoming.append((event_start, event))
    if not upcoming:
        return None, None
    upcoming.sort(key=lambda x: x[0])
    return upcoming[0]  # returns (start_time, event)

def main():
    ics_data = get_ics_data()
    if not ics_data:
        print("Error: No ICS data available")
        return

    now_utc = datetime.now(timezone.utc)
    event_start, event = parse_next_event(ics_data)
    
    if event:
        meeting_name = event.name if event.name else 'No Title'
        if len(meeting_name) > 15:
            meeting_name = meeting_name[:15] + "..."
        delta_minutes = int((event_start - now_utc).total_seconds() // 60)
        if(delta_minutes < 480):
            if(delta_minutes < 60):
                print(f"{meeting_name} in {delta_minutes} mins")
            else:
                print(f"{meeting_name} in {delta_minutes / 60:.1f} hours")
        else:
            print("🌴")

    else:
        print("No upcoming events")

if __name__ == '__main__':
    main()
