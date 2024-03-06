# Emacs configuration
{ config, pkgs, ... }:
{
  home.file.".emacs.d/" = {
    source = pkgs.fetchFromGitHub {
      owner = "Panadestein";
      repo = "emacsd";
      rev = "a52ead470dbf84f6e1bcba5f3ba65949a4ad06ef";
      sha256 = "1h4kis51w39qjp4a0sj24z5cbbrdhci1d8vdi0wgv0pjf0nv3y7b";
    };
    recursive = true;
    onChange = builtins.readFile ../../dotfiles/set_emacs.sh;
  };
}
