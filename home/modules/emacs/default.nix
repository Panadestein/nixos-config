# Emacs configuration
{ config, pkgs, ... }:
{
  home.file.".emacs.d/" = {
    source = pkgs.fetchFromGitHub {
      owner = "Panadestein";
      repo = "emacsd";
      rev = "ab7f3af475d589eec659380a00addbd3fa6aa7bc";
      sha256 = "1mp49w8f3219620r779bvsyfn7z4r5wv95i48v0293phw5x992hv";
    };
    recursive = true;
    onChange = builtins.readFile ../../dotfiles/set_emacs.sh;
  };
}
