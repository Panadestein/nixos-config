# Fish config
{ pkgs, ... }:
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
      sv = "sudo nvim";
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
      vz = "nvim ~/.config/zsh/.zshrc";
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
    ];

  };

}
