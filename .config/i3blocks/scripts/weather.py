#!/usr/local/venvs/i3statusenv/bin/python3

import os
import requests
from dotenv import load_dotenv
from datetime import datetime
# Load environment variables from a centralised .env file.
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
    weather_condition = data["weather"][0]["main"].lower()
    if "clear" in weather_condition:
        weather_emoji = "☀️"
    elif "cloud" in weather_condition:
        weather_emoji = "☁️"
    elif "rain" in weather_condition:
        weather_emoji = "🌧️"
    elif "thunderstorm" in weather_condition:
        weather_emoji = "⛈️"
    elif "snow" in weather_condition:
        weather_emoji = "❄️"
    else:
        weather_emoji = "🌡️"

    temperature = data["main"]["temp"]
    humidity = data["main"]["humidity"]
    wind = round(data["wind"]["speed"], 1)

    # Determine current month and season logic
    month = datetime.now().month
    if month in [12, 1, 2]:  # Summer
        season = "summer"
        display = temperature > 25 or temperature < 22
    elif month in [3, 4, 5]:  # Autumn
        season = "autumn"
        display = temperature < 15 or temperature > 25
    elif month in [6, 7, 8]:  # Winter
        season = "winter"
        display = temperature > 15 or temperature < 5
    else:  # Spring
        season = "spring"
        display = temperature > 18 or temperature < 10

    # Decide whether to display temp
    temp_display = f"{weather_emoji}{temperature:.0f}°C" if display else ""
    humidity_display = f"💧{humidity}%" if humidity < 45 else ""
    wind_display = f"🌬️{wind}km/h" if wind > 20 else ""

    # Collect non-empty display strings
    display_parts = [part for part in [temp_display, humidity_display, wind_display] if part]
    
    # Join the non-empty parts with a space
    print(" ".join(display_parts))
