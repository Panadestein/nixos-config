# Hyprland desktop environment suite (Hyprland, Hyprlock, Hypridle, Hyprpaper, Hyprpolkitagent)
{
  pkgs,
  ...
}:
let
  theme = import ../../theme.nix;
  wallpaperSource = ../../wallpapers/oehme;
  defaultWallpaper = "${wallpaperSource}/01-burg-scharfenberg-bei-nacht.jpg";
  stripHash = color: builtins.substring 1 6 color;
in
{
  # Hyprland native Lua configuration and session utilities
  wayland.windowManager.hyprland = {
    enable = true;
    package = null;
    portalPackage = null;
    configType = "lua";
    systemd.enable = false;
    extraLuaFiles."config" = pkgs.replaceVars ./config.lua {
      blue = stripHash theme.blue;
      magenta = stripHash theme.magenta;
      muted = stripHash theme.muted;
      darkerBackground = stripHash theme.darkerBackground;
    };
  };

  # Hyprlock screen locker
  programs.hyprlock = {
    enable = true;
    settings = {
      general = {
        hide_cursor = true;
        ignore_empty_input = true;
      };
      animations = {
        enabled = true;
        bezier = "easeOut, 0.16, 1, 0.3, 1";
        animation = [
          "fadeIn, 1, 4, easeOut"
          "fadeOut, 1, 4, easeOut"
          "inputFieldDots, 1, 2, easeOut"
        ];
      };
      background = [
        {
          path = defaultWallpaper;
          blur_passes = 3;
          blur_size = 8;
        }
      ];
      input-field = [
        {
          monitor = "";
          size = "280, 54";
          position = "0, -80";
          dots_center = true;
          fade_on_empty = false;
          font_color = "rgb(${stripHash theme.brightForeground})";
          inner_color = "rgb(${stripHash theme.background})";
          outer_color = "rgb(${stripHash theme.accent})";
          check_color = "rgb(${stripHash theme.green})";
          fail_color = "rgb(${stripHash theme.red})";
          outline_thickness = 3;
          rounding = 14;
          dots_spacing = 0.25;
          font_family = "JetBrainsMono Nerd Font";
          placeholder_text = "Password";
          check_text = "Authenticating…";
          fail_text = "$PAMFAIL";
        }
      ];
      label = [
        {
          monitor = "";
          text = "$TIME";
          color = "rgb(${stripHash theme.brightForeground})";
          font_size = 68;
          font_family = "JetBrainsMono Nerd Font";
          position = "0, 110";
          halign = "center";
          valign = "center";
        }
        {
          monitor = "";
          text = ''cmd[update:60000] date +"%A, %d %B"'';
          color = "rgb(${stripHash theme.lightForeground})";
          font_size = 18;
          font_family = "JetBrainsMono Nerd Font";
          position = "0, 52";
          halign = "center";
          valign = "center";
        }
        {
          monitor = "";
          text = "loren";
          color = "rgb(${stripHash theme.accent})";
          font_size = 16;
          font_family = "JetBrainsMono Nerd Font";
          position = "0, -28";
          halign = "center";
          valign = "center";
        }
      ];
    };
  };

  # Hyprland idle daemon: turns screen black when locked and handles sleep/suspend
  services.hypridle = {
    enable = true;
    systemdTarget = "wayland-session@hyprland.desktop.target";
    settings = {
      general = {
        lock_cmd = "pidof hyprlock || hyprlock";
        before_sleep_cmd = "loginctl lock-session";
        after_sleep_cmd = ''hyprctl dispatch 'hl.dsp.dpms({ action = "enable" })' '';
        # Wait for the compositor to confirm the lock before releasing sleep.
        inhibit_sleep = 3;
        ignore_dbus_inhibit = false;
      };
      listener = [
        # Turn off a manually locked display after 60 seconds of inactivity.
        {
          timeout = 60;
          on-timeout = ''pidof hyprlock && hyprctl dispatch 'hl.dsp.dpms({ action = "disable" })' '';
          on-resume = ''hyprctl dispatch 'hl.dsp.dpms({ action = "enable" })' '';
        }
        # Lock screen after 10 minutes of general inactivity
        {
          timeout = 600;
          on-timeout = "loginctl lock-session";
        }
        # Turn the display off one minute after automatic locking.
        {
          timeout = 660;
          on-timeout = ''hyprctl dispatch 'hl.dsp.dpms({ action = "disable" })' '';
          on-resume = ''hyprctl dispatch 'hl.dsp.dpms({ action = "enable" })' '';
        }
        # Suspend system after 30 minutes of inactivity
        {
          timeout = 1800;
          on-timeout = "systemctl suspend";
        }
      ];
    };
  };

  # Hyprpaper wallpaper daemon
  services.hyprpaper = {
    enable = true;
    systemdTarget = "wayland-session@hyprland.desktop.target";
    settings = {
      splash = false;
      wallpaper = [
        {
          monitor = "";
          path = defaultWallpaper;
          fit_mode = "cover";
        }
      ];
    };
  };

  # Polkit authentication agent for Hyprland
  services.hyprpolkitagent.enable = true;

  # Restore wallpaper into hyprpaper when graphical session starts
  systemd.user.services.waypaper-restore = {
    Unit = {
      Description = "Restore the wallpaper selected in Waypaper";
      After = [ "hyprpaper.service" ];
      Requires = [ "hyprpaper.service" ];
      PartOf = [ "graphical-session.target" ];
    };
    Service = {
      Type = "oneshot";
      ExecCondition = "${pkgs.coreutils}/bin/test -f %h/.config/waypaper/config.ini";
      ExecStart = "${pkgs.waypaper}/bin/waypaper --restore --backend hyprpaper";
    };
    Install.WantedBy = [ "graphical-session.target" ];
  };

  # Hyprland session packages
  home.packages = [
    pkgs.hyprshot
  ];
}
