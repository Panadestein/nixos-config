#-----------------------------
#    _   _ _       ___  ____  
#   | \ | (_)_  __/ _ \/ ___| 
#   |  \| | \ \/ / | | \___ \ 
#   | |\  | |>  <| |_| |___) |
#   |_| \_|_/_/\_\\___/|____/ 
#
#      Panadestein's NixOS
#-----------------------------

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      # Use home-manager
      ./home.nix
    ];

  # Enable unfree packages
  nixpkgs.config.allowUnfree = true;

  # Use the latest linux kernel
  boot.kernelPackages = pkgs.linuxPackages_5_15;

  # Load AMD CPU microcode
  hardware.cpu.amd.updateMicrocode = true;

  # Add HiDPI support
  hardware.video.hidpi.enable = true;

  # Kernel parameters and modules
  boot.initrd.kernelModules = [ "amdgpu" "hid-apple"];
  boot.kernelParams = [
    "quiet"
    "loglevel=3"
    "rd.systemd.show_status=auto"
    "rd.udev.log_level=3"
    "hid_apple.fnmode=0"
  ];
  boot.initrd.verbose = false;
  boot.plymouth.enable = true;

  # Use the systemd-boot EFI boot loader.
  boot.loader = {
    systemd-boot.enable = false;
    efi.canTouchEfiVariables = true;
    grub.enable = true;
    grub.efiSupport = true;
    grub.device = "nodev";
  };

  # Set hostname
  networking.hostName = "cyrus";

  # Set your time zone.
  time.timeZone = "Europe/Berlin";

  # Set zsh as default shell
  programs.zsh.enable = true;
  users.defaultUserShell = pkgs.zsh;

  # Network configuration
  networking.useDHCP = false;
  networking.interfaces.enp2s0f0.useDHCP = true;
  networking.interfaces.enp5s0.useDHCP = true;
  networking.networkmanager.enable = true;
  programs.nm-applet.enable = true;

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Configure AMD graphics
  services.xserver.videoDrivers = [ "amdgpu" ];
  hardware.opengl.driSupport = true;
  hardware.opengl.extraPackages = with pkgs; [
   amdvlk
   rocm-opencl-icd
   rocm-opencl-runtime
  ];
  services.xserver.deviceSection = ''Option "TearFree" "true"'';

  # Desktop
  services.xserver.displayManager.defaultSession = "none+xmonad";
  services.xserver.displayManager.lightdm = {
    enable = true;
    greeters.enso = {
      enable = true;
    }; 
  };

  services.xserver.windowManager = {
    xmonad = {
      enable = true;
      enableContribAndExtras = true;
      extraPackages = haskellPackages: [
        haskellPackages.xmonad
        haskellPackages.xmonad-contrib
        haskellPackages.xmonad-extras
      ];
    };
  };

  # Configure keymap in X11
  services.xserver.layout = "us";

  # Enable CUPS to print documents.
  services.printing = {
    enable = true;
    clientConf = ''
      ServerName cpcs04.chm.tu-dresden.de 
    '';
  };
  services.avahi.enable = true;
  services.avahi.nssmdns = true;

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;
  hardware.pulseaudio.package = pkgs.pulseaudioFull;
  nixpkgs.config.pulseaudio = true;
  sound.mediaKeys.enable = true;

  # Bluetooth support
  hardware.bluetooth = {
    enable = true;
  };
  services.blueman.enable = true;

  # Enable touchpad support
  services.xserver.libinput.enable = true;

  # User account and configuration
  users.users.loren = {
    isNormalUser = true;
    home = "/home/loren";
    createHome = true;
    extraGroups = [ "wheel"
                    "audio"
                    "input"
                    "networkmanager" 
                    "systemd-journal" 
                    "video"];
  };

  # Global packages
  environment.systemPackages = with pkgs; [
    # General utilities
    acpi
    bat
    binutils
    cacert
    coreutils
    curl
    djvulibre
    dmidecode
    figlet
    file
    git
    htop
    inxi
    killall
    libtool
    lolcat
    maim
    pavucontrol
    pciutils
    poetry
    rsync
    sshfs
    unrar
    unzip
    usbutils
    wget
    which
    xclip
    xdg-utils
    xdotool
    # Programming languages
    cmake
    gcc
    gfortran
    ghc
    gnumake
    mpich
    qt5Full
    (let
      my-python-packages = python-packages: with python-packages; [
        # Scientific libraries
        ipython
        jupyter
        matplotlib
        numpy
        pandas
        scikit-learn
        scipy
        sympy
        # Qt backend
        pyqt5
        # Documentation
        sphinx
        # Linters
        autopep8
        flake8
        jedi
        pylint
      ];
      python-with-my-packages = python3.withPackages my-python-packages;
    in
      python-with-my-packages)
    # Science utilities
    gnuplot
    # Terminal and CLI utilities
    alacritty
    zsh
    # File browser
    dropbox-cli
    ranger
    # Text editors and office
    emacs
    evince
    neovim
    pandoc
    vim_configurable
    # Internet and communications
    firefox
    # Windowm manager utilities
    dmenu
    nitrogen
    picom
    rofi
    xmobar
    # GTK packages
    arc-theme
    cairo
    dconf
    glib
    gnome.adwaita-icon-theme
    gobject-introspection
    gtk3
    pantheon.elementary-icon-theme
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

  # Use Flatpak
  # Every now and then some apps annoy you with versions (e.g. Zoom)
  # https://nixos.org/manual/nixos/stable/index.html#module-services-flatpak
  services.flatpak.enable = true;
  xdg.portal = {
    enable =  true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };

  # Fonts
  fonts.fonts = with pkgs; [
    dina-font
    fira-code
    fira-code-symbols
    font-awesome-ttf
    liberation_ttf
    mplus-outline-fonts
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
    proggyfonts
    source-code-pro
    (nerdfonts.override { fonts = [ "SourceCodePro" ]; })
  ];

  # Gnome apps configuration
  programs.dconf.enable = true;

  # Gnupg configuration
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  # Services
  services.actkbd.enable = true;
  services.gvfs.enable = true;
  services.openssh.enable = true;
  services.teamviewer.enable = true;
  services.emacs = {
    enable = true;
    defaultEditor = true;
  };
  services.upower.enable = true;
  services.gnome.gnome-keyring.enable = true;
  services.dbus = {
    enable = true;
    packages = [ pkgs.gnome3.dconf ];
  };
  systemd.user.services.dropbox = {
    description = "Dropbox";
    wantedBy = [ "graphical-session.target" ];
    environment = {
      QT_PLUGIN_PATH = "/run/current-system/sw/" + pkgs.qt5.qtbase.qtPluginPrefix;
      QML2_IMPORT_PATH = "/run/current-system/sw/" + pkgs.qt5.qtbase.qtQmlPrefix;
    };
    serviceConfig = {
      ExecStart = "${pkgs.dropbox.out}/bin/dropbox";
      ExecReload = "${pkgs.coreutils.out}/bin/kill -HUP $MAINPID";
      KillMode = "control-group"; # upstream recommends process
      Restart = "on-failure";
      PrivateTmp = true;
      ProtectSystem = "full";
      Nice = 10;
    };
  };

  # State version
  system.stateVersion = "21.11";
}

