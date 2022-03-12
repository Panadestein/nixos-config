# Home manager configuration

{ config, pkgs, ... }:
let
  home-manager = builtins.fetchTarball "https://github.com/nix-community/home-manager/archive/master.tar.gz";
in
{
  imports = [
    (import "${home-manager}/nixos")
  ];

  home-manager.users.loren = {
    nixpkgs.config.allowUnfree = true;
    home.packages = [
      # General utilities
      pkgs.brightnessctl
      pkgs.calcurse
      pkgs.ccls
      pkgs.code-minimap
      pkgs.gnome.eog
      pkgs.gnome.nautilus
      pkgs.poppler_utils
      pkgs.trayer
      pkgs.ueberzug
      pkgs.universal-ctags
      pkgs.volumeicon
      # Science
      pkgs.avogadro2
      pkgs.molden
      pkgs.sage
      pkgs.zotero
      # Image editing
      pkgs.gimp
      pkgs.imagemagick
      pkgs.inkscape
      pkgs.pdftk
      # Office
      pkgs.libreoffice
      pkgs.pandoc
      pkgs.xournalpp
      # Programming
      pkgs.chicken
      pkgs.neovide
      pkgs.shellcheck
      # Communications
      pkgs.mattermost-desktop
      pkgs.skype
      pkgs.slack
      pkgs.tdesktop
      pkgs.zoom-us
      # Leisure
      pkgs.retroarch
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
        rev = "a81dbdc3385101644959a6dd6f44131a011cae80";
        sha256 = "08pqq0rg0z2c2jmgadn26xcb12nzqw6vh68vnw29bx9wlqp20f8c"; 
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
      inactiveOpacity = "0.8";
      noDockShadow = true;
      noDNDShadow = true;
      menuOpacity = "1.0";
      opacityRule = [
         "80:class_g = 'Alacritty'"
        "100:class_g = 'Evince'"
        "100:class_g = 'firefox-default' && argb"
        "100:class_g = 'Gimp-2.10'"
        "100:class_g = 'Inkscape'"
        "100:class_g = 'Mattermost'"
        "100:class_g = 'Rofi'"
        "100:class_g = 'Skype'"
        "100:class_g = 'Slack'"
        "100:class_g = 'TelegramDesktop'"
        "100:class_g = 'Xournalpp'"
        "100:class_g = 'Zotero'"
        "100:class_g = 'zoom'"
      ];
      backend = "glx";
    };

    # Extra Xsession config
    xsession = {
      pointerCursor = {
      name = "Adwaita";
      package = pkgs.gnome.adwaita-icon-theme;
      size = 25;
      };
      windowManager.xmonad = {
        enable = true;
        enableContribAndExtras = true;
        config = ./dotfiles/xmonad.hs;
      };
    };
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
        tume = "ssh -Y rbarrueta@cpch06.chm.tu-dresden.de";
        lsts0 = "ssh -Y rbarrueta@141.30.9.190";
        lsts1 = "ssh -Y rbarrueta@141.30.9.191";
        tukup = "sftp rbarrueta@cpch06.chm.tu-dresden.de";
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

