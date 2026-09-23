# Zoom with native Wayland support under Hyprland.
{ pkgs, ... }:
let
  zoomUs = pkgs.zoom-us.override {
    hyprlandXdgDesktopPortalSupport = true;
    pulseaudioSupport = true;
  };
  zoomLaunch = pkgs.writeShellScript "zoom-wayland-launch" ''
    zoomConfig="$HOME/.config/zoomus.conf"
    ${pkgs.coreutils}/bin/mkdir -p "$HOME/.config"
    ${pkgs.coreutils}/bin/touch "$zoomConfig"

    if ${pkgs.gnugrep}/bin/grep -q '^xwayland=' "$zoomConfig"; then
      ${pkgs.gnused}/bin/sed -i 's/^xwayland=.*/xwayland=false/' "$zoomConfig"
    else
      printf '%s\n' 'xwayland=false' >> "$zoomConfig"
    fi

    export QT_QPA_PLATFORM=wayland
    export XDG_CURRENT_DESKTOP=Hyprland
    exec ${zoomUs}/bin/zoom "$@"
  '';
  zoomWayland = pkgs.symlinkJoin {
    name = "zoom-us-wayland";
    paths = [ zoomUs ];
    postBuild = ''
      rm "$out/bin/zoom"
      ln -s ${zoomLaunch} "$out/bin/zoom"
    '';
  };
in
{
  home.packages = [ zoomWayland ];

  xdg.dataFile."icons/zoom.png".source = "${zoomUs}/share/pixmaps/Zoom.png";
}
