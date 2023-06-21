# Emacs configuration
{ config, pkgs, ... }:
{
  home.file.".emacs.d/" = {
    source = pkgs.fetchFromGitHub {
      owner = "Panadestein";
      repo = "emacsd";
      rev = "bdb1fbf20e4021b2b7289ee4ade99353ed9ae7f3";
      sha256 = "0ipp2h9mvbyggv4l4nx2irsxp4a5fhcl1qk3hpr67hqfhn56zill";
    };
    recursive = true;
    onChange = builtins.readFile ../../dotfiles/set_emacs.sh;
  };
}
