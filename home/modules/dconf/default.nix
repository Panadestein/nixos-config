# Generated via dconf2nix: https://github.com/gvolpe/dconf2nix
{ lib, ... }:

with lib.hm.gvariant;

{
  dconf.settings = {
    "apps/guake/general" = {
      abbreviate-tab-names = false;
      compat-delete = "delete-sequence";
      display-n = 0;
      display-tab-names = 0;
      gtk-theme-name = "Adwaita";
      gtk-use-system-default-theme = true;
      hide-tabs-if-one-tab = false;
      history-size = 10000;
      load-guake-yml = true;
      max-tab-name-length = 100;
      mouse-display = true;
      open-tab-cwd = true;
      prompt-on-quit = false;
      quick-open-command-line = "emacsclient -c %(file_path)s";
      quick-open-enable = true;
      restore-tabs-notify = true;
      restore-tabs-startup = true;
      save-tabs-when-changed = true;
      schema-version = "3.9.0";
      scroll-keystroke = true;
      start-at-login = true;
      start-fullscreen = true;
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
      transparency = 87;
    };

    "apps/guake/style/font" = {
      allow-bold = true;
      palette = "#222222222222:#FFFF00000F0F:#8C8CE0E00A0A:#FFFFB9B90000:#00008D8DF8F8:#6C6C4343A5A5:#0000D7D7EBEB:#FFFFFFFFFFFF:#444444444444:#FFFF27273F3F:#ABABE0E05A5A:#FFFFD1D14141:#00009292FFFF:#9A9A5F5FEBEB:#6767FFFFEFEF:#FFFFFFFFFFFF:#FFFFFAFAF3F3:#0D0D0F0F1818";
      palette-name = "Argonaut";
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
      font-scale = 2.2;
      theme = "auto";
    };

    "org/gnome/Geary" = {
      migrated-config = true;
    };

    "org/gnome/Totem" = {
      active-plugins = [ "skipto" "screensaver" "variable-rate" "vimeo" "apple-trailers" "rotation" "open-directory" "mpris" "save-file" "recent" "autoload-subtitles" "movie-properties" "screenshot" ];
      subtitle-encoding = "UTF-8";
    };

    "org/gnome/calculator" = {
      accuracy = 9;
      angle-units = "degrees";
      base = 10;
      button-mode = "basic";
      number-format = "automatic";
      show-thousands = false;
      show-zeroes = false;
      source-currency = "";
      source-units = "degree";
      target-currency = "";
      target-units = "radian";
      word-size = 64;
    };

    "org/gnome/calendar" = {
      active-view = "month";
      window-maximized = true;
      window-position = mkTuple [ 681 281 ];
      window-size = mkTuple [ 1124 785 ];
    };

    "org/gnome/control-center" = {
      last-panel = "info-overview";
      window-state = mkTuple [ 980 640 ];
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
      sources = [ (mkTuple [ "xkb" "us" ]) (mkTuple [ "xkb" "de" ]) ];
      xkb-options = [ "terminate:ctrl_alt_bksp" "lv3:ralt_switch" "compose:ralt" ];
    };

    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
      cursor-size = 25;
      cursor-theme = "Adwaita";
      font-antialiasing = "grayscale";
      font-hinting = "slight";
      gtk-theme = "Arc-Dark";
      icon-theme = "Adwaita";
    };

    "org/gnome/desktop/notifications" = {
      application-children = [ "guake" "emacsclient" "firefox" "gnome-power-panel" "mattermost" "org-gnome-nautilus" "org-gnome-evince" "telegramdesktop" "zoom" "org-telegram-desktop" ];
    };

    "org/gnome/desktop/notifications/application/alacritty" = {
      application-id = "Alacritty.desktop";
    };

    "org/gnome/desktop/notifications/application/avogadro2" = {
      application-id = "avogadro2.desktop";
    };

    "org/gnome/desktop/notifications/application/brave-browser" = {
      application-id = "brave-browser.desktop";
    };

    "org/gnome/desktop/notifications/application/code" = {
      application-id = "code.desktop";
    };

    "org/gnome/desktop/notifications/application/emacsclient" = {
      application-id = "emacsclient.desktop";
    };

    "org/gnome/desktop/notifications/application/firefox" = {
      application-id = "firefox.desktop";
    };

    "org/gnome/desktop/notifications/application/gimp" = {
      application-id = "gimp.desktop";
    };

    "org/gnome/desktop/notifications/application/gnome-power-panel" = {
      application-id = "gnome-power-panel.desktop";
    };

    "org/gnome/desktop/notifications/application/guake" = {
      application-id = "guake.desktop";
    };

    "org/gnome/desktop/notifications/application/mattermost" = {
      application-id = "Mattermost.desktop";
    };

    "org/gnome/desktop/notifications/application/neovide" = {
      application-id = "neovide.desktop";
    };

    "org/gnome/desktop/notifications/application/org-gnome-eog" = {
      application-id = "org.gnome.eog.desktop";
    };

    "org/gnome/desktop/notifications/application/org-gnome-evince" = {
      application-id = "org.gnome.Evince.desktop";
    };

    "org/gnome/desktop/notifications/application/org-gnome-nautilus" = {
      application-id = "org.gnome.Nautilus.desktop";
    };

    "org/gnome/desktop/notifications/application/org-gnome-settings" = {
      application-id = "org.gnome.Settings.desktop";
    };

    "org/gnome/desktop/notifications/application/org-gnome-totem" = {
      application-id = "org.gnome.Totem.desktop";
    };

    "org/gnome/desktop/notifications/application/org-inkscape-inkscape" = {
      application-id = "org.inkscape.Inkscape.desktop";
    };

    "org/gnome/desktop/notifications/application/org-telegram-desktop" = {
      application-id = "org.telegram.desktop.desktop";
    };

    "org/gnome/desktop/notifications/application/slack" = {
      application-id = "slack.desktop";
    };

    "org/gnome/desktop/notifications/application/telegramdesktop" = {
      application-id = "telegramdesktop.desktop";
    };

    "org/gnome/desktop/notifications/application/yelp" = {
      application-id = "yelp.desktop";
    };

    "org/gnome/desktop/notifications/application/zoom" = {
      application-id = "Zoom.desktop";
    };

    "org/gnome/desktop/notifications/application/zotero-6-0-18" = {
      application-id = "zotero-6.0.18.desktop";
    };

    "org/gnome/desktop/peripherals/mouse" = {
      left-handed = false;
    };

    "org/gnome/desktop/peripherals/touchpad" = {
      edge-scrolling-enabled = false;
      natural-scroll = true;
      send-events = "enabled";
      tap-to-click = true;
      two-finger-scrolling-enabled = true;
    };

    "org/gnome/desktop/privacy" = {
      old-files-age = mkUint32 30;
      recent-files-max-age = -1;
    };

    "org/gnome/desktop/screensaver" = {
      color-shading-type = "solid";
      picture-options = "zoom";
      picture-uri = "file:///home/loren/.local/share/backgrounds/2022-04-15-00-12-26-tc-feynman.png";
      primary-color = "#000000000000";
      secondary-color = "#000000000000";
    };

    "org/gnome/desktop/session" = {
      idle-delay = mkUint32 300;
    };

    "org/gnome/desktop/sound" = {
      event-sounds = true;
      theme-name = "__custom";
    };

    "org/gnome/desktop/wm/keybindings" = {
      close = [ "<Super>q" ];
      move-to-workspace-1 = [ "<Shift><Super>1" ];
      move-to-workspace-2 = [ "<Shift><Super>2" ];
      move-to-workspace-3 = [ "<Shift><Super>3" ];
      move-to-workspace-4 = [ "<Shift><Super>4" ];
      panel-run-dialog = [ "<Super>r" ];
      switch-to-workspace-1 = [ "<Super>1" ];
      switch-to-workspace-2 = [ "<Super>2" ];
      switch-to-workspace-3 = [ "<Super>3" ];
      switch-to-workspace-4 = [ "<Super>4" ];
    };

    "org/gnome/desktop/wm/preferences" = {
      num-workspaces = 3;
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
      window-ratio = mkTuple [ 4.446429 2.085586 ];
    };

    "org/gnome/evolution-data-server" = {
      migrated = true;
      network-monitor-gio-name = "";
    };

    "org/gnome/file-roller/listing" = {
      list-mode = "as-folder";
      name-column-width = 250;
      show-path = false;
      sort-method = "name";
      sort-type = "ascending";
    };

    "org/gnome/file-roller/ui" = {
      sidebar-width = 200;
      window-height = 480;
      window-width = 600;
    };

    "org/gnome/gnome-screenshot" = {
      delay = 0;
      include-pointer = false;
      last-save-directory = "file:///home/loren/Documents/Arbeit/GERMANY/PRES/AIMS_GW_MEETING/OCT22/figures";
    };

    "org/gnome/gnome-system-monitor" = {
      maximized = false;
      network-total-in-bits = false;
      show-dependencies = false;
      show-whose-processes = "user";
      window-state = mkTuple [ 700 500 ];
    };

    "org/gnome/gnome-system-monitor/disktreenew" = {
      col-6-visible = true;
      col-6-width = 0;
    };

    "org/gnome/maps" = {
      last-viewed-location = [ 49.937577 6.669774 ];
      map-type = "MapsStreetSource";
      transportation-type = "pedestrian";
      window-maximized = true;
      zoom-level = 8;
    };

    "org/gnome/mutter" = {
      attach-modal-dialogs = true;
      dynamic-workspaces = true;
      edge-tiling = true;
      focus-change-on-pointer-rest = true;
      workspaces-only-on-primary = true;
    };

    "org/gnome/nautilus/icon-view" = {
      default-zoom-level = "medium";
    };

    "org/gnome/nautilus/preferences" = {
      default-folder-viewer = "icon-view";
      migrated-gtk-settings = true;
      search-filter-time-type = "last_modified";
      search-view = "list-view";
    };

    "org/gnome/nautilus/window-state" = {
      initial-size = mkTuple [ 997 677 ];
      maximized = false;
    };

    "org/gnome/nm-applet/eap/018ad212-4fd8-4a9c-84be-f7be3a9c6aa5" = {
      ignore-ca-cert = false;
      ignore-phase2-ca-cert = false;
    };

    "org/gnome/nm-applet/eap/1931c61a-f848-4188-84b6-c62c0a062fa5" = {
      ignore-ca-cert = false;
      ignore-phase2-ca-cert = false;
    };

    "org/gnome/nm-applet/eap/20290588-f500-4fc7-ae72-41b7fdbee99c" = {
      ignore-ca-cert = false;
      ignore-phase2-ca-cert = false;
    };

    "org/gnome/nm-applet/eap/233f112c-eee9-4efd-babf-007576431e39" = {
      ignore-ca-cert = false;
      ignore-phase2-ca-cert = false;
    };

    "org/gnome/nm-applet/eap/28082add-5100-4f84-bacc-67d041ce520b" = {
      ignore-ca-cert = false;
      ignore-phase2-ca-cert = false;
    };

    "org/gnome/nm-applet/eap/382917de-92c1-45fa-a0be-2fb612a75bc5" = {
      ignore-ca-cert = false;
      ignore-phase2-ca-cert = false;
    };

    "org/gnome/nm-applet/eap/4a2cffa8-20dc-41e7-a65e-7d637160c051" = {
      ignore-ca-cert = false;
      ignore-phase2-ca-cert = false;
    };

    "org/gnome/nm-applet/eap/59df293f-6208-476a-8ecd-27a2dea10d69" = {
      ignore-ca-cert = false;
      ignore-phase2-ca-cert = false;
    };

    "org/gnome/nm-applet/eap/7e3a817a-41f9-4bc1-88be-3affd9e9b447" = {
      ignore-ca-cert = false;
      ignore-phase2-ca-cert = false;
    };

    "org/gnome/nm-applet/eap/9735e3fe-42b9-40ac-9cda-79b1a46206ba" = {
      ignore-ca-cert = false;
      ignore-phase2-ca-cert = false;
    };

    "org/gnome/nm-applet/eap/9c1f1740-442b-483c-b441-b32d361bc3a4" = {
      ignore-ca-cert = false;
      ignore-phase2-ca-cert = false;
    };

    "org/gnome/nm-applet/eap/9ec81f93-4f75-441b-9e09-10354a1ea148" = {
      ignore-ca-cert = false;
      ignore-phase2-ca-cert = false;
    };

    "org/gnome/nm-applet/eap/a2a536cf-c616-4785-b350-2b8c0eec70b5" = {
      ignore-ca-cert = false;
      ignore-phase2-ca-cert = false;
    };

    "org/gnome/nm-applet/eap/b375e865-ca22-4371-bb7c-b517b2680e56" = {
      ignore-ca-cert = false;
      ignore-phase2-ca-cert = false;
    };

    "org/gnome/nm-applet/eap/c324af01-e0b3-47ff-a94d-c4c07c45acd4" = {
      ignore-ca-cert = true;
      ignore-phase2-ca-cert = false;
    };

    "org/gnome/nm-applet/eap/ce654d28-ba24-4919-ad58-971e5652104c" = {
      ignore-ca-cert = false;
      ignore-phase2-ca-cert = false;
    };

    "org/gnome/nm-applet/eap/d9e73ea1-a871-495f-b4fd-8c50a055b9e6" = {
      ignore-ca-cert = false;
      ignore-phase2-ca-cert = false;
    };

    "org/gnome/nm-applet/eap/e92c66f9-4d14-469c-aaf2-d123fddcdc7e" = {
      ignore-ca-cert = false;
      ignore-phase2-ca-cert = false;
    };

    "org/gnome/nm-applet/eap/f99a8d43-90e1-4f4b-b10b-6dd217b90974" = {
      ignore-ca-cert = false;
      ignore-phase2-ca-cert = false;
    };

    "org/gnome/settings-daemon/plugins/color" = {
      night-light-enabled = false;
    };

    "org/gnome/settings-daemon/plugins/media-keys" = {
      custom-keybindings = [ "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/" "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/" "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2/" "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom3/" "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom4/" "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom5/" "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom6/" "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom7/" ];
      www = [ "<Super>w" ];
    };

    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
      binding = "<Super>Return";
      command = "kgx";
      name = "Terminal";
    };

    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1" = {
      binding = "<Shift><Super>Return";
      command = "kgx -e ipython";
      name = "Ipython";
    };

    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2" = {
      binding = "<Shift><Super>f";
      command = "kgx -e ranger";
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
      binding = "<Super>f";
      command = "nautilus";
      name = "Naut";
    };

    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom6" = {
      binding = "<Super>e";
      command = "emacsclient -c";
      name = "Emacs";
    };

    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom7" = {
      binding = "<Super>d";
      command = "neovide";
      name = "Neovide";
    };

    "org/gnome/settings-daemon/plugins/power" = {
      power-button-action = "suspend";
    };

    "org/gnome/shell" = {
      command-history = [ "console" "gnome-console" "slack" ];
      enabled-extensions = [ "auto-move-windows@gnome-shell-extensions.gcampax.github.com" ];
      favorite-apps = [ "firefox.desktop" "emacsclient.desktop" "code.desktop" "com.github.xournalpp.xournalpp.desktop" "zotero.desktop" "org.gnome.Nautilus.desktop" "slack.desktop" "Mattermost.desktop" "org.telegram.desktop.desktop" ];
      last-selected-power-profile = "power-saver";
      welcome-dialog-last-shown-version = "42.0";
    };

    "org/gnome/shell/extensions/auto-move-windows" = {
      application-list = [ "slack.desktop:2" "Mattermost.desktop:2" "telegramdesktop.desktop:2" ];
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

    "org/gnome/simple-scan" = {
      document-type = "photo";
      paper-height = 2970;
      paper-width = 2100;
      photo-dpi = 300;
      save-directory = "file:///home/loren/Documents/";
      text-dpi = 2400;
    };

    "org/gnome/software" = {
      check-timestamp = mkInt64 1689235346;
      first-run = false;
      flatpak-purge-timestamp = mkInt64 1689246135;
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
      custom-colors = [ (mkTuple [ 1.0 1.0 ]) ];
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
      window-position = mkTuple [ 799 386 ];
      window-size = mkTuple [ 962 658 ];
    };

    "system/proxy" = {
      mode = "none";
    };

  };
}
