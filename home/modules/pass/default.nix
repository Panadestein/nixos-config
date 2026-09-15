# Pass and passmenu configuration with Wayland and Rofi support
{
  lib,
  pkgs,
  ...
}:
let
  passPkg = pkgs.pass-wayland.withExtensions (exts: [
    exts.pass-otp
    exts.pass-import
    exts.pass-update
  ]);

  passmenu = pkgs.writeShellScriptBin "passmenu" ''
    set -euo pipefail
    shopt -s nullglob globstar

    typeit=0
    otp=0

    while [[ $# -gt 0 ]]; do
      case "$1" in
        -t|--type)
          typeit=1
          shift
          ;;
        -o|--otp)
          otp=1
          shift
          ;;
        *)
          break
          ;;
      esac
    done

    prefix="''${PASSWORD_STORE_DIR:-$HOME/.password-store}"
    prefix="''${prefix%/}"
    if [[ ! -d "$prefix" ]]; then
      ${pkgs.libnotify}/bin/notify-send -a Pass "Pass" "Password store directory not found: $prefix"
      exit 1
    fi

    password_files=( "$prefix"/**/*.gpg )
    password_files=( "''${password_files[@]#"$prefix"/}" )
    password_files=( "''${password_files[@]%.gpg}" )

    if [[ ''${#password_files[@]} -eq 0 ]]; then
      ${pkgs.libnotify}/bin/notify-send -a Pass "Pass" "No passwords found in $prefix"
      exit 0
    fi

    prompt="󰌋 Pass"
    if [[ $otp -eq 1 ]]; then
      prompt="󰌋 OTP"
    elif [[ $typeit -eq 1 ]]; then
      prompt="󰌋 Type Pass"
    fi

    password=$(printf '%s\n' "''${password_files[@]}" | ${pkgs.coreutils}/bin/sort | ${pkgs.rofi}/bin/rofi -dmenu -i -p "$prompt" -theme-str 'inputbar { children: [ "prompt", "entry" ]; }' "$@")

    [[ -n "$password" ]] || exit 0

    if [[ $otp -eq 1 ]]; then
      if ${passPkg}/bin/pass otp -c "$password"; then
        ${pkgs.libnotify}/bin/notify-send -a Pass "Pass" "Copied OTP for $password to clipboard"
      else
        ${pkgs.libnotify}/bin/notify-send -u critical -a Pass "Pass" "Failed to get OTP for $password"
      fi
    elif [[ $typeit -eq 1 ]]; then
      if pass_output=$(${passPkg}/bin/pass show "$password"); then
        IFS= read -r secret <<< "$pass_output"
        if [[ -n "$secret" ]]; then
          ${pkgs.coreutils}/bin/sleep 0.1
          printf '%s' "$secret" | ${pkgs.wtype}/bin/wtype -
        fi
      else
        ${pkgs.libnotify}/bin/notify-send -u critical -a Pass "Pass" "Failed to retrieve password for $password"
      fi
    else
      if ${passPkg}/bin/pass show -c "$password"; then
        ${pkgs.libnotify}/bin/notify-send -a Pass "Pass" "Copied password for $password to clipboard"
      else
        ${pkgs.libnotify}/bin/notify-send -u critical -a Pass "Pass" "Failed to copy password for $password"
      fi
    fi
  '';
in
{
  home.packages = [
    passPkg
    (lib.hiPrio passmenu)
    pkgs.wtype
  ];
}
