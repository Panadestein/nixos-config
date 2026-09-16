# Nushell configuration
{ pkgs, ... }:
{
  home.packages = [ pkgs.nushell ];

  xdg.configFile = {
    "nushell/config.nu".source = ./config.nu;
    "nushell/env.nu".source = ./env.nu;
  };
}
