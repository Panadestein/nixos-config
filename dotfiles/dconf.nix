# Generated via dconf2nix: https://github.com/gvolpe/dconf2nix
{ lib, ... }:

with lib.hm.gvariant;

{
  dconf.settings = {
    "apps/guake/general" = {
      abbreviate-tab-names = false;
      compat-delete = "delete-sequence";
      display-n = 0;
      history-size = 10000;
      max-tab-name-length = 100;
      mouse-display = true;
      open-tab-cwd = true;
      prompt-on-quit = false;
      quick-open-command-line = "gedit %(file_path)s";
      restore-tabs-notify = true;
      restore-tabs-startup = true;
      save-tabs-when-changed = true;
      scroll-keystroke = true;
      use-default-font = false;
      use-popup = true;
      use-scrollbar = false;
      use-trayicon = true;
      window-halignment = 0;
      window-height = 100;
      window-losefocus = false;
      window-refocus = false;
      window-tabbar = false;
      window-width = 100;
    };

    "apps/guake/style/background" = {
      transparency = 96;
    };

    "apps/guake/style/font" = {
      allow-bold = true;
      palette = "#343438383535:#CECE3E3E6060:#7B7BB7B75B5B:#E8E8B3B32A2A:#4C4C9999D3D3:#A5A57F7FC4C4:#38389A9AACAC:#F9F9FAFAF6F6:#58585A5A5858:#D1D18E8EA6A6:#76767E7E2B2B:#777759592E2E:#131358587979:#5F5F41419090:#7676BBBBCACA:#B1B1B5B5AEAE:#F7F7F6F6ECEC:#1D1D1D1D1D1D";
      palette-name = "Japanesque";
      style = "Fira Code 24";
    };

    "ca/desrt/dconf-editor" = {
      saved-pathbar-path = "/org/gnome/nautilus/window-state/";
      saved-view = "/org/gnome/";
      window-height = 990;
      window-is-maximized = false;
      window-width = 941;
    };

    "org/blueman/general" = {
      window-properties = [ 1918 1055 1 24 ];
    };

    "org/blueman/plugins/powermanager" = {
      auto-power-on = "@mb true";
    };

    "org/blueman/plugins/recentconns" = {
      recent-connections = "[{'adapter': 'C8:94:02:7D:D3:A2', 'address': '0C:AE:7D:B1:5C:18', 'alias': 'Bose SoundTouch AAA277', 'icon': 'audio-card', 'name': 'Audio and input profiles', 'uuid': '00000000-0000-0000-0000-000000000000', 'time': '1649935474.0410156'}]";
    };

    "org/gnome/Console" = {
      font-scale = 2.200000000000001;
      theme = "auto";
    };

    "org/gnome/Geary" = {
      migrated-config = true;
    };

    "org/gnome/calendar" = {
      active-view = "month";
      window-maximized = true;
      window-position = mkTuple [ 681 281 ];
      window-size = mkTuple [ 1124 785 ];
    };

    "org/gnome/control-center" = {
      last-panel = "wifi";
      window-state = mkTuple [ 1149 806 ];
    };

    "org/gnome/desktop/app-folders" = {
      folder-children = [ "Utilities" "YaST" ];
    };

    "org/gnome/desktop/background" = {
      color-shading-type = "solid";
      picture-options = "zoom";
      picture-uri = "file:///home/loren/.local/share/backgrounds/2022-04-15-00-12-26-tc-feynman.png";
      picture-uri-dark = "file:///home/loren/.local/share/backgrounds/2022-04-15-00-12-26-tc-feynman.png";
      primary-color = "#000000000000";
      secondary-color = "#000000000000";
    };

    "org/gnome/desktop/calendar" = {
      show-weekdate = false;
    };

    "org/gnome/desktop/input-sources" = {
      sources = [ (mkTuple [ "xkb" "us" ]) ];
      xkb-options = [ "terminate:ctrl_alt_bksp" ];
    };

    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
      cursor-size = 25;
      cursor-theme = "Adwaita";
      font-antialiasing = "grayscale";
      font-hinting = "slight";
      gtk-theme = "Arc-Dark";
      icon-theme = "elementary";
    };

    "org/gnome/desktop/notifications" = {
      application-children = [ "guake" "emacsclient" ];
    };

    "org/gnome/desktop/notifications/application/emacsclient" = {
      application-id = "emacsclient.desktop";
    };

    "org/gnome/desktop/notifications/application/guake" = {
      application-id = "guake.desktop";
    };

    "org/gnome/desktop/screensaver" = {
      color-shading-type = "solid";
      picture-options = "zoom";
      picture-uri = "file:///home/loren/.local/share/backgrounds/2022-04-15-00-12-26-tc-feynman.png";
      primary-color = "#000000000000";
      secondary-color = "#000000000000";
    };

    "org/gnome/desktop/wm/keybindings" = {
      close = [ "<Super>q" ];
      move-to-workspace-1 = [ "<Shift><Super>exclam" ];
      move-to-workspace-2 = [ "<Shift><Super>at" ];
      switch-to-workspace-1 = [ "<Super>1" ];
      switch-to-workspace-2 = [ "<Super>2" ];
      switch-to-workspace-3 = [];
      switch-to-workspace-4 = [];
    };

    "org/gnome/eog/ui" = {
      sidebar = false;
    };

    "org/gnome/eog/view" = {
      background-color = "rgb(0,0,0)";
      use-background-color = true;
    };

    "org/gnome/epiphany" = {
      ask-for-default = false;
    };

    "org/gnome/epiphany/state" = {
      is-maximized = true;
      window-position = mkTuple [ (-1) (-1) ];
      window-size = mkTuple [ 1024 768 ];
    };

    "org/gnome/evince" = {
      document-directory = "@ms 'file:///home/loren/Pictures'";
    };

    "org/gnome/evince/default" = {
      window-ratio = mkTuple [ 5.877483 2.162137 ];
    };

    "org/gnome/evolution-data-server" = {
      migrated = true;
      network-monitor-gio-name = "";
    };

    "org/gnome/mutter" = {
      attach-modal-dialogs = true;
      dynamic-workspaces = true;
      edge-tiling = true;
      focus-change-on-pointer-rest = true;
      workspaces-only-on-primary = true;
    };

    "org/gnome/nautilus/preferences" = {
      default-folder-viewer = "icon-view";
      search-filter-time-type = "last_modified";
      search-view = "list-view";
    };

    "org/gnome/nautilus/window-state" = {
      initial-size = mkTuple [ 997 677 ];
      maximized = false;
    };

    "org/gnome/settings-daemon/plugins/media-keys" = {
      custom-keybindings = [ "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/" "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/" "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2/" "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom3/" "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom4/" "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom5/" ];
      www = [ "<Super>w" ];
    };

    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
      binding = "<Super>Return";
      command = "alacritty";
      name = "Terminal";
    };

    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1" = {
      binding = "<Shift><Super>Return";
      command = "alacritty -e ipython";
      name = "Ipython";
    };

    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2" = {
      binding = "<Super>f";
      command = "alacritty -e ranger";
      name = "Ranger";
    };

    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom3" = {
      binding = "<Shift><Super>x";
      command = "shutdown now";
      name = "Shutdown";
    };

    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom4" = {
      binding = "<Shift><Super>BackSpace";
      command = "reboot";
      name = "Reboot";
    };

    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom5" = {
      binding = "<Shift><Super>f";
      command = "nautilus";
      name = "Naut";
    };

    "org/gnome/shell" = {
      favorite-apps = [ "firefox.desktop" "emacsclient.desktop" "com.github.xournalpp.xournalpp.desktop" "org.gnome.Nautilus.desktop" "zotero-6.0.desktop" "slack.desktop" "Mattermost.desktop" "telegramdesktop.desktop" ];
      welcome-dialog-last-shown-version = "42.0";
    };

    "org/gnome/shell/keybindings" = {
      switch-to-application-1 = [];
      switch-to-application-2 = [];
      switch-to-application-3 = [];
      switch-to-application-4 = [];
    };

    "org/gnome/shell/world-clocks" = {
      locations = "@av []";
    };

    "org/gnome/software" = {
      first-run = false;
    };

    "org/gnome/tweaks" = {
      show-extensions-notice = false;
    };

    "org/gtk/gtk4/settings/file-chooser" = {
      date-format = "regular";
      location-mode = "path-bar";
      show-hidden = false;
      show-size-column = true;
      show-type-column = true;
      sidebar-width = 169;
      sort-column = "name";
      sort-directories-first = false;
      sort-order = "ascending";
      type-format = "category";
      window-size = mkTuple [ 1010 449 ];
    };

    "org/gtk/settings/color-chooser" = {
      selected-color = mkTuple [ true 1.0 ];
    };

    "org/gtk/settings/file-chooser" = {
      date-format = "regular";
      location-mode = "path-bar";
      show-hidden = false;
      show-size-column = true;
      show-type-column = true;
      sidebar-width = 180;
      sort-column = "name";
      sort-directories-first = false;
      sort-order = "ascending";
      type-format = "category";
      window-position = mkTuple [ 479 199 ];
      window-size = mkTuple [ 962 658 ];
    };

  };
}
