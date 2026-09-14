# Fish config
{ pkgs, ... }:
let
  theme = import ../../theme.nix;
in
{
  programs.fish = {
    enable = true;

    interactiveShellInit = ''
      # Remove greeting message
      set -g fish_greeting

      # Better man pager
      set -x MANPAGER "sh -c 'col -bx | bat -l man -p'"
      set -x MANROFFOPT "-c"
      set -gx LS_COLORS (vivid generate oehme)

      # Ensure fzf.fish history instead of fzf
      bind \cr _fzf_search_history
      bind -M insert \cr _fzf_search_history

      # Useful functions
      function emhash
          set head_hash (git rev-parse HEAD)

          if test -n "$head_hash"
              echo "Hash of HEAD: $head_hash"
              set url "https://github.com/Panadestein/emacsd/archive/$head_hash.tar.gz"
              nix-prefetch-url --unpack $url
          else
              echo "Error: Unable to retrieve HEAD hash. Are you in a Git repository?"
          end
      end

      function bqnhash
          set head_hash (git rev-parse HEAD)

          if test -n "$head_hash"
              echo "Hash of HEAD: $head_hash"
              set url "https://github.com/dzaima/CBQN.git"
              nix-prefetch-git --url $url --rev $head_hash --fetch-submodules
          else
              echo "Error: Unable to retrieve HEAD hash. Are you in a Git repository?"
          end
      end

      # Entering nix-shells
      any-nix-shell fish --info-right | source
    '';

    shellAliases = {
      # General aliases
      c = "code -r";
      cow = "fortune | cowsay";
      e = "emacsclient";
      E = "SUDO_EDITOR='emacsclient -t -a emacs' sudoedit";
      en = "emacsclient -c -nw";
      jour1 = "journalctl -p 3 -xb";
      jour2 = "journalctl -xb | grep rror";
      ka = "killall";
      ls = "eza";
      n = "nvim";
      y = "yazi";
      sb = "source ~/.bashrc";
      sv = "sudo nvim";
      sz = "source ~/.zshrc";
      t = "trans";
      v = "nvim";
      wgnord = "sudo wgnord";
      # Aliases for configuration files
      cde = "cd ~/.emacs.d/";
      cfb = "e ~/.bashrc";
      cfe = "e ~/.emacs.d/init.el";
      cfn = "nvim ~/.config/nvim/init.lua";
      cfv = "vim ~/.vimrc";
      vb = "nvim ~/.bashrc";
      vz = "nvim ~/.zshrc";
      # Less frequently used aliases
      jnb = "jupyter notebook";
      starwars = "telnet towel.blinkenlights.nl";
      wo = ''figlet -t "$(hostname)" | lolcat'';
      meteo = "curl http://wttr.in";
      # Supercomputers
      barb = "ssh -i ~/.ssh/id_rsa it4i-rpanades@barbora.it4i.cz";
      karo = "ssh -i ~/.ssh/id_rsa it4i-rpanades@karolina.it4i.cz";
      lumi = "ssh -i ~/.ssh/id_ed25519 rpanades2@lumi.csc.fi";
    };

    plugins = with pkgs.fishPlugins; [
      {
        name = "grc";
        src = grc.src;
      }
      {
        name = "fzf-fish";
        src = fzf-fish.src;
      }
      {
        name = "z";
        src = z.src;
      }
    ];

  };

  programs.starship = {
    enable = true;
    enableFishIntegration = true;
    settings = {
      add_newline = false;
      palette = "oehme";
      format = "$directory$git_branch$git_status$nix_shell$cmd_duration$line_break$character";

      palettes.oehme = {
        blue = theme.blue;
        cyan = theme.cyan;
        foreground = theme.foreground;
        green = theme.green;
        magenta = theme.magenta;
        orange = theme.orange;
        red = theme.red;
        yellow = theme.yellow;
      };

      directory = {
        format = "[$path]($style)[$read_only]($read_only_style) ";
        style = "bold blue";
        read_only = " ro";
        read_only_style = "bold red";
        truncation_length = 4;
        truncate_to_repo = false;
      };
      git_branch = {
        format = "[$symbol$branch(:$remote_branch)]($style) ";
        symbol = "git:";
        style = "bold magenta";
      };
      git_status = {
        format = "([$all_status$ahead_behind]($style) )";
        style = "bold yellow";
      };
      nix_shell = {
        format = "[$symbol$name]($style) ";
        symbol = "nix:";
        style = "bold cyan";
      };
      cmd_duration = {
        min_time = 2000;
        format = "[$duration]($style) ";
        style = "bold orange";
      };
      character = {
        success_symbol = "[❯](bold green) ";
        error_symbol = "[❯](bold red) ";
      };
    };
  };
}
