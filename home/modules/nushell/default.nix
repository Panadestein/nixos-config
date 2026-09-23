# Nushell configuration
{ lib, ... }:
{
  programs.nushell = {
    enable = true;

    settings = {
      show_banner = false;
      cursor_shape.emacs = "line";
    };

    shellAliases = {
      c = "code -r";
      cde = "cd ~/.emacs.d/";
      cfe = "emacsclient ~/.emacs.d/init.el";
      cfn = "nvim ~/.config/nvim/init.lua";
      e = "emacsclient";
      en = "emacsclient -c -nw";
      jnb = "jupyter notebook";
      jour1 = "journalctl -p 3 -xb";
      jour2 = "journalctl -xb | rg rror";
      ka = "killall";
      meteo = "curl http://wttr.in";
      n = "nvim";
      starwars = "telnet towel.blinkenlights.nl";
      sv = "sudo nvim";
      t = "trans";
      v = "nvim";
    };

    environmentVariables.LS_COLORS = lib.hm.nushell.mkNushellInline "(vivid generate oehme | str trim)";

    extraConfig = ''
      def wo [] {
          hostname | figlet -t $in | lolcat
      }

      def isrun [proc] {
          ps | rg $proc
      }

      def E [fil] {
          with-env [SUDO_EDITOR "emacsclient -t -a emacs"] { sudoedit $fil }
      }

      def poc [...col: string] {
          let redcol = $col | reduce { |it, acc| $acc + " " + $it }
          let st = 'collections : ' | append $'"($redcol)"' | str join ' '
          papis open $"\'($st)\'"
      }

      def emhash [commit] {
          nix-prefetch-url --unpack $"https://github.com/Panadestein/emacsd/archive/($commit).tar.gz"
      }
    '';
  };
}
