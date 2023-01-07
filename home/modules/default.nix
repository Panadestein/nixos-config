{ config, pkgs, ... }:
{
  #users.users.user.isNormalUser = true;

  home-manager.users.loren = { ... }: {
    import =  [
      ./emacs
      ./zsh
      ./dconf
    ];
  };
}
