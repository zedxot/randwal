# RandWal - Random Wallpaper Setter

## Description

`RandWal` is a shell script that periodically sets a random wallpaper from a specified directory. It uses `feh` to set the wallpaper. The script runs in a loop, changing the wallpaper at a configurable interval (currently 60 seconds), and can be gracefully terminated.

## Dependencies

*   `feh`: Required for setting the wallpaper.
*   `shuf` (GNU coreutils): Used for selecting a random image. Typically available on most Linux systems.
*   `find` (GNU findutils): Used for finding image files. Typically available on most Linux systems.

You can usually install `feh` using your system's package manager (e.g., `sudo apt-get install feh` on Debian/Ubuntu).

## How to Run

1.  **Make the script executable:**
    ```bash
    chmod +x randwal.sh
    ```

2.  **Run the script:**
    *   **Using the default wallpaper directory:**
        ```bash
        ./randwal.sh
        ```
        If no directory is specified, `RandWal` will look for wallpapers in `~/Pictures/wallpapers/`.

    *   **Specifying a custom wallpaper directory:**
        Provide the path to your desired wallpaper directory as the first argument:
        ```bash
        ./randwal.sh /path/to/your/wallpapers/
        ```
        For example:
        ```bash
        ./randwal.sh ~/MyWallpapers/
        ```

    The script will then start changing the wallpaper every 60 seconds.

## Default Wallpaper Directory

If no command-line argument is provided, the script defaults to using `~/Pictures/wallpapers/` as the source for images. The script will notify you if it's using the default directory.

## How to Stop

To stop the script and the wallpaper rotation, press `Ctrl+C` in the terminal where the script is running. This will also terminate the `feh` process that was launched by the script.
