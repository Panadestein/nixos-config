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
      palette = "#1F1F1F1F1F1F:#F7F711111818:#2C2CC5C55D5D:#ECECB9B90F0F:#2A2A8484D2D2:#4E4E5959B7B7:#0F0F8080D5D5:#D6D6DADAE4E4:#D6D6DADAE4E4:#DEDE34342E2E:#1D1DD2D26060:#F2F2BDBD0909:#0F0F8080D5D5:#52524F4FB9B9:#0F0F7C7CDADA:#FFFFFFFFFFFF:#D6D6DADAE4E4:#131313131313";
      palette-name = "Brogrammer";
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
      last-panel = "keyboard";
      window-state = mkTuple [ 1346 1006 ];
    };

    "org/gnome/desktop/app-folders" = {
      folder-children = [ "Utilities" "YaST" ];
    };

    "org/gnome/desktop/calendar" = {
      show-weekdate = false;
    };

    "org/gnome/desktop/input-sources" = {
      sources = [ (mkTuple [ "xkb" "us" ]) ];
      xkb-options = [ "terminate:ctrl_alt_bksp" ];
    };

    "org/gnome/desktop/interface" = {
      cursor-size = 25;
      cursor-theme = "Adwaita";
      font-antialiasing = "grayscale";
      font-hinting = "slight";
      gtk-theme = "Arc-Dark";
      icon-theme = "elementary";
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
      window-ratio = mkTuple [ 5.877483443708609 2.1621373352788753 ];
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
      initial-size = mkTuple [ 1261 1080 ];
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
      favorite-apps = [ "firefox.desktop" "com.github.xournalpp.xournalpp.desktop" "telegramdesktop.desktop" "Mattermost.desktop" "slack.desktop" ];
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
