# RandWal - Random Wallpaper Setter

## Description

`RandWal` is a shell script that periodically sets a random wallpaper from a specified directory. It uses `feh` to set the wallpaper. The script runs in a loop, changing the wallpaper at a configurable interval, and can be gracefully terminated. It supports configuration via a file and command-line arguments.

## Dependencies

*   `feh`: Required for setting the wallpaper.
*   `shuf` (GNU coreutils): Used for selecting a random image. Typically available on most Linux systems.
*   `find` (GNU findutils): Used for finding image files. Typically available on most Linux systems.
*   `mkdir` (GNU coreutils): Used for creating the configuration directory. Typically available on most Linux systems.

You can usually install `feh` using your system's package manager (e.g., `sudo apt-get install feh` on Debian/Ubuntu). The other utilities are generally pre-installed.

## Installation

1.  **Make the script executable:**
    ```bash
    chmod +x randwal
    ```

2.  **Move the script to a directory in your `$PATH`:**
    This allows you to run `randwal` from any terminal location.
    *   For a user-specific installation (recommended):
        ```bash
        # Ensure ~/.local/bin exists and is in your PATH
        mkdir -p ~/.local/bin
        mv randwal ~/.local/bin/
        ```
        You might need to log out and log back in or source your shell's configuration file (e.g., `~/.bashrc`, `~/.zshrc`) for `~/.local/bin` to be added to your `$PATH` if it wasn't already.

    *   For a system-wide installation (requires root):
        ```bash
        sudo mv randwal /usr/local/bin/
        ```

## Configuration

`RandWal` uses a configuration file located at `~/.config/randwal/config`. The script will automatically create this directory and file with default settings if they don't exist on the first run.

The configuration file can contain the following settings:

*   `CONFIG_WALLPAPERS_DIR`: The full path to the directory containing your wallpapers.
    *   Example: `CONFIG_WALLPAPERS_DIR="/home/user/Pictures/MyWallpapers"`
*   `CONFIG_INTERVAL`: The time in seconds between wallpaper changes.
    *   Example: `CONFIG_INTERVAL="60"` (for 60 seconds)

**Command-Line Override:**
If you provide a wallpaper directory as a command-line argument when running `randwal`, this directory will be used for the current session and will also update the `CONFIG_WALLPAPERS_DIR` value in the configuration file for future runs.

## Usage

Once installed (see [Installation](#installation)), you can run `RandWal` as follows:

*   **Using the configured or default wallpaper directory:**
    ```bash
    randwal
    ```
    The script will use the directory specified in `~/.config/randwal/config` or default to `~/Pictures/wallpapers/` if the config file is new or doesn't specify a directory. The interval will also be loaded from the config file or default to 60 seconds.

*   **Specifying a custom wallpaper directory (overrides config for the session and updates config):**
    Provide the path to your desired wallpaper directory as the first argument:
    ```bash
    randwal /path/to/your/wallpapers/
    ```
    For example:
    ```bash
    randwal ~/MyFavoriteWallpapers/
    ```
    This will use `~/MyFavoriteWallpapers/` for the current session, and this path will be saved to `~/.config/randwal/config` for subsequent runs.

The script will then start changing the wallpaper at the configured interval. Messages in the terminal will indicate which directory and interval are being used.

## Autostart

To have `RandWal` start automatically when you log in, you can use one of the following methods. Choose the one most appropriate for your desktop environment or system.

**1. .desktop file (Recommended for most desktop environments):**

Create a file named `randwal.desktop` in `~/.config/autostart/` with the following content:

```ini
[Desktop Entry]
Name=RandWal
Exec=/path/to/randwal
Type=Application
Terminal=false
Comment=Randomly changes wallpaper
```
**Important:** Replace `/path/to/randwal` with the actual absolute path to where you installed the `randwal` script (e.g., `/home/youruser/.local/bin/randwal` or `/usr/local/bin/randwal`).

**2. systemd User Service:**

Create a file named `randwal.service` in `~/.config/systemd/user/` with the following content:

```ini
[Unit]
Description=Random Wallpaper Setter
After=graphical-session.target

[Service]
ExecStart=/path/to/randwal
Restart=always
RestartSec=10

[Install]
WantedBy=graphical-session.target
```
**Important:** Replace `/path/to/randwal` with the actual absolute path.

Then, enable and start the service:
```bash
systemctl --user enable --now randwal.service
```
You can check its status with `systemctl --user status randwal.service`.

**3. cron (Less ideal for GUI applications):**

You can use `cron` with `@reboot`, but this method can be tricky for GUI applications like `feh` because `cron` jobs run in a very minimal environment, often without access to the necessary `DISPLAY` variable or user session information.

If you choose to try `cron`, it might look like this in your crontab (`crontab -e`):
```cron
@reboot /path/to/randwal
```
You might need to explicitly set the `DISPLAY` variable within the script or use a wrapper script if `feh` fails to connect to the X server. This method is generally not recommended for this type of application.

## How to Stop

To stop the script and the wallpaper rotation, press `Ctrl+C` in the terminal where `randwal` is running (if you ran it manually). If it's running as an autostarted process:
*   For `.desktop` or manual background execution: find the process ID (`pgrep -f randwal` or `pgrep feh`) and kill it (`kill <PID>`).
*   For systemd: `systemctl --user stop randwal.service`.
The script is designed to clean up the `feh` process it launched upon graceful termination (SIGINT, SIGTERM).
