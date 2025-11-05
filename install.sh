#!/usr/bin/env bash
set -e

# this script currently only supports Debian 13+ based systems (Raspberry Pi OS included)

echo "--- Install Dependencies ---"
sudo apt install qml6-module-qtquick-virtualkeyboard qt6-base-dev qt6-declarative-dev libpulse-dev cmake build-essential desktop-file-utils

echo "--- Clone Repo and Build ---"
git clone https://github.com/dylondark/OpenQarUI.git
cd OpenQarUI
mkdir build
cd build
cmake .. -DCMAKE_BUILD_TYPE=Release
make -j"$(nproc)"

echo "--- Install Program ---"
sudo install -Dm755 appOpenQarUI /usr/bin/openqarui
cd ../../
echo "[Desktop Entry]
Type=Application
Name=OpenQarUI
Comment=UI for custom car infotainment systems, developed with Qt
Path=/usr/bin
Exec=openqarui
" > OpenQarUI.desktop
sudo desktop-file-install --dir /usr/share/applications OpenQarUI.desktop

echo "Would you like to add OpenQarUI as an autostart application so that it starts with your desktop session?"
echo "This will only work if your desktop environment supports the Freedesktop autostart spec."
read -p "Answer (y/N): " ans
if [[ "$ans" = "y" || "$ans" = "Y" ]]; then
    mkdir -p ~/.config/autostart
    sudo desktop-file-install --dir ~/.config/autostart OpenQarUI.desktop
fi

rm OpenQarUI.desktop
rm -rf OpenQarUI
