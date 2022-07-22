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
let
  unstable = import <nixos-unstable> { config = { allowUnfree = true; }; };
in {
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      # Use home-manager
      ./home.nix
    ];

  # Overlays
  nixpkgs.overlays = [
    # Qtile overlay
    (self: super: {
      qtile = super.qtile.overrideAttrs(oldAttrs: {
        propagatedBuildInputs =
          oldAttrs.passthru.unwrapped.propagatedBuildInputs
          ++ (with self.python3Packages; [
          # Extra Python packages for Qtile widgets
          dbus-next
        ]);
      });
    })

    # Emacs overlay
    (import (builtins.fetchTarball {
      url = https://github.com/nix-community/emacs-overlay/archive/master.tar.gz;
    }))
  ];

  # Nixpkgs configuration
  nixpkgs.config = {
    allowUnfree = true;
    packageOverrides = pkgs: {
      inxi = pkgs.inxi.override { withRecommends = true; };
    };
  };

  # Nix configuration
  nix = {
    settings = {
      substituters = [
        "https://nix-community.cachix.org/"
        "https://cache.nixos.org/"
      ];
      trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];
      trusted-users = [
        "root"
        "loren"
      ];
    };
  };

  # Use the latest linux kernel
  boot.kernelPackages = pkgs.linuxPackages_latest;

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

  # Display manager
  services.xserver.displayManager = {
    defaultSession = "none+qtile";
    gdm = {
      enable = false;
      wayland = false;
    };
    lightdm = {
      enable = true;
      greeters.enso = {
        enable = true;
      }; 
    };
  };

  # Window managers :fire:
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
    qtile = {
      enable = true;
    };
  };

  # In case we need Gnome at some point
  services.xserver.desktopManager.gnome.enable = false;

  # Configure keymap in X11
  services.xserver.layout = "us,de";
  services.xserver.xkbVariant = "altgr-intl";

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
  services.xserver.libinput = {
    enable = true;
    touchpad = {
      tapping = true;
      naturalScrolling = true;
      scrollMethod = "twofinger";
    };
  };

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
    bc
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
    fortran-language-server
    gcc
    gdb
    gfortran
    ghc
    gnumake
    jdk11
    mpich
    qt5Full
    (let
      my-python-packages = python-packages: with python-packages; [
        # Language server
        python-lsp-server
        # Scientific libraries
        ipython
        jupyter
        matplotlib
        mpmath
        numpy
        pandas
        seaborn
        scikit-learn
        scipy
        sympy
        tensorly
        # Qt backend
        pyqt5
        # Documentation
        sphinx
        # Linters
        autopep8
        flake8
        jedi
        pylint
        # Web
        tornado
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
    dropbox-cli.nautilusExtension
    ranger
    # Text editors and office
    emacsGitNativeComp
    evince
    neovim
    pandoc
    vim_configurable
    # Internet and communications
    firefox
    zoom-us
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

  # Emacs configuration
  services.emacs = {
    enable = true;
    package = pkgs.emacsGitNativeComp;
    defaultEditor = true;
  };

  # Enable Java
  programs.java.enable = true;

  # Use Flatpak, just in case
  services.flatpak.enable = true;
  xdg.portal.enable = true;
  xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk ];

  # Fonts
  fonts.fonts = with pkgs; [
    dina-font
    fira-code
    fira-code-symbols
    font-awesome
    liberation_ttf
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

  # Enable docker (rarely needed but still)
  virtualisation.docker.enable = true;

  # Services
  services.actkbd.enable = true;
  services.gvfs.enable = true;
  services.openssh.enable = true;
  services.teamviewer.enable = true;
  services.upower.enable = true;
  services.gnome.gnome-keyring.enable = true;
  services.dbus = {
    enable = true;
    packages = [ pkgs.dconf ];
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
  system.stateVersion = "22.05";
}

