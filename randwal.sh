#!/bin/sh

# --- Configuration ---
# Determine the wallpaper directory:
# Use the first command-line argument if provided, otherwise default to $HOME/Pictures/wallpapers.
if [ -n "$1" ]; then
  wallpapers_dir="$1"
  echo "Using wallpaper directory provided: $wallpapers_dir"
else
  wallpapers_dir="$HOME/Pictures/wallpapers"
  echo "No wallpaper directory specified. Using default: $wallpapers_dir"
fi

# Global variable to store the Process ID (PID) of the background feh process.
# This is used to terminate the existing feh instance before starting a new one
# and for cleanup on script exit.
FEH_PID=""

# --- Pre-run Checks ---
# Check if feh (wallpaper setting utility) is installed.
if ! command -v feh >/dev/null 2>&1; then
  echo "Error: feh is not installed. Please install feh to use this script." >&2
  exit 1
fi

# Check if the determined wallpaper directory exists, is a directory, and is readable.
if [ ! -d "$wallpapers_dir" ] || [ ! -r "$wallpapers_dir" ]; then
  echo "Error: Wallpaper directory '$wallpapers_dir' does not exist, is not a directory, or is not readable." >&2
  exit 1
fi

# --- Functions ---
# Function to gracefully clean up the feh process and exit.
cleanup_and_exit() {
  echo "Exiting and cleaning up feh process..."
  if [ -n "$FEH_PID" ]; then
    # Check if the process is still running
    if kill -0 "$FEH_PID" >/dev/null 2>&1; then
      kill "$FEH_PID" >/dev/null 2>&1 # Terminate the feh process
    fi
  fi
  exit 0
}

# Trap SIGINT (Ctrl+C) and SIGTERM signals to call cleanup_and_exit.
trap cleanup_and_exit INT TERM

# Function to set the wallpaper.
set_wallpaper() {
  # If a previous feh process was started by this script, terminate it.
  if [ -n "$FEH_PID" ]; then
    if kill -0 "$FEH_PID" >/dev/null 2>&1; then # Check if process exists
      kill "$FEH_PID" >/dev/null 2>&1          # Terminate it
      sleep 0.1                            # Short pause to allow termination
    fi
  fi

  local image_path
  # Find a random file within the wallpaper directory.
  # -print0 and -z are used for safe handling of filenames with special characters.
  image_path=$(find "$wallpapers_dir" -type f -print0 | shuf -n1 -z --)

  if [ -n "$image_path" ]; then
    # Set the wallpaper using feh, running it in the background.
    feh --bg-fill "$image_path" &
    # Store the PID of the newly started feh process.
    FEH_PID=$!
  else
    # This error is non-fatal; the script will try again on the next cycle.
    echo "Error: No images found in '$wallpapers_dir'. Will try again." >&2
  fi
}

# --- Main Loop ---
# Continuously change wallpaper at a set interval.
echo "Starting wallpaper rotation. Press Ctrl+C to exit."
while true; do
  set_wallpaper # Set wallpaper at the beginning of the iteration
  sleep 60      # Wait for 60 seconds
done

