# Wallpaper switcher script for Hyprpaper and Waypaper
{ pkgs, ... }:
let
  wallpaperNext = pkgs.writeShellApplication {
    name = "wallpaper-next";
    runtimeInputs = [
      pkgs.coreutils
      pkgs.gnugrep
      pkgs.waypaper
    ];
    text = ''
      wallpaper_dir="$HOME/.local/share/wallpapers/oehme"
      waypaper_config="$HOME/.config/waypaper/config.ini"

      shopt -s nullglob
      wallpapers=(
        "$wallpaper_dir"/*.jpg
        "$wallpaper_dir"/*.jpeg
        "$wallpaper_dir"/*.png
        "$wallpaper_dir"/*.webp
      )

      if (( ''${#wallpapers[@]} == 0 )); then
        echo "No wallpapers found in $wallpaper_dir" >&2
        exit 1
      fi

      current=""
      if [[ -f "$waypaper_config" ]]; then
        while IFS= read -r line; do
          current="''${line#wallpaper = }"
          current="''${current/#\~/$HOME}"
          break
        done < <(grep '^wallpaper = ' "$waypaper_config")
      fi

      next=0
      for index in "''${!wallpapers[@]}"; do
        if [[ "$(readlink -f "''${wallpapers[$index]}")" == "$(readlink -f "$current" 2>/dev/null || true)" ]]; then
          next=$(( (index + 1) % ''${#wallpapers[@]} ))
          break
        fi
      done

      exec waypaper \
        --backend hyprpaper \
        --folder "$wallpaper_dir" \
        --wallpaper "''${wallpapers[$next]}"
    '';
  };
in
{
  home.packages = [
    wallpaperNext
  ];
}
