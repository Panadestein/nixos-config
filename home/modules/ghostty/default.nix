# Ghostty terminal emulator configuration
{ pkgs, ... }:
let
  theme = import ../../theme.nix;
in
{
  programs.ghostty = {
    enable = true;
    enableBashIntegration = true;
    enableFishIntegration = true;
    enableZshIntegration = true;
    settings = {
      font-family = "JetBrainsMono Nerd Font";
      font-size = 12;
      command = "direct:${pkgs.fish}/bin/fish";
      background = theme.background;
      foreground = theme.foreground;
      cursor-color = theme.accent;
      selection-background = theme.selection;
      selection-foreground = theme.brightForeground;
      palette = [
        "0=${theme.darkerBackground}"
        "1=${theme.red}"
        "2=${theme.green}"
        "3=${theme.yellow}"
        "4=${theme.blue}"
        "5=${theme.magenta}"
        "6=${theme.cyan}"
        "7=${theme.foreground}"
        "8=${theme.muted}"
        "9=${theme.brightRed}"
        "10=${theme.brightGreen}"
        "11=${theme.brightYellow}"
        "12=${theme.brightBlue}"
        "13=${theme.brightMagenta}"
        "14=${theme.brightCyan}"
        "15=${theme.brightForeground}"
      ];
      background-opacity = 0.96;
      # Ghostty measures this in bytes, including the visible screen.
      scrollback-limit = 50 * 1024 * 1024;
      window-padding-x = 10;
      window-padding-y = 10;
    };
  };
}
