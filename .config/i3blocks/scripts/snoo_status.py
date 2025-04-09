#!/usr/local/venvs/i3statusenv/bin/python3

from snoo import Client

def format_duration(duration_str):
    if not duration_str:
        return "0h0m"
    try:
        h, m, s = duration_str.split(':')
        return f"{int(h)}h{int(m)}m"
    except Exception as e:
        print("Error parsing duration:", e)
        return "0h0m"

def main():
    client = Client()
    try:
        status = client.status()  # Expected to return a dict with keys 'state' and 'since_session_start'
    except Exception as e:
        print("Error retrieving Snoo status:", e)
        return

    level = status.get('state', 'unknown')
    duration_str = status.get('since_session_start', None)
    formatted_duration = format_duration(duration_str)

    print(f"Snoo Status: {level}")
    print(f"Time at Level: {formatted_duration}")

if __name__ == '__main__':
    main()
