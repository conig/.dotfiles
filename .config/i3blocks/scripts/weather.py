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

    # Only show the weather emoji and temperature if the temperature exceeds 34°C.
    temp_display = f"{weather_emoji} {temperature:.0f}°C" if temperature > 24 else ""
    # Humidity is shown separately if it is below 45%.
    humidity_display = f" 💧{humidity}%" if humidity < 45 else ""
    
    print(f"{temp_display}{humidity_display}")
