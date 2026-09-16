#-----------------------------
#    _   _ _       ___  ____
#   | \ | (_)_  __/ _ \/ ___|
#   |  \| | \ \/ / | | \___ \
#   | |\  | |>  <| |_| |___) |
#   |_| \_|_/_/\_\\___/|____/
#
#      Panadestein's NixOS
#-----------------------------

{
  config,
  pkgs,
  lib,
  inputs,
  ...
}:
let
  theme = import ../../home/theme.nix;
  hyprlandSession = pkgs.writeShellScript "hyprland-session" ''
    exec ${lib.getExe config.programs.uwsm.package} start -e -D Hyprland -g -1 hyprland.desktop >/dev/null 2>&1
  '';
  zoomUs = pkgs.zoom-us.override {
    hyprlandXdgDesktopPortalSupport = true;
    pulseaudioSupport = true;
  };
  zoomLaunch = pkgs.writeShellScript "zoom-wayland-launch" ''
    zoomConfig="$HOME/.config/zoomus.conf"
    ${pkgs.coreutils}/bin/mkdir -p "$HOME/.config"
    ${pkgs.coreutils}/bin/touch "$zoomConfig"

    if ${pkgs.gnugrep}/bin/grep -q '^xwayland=' "$zoomConfig"; then
      ${pkgs.gnused}/bin/sed -i 's/^xwayland=.*/xwayland=false/' "$zoomConfig"
    else
      printf '%s\n' 'xwayland=false' >> "$zoomConfig"
    fi

    export QT_QPA_PLATFORM=wayland
    export XDG_CURRENT_DESKTOP=Hyprland
    exec ${zoomUs}/bin/zoom "$@"
  '';
  zoomWayland = pkgs.symlinkJoin {
    name = "zoom-us-wayland";
    paths = [ zoomUs ];
    postBuild = ''
      rm "$out/bin/zoom"
      ln -s ${zoomLaunch} "$out/bin/zoom"
    '';
  };
in
{
  imports = [
    # Hardware of current machine
    ./hardware-configuration.nix
  ];

  # Overlays
  nixpkgs.overlays = [
    # Emacs overlay
    (import inputs.emacs-overlay)
    # Use a stable wireplumber
    (final: _: {
      wireplumber = final.nixpkgs-stable.wireplumber;
    })
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
    optimise.automatic = true;
    settings = {
      accept-flake-config = true;
      auto-optimise-store = true;
      extra-substituters = [
        "https://nix-community.cachix.org"
        "https://cache.numtide.com"
      ];
      extra-trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "niks3.numtide.com-1:DTx8wZduET09hRmMtKdQDxNNthLQETkc/yaX7M4qK0g="
      ];
      trusted-users = [
        "root"
        "loren"
      ];
      experimental-features = [
        "nix-command"
        "flakes"
      ];
    };
  };

  # Set the linux kernel
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # Load AMD CPU microcode and firmware
  hardware.cpu.amd.updateMicrocode = true;
  hardware.firmware = [ pkgs.linux-firmware ];

  # Kernel parameters and modules
  boot.initrd.kernelModules = [
    "amdgpu"
    "hid-apple"
  ];
  boot.kernelParams = [
    "quiet"
    "loglevel=3"
    "systemd.show_status=false"
    "rd.systemd.show_status=false"
    "rd.udev.log_level=3"
    "udev.log_level=3"
    "vt.global_cursor_default=0"
    "fbcon=nodefer"
    "hid_apple.fnmode=0"
    "psmouse.synaptics_intertouch=0"
  ];
  boot.consoleLogLevel = 0;
  boot.initrd.verbose = false;
  boot.plymouth.enable = true;
  boot.plymouth.extraConfig = "DeviceTimeout=5\n";
  systemd.settings.Manager.ShowStatus = false;
  boot.kernel.sysctl = {
    "kernel.printk" = "3 3 3 3";
  };

  # GRUB provides access to earlier generations if an upgrade fails to boot.
  boot.loader = {
    timeout = 5;
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

  # Enable fish shell
  programs.fish.enable = true;

  # Network configuration
  networking = {
    networkmanager = {
      enable = true;
      wifi.powersave = lib.mkDefault false;
      plugins = with pkgs; [
        networkmanager-openvpn
      ];
    };
    firewall = {
      checkReversePath = "loose";
      interfaces.wlp2s0 = {
        allowedTCPPorts = [ 53317 ];
        allowedUDPPorts = [ 53317 ];
      };
    };
  };
  programs.nm-applet.enable = true;
  systemd.services.NetworkManager-wait-online.enable = false;

  # Select internationalization properties.
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };

  # Hyprland is the only graphical session. UWSM owns its systemd lifecycle.
  programs.hyprland = {
    enable = true;
    withUWSM = true;
  };
  programs.dconf.enable = true;

  programs.chromium = {
    enable = true;
    extraOpts = {
      BrowserThemeColor = theme.background;
      BrowserColorScheme = "device";
    };
    initialPrefs.browser.theme = {
      color_scheme = 0;
      color_scheme2 = 0;
    };
  };

  # Fingerprint authentication is exposed through PAM to greetd
  services.fprintd.enable = true;
  security.pam.services.greetd.fprintAuth = true;
  security.pam.services.hyprlock.fprintAuth = true;

  services.greetd = {
    enable = true;
    settings = {
      initial_session = {
        command = "${hyprlandSession}";
        user = "loren";
      };
      default_session = {
        command = "${lib.getExe' pkgs.greetd "agreety"} --cmd ${lib.escapeShellArg "${hyprlandSession}"}";
        user = "greeter";
      };
    };
  };
  systemd.services.greetd.serviceConfig.Type = lib.mkForce "simple";
  systemd.services.plymouth-quit = {
    restartIfChanged = false;
    serviceConfig.ExecStart = [
      ""
      "-${pkgs.plymouth}/bin/plymouth quit --retain-splash"
    ];
  };
  security.pam.services.greetd.enableGnomeKeyring = true;
  security.pam.services.hyprlock.enableGnomeKeyring = true;

  # Update UEFI and supported peripheral firmware through LVFS.
  services.fwupd.enable = true;

  # Printing support with CUPS
  services.printing = {
    enable = true;
    drivers = [
      pkgs.nixpkgs-stable.hplip
      pkgs.nixpkgs-stable.hplipWithPlugin
    ];
  };
  services.avahi.enable = true;
  services.avahi.nssmdns4 = true;
  programs.system-config-printer.enable = true;

  # Scanners
  hardware.sane = {
    enable = true;
    extraBackends = [
      pkgs.sane-airscan
    ];
  };

  # Bluetooth support
  hardware.bluetooth = {
    enable = true;
  };
  services.blueman.enable = true;

  # User account and configuration
  users.users.loren = {
    isNormalUser = true;
    home = "/home/loren";
    createHome = true;
    extraGroups = [
      "wheel"
      "audio"
      "input"
      "docker"
      "networkmanager"
      "systemd-journal"
      "video"
      "scanner"
      "lp"
    ];
  };

  # Global packages, minimal to avoid polluting environment
  environment.systemPackages = with pkgs; [
    # General utilities
    acpi
    binutils
    cacert
    coreutils
    curl
    dmidecode
    file
    git
    inxi
    iw
    killall
    libtool
    pavucontrol
    pciutils
    rsync
    sshfs
    unrar
    unzip
    usbutils
    wget
    which
    wgnord
    wireguard-tools
    zoomWayland
    # Terminal and CLI utilities
    zsh
    inputs.nix-inspect.packages.${pkgs.stdenv.hostPlatform.system}.default
    inputs.papis.packages.${pkgs.stdenv.hostPlatform.system}.default
    # Text editors and office
    emacs-git-pgtk
    vim-full
    # Programming languages (here to avoid environment clashes)
    gfortran
    mono
    (
      let
        my-python-packages =
          python-packages: with python-packages; [
            # Language server protocol
            ruff
            # Scientific libraries
            ipython
            ipykernel
            jupyter
            matplotlib
            mpmath
            numpy
            pandas
            scikit-learn
            scipy
            sympy
            # Qt backend
            pyqt6
            # Linters
            autopep8
            flake8
            jedi
            mypy
            pydocstyle
            pylint
            # Web
            tornado
            # Hy utilities
            hy
            # Dependencies
            pickleshare
          ];
        python-with-my-packages = python3.withPackages my-python-packages;
      in
      python-with-my-packages
    )
    (hy.withPackages (
      py-packages: with py-packages; [
        # Scientific libraries
        numpy
        matplotlib
        pandas
        scipy
        sympy
        # Qt backend
        pyqt6
      ]
    ))
    uv
  ];

  # Wayland electron apps
  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    COLORTERM = "truecolor";
  };

  # Emacs configuration
  services.emacs = {
    enable = true;
    package = pkgs.emacs-git-pgtk;
    defaultEditor = true;
  };

  # Make your life easier
  programs.nix-ld = {
    enable = true;
    libraries = with pkgs; [
      zlib
      stdenv.cc.cc.lib
    ];
  };

  # Enable Java
  programs.java.enable = true;

  # Fonts
  fonts.packages = with pkgs; [
    dina-font
    fira-code
    fira-code-symbols
    font-awesome
    inter
    iosevka
    liberation_ttf
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-color-emoji
    proggyfonts
    source-code-pro
    uiua386
    nerd-fonts.fira-code
    nerd-fonts.jetbrains-mono
    nerd-fonts.symbols-only
    emacs-all-the-icons-fonts
  ];
  fonts.fontconfig.defaultFonts = {
    monospace = [ "JetBrainsMono Nerd Font" ];
    sansSerif = [
      "Inter"
      "Noto Sans"
    ];
    serif = [
      "Noto Serif"
      "Liberation Serif"
    ];
    emoji = [ "Noto Color Emoji" ];
  };

  # Gnupg configuration
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  # Virtualization setup, only docker at the moment
  virtualisation = {
    docker = {
      enable = true;
      extraOptions = "--default-ulimit nofile=65536:65536";
    };
  };

  # Audio service
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Additional services
  services.gnome.gnome-keyring.enable = true;
  services.gvfs.enable = true;
  services.udisks2.enable = true;
  services.openssh.enable = true;
  services.upower.enable = true;
  services.dbus.enable = true;
  systemd.user.services.nm-applet = {
    after = [ "graphical-session.target" ];
    wantedBy = lib.mkForce [ "graphical-session.target" ];
  };
  systemd.user.services.dropbox = {
    description = "Dropbox";
    after = [ "graphical-session.target" ];
    partOf = [ "graphical-session.target" ];
    wantedBy = [ "graphical-session.target" ];
    serviceConfig = {
      ExecStart = "${pkgs.dropbox}/bin/dropbox";
      Restart = "on-failure";
      ProtectSystem = "full";
      Nice = 10;
    };
  };
  systemd.user.services.udiskie = {
    description = "Removable-media tray service";
    after = [ "graphical-session.target" ];
    partOf = [ "graphical-session.target" ];
    wantedBy = [ "graphical-session.target" ];
    serviceConfig = {
      ExecStart = "${pkgs.udiskie}/bin/udiskie --tray";
      Restart = "on-failure";
    };
  };

  # WireGuard & wgnord (NordVPN) directory & template provisioning
  systemd.tmpfiles.rules = [
    "d /etc/wireguard 0700 root root -"
    "d /var/lib/wgnord 0700 root root -"
    "C /var/lib/wgnord/template.conf 0600 root root - ${pkgs.writeText "wgnord-template.conf" ''
      [Interface]
      PrivateKey = PRIVKEY
      Address = 10.5.0.2/32
      MTU = 1350
      DNS = 103.86.96.100 103.86.99.100

      [Peer]
      PublicKey = SERVER_PUBKEY
      AllowedIPs = 0.0.0.0/0, ::/0
      Endpoint = SERVER_IP:51820
      PersistentKeepalive = 25
    ''}"
  ];

  # Passwordless sudo for wgnord
  security.sudo.extraRules = [
    {
      users = [ "loren" ];
      commands = [
        {
          command = "${pkgs.wgnord}/bin/wgnord";
          options = [ "NOPASSWD" ];
        }
      ];
    }
  ];

  # State version
  system.stateVersion = "24.05";
}
