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

    # Determine current month and season logic
    month = datetime.now().month
    if month in [12, 1, 2]:  # Summer
        season = "summer"
        display = temperature < 20
    elif month in [3, 4, 5]:  # Autumn
        season = "autumn"
        display = temperature < 20
    elif month in [6, 7, 8]:  # Winter
        season = "winter"
        display = temperature > 18
    else:  # Spring
        season = "spring"
        display = temperature > 18

    # Decide whether to display temp
    temp_display = f"{weather_emoji} {temperature:.0f}°C" if display else ""
    humidity_display = f"💧{humidity}%" if humidity < 50 else ""

    print(f"{temp_display}{humidity_display}")
