# Generated via dconf2nix: https://github.com/gvolpe/dconf2nix
{ lib, ... }:

with lib.hm.gvariant;

{
  dconf.settings = {
    "com/github/amezin/ddterm" = {
      background-opacity = 1.0;
      window-maximize = false;
      window-monitor = "current";
      window-size = 1.0;
      window-type-hint = "dock";
    };

    "org/gnome/desktop/interface" = {
      cursor-size = 25;
      cursor-theme = "Adwaita";
      gtk-theme = "Arc-Dark";
      icon-theme = "Papirus";
    };

    "org/gnome/desktop/notifications/application/engineer-atlas-nyxt" = {
      application-id = "engineer.atlas.Nyxt.desktop";
    };

    "org/gnome/desktop/notifications/application/gnome-printers-panel" = {
      application-id = "gnome-printers-panel.desktop";
    };

    "org/gnome/desktop/notifications/application/org-gnome-weather" = {
      application-id = "org.gnome.Weather.desktop";
    };

    "org/gnome/desktop/notifications/application/simple-scan" = {
      application-id = "simple-scan.desktop";
    };

    "org/gnome/desktop/notifications/application/system-config-printer" = {
      application-id = "system-config-printer.desktop";
    };

    "org/gnome/nautilus/preferences" = {
      default-folder-viewer = "icon-view";
      migrated-gtk-settings = true;
      search-filter-time-type = "last_modified";
    };

    "org/gnome/nautilus/window-state" = {
      initial-size = mkTuple [ 890 550 ];
    };

  };
}
