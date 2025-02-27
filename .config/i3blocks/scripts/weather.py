#!/usr/local/venvs/i3statusenv/bin/python3

import os
import requests
from dotenv import load_dotenv

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

    humidity_output = f" 💧{humidity}%" if humidity < 60 else ""
    print(f"{weather_emoji} {temperature:.0f}°C{humidity_output}")
