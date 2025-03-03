import cv2
import numpy as np
import pychromecast
import json
from PIL import Image
import requests
from io import BytesIO
import os
import time

CONFIG_FILE = "chromecast_config.json"

def download_image(url):
    response = requests.get(url)
    if response.status_code == 200:
        return Image.open(BytesIO(response.content))
    return None

def discover_chromecasts():
    chromecasts, _ = pychromecast.get_chromecasts()
    return [cast.device.friendly_name for cast in chromecasts]

def load_preferred_chromecasts():
    if os.path.exists(CONFIG_FILE):
        with open(CONFIG_FILE, "r") as f:
            return json.load(f).get("preferred_chromecasts", [])
    return []

def save_preferred_chromecasts(devices):
    with open(CONFIG_FILE, "w") as f:
        json.dump({"preferred_chromecasts": devices}, f)

def send_to_chromecast(image_path, device_name):
    chromecasts, browser = pychromecast.get_listed_chromecasts(friendly_names=[device_name])
    if not chromecasts:
        print(f"Chromecast '{device_name}' not found.")
        return False

    cast = chromecasts[0]
    cast.wait()
    mc = cast.media_controller
    mc.play_media(f"http://your_local_server/{image_path}", "image/jpeg")
    mc.block_until_active()
    mc.play()
    browser.stop_discovery()
    return True

def main():
    image_url = "https://source.unsplash.com/5760x1080/?landscape"
    image = download_image(image_url)

    if image:
        chromecasts = load_preferred_chromecasts()
        if not chromecasts:
            chromecasts = discover_chromecasts()
            if len(chromecasts) >= 3:
                chromecasts = chromecasts[:3]
            save_preferred_chromecasts(chromecasts)

        for i, device in enumerate(chromecasts):
            send_to_chromecast(f"screen{i+1}.jpg", device)
            time.sleep(2)
        print("Images sent successfully.")
    else:
        print("Failed to fetch image.")

if __name__ == "__main__":
    main()

