# Home manager configuration
{ inputs, config, lib, pkgs, ... }:
let
  hm = inputs.home-manager.lib.hm;
in
{
  # Import home-manager modules
  imports = builtins.concatMap import [
    ../modules
  ];

  # User packages
  home.packages = with pkgs; [
    # General utilities
    asciidoctor
    bat
    bc
    brightnessctl
    calcurse
    ccls
    code-minimap
    cowsay
    dconf2nix
    fd
    figlet
    fortune
    fzf
    guake
    htop
    lolcat
    poppler_utils
    qemu
    tmate
    tmux
    trayer
    ueberzug
    universal-ctags
    volumeicon
    xclip
    xdg-utils
    xdotool
    # Windowm manager utilities
    dmenu
    mako
    nitrogen
    picom
    pipewire
    qt6.qtwayland
    xdg-desktop-portal-hyprland
    waybar
    wofi
    xmobar
    # GTK packages
    arc-theme
    cairo
    glib
    gnome.eog
    gnome.gnome-screenshot
    gnome.simple-scan 
    gobject-introspection
    gtk3
    siglo
    # Xfce packages
    xfce.exo
    xfce.thunar
    xfce.thunar-archive-plugin
    xfce.xfconf
    # Terminal based apps
    alacritty
    kitty
    ranger
    # Text editors
    neovim
    # Science
    avogadro2
    gnuplot
    graphviz
    maxima
    nodePackages.insect
    pymol
    sage
    zotero
    # Office
    calibre
    crow-translate
    djvulibre
    evince
    libreoffice-fresh
    ltex-ls
    pandoc
    translate-shell
    xournalpp
    # Videos
    ffmpeg
    mpv
    youtube-dl
    # Image editing
    gimp
    imagemagick
    inkscape
    pdftk
    povray
    # Programming utilities
    cmake
    exercism
    fortls
    haskell-language-server
    neovide
    shellcheck
    valgrind
    # Programming languages
    chez
    clojure
    gcc
    gdb
    ghc
    gnumake
    jdk11
    leiningen
    mpich
    nodejs
    racket
    sbcl
    # Internet and communications
    brave
    firefox
    mattermost-desktop
    qutebrowser
    skypeforlinux
    nixpkgs-stable.slack
    tdesktop
    whatsapp-for-linux
    zoom-us
    # Leisure
    retroarch
    # Web
    bundler
    hugo
    skribilo
    # Latex
    texlive.combined.scheme-full
    # Spell checkers and dictionaries
    aspell
    aspellDicts.de
    aspellDicts.en
    aspellDicts.es
    aspellDicts.fr
    hunspell
    hunspellDicts.de_DE
    hunspellDicts.de_DE
    hunspellDicts.en_US
    hunspellDicts.fr-moderne
    languagetool
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

  # VScode configuration
  programs.vscode = {
    enable = true;
    package = pkgs.vscode.fhsWithPackages (ps: with ps; [ fortran-language-server ]);
  };

  # Rofi
  programs.rofi = {
    enable = true;
    package = pkgs.rofi.override { plugins = [ pkgs.rofi-file-browser ]; };
    terminal = "${pkgs.alacritty}/bin/alacritty";
    theme = "arthur";
    extraConfig = {
      modi = "window,drun,run,ssh,file-browser-extended";
    };
  };
  xdg.configFile."rofi/file-browser".source = ../dotfiles/rofi_browser;

  # Alacritty
  xdg.configFile."alacritty/alacritty.yml".source = ../dotfiles/alacritty.yml;
  programs.alacritty = {
    enable = true;
  };

  # Xmobar
  xdg.configFile."xmobar/.xmobarrc".source = ../dotfiles/xmobarrc;
  home.file.".xmonad/xpm/haskell_20.xpm".source = ../dotfiles/images/haskell_20.xpm;
  home.file.".xmonad/trayer_padding.sh".source = ../dotfiles/trayer_padding.sh;
  programs.xmobar = {
    enable = true;
  };

  # Vim and Neovim
  home.file.".vimrc".source = ../dotfiles/vimrc;
  xdg.configFile."nvim/init.vim".source = ../dotfiles/init.vim;

  # Ranger
  xdg.configFile."ranger/rc.conf".source = ../dotfiles/rc.conf;

  # Thunar
  xdg.configFile."xfce4/helpers.rc".source = ../dotfiles/helpers_xfce.rc;

  # Ipython
  home.file.".ipython/profile_default/ipython_config.py".source = ../dotfiles/ipython_config.py;

  # Matplotlib (ensure Qt backend)
  home.file.".config/matplotlib/matplotlibrc".source = ../dotfiles/matplotlibrc;

  # Translate Shell
  xdg.configFile."translate-shell/init.trans".source = ../dotfiles/init.trans;
  home.file.".config/translate-shell/happiness.trans".source = ../dotfiles/happiness.trans;

  # Picom, disables if not using a WM
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
        config = ../dotfiles/xmonad.hs;
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
  xdg.configFile."qtile/config.py".source = ../dotfiles/config_qtile.py;
  home.file.".config/qtile/python_icon.png".source = ../dotfiles/images/python_icon.png;
  home.file.".config/qtile/tc_feyn.png".source = ../dotfiles/images/tc_feyn.png;
  home.file.".config/qtile/cc_tram.jpg".source = ../dotfiles/images/cc_tram.jpg;

  # Set LightDM avatar (https://wiki.archlinux.org/title/LightDM#Changing_your_avatar)
  home.file.".face".source = ../dotfiles/images/cfd_DWudN.png;

  # Script to control plugged monitors
  home.file.".config/scripts/randr_conf.sh".source = ../dotfiles/randr_conf.sh;

  # GTk theme, disabled if using Gnome
  gtk = {
    enable = true;
    iconTheme = {
      name = "Adwaita";
      package = pkgs.gnome.adwaita-icon-theme;
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

  # State version
  home.stateVersion = "22.05";
}
