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
      tmux
      trayer
      ueberzug
      universal-ctags
      volumeicon
      # File manager
      xfce.exo
      xfce.thunar
      xfce.thunar-archive-plugin
      xfce.xfconf
      # Science
      avogadro2
      molden
      zotero
      # Videos
      mpv
      youtube-dl
      # Image editing
      gimp
      imagemagick
      inkscape
      pdftk
      # Office
      libreoffice-fresh
      pandoc
      translate-shell
      xournalpp
      # Programming
      neovide
      shellcheck
      # Communications
      brave
      mattermost-desktop
      #nyxt
      skypeforlinux
      slack
      tdesktop
      whatsapp-for-linux
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
        rev = "365c02cee3986b52d7fd3e9392ca11900508e0e7";
        # nix-prefetch-url --unpack https://github.com/Panadestein/emacsd/archive/rev.tar.gz
        sha256 = "0nsyk87x98vq4ps618mrb3xhs3pip8xyk868iz4dpykqcgz8wjjq"; 
      };
      recursive = true;
      onChange = builtins.readFile /etc/nixos/dotfiles/set_emacs.sh;
    };

    # VScode configuration
    programs.vscode = {
      enable = true;
      package = pkgs.vscode.fhsWithPackages (ps: with ps; [ fortran-language-server ]);
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

    # Translate Shell
    xdg.configFile."translate-shell/init.trans".source = ./dotfiles/init.trans;
    home.file.".config/translate-shell/happiness.trans".source = ./dotfiles/happiness.trans;

    # Picom
    services.picom = {
      enable = true;
      activeOpacity = 1.0;
      inactiveOpacity = 1.0;
      menuOpacity = 1.0;
      wintypes = {
        dock = { shadow = false; };
        dnd = { shadow = false; };
      };
      opacityRules = [
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
    home.file.".config/qtile/cc_tram.jpg".source = ./dotfiles/images/cc_tram.jpg;

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
        c = "code -r";
        e = "emacsclient";
        E = "SUDO_EDITOR='emacsclient -t -a emacs' sudoedit";
        en = "emacsclient -c -nw";
        jour1 = "journalctl -p 3 -xb";
        jour2 = "journalctl -xb | grep rror";
        ka = "killall";
        n = "neovide --maximized";
        r = "ranger";
        sb = "source ~/.bashrc";
        sv = "sudo nvim";
        sz = "source ~/.zshrc";
        t = "trans";
        v = "nvim";
        # Aliases for configuration files
        cde = "cd ~/.emacs.d/";
        cfb = "e ~/.bashrc";
        cfe = "e ~/.emacs.d/init.el";
        cfn = "neovide --maximized ~/.config/nvim/init.vim";
        cfv = "vim ~/.vimrc";
        vb = "nvim ~/.bashrc";
        vz = "nvim ~/.zshrc";
        # Less useful aliases
        jnb = "jupyter notebook";
        starwars = "telnet towel.blinkenlights.nl";
        wo = ''figlet -t "$(hostname)"'';
        # Aliases for remote machines
        ccpgate = "ssh -Y panades@ccpgate.tnw.utwente.nl";
        jul = "ssh -i ~/.ssh/id_ed25519 -Y panadesbarrueta1@juwels-cluster.fz-juelich.de";
        lsts0 = "ssh -Y rbarrueta@141.30.9.190";
        lsts1 = "ssh -Y rbarrueta@141.30.9.191";
        mah = "ssh rpanades@mahti.csc.fi";
        sakup = "sftp ramon@sakura.univ-lille1.fr";
        sakura = "ssh -Y ramon@sakura.univ-lille1.fr";
        sssara = "ssh -Y panades@doornode.surfsara.nl";
        tau = "ssh -Y rapa157d@taurus.hrsk.tu-dresden.de";
        toul = "ssh panades@lpqsv11.ups-tlse.fr";
        tukup = "OBsftp rbarrueta@cpch06.chm.tu-dresden.de";
        tume = "ssh -Y rbarrueta@cpch06.chm.tu-dresden.de";
      };

      history = {
        expireDuplicatesFirst = true;
        size = 10000000;
      };

      initExtra = builtins.readFile ./dotfiles/zshextra;

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
            rev = "v0.5.0";
            sha256 = "0za4aiwwrlawnia4f29msk822rj9bgcygw6a8a6iikiwzjjz0g91";
          };
        }
      ];
    };
  };
}

