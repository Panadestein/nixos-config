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

  # Keychron K2
  boot.extraModprobeConfig = ''
    options hid_apple fnmode=2
  '';

  # Kernel parameters and modules
  boot.initrd.kernelModules = [ "amdgpu" "hid-apple"];
  boot.kernelParams = [
    "quiet"
    "loglevel=3"
    "rd.systemd.show_status=auto"
    "rd.udev.log_level=3"
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
      extraPackages = hpkgs: [ 
        hpkgs.xmonad
        hpkgs.xmonad-contrib
        hpkgs.xmonad-extras
      ];
    };
  };

  # Configure keymap in X11
  services.xserver.layout = "us";

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;
  hardware.pulseaudio.package = pkgs.pulseaudioFull;
  nixpkgs.config.pulseaudio = true;
  sound.mediaKeys.enable = true;

  # Bluetooth support
  hardware.bluetooth.enable = true;
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
    binutils
    cacert
    coreutils
    curl
    dmidecode
    file
    poetry
    rsync
    unrar
    unzip
    usbutils
    which
    xclip
    xdg-utils
    bat
    git
    wget
    htop
    inxi
    figlet
    lolcat
    maim
    xorg.libxcb
    pciutils
    pavucontrol
    # Programming languages
    ghc
    (let
      my-python-packages = python-packages: with python-packages; [
        # Libraries
        pandas
        numpy
        scipy
        matplotlib
        jupyter
        ipython
        pygobject3
        pycairo
        sphinx
        # Linters
        pylint
        flake8
        jedi
        autopep8
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
    ranger
    # Text editors and office
    vim_configurable
    neovim
    emacs
    evince
    pandoc
    # Internet and communications
    firefox
    # Windowm manager utilities
    picom
    rofi
    dmenu
    nitrogen
    xmobar
    # GTK packages
    gtk3
    cairo
    gobject-introspection
    arc-theme
    pantheon.elementary-icon-theme
    gnome.adwaita-icon-theme
    dconf
    # Spell checkers and dictionaries
    aspell
    hunspell
    hunspellDicts.fr-moderne
    hunspellDicts.en_US
    hunspellDicts.de_DE
    hunspellDicts.de_DE
    aspellDicts.en
    aspellDicts.fr
    aspellDicts.es
    aspellDicts.de
    languagetool
  ];

  # Fonts
  fonts.fonts = with pkgs; [
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
    liberation_ttf
    fira-code
    fira-code-symbols
    mplus-outline-fonts
    source-code-pro
    dina-font
    proggyfonts
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
  services.openssh.enable = true;
  services.emacs.enable = true;
  services.upower.enable = true;
  services.gnome.gnome-keyring.enable = true;
  services.dbus = {
    enable = true;
    packages = [ pkgs.gnome3.dconf ];
  }; 

  # State version
  system.stateVersion = "21.11";
}

