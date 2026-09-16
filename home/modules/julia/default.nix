# Julia launcher and icon
{ pkgs, ... }:
{
  home.packages = [ pkgs.julia-bin ];
  xdg.dataFile."icons/hicolor/scalable/apps/julia.svg".source = ./julia.svg;

  xdg.desktopEntries.julia = {
    name = "Julia";
    comment = "High-performance language for technical computing";
    icon = "julia";
    exec = "${pkgs.ghostty}/bin/ghostty -e julia";
    terminal = false;
    categories = [
      "Development"
      "Science"
    ];
  };
}
