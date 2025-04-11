#!/usr/local/venvs/i3statusenv/bin/python3

import os
import requests
from dotenv import load_dotenv
from datetime import datetime

# Load environment variables from centralised .env file
dotenv_path = os.path.expanduser('~/.config/owm/owm.env')
load_dotenv(dotenv_path)

API_KEY = os.getenv('OWM_API_KEY')
location = "Hazelbrook,NSW,AU"
url = f"http://api.openweathermap.org/data/2.5/weather?q={location}&appid={API_KEY}&units=metric"

response = requests.get(url)
data = response.json()

if data.get("cod") != 200:
    print("Error:", data.get("message"))
else:
    # Determine weather emoji
    weather_condition = data["weather"][0]["main"].lower()
    emoji_map = {
        "clear": "☀️",
        "cloud": "☁️",
        "rain": "🌧️",
        "thunderstorm": "⛈️",
        "snow": "❄️"
    }
    weather_emoji = next((emoji for key, emoji in emoji_map.items() if key in weather_condition), "🌡️")

    temperature = data["main"]["temp"]
    humidity = data["main"]["humidity"]
    wind = round(data["wind"]["speed"], 1)

    # Determine current season and set temperature thresholds
    month = datetime.now().month
    if month in [12, 1, 2]:  # Summer
        display = temperature < 22 or temperature > 25
    elif month in [3, 4, 5]:  # Autumn
        display = temperature < 15 or temperature > 21
    elif month in [6, 7, 8]:  # Winter
        display = temperature < 3 or temperature > 18
    else:  # Spring
        display = temperature < 8 or temperature > 23

    # Always display if rain, storm, or snow
    if any(cond in weather_condition for cond in ["rain", "thunderstorm", "snow"]):
        display = True

    # Build display strings
    temp_display = f"{weather_emoji} {temperature:.0f}°C" if display else ""
    humidity_display = f"💧{humidity}%" if humidity < 45 or humidity > 99 else ""
    wind_display = f"🌬️{wind}km/h" if wind > 30 else ""

    # Collect and print
    display_parts = [part for part in [temp_display, humidity_display, wind_display] if part]
    print(" ".join(display_parts))
