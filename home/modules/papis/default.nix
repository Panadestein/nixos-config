# Papis configuration
{ pkgs, ... }:
{
  xdg = {
    configFile."papis/config".source = ./config;
    dataFile."icons/hicolor/256x256/apps/gnome-books.png".source =
      "${pkgs.yaru-theme}/share/icons/Yaru/256x256/apps/gnome-books.png";

    desktopEntries.papis = {
      name = "papis-open";
      comment = "Launches the Papis document opener after picking a library";
      icon = "gnome-books";
      exec = "${pkgs.ghostty}/bin/ghostty -e papis --pick-lib open";
      terminal = false;
      categories = [
        "Office"
        "ConsoleOnly"
      ];
      mimeType = [ "inode/directory" ];
    };
  };
}
