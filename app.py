from flask import Flask, jsonify, request, render_template
import pychromecast
import json
import os

CONFIG_FILE = "chromecast_config.json"

app = Flask(__name__)

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

@app.route("/")
def index():
    return render_template("index.html")

@app.route("/discover", methods=["GET"])
def get_chromecasts():
    devices = discover_chromecasts()
    return jsonify({"devices": devices})

@app.route("/save", methods=["POST"])
def save_chromecasts():
    data = request.json
    selected_devices = data.get("devices", [])
    save_preferred_chromecasts(selected_devices)
    return jsonify({"status": "success", "selected_devices": selected_devices})

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000, debug=True)

