#!/bin/sh

# Directory containing the wallpapers
wallpapers_dir="/home/zed/Pictures/gowall/"

# Function to set the wallpaper
set_wallpaper() {
  local random_image=$(ls -p "$wallpapers_dir" | shuf -n 1)
  feh --bg-fill "$wallpapers_dir/$random_image" &
}

# Set the initial wallpaper
set_wallpaper

# Loop to change wallpaper every 10 seconds
while true; do
  sleep 60
  set_wallpaper
done

