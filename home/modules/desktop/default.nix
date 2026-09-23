{ config, pkgs, ... }:
{
  dconf.enable = true;

  xdg.userDirs = {
    enable = true;
    createDirectories = true;
    desktop = null;
    documents = "$HOME/Documents";
    download = "$HOME/Downloads";
    music = null;
    pictures = "$HOME/Pictures";
    projects = null;
    publicShare = null;
    templates = null;
    videos = "$HOME/Videos";
  };

  # Nautilus shows GTK bookmarks in its sidebar.
  xdg.configFile."gtk-3.0/bookmarks".text = ''
    file://${config.home.homeDirectory}/Documents
    file://${config.home.homeDirectory}/Downloads
    file://${config.home.homeDirectory}/Pictures
    file://${config.home.homeDirectory}/Videos
  '';

  home.pointerCursor = {
    enable = true;
    name = "Adwaita";
    package = pkgs.adwaita-icon-theme;
    size = 25;
  };

  dconf.settings."org/gnome/desktop/interface" = {
    color-scheme = "prefer-dark";
    cursor-theme = "Adwaita";
    cursor-size = 25;
    font-name = "Inter 11";
    gtk-theme = "Yaru-dark";
    icon-theme = "Yaru-blue-dark";
    monospace-font-name = "JetBrainsMono Nerd Font 11";
    text-scaling-factor = 1.3636;
  };

  xdg.configFile."gtk-3.0/settings.ini".text = ''
    [Settings]
    gtk-theme-name=Yaru-dark
    gtk-icon-theme-name=Yaru-blue-dark
    gtk-cursor-theme-name=Adwaita
    gtk-cursor-theme-size=25
    gtk-font-name=Inter 11
    gtk-application-prefer-dark-theme=1
  '';
  xdg.configFile."gtk-4.0/settings.ini".text = ''
    [Settings]
    gtk-theme-name=Yaru-dark
    gtk-icon-theme-name=Yaru-blue-dark
    gtk-cursor-theme-name=Adwaita
    gtk-cursor-theme-size=25
    gtk-font-name=Inter 11
    gtk-application-prefer-dark-theme=1
    gtk-interface-color-scheme=2
  '';

  # Let Rofi resolve icons for Wayland app IDs that differ from their packaged icon names.
  xdg.dataFile."icons/chromium-browser.png".source =
    "${pkgs.chromium}/share/icons/hicolor/256x256/apps/chromium.png";
  xdg.dataFile."icons/code.png".source = "${pkgs.vscode}/share/pixmaps/vscode.png";
  xdg.dataFile."icons/org.localsend.localsend_app.png".source =
    "${pkgs.localsend}/share/icons/hicolor/256x256/apps/localsend.png";
  xdg.dataFile."icons/org.inkscape.inkscape.svg".source =
    "${pkgs.inkscape}/share/icons/hicolor/scalable/apps/org.inkscape.Inkscape.svg";
  xdg.dataFile."icons/org.gnome.loupe.svg".source =
    "${pkgs.loupe}/share/icons/hicolor/scalable/apps/org.gnome.Loupe.svg";
  xdg.dataFile."icons/org.gnome.papers.svg".source =
    "${pkgs.papers}/share/icons/hicolor/scalable/apps/org.gnome.Papers.svg";
  xdg.dataFile."icons/signal.png".source =
    "${pkgs.signal-desktop}/share/icons/hicolor/256x256/apps/signal-desktop.png";
  xdg.dataFile."icons/hicolor/256x256/apps/com.mitchellh.ghostty.scratchpad-fish.png".source =
    "${pkgs.ghostty}/share/icons/hicolor/256x256/apps/com.mitchellh.ghostty.png";

  # Present the repository-tracked paintings as one user-facing gallery.
  xdg.dataFile."wallpapers/oehme".source = ../../assets/wallpapers/oehme;

  # Icon assets and fallbacks
  xdg.dataFile."icons/hicolor/256x256/apps/preferences-system.png".source =
    "${pkgs.yaru-theme}/share/icons/Yaru/256x256/apps/preferences-system.png";
  xdg.dataFile."icons/hicolor/256x256/apps/preferences-system-network.png".source =
    "${pkgs.yaru-theme}/share/icons/Yaru/256x256/categories/preferences-system-network.png";

  # Desktop entries for applications with missing or launcher-incompatible icons
  xdg.desktopEntries = {
    nm-connection-editor = {
      name = "Advanced Network Configuration";
      comment = "Manage and change your network connection settings";
      icon = "preferences-system-network";
      exec = "nm-connection-editor";
      terminal = false;
      categories = [
        "GNOME"
        "GTK"
        "Settings"
        "X-GNOME-NetworkSettings"
      ];
    };
    uuctl = {
      name = "uuctl";
      genericName = "User unit manager";
      comment = "Select and perform actions on user systemd units";
      icon = "preferences-system";
      exec = "uuctl";
      terminal = false;
      categories = [
        "Utility"
        "Settings"
      ];
    };
  };

  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "text/plain" = [ "emacsclient.desktop" ];
      "text/markdown" = [ "emacsclient.desktop" ];
      "text/org" = [ "emacsclient.desktop" ];
      "x-scheme-handler/org-protocol" = [ "emacsclient.desktop" ];
      "application/pdf" = [ "org.gnome.Papers.desktop" ];
      "application/x-bzpdf" = [ "org.gnome.Papers.desktop" ];
      "application/x-gzpdf" = [ "org.gnome.Papers.desktop" ];
      "application/x-xzpdf" = [ "org.gnome.Papers.desktop" ];
      "image/jpeg" = [ "org.gnome.Loupe.desktop" ];
      "image/png" = [ "org.gnome.Loupe.desktop" ];
      "image/webp" = [ "org.gnome.Loupe.desktop" ];
      "image/gif" = [ "org.gnome.Loupe.desktop" ];
      "image/svg+xml" = [ "org.gnome.Loupe.desktop" ];
      "inode/directory" = [ "org.gnome.Nautilus.desktop" ];
      "application/x-gnome-saved-search" = [ "org.gnome.Nautilus.desktop" ];
      "text/html" = [ "firefox.desktop" ];
      "x-scheme-handler/http" = [ "firefox.desktop" ];
      "x-scheme-handler/https" = [ "firefox.desktop" ];
      "x-scheme-handler/about" = [ "firefox.desktop" ];
      "x-scheme-handler/unknown" = [ "firefox.desktop" ];
      "x-scheme-handler/slack" = [ "slack.desktop" ];
      "x-scheme-handler/antigravity" = [ "antigravity.desktop" ];
      "x-scheme-handler/claude-cli" = [ "claude-code-url-handler.desktop" ];
    };
  };
}
