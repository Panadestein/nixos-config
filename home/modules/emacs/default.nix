# Emacs configuration
{ pkgs, ... }:
{
  home.file.".emacs.d/" = {
    source = pkgs.fetchFromGitHub {
      owner = "Panadestein";
      repo = "emacsd";
      rev = "52fd2cec893dfe819955192056eb48c9da1ac563";
      sha256 = "0727cswph8j1bcfsgi5glzwf2svg1bgq6n30xavr1yywspsmf57n";
    };
    recursive = true;
    onChange = ''
      (
        emacs_dir="$HOME/.emacs.d"
        ${pkgs.coreutils}/bin/mkdir -p \
          "$emacs_dir/lib" \
          "$emacs_dir/snippets/irp-mode" \
          "$emacs_dir/undo"
        cd "$emacs_dir"
        ${pkgs.emacs-git-pgtk}/bin/emacs --batch \
          --eval "(require 'org-loaddefs)" \
          --eval "(setq org-resource-download-policy t)" \
          --eval '(org-babel-tangle-file "./content/index.org")'
      )
    '';
  };

  xdg.desktopEntries.emacsclient = {
    name = "Emacs (Client)";
    genericName = "Text Editor";
    comment = "Edit text";
    icon = "emacs";
    exec = "emacsclient --reuse-frame --no-wait --alternate-editor= %F";
    terminal = false;
    categories = [
      "Development"
      "TextEditor"
    ];
    mimeType = [
      "text/plain"
      "text/markdown"
      "text/org"
      "x-scheme-handler/org-protocol"
    ];
    settings.StartupWMClass = "Emacs";
  };
}
