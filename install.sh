#!/bin/bash

# Update system and install dependencies
echo "Updating system and installing dependencies..."
sudo apt update && sudo apt upgrade -y
sudo apt install -y python3 python3-pip python3-venv git curl avahi-daemon

# Enable and start avahi-daemon
echo "Starting avahi-daemon..."
sudo systemctl enable avahi-daemon
sudo systemctl restart avahi-daemon

# Define GitHub repo
GITHUB_REPO="https://github.com/YOUR_USERNAME/chromecast_wallpaper.git"
INSTALL_DIR="$HOME/chromecast_wallpaper"

# Clone the project into the user's home directory
echo "Cloning project from GitHub..."
rm -rf $INSTALL_DIR  # Remove any existing copy to ensure a clean install
git clone --depth=1 $GITHUB_REPO $INSTALL_DIR
cd $INSTALL_DIR

# Create and activate Python virtual environment
echo "Setting up Python virtual environment..."
python3 -m venv venv
source venv/bin/activate

# Install Python dependencies
echo "Installing Python dependencies..."
pip install --upgrade pip
pip install -r requirements.txt

# Provide instructions to the user
echo "✅ Installation complete!"
echo "➡️  To activate the environment, run: source $INSTALL_DIR/venv/bin/activate"
echo "➡️  To start the Flask app, run: python $INSTALL_DIR/app.py"
echo "➡️  To run the wallpaper update script, run: python $INSTALL_DIR/chromecast_wallpaper.py"
