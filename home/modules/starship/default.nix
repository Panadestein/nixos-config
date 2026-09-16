# Shared Starship prompt configuration
_:
let
  theme = import ../../theme.nix;
in
{
  programs.starship = {
    enable = true;
    enableBashIntegration = true;
    enableFishIntegration = true;
    enableNushellIntegration = true;
    enableZshIntegration = true;

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
