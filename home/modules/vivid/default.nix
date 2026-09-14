# Vivid LS_COLORS generator theme
{ pkgs, ... }:
let
  theme = import ../../theme.nix;
  stripHash = color: builtins.substring 1 6 color;
in
{
  home.packages = [
    pkgs.vivid
  ];

  xdg.configFile."vivid/themes/oehme.yml".text = ''
    colors:
      background: '${stripHash theme.background}'
      foreground: '${stripHash theme.foreground}'
      muted: '${stripHash theme.muted}'
      red: '${stripHash theme.red}'
      orange: '${stripHash theme.orange}'
      yellow: '${stripHash theme.yellow}'
      green: '${stripHash theme.green}'
      cyan: '${stripHash theme.cyan}'
      blue: '${stripHash theme.blue}'
      magenta: '${stripHash theme.magenta}'
    core:
      normal_text: { foreground: foreground }
      regular_file: { foreground: foreground }
      reset_to_normal: { foreground: foreground }
      directory: { foreground: blue, font-style: bold }
      symlink: { foreground: cyan }
      multi_hard_link: { foreground: cyan, font-style: underline }
      fifo: { foreground: yellow }
      socket: { foreground: magenta }
      door: { foreground: magenta }
      block_device: { foreground: orange }
      character_device: { foreground: orange }
      broken_symlink: { foreground: red, font-style: bold }
      missing_symlink_target: { foreground: red, font-style: bold }
      setuid: { foreground: red }
      setgid: { foreground: orange }
      file_with_capability: { foreground: yellow }
      sticky_other_writable: { foreground: background, background: blue }
      other_writable: { foreground: background, background: cyan }
      sticky: { foreground: background, background: magenta }
      executable_file: { foreground: green, font-style: bold }
    text:
      special: { foreground: yellow }
      todo: { foreground: orange, font-style: bold }
      licenses: { foreground: muted }
      configuration: { foreground: yellow }
      other: { foreground: foreground }
    markup: { foreground: cyan }
    programming:
      source: { foreground: green }
      tooling: { foreground: cyan }
    media: { foreground: magenta }
    office: { foreground: orange }
    archives: { foreground: red, font-style: bold }
    executable: { foreground: green, font-style: bold }
    unimportant: { foreground: muted }
  '';
}
