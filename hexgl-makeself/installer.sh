#!/bin/bash

###For_makeself.
###All_credit besides this script and the game goes to makeself.
###The game is made by BKcore
###The installer.sh is made by 12Tae12

# Prompt user to choose GUI or terminal mode
echo "Do you want to use a graphical (GUI) installer? (requires Zenity)"
echo "Type Y to use GUI or N for a text-based installation."
read -r gui_choice

if [[ "$gui_choice" == "Y" || "$gui_choice" == "y" ]]; then
    use_gui=true
else
    use_gui=false
fi

# Check if Zenity is installed, and if not, warn and offer to install it
if [ "$use_gui" = true ]; then
    if ! command -v zenity &> /dev/null; then
        echo "Warning: Zenity is not installed. A GUI installer requires Zenity."
        read -p "Do you want to install Zenity? (Y/N): " install_choice
        if [[ "$install_choice" == "Y" || "$install_choice" == "y" ]]; then
            # Detect the distribution and install Zenity accordingly
            if [ -f /etc/debian_version ]; then
                echo "Detected Debian-based system. Installing Zenity using apt..."
                sudo apt update && sudo apt install -y zenity
            elif [ -f /etc/arch-release ]; then
                echo "Detected Arch-based system. Installing Zenity using pacman..."
                sudo pacman -Sy zenity --noconfirm
            elif [ -f /etc/fedora-release ]; then
                echo "Detected Fedora-based system. Installing Zenity using dnf..."
                sudo dnf install -y zenity
            elif [ -f /etc/SuSE-release ] || [ -f /etc/SUSE-brand ]; then
                echo "Detected SUSE-based system. Installing Zenity using zypper..."
                sudo zypper install -y zenity
            else
                echo "Could not detect your distribution automatically."
                echo "Please install Zenity manually, then re-run this script."
                exit 1
            fi
        else
            echo "Zenity is required for GUI mode. Exiting."
            exit 1
        fi
    fi
fi

if [ "$use_gui" = true ]; then
    # GUI mode
    zenity --info --title="HexGL Installer" --text="Welcome to the HexGL installer!"
    if ! zenity --question --title="Install HexGL" --text="Do you want to install HexGL?" --ok-label="Yes" --cancel-label="No"; then
        zenity --info --title="HexGL Installer" --text="Installation cancelled."
        exit 0
    fi
else
    # Terminal mode
    echo 'Hello! This is the easy HexGL Linux game installer!'
    echo 'Press Y and enter to install HexGL or press N and enter to quit.'
    
    # Read user input
    read -r choice

    # Check if the user wants to install or quit
    if [[ "$choice" != "Y" && "$choice" != "y" ]]; then
        echo "Quitting the installer."
        exit 0
    fi
fi

# Define the target directory
TARGET_DIR="/opt/BKcore/HexGL"

if [ "$use_gui" = true ]; then
    zenity --info --title="HexGL Installer" --text="Installing HexGL..."
else
    echo "Installing HexGL..."
fi

# Check if the target directory exists; if not, create it
if [ ! -d "$TARGET_DIR" ]; then
    if [ "$use_gui" = true ]; then
        zenity --info --title="HexGL Installer" --text="Creating directory $TARGET_DIR..."
    else
        echo "Directory $TARGET_DIR does not exist. Creating it now."
    fi
    sudo mkdir -p "$TARGET_DIR"
    sudo chown $USER:$USER "$TARGET_DIR"
else
    if [ "$use_gui" = true ]; then
        zenity --info --title="HexGL Installer" --text="Directory $TARGET_DIR already exists."
    else
        echo "Directory $TARGET_DIR already exists."
    fi
fi

# Define the source directory (the folder you want to cut/move)
SOURCE_DIR="./hexgl_files"

# Move the source directory to the target directory
if [ -d "$SOURCE_DIR" ]; then
    if [ "$use_gui" = true ]; then
        zenity --info --title="HexGL Installer" --text="Moving $SOURCE_DIR to $TARGET_DIR..."
    else
        echo "Moving $SOURCE_DIR to $TARGET_DIR..."
    fi
    sudo mv "$SOURCE_DIR" "$TARGET_DIR"
    if [ "$use_gui" = true ]; then
        zenity --info --title="HexGL Installer" --text="Moved successfully."
    else
        echo "Moved successfully."
    fi
else
    if [ "$use_gui" = true ]; then
        zenity --error --title="HexGL Installer" --text="Source directory $SOURCE_DIR does not exist. Please check the path."
    else
        echo "Source directory $SOURCE_DIR does not exist. Please check the path."
    fi
    exit 1
fi

# Define the desktop entry content
desktop_entry="[Desktop Entry]
Name=HexGL
Comment=Futuristic racing game
Exec=/opt/BKcore/HexGL/hexgl_files/HexGL.sh
Terminal=false
Type=Application
Categories=Game;ArcadeGame;"

# Create the .desktop file
echo "$desktop_entry" > ~/.local/share/applications/hexgl.desktop

# Make the .desktop file executable
chmod +x ~/.local/share/applications/hexgl.desktop

if [ "$use_gui" = true ]; then
    zenity --info --title="HexGL Installer" --text="HexGL desktop entry created successfully!"
else
    echo "HexGL desktop entry created successfully!"
fi

