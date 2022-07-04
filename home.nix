# Home manager configuration

{ config, pkgs, ... }:
let
  home-manager = builtins.fetchTarball "https://github.com/nix-community/home-manager/archive/master.tar.gz";
  unstable = import <nixos-unstable> { config = { allowUnfree = true; }; };
in
{
  imports = [
    (import "${home-manager}/nixos")
  ];

  home-manager.users.loren = {
    nixpkgs.config.allowUnfree = true;

    # Dconf settings for Gnome
    imports = [ ./dotfiles/dconf.nix ];

    # User packages
    home.stateVersion = "22.05";
    home.packages = with pkgs; [
      # General utilities
      brightnessctl
      calcurse
      ccls
      code-minimap
      dconf2nix
      fzf
      gnome.eog
      gnome.gnome-screenshot
      gnome.gnome-tweaks
      gnome.nautilus
      guake
      poppler_utils
      tmate
      trayer
      ueberzug
      universal-ctags
      volumeicon
      # Science
      avogadro2
      molden
      zotero
      # Image editing
      gimp
      imagemagick
      inkscape
      pdftk
      # Office
      libreoffice
      pandoc
      xournalpp
      # Programming
      chicken
      #  neovide
      shellcheck
      # Communications
      brave
      mattermost-desktop
      skypeforlinux
      slack
      tdesktop
      # Leisure
      retroarch
    ];

    # Git
    programs.git = {
      enable = true;
      userName = "Panadestein";
      userEmail = "rpana92@gmail.com";
      extraConfig = {
        credential.helper = "${
          pkgs.git.override { withLibsecret = true; }
        }/bin/git-credential-libsecret";};
    };

    # Emacs configuration
    home.file.".emacs.d/" = {
      source = pkgs.fetchFromGitHub {
        owner = "Panadestein";
        repo = "emacsd";
        rev = "282082f3df4f815f485f80d0cb24aa2dad85d67e";
        sha256 = "1i9bk6k4naai6w845zqnzp7606h7jwdp5cfa6j8zk3505sg0ia3a"; 
      };
      recursive = true;
      onChange = builtins.readFile /etc/nixos/dotfiles/set_emacs.sh;
    };

    # Rofi
    programs.rofi = {
      enable = true;
      terminal = "${pkgs.alacritty}/bin/alacritty";
      theme = "arthur";
    };

    # Alacritty
    xdg.configFile."alacritty/alacritty.yml".source = ./dotfiles/alacritty.yml;
    programs.alacritty = {
      enable = true;
    };

    # Xmobar
    xdg.configFile."xmobar/.xmobarrc".source = ./dotfiles/xmobarrc;
    home.file.".xmonad/xpm/haskell_20.xpm".source = dotfiles/images/haskell_20.xpm;
    home.file.".xmonad/trayer_padding.sh".source = dotfiles/trayer_padding.sh;
    programs.xmobar = {
      enable = true;
    };

    # Vim and Neovim
    home.file.".vimrc".source = ./dotfiles/vimrc;
    xdg.configFile."nvim/init.vim".source = ./dotfiles/init.vim;

    # Ranger
    xdg.configFile."ranger/rc.conf".source = ./dotfiles/rc.conf;

    # Ipython
    home.file.".ipython/profile_default/ipython_config.py".source = ./dotfiles/ipython_config.py;

    # Matplotlib (ensure Qt backend)
    home.file.".config/matplotlib/matplotlibrc".source = ./dotfiles/matplotlibrc;

    # Picom
    services.picom = {
      enable = true;
      activeOpacity = "1.0";
      inactiveOpacity = "1.0";
      noDockShadow = true;
      noDNDShadow = true;
      menuOpacity = "1.0";
      opacityRule = [
         "90:class_g = 'Alacritty'"
      ];
      backend = "glx";
    };

    # Extra Xsession config
    xsession = {
      windowManager = {
        xmonad = {
          enable = true;
          enableContribAndExtras = true;
          config = ./dotfiles/xmonad.hs;
        };
      };
    };

    # Pointer cursor
    home.pointerCursor = {
      x11.enable = true;
      name = "Adwaita";
      package = pkgs.gnome.adwaita-icon-theme;
      size = 25;
    };

    # Qtile configuration
    xdg.configFile."qtile/config.py".source = ./dotfiles/config_qtile.py;
    home.file.".config/qtile/python_icon.png".source = ./dotfiles/images/python_icon.png;
    home.file.".config/qtile/tc_feyn.png".source = ./dotfiles/images/tc_feyn.png;

    # Set LightDM avatar (https://wiki.archlinux.org/title/LightDM#Changing_your_avatar)
    home.file.".face".source = dotfiles/images/cfd_DWudN.png;

    # Script to control plugged monitors
    home.file.".config/scripts/randr_conf.sh".source = ./dotfiles/randr_conf.sh;

    # GTk theme
    gtk = {
      enable = true;
      iconTheme = {
        name = "elementary";
        package = pkgs.pantheon.elementary-icon-theme;
      };
      cursorTheme = {
      name = "Adwaita";
      package = pkgs.gnome.adwaita-icon-theme;
      size = 25;
      };
      theme = {
        name = "Arc-Dark";
        package = pkgs.arc-theme;
      };
    };

    # Removable devices
    services.udiskie = {
      enable = true;
      tray = "always";
    };

    # Zsh config
    programs.zsh = {
      enable = true;
      autocd = true;
      dotDir = ".config/zsh";
      enableAutosuggestions = true;
      enableCompletion = true;

      shellAliases = {
        # General aliases
        e = "emacsclient";
        en = "emacsclient -c -nw";
        E = "SUDO_EDITOR='emacsclient -t -a emacs' sudoedit";
        v = "nvim";
        n = "neovide --maximized";
        r = "ranger";
        sb = "source ~/.bashrc";
        sz = "source ~/.zshrc";
        ka = "killall";
        sv = "sudo nvim";
        jour1 = "journalctl -p 3 -xb";
        jour2 = "journalctl -xb | grep rror";
        # Aliases for configuration files
        cfb = "e ~/.bashrc";
        vb = "nvim ~/.bashrc";
        vz = "nvim ~/.zshrc";
        cfe = "e ~/.emacs.d/init.el";
        cde = "cd ~/.emacs.d/";
        cfv = "vim ~/.vimrc";
        cfn = "neovide --maximized ~/.config/nvim/init.vim";
        # Less useful aliases
        wo = ''figlet -t "$(hostname)"'';
        jnb = "jupyter notebook";
        starwars = "telnet towel.blinkenlights.nl";
        # Aliases for remote machines
        sakura = "ssh -Y ramon@sakura.univ-lille1.fr";
        sssara = "ssh -Y panades@doornode.surfsara.nl";
        ccpgate = "ssh -Y panades@ccpgate.tnw.utwente.nl";
        tau = "ssh -Y rapa157d@taurus.hrsk.tu-dresden.de";
        mah = "ssh rpanades@mahti.csc.fi";
        jul = "ssh -i ~/.ssh/id_ed25519 -Y panadesbarrueta1@juwels-cluster.fz-juelich.de";
        tume = "ssh -Y rbarrueta@cpch06.chm.tu-dresden.de";
        lsts0 = "ssh -Y rbarrueta@141.30.9.190";
        lsts1 = "ssh -Y rbarrueta@141.30.9.191";
        tukup = "OBsftp rbarrueta@cpch06.chm.tu-dresden.de";
        sakup = "sftp ramon@sakura.univ-lille1.fr";
        toul = "ssh panades@lpqsv11.ups-tlse.fr";
      };

      history = {
        expireDuplicatesFirst = true;
        size = 10000000;
      };

      initExtra = ''
      source /etc/nixos/dotfiles/zshextra
      '';

      oh-my-zsh = {
        enable = true;
        plugins = [
          "command-not-found"
          "git"
          "history"
          "sudo"
        ];
      };

      zplug = {
        enable = true;
        plugins = [
          { name = "zsh-users/zsh-completions"; }
          { name = "zsh-users/zsh-syntax-highlighting"; }
        ];
      };

      plugins = [
        {
          name = "zsh-nix-shell";
          file = "nix-shell.plugin.zsh";
          src = pkgs.fetchFromGitHub {
            owner = "chisui";
            repo = "zsh-nix-shell";
            rev = "v0.4.0";
            sha256 = "037wz9fqmx0ngcwl9az55fgkipb745rymznxnssr3rx9irb6apzg";
          };
        }
      ];
    };
  };
}

