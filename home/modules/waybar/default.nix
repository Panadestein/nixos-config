_:
let
  theme = import ../../theme.nix;
in
{
  programs.waybar = {
    enable = true;
    systemd = {
      enable = true;
      targets = [ "wayland-session@hyprland.desktop.target" ];
    };

    settings.mainBar = {
      layer = "top";
      position = "top";
      height = 34;
      spacing = 0;

      modules-left = [
        "hyprland/workspaces"
      ];
      modules-center = [ "clock" ];
      modules-right = [
        "hyprland/language"
        "pulseaudio"
        "cpu"
        "battery"
        "tray"
      ];

      "hyprland/workspaces" = {
        format = "{id}";
        sort-by-number = true;
        tooltip = false;
        on-scroll-up = "hyprctl dispatch 'hl.dsp.focus({ workspace = \"e+1\" })'";
        on-scroll-down = "hyprctl dispatch 'hl.dsp.focus({ workspace = \"e-1\" })'";
      };
      "hyprland/language" = {
        format = "{}";
        format-en = "US";
        format-bqn = "BQN";
        tooltip = false;
        on-click = "hyprctl switchxkblayout all next";
      };
      pulseaudio = {
        format = "Vol {volume}%";
        format-muted = "Muted";
        tooltip = false;
        on-click = "pavucontrol";
        on-click-right = "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
        on-scroll-up = "wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+";
        on-scroll-down = "wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-";
      };
      cpu = {
        format = "CPU {usage}%";
        tooltip = false;
        on-click = "ghostty -e btop";
      };
      battery = {
        format = "Bat {capacity}%";
        format-charging = "Bat +{capacity}%";
        tooltip = false;
        states = {
          warning = 20;
          critical = 10;
        };
      };
      clock = {
        format = "{:%a %d %b  %H:%M}";
        tooltip = false;
      };
      tray = {
        spacing = 8;
        tooltip = false;
      };
    };

    style = ''
      * {
        border: none;
        border-radius: 0;
        font-family: "JetBrainsMono Nerd Font";
        font-size: 16px;
        min-height: 0;
      }

      window#waybar {
        background: ${theme.background};
        border-bottom: 2px solid ${theme.accent};
        color: ${theme.foreground};
      }

      #workspaces {
        margin: 3px 6px;
      }

      #workspaces button {
        border-radius: 5px;
        color: ${theme.muted};
        margin-right: 2px;
        padding: 0 8px;
      }

      #workspaces button:not(.empty):not(.active) {
        background: ${theme.lighterBackground};
        box-shadow: inset 0 -2px ${theme.accent};
        color: ${theme.brightBlue};
      }

      #workspaces button.active {
        background: ${theme.selection};
        color: ${theme.brightForeground};
      }

      #workspaces button.visible {
        color: ${theme.brightBlue};
      }

      #workspaces button.urgent {
        background: ${theme.red};
        color: ${theme.brightForeground};
      }

      #workspaces button:hover {
        background: transparent;
        box-shadow: none;
        text-shadow: none;
      }

      #workspaces button.active:hover {
        background: ${theme.selection};
        color: ${theme.brightForeground};
      }

      #clock {
        color: ${theme.lightForeground};
        font-weight: bold;
        padding: 0 12px;
      }

      .modules-right {
        background: ${theme.lighterBackground};
        border: 1px solid ${theme.selection};
        border-radius: 10px;
        margin: 4px 8px 4px 0;
        padding: 0 3px;
      }

      #language,
      #pulseaudio,
      #cpu,
      #battery,
      #tray {
        border-radius: 7px;
        padding: 0 8px;
      }

      #language { color: ${theme.magenta}; }
      #pulseaudio { color: ${theme.green}; }
      #cpu { color: ${theme.orange}; }
      #battery { color: ${theme.yellow}; }

      #pulseaudio.muted,
      #battery.warning {
        color: ${theme.orange};
      }

      #battery.critical {
        background: ${theme.red};
        color: ${theme.brightForeground};
      }
    '';
  };
}
