# Translate Shell configuration
{ pkgs, ... }:
{
  home.packages = [ pkgs.translate-shell ];

  xdg.configFile = {
    "translate-shell/happiness.trans".source = ./happiness.trans;
    "translate-shell/init.trans".source = ./init.trans;
  };
}
