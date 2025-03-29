#!/usr/local/venvs/i3statusenv/bin/python3

import time
import os
import re
import requests
import pytz
import traceback

from ics import Calendar
from datetime import datetime, timezone, timedelta
# === CONFIGURATION ===

# Replace with your actual ICS feed URL
CACHE_FILE = os.path.expanduser('~/.cache/calendar/ltu.ics')
# Fixed offset correction (ideally 0 when timezone conversion is correct)
FIX_OFFSET_HOURS = 0

# Mapping Windows time zone names to IANA time zones.
WIN_TZ_TO_IANA = {
'AUS Central Standard Time': 'Australia/Darwin',
 'AUS Eastern Standard Time': 'Australia/Sydney',
 'Afghanistan Standard Time': 'Asia/Kabul',
 'Alaskan Standard Time': 'America/Anchorage',
 'Arab Standard Time': 'Asia/Riyadh',
 'Arabian Standard Time': 'Asia/Dubai',
 'Arabic Standard Time': 'Asia/Baghdad',
 'Argentina Standard Time': 'America/Buenos_Aires',
 'Atlantic Standard Time': 'America/Halifax',
 'Azerbaijan Standard Time': 'Asia/Baku',
 'Azores Standard Time': 'Atlantic/Azores',
 'Bahia Standard Time': 'America/Bahia',
 'Bangladesh Standard Time': 'Asia/Dhaka',
 'Canada Central Standard Time': 'America/Regina',
 'Cape Verde Standard Time': 'Atlantic/Cape_Verde',
 'Caucasus Standard Time': 'Asia/Yerevan',
 'Cen. Australia Standard Time': 'Australia/Adelaide',
 'Central America Standard Time': 'America/Guatemala',
 'Central Asia Standard Time': 'Asia/Almaty',
 'Central Brazilian Standard Time': 'America/Cuiaba',
 'Central Europe Standard Time': 'Europe/Budapest',
 'Central European Standard Time': 'Europe/Warsaw',
 'Central Pacific Standard Time': 'Pacific/Guadalcanal',
 'Central Standard Time': 'America/Chicago',
 'Central Standard Time (Mexico)': 'America/Mexico_City',
 'China Standard Time': 'Asia/Shanghai',
 'Dateline Standard Time': 'Etc/GMT+12',
 'E. Africa Standard Time': 'Africa/Nairobi',
 'E. Australia Standard Time': 'Australia/Brisbane',
 'E. Europe Standard Time': 'Asia/Nicosia',
 'E. South America Standard Time': 'America/Sao_Paulo',
 'Eastern Standard Time': 'America/New_York',
 'Egypt Standard Time': 'Africa/Cairo',
 'Ekaterinburg Standard Time': 'Asia/Yekaterinburg',
 'FLE Standard Time': 'Europe/Kiev',
 'Fiji Standard Time': 'Pacific/Fiji',
 'GMT Standard Time': 'Europe/London',
 'GTB Standard Time': 'Europe/Bucharest',
 'Georgian Standard Time': 'Asia/Tbilisi',
 'Greenland Standard Time': 'America/Godthab',
 'Greenwich Standard Time': 'Atlantic/Reykjavik',
 'Hawaiian Standard Time': 'Pacific/Honolulu',
 'India Standard Time': 'Asia/Calcutta',
 'Iran Standard Time': 'Asia/Tehran',
 'Israel Standard Time': 'Asia/Jerusalem',
 'Jordan Standard Time': 'Asia/Amman',
 'Kaliningrad Standard Time': 'Europe/Kaliningrad',
 'Korea Standard Time': 'Asia/Seoul',
 'Magadan Standard Time': 'Asia/Magadan',
 'Mauritius Standard Time': 'Indian/Mauritius',
 'Middle East Standard Time': 'Asia/Beirut',
 'Montevideo Standard Time': 'America/Montevideo',
 'Morocco Standard Time': 'Africa/Casablanca',
 'Mountain Standard Time': 'America/Denver',
 'Mountain Standard Time (Mexico)': 'America/Chihuahua',
 'Myanmar Standard Time': 'Asia/Rangoon',
 'N. Central Asia Standard Time': 'Asia/Novosibirsk',
 'Namibia Standard Time': 'Africa/Windhoek',
 'Nepal Standard Time': 'Asia/Katmandu',
 'New Zealand Standard Time': 'Pacific/Auckland',
 'Newfoundland Standard Time': 'America/St_Johns',
 'North Asia East Standard Time': 'Asia/Irkutsk',
 'North Asia Standard Time': 'Asia/Krasnoyarsk',
 'Pacific SA Standard Time': 'America/Santiago',
 'Pacific Standard Time': 'America/Los_Angeles',
 'Pacific Standard Time (Mexico)': 'America/Santa_Isabel',
 'Pakistan Standard Time': 'Asia/Karachi',
 'Paraguay Standard Time': 'America/Asuncion',
 'Romance Standard Time': 'Europe/Paris',
 'Russian Standard Time': 'Europe/Moscow',
 'SA Eastern Standard Time': 'America/Cayenne',
 'SA Pacific Standard Time': 'America/Bogota',
 'SA Western Standard Time': 'America/La_Paz',
 'SE Asia Standard Time': 'Asia/Bangkok',
 'Samoa Standard Time': 'Pacific/Apia',
 'Singapore Standard Time': 'Asia/Singapore',
 'South Africa Standard Time': 'Africa/Johannesburg',
 'Sri Lanka Standard Time': 'Asia/Colombo',
 'Syria Standard Time': 'Asia/Damascus',
 'Taipei Standard Time': 'Asia/Taipei',
 'Tasmania Standard Time': 'Australia/Hobart',
 'Tokyo Standard Time': 'Asia/Tokyo',
 'Tonga Standard Time': 'Pacific/Tongatapu',
 'Turkey Standard Time': 'Europe/Istanbul',
 'US Eastern Standard Time': 'America/Indianapolis',
 'US Mountain Standard Time': 'America/Phoenix',
 'UTC': 'Etc/GMT',
 'UTC+12': 'Etc/GMT-12',
 'UTC-02': 'Etc/GMT+2',
 'UTC-11': 'Etc/GMT+11',
 'Ulaanbaatar Standard Time': 'Asia/Ulaanbaatar',
 'Venezuela Standard Time': 'America/Caracas',
 'Vladivostok Standard Time': 'Asia/Vladivostok',
 'W. Australia Standard Time': 'Australia/Perth',
 'W. Central Africa Standard Time': 'Africa/Lagos',
 'W. Europe Standard Time': 'Europe/Berlin',
 'West Asia Standard Time': 'Asia/Tashkent',
 'West Pacific Standard Time': 'Pacific/Port_Moresby',
 'Yakutsk Standard Time': 'Asia/Yakutsk'
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
    dt = event.begin.datetime
    if dt.tzinfo is None:
        local_tz = datetime.now().astimezone().tzinfo
        dt = dt.replace(tzinfo=local_tz)
    event_start = dt.astimezone(timezone.utc)
    if FIX_OFFSET_HOURS:
        event_start -= timedelta(hours=FIX_OFFSET_HOURS)
    return event_start

def get_event_end(event):
    dt = event.end.datetime
    if dt.tzinfo is None:
        local_tz = datetime.now().astimezone().tzinfo
        dt = dt.replace(tzinfo=local_tz)
    event_end = dt.astimezone(timezone.utc)
    if FIX_OFFSET_HOURS:
        event_end -= timedelta(hours=FIX_OFFSET_HOURS)
    return event_end

def parse_current_event(ics_data):
    cal = Calendar(ics_data)
    now_utc = datetime.now(timezone.utc)
    for event in cal.events:
        if event.name and event.name.lower().startswith("canceled:"):
            continue
        if getattr(event, 'status', '').upper() == 'CANCELLED':
            continue
        if event.all_day:  # Exclude all-day events
            continue

        event_start = get_event_start(event)
        event_end = get_event_end(event)
        if event_start <= now_utc < event_end:
            return event, event_end
    return None, None

def parse_next_event(ics_data):
    cal = Calendar(ics_data)
    now_utc = datetime.now(timezone.utc)
    upcoming = []
    for event in cal.events:
        if event.name and event.name.lower().startswith("canceled:"):
            continue
        if getattr(event, 'status', '').upper() == 'CANCELLED':
            continue
        if event.all_day:  # Exclude all-day events
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
        print("")
        return

    now_utc = datetime.now(timezone.utc)
    # Check for a current meeting.
    current_event, event_end = parse_current_event(ics_data)
    if current_event:
        remaining = int((event_end - now_utc).total_seconds() // 60)
        print(f"⏳ {remaining} mins")
        return

    # If no current meeting, display the next upcoming event.
    event_start, event = parse_next_event(ics_data)
    if event:
        meeting_name = event.name if event.name else 'No Title'
        if len(meeting_name) > 15:
            meeting_name = meeting_name[:15] + "..."
        delta_minutes = int((event_start - now_utc).total_seconds() // 60)
        if delta_minutes < 720:
            if delta_minutes < 60:
                print(f"{meeting_name} in {delta_minutes} mins")
            else:
                print(f"{meeting_name} in {delta_minutes / 60:.1f} hours")
        else:
            print("")
    else:
        print("No upcoming events")

if __name__ == '__main__':
    main()
