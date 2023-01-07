{ config, pkgs, ... }
{
  import =  [
    ./emacs
    ./zsh
    ./dconf
  ];
}
