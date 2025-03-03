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

# Create systemd service file
echo "Creating systemd service..."
SERVICE_FILE="/etc/systemd/system/chromecast_manager.service"
sudo bash -c "cat > $SERVICE_FILE" <<EOF
[Unit]
Description=Chromecast Display Manager
After=network.target

[Service]
User=$USER
WorkingDirectory=$INSTALL_DIR
ExecStart=$INSTALL_DIR/venv/bin/python $INSTALL_DIR/app.py
Restart=always

[Install]
WantedBy=multi-user.target
EOF

# Reload systemd, enable and start the service
echo "Enabling and starting Chromecast Manager service..."
sudo systemctl daemon-reload
sudo systemctl enable chromecast_manager.service
sudo systemctl start chromecast_manager.service

# Provide instructions to the user
echo "✅ Installation complete!"
echo "➡️  The Flask app is running as a systemd service."
echo "➡️  To check the service status, run: sudo systemctl status chromecast_manager.service"
echo "➡️  To restart the service, run: sudo systemctl restart chromecast_manager.service"
echo "➡️  To stop the service, run: sudo systemctl stop chromecast_manager.service"

