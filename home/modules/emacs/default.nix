# Emacs configuration
{ config, pkgs, ... }:
{
  home.file.".emacs.d/" = {
    source = pkgs.fetchFromGitHub {
      owner = "Panadestein";
      repo = "emacsd";
      rev = "0de6903061823084df2ee97d17499aab100f96b5";
      sha256 = "07vgnnpk03crflj3aq8lcwvd5p0b6cnl8nsnvrcpnlwgsnz80q43";
    };
    recursive = true;
    onChange = builtins.readFile ../../dotfiles/set_emacs.sh;
  };
}
