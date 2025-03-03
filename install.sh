#!/bin/bash

# Update system and install dependencies
echo "Updating system and installing dependencies..."
sudo apt update && sudo apt upgrade -y
sudo apt install -y python3 python3-pip python3-venv git curl

# Clone the project from GitHub
echo "Cloning project from GitHub..."
git clone https://github.com/YOUR_USERNAME/chromecast_wallpaper.git
cd chromecast_wallpaper

# Create and activate virtual environment
echo "Setting up Python virtual environment..."
python3 -m venv venv
source venv/bin/activate

# Install Python dependencies
echo "Installing Python dependencies..."
pip install -r requirements.txt

# Provide instructions to the user
echo "Installation complete!"
echo "To activate the environment, run: source venv/bin/activate"
echo "To start the Flask app, run: python app.py"
echo "To run the wallpaper update script, run: python chromecast_wallpaper.py"


