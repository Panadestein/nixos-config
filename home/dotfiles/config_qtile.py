r"""Qtile configuration.

  ___  _   _ _
 / _ \| |_(_) | ___
| | | | __| | |/ _ \
| |_| | |_| | |  __/
 \__\_\\__|_|_|\___|

100% PEP8 compliant.
"""
from __future__ import annotations

import logging
import os
import re
import socket
import subprocess
from pathlib import Path
from typing import Any

from libqtile import bar, hook, layout, qtile, widget
from libqtile.config import Click, Drag, DropDown, Group, Key, Match, ScratchPad, Screen
from libqtile.dgroups import simple_key_binder
from libqtile.lazy import lazy
from libqtile.utils import guess_terminal

# Define helper functions


def parse_keys(keys_obj: list[Key]) -> str:
    """Format string of defined keybindings."""
    key_help = ""
    for k in keys_obj:
        mods = ""
        for m in k.modifiers:
            if m == "mod4":
                mods += "Super + "
            else:
                mods += m.capitalize() + " + "
        if len(k.key) > 1:
            mods += k.key.capitalize()
        else:
            mods += k.key
        key_help += f"{mods:<50}{k.desc}\n"
    return key_help


# Define global variables

mod: str = "mod4"
terminal: str = guess_terminal()
dgroups_key_binder = simple_key_binder("mod4")
xrancmd: str = f"{Path.home()}/.config/scripts/randr_conf.sh"
prompt: str = f'{os.environ["USER"]}@{socket.gethostname()}: '
rofifm: str = "rofi -show filebrowser"
rofiw: str = "rofi -show window -show-icons"
cbqn: str = (
    """alacritty -o 'font.normal.family="BQN386 Unicode"' -o 'font.size=60'
    -e zsh -c 'figlet "BQN" | lolcat && cbqn --version && bqn'"""
)

# Useful colors
# https://www.schemecolor.com/python-logo-colors.php

cl_pal: dict[str, list[str]] = {
    "cazure": ["#4b8bbe", "#4b8bbe"],
    "sunglow": ["#ffe873", "#ffe873"],
    "amag": ["#c678dd", "#c678dd"],
    "deepr": ["#8B0000"],
}

# Define keybindings

keys: list[Key] = [
    # Applications
    Key([mod], "Return", lazy.spawn(terminal),
        desc="Launches detected terminal"),
    Key([mod, "shift"], "Return", lazy.spawn("alacritty -e fish"),
        desc="Launches a fish session"),
    Key([mod, "control"], "Return", lazy.spawn("alacritty -e xonsh"),
        desc="Launches a xonsh session"),
    Key([mod], "r", lazy.spawn("rofi -show drun -show-icons"),
        desc="Toggles the Rofi launcher"),
    Key([mod], "Tab", lazy.spawn(rofiw),
        desc="Toggles the Rofi window switcher"),
    Key([mod], "b", lazy.spawn(["sh", "-c", rofifm]),
        desc="Launches the Rofi file browser"),
    Key([mod], "p", lazy.spawn("rofi-pass"),
        desc="Launches GNU Pass."),
    Key([mod, "shift"], "r", lazy.spawncmd(),
        desc="Spawn a command using a prompt widget"),
    Key([mod], "w", lazy.spawn("firefox"),
        desc="Launches the Firefox web browser"),
    Key([mod], "e", lazy.spawn("emacsclient -c"),
        desc="Launches an emacsclient frame"),
    Key([mod], "v", lazy.spawn("code"),
        desc="Launches VS Code"),
    Key([mod, "shift"], "f", lazy.spawn("thunar"),
        desc="Launches the Thunar file browser"),
    Key([mod], "f", lazy.spawn("alacritty -e ranger"),
        desc="Launches the Ranger file browser"),
    Key([], "Print", lazy.spawn("flameshot gui"),
        desc="Takes a screenshot"),

    # Language
    Key([mod], "i", lazy.widget["keyboardlayout"].next_keyboard(),
        desc="Cycle through keyboard layouts"),

    # Dropdown terminal
    Key([], "F12", lazy.group["scratchpad"].dropdown_toggle("term"),
        desc="Toggles scratchpad terminal"),
    Key([mod], "c", lazy.group["scratchpad"].dropdown_toggle("calculator"),
        desc="Toggles the numbat calculator"),
    Key([mod], "a", lazy.group["scratchpad"].dropdown_toggle("bqn"),
        desc="Toggles the CBQN repl"),

    # Media Keys
    Key([], "XF86AudioLowerVolume", lazy.spawn("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),
        desc="Lowers volume"),
    Key([], "XF86AudioRaiseVolume", lazy.spawn("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"),
        desc="Raises volume"),
    Key([], "XF86AudioMute", lazy.spawn("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),
        desc="Toggles sound"),
    Key([], "XF86MonBrightnessDown",   lazy.spawn("brightnessctl -q s 5%-"),
        desc="Decreases brightness"),
    Key([], "XF86MonBrightnessUp",   lazy.spawn("brightnessctl -q s +5%"),
        desc="Increases brightness"),

    # Display Manager
    Key([mod], "o", lazy.spawn("dm-tool lock"),
        desc="Locks the screen"),
    Key([mod], "m", lazy.spawn(xrancmd),
        desc="Ensures external monitor usage"),

    # Session control
    Key([mod, "shift"], "x", lazy.spawn("shutdown now"),
        desc="Shutdown the box"),
    Key([mod, "shift"], "BackSpace", lazy.spawn("reboot"),
        desc="Reboot the box"),
    Key([mod, "control"], "r", lazy.restart(), desc="Restart Qtile"),
    Key([mod, "control"], "q", lazy.shutdown(), desc="Shutdown Qtile"),

    # Groups control
    Key([mod], "Right", lazy.screen.prev_group(),
        desc="Move to the group on the right"),
    Key([mod], "Left", lazy.screen.next_group(),
        desc="Move to the group on the left"),

    # Window and layout control
    Key([mod], "q", lazy.window.kill(), desc="Kill focused window"),
    Key([mod], "u",
        lazy.window.toggle_fullscreen(),
        desc="Toggles fullscreen when window is not floating"),
    Key([mod], "t", lazy.window.toggle_floating(),
        desc="Toggle floating"),

    Key([mod], "h", lazy.layout.left(), desc="Move focus to left"),
    Key([mod], "l", lazy.layout.right(), desc="Move focus to right"),
    Key([mod], "j", lazy.layout.down(), desc="Move focus down"),
    Key([mod], "k", lazy.layout.up(), desc="Move focus up"),
    Key([mod, "shift"], "Tab", lazy.layout.next(),
        desc="Move window focus to the next window"),
    Key([mod, "shift"], "h", lazy.layout.shuffle_left(),
        desc="Move window to the left"),
    Key([mod, "shift"], "l", lazy.layout.shuffle_right(),
        desc="Move window to the right"),
    Key([mod, "shift"], "j", lazy.layout.shuffle_down(),
        desc="Move window down"),
    Key([mod, "shift"], "k", lazy.layout.shuffle_up(),
        desc="Move window up"),
    Key([mod, "control"], "h", lazy.layout.grow_left(),
        desc="Grow window to the left"),
    Key([mod, "control"], "l", lazy.layout.grow_right(),
        desc="Grow window to the right"),
    Key([mod, "control"], "j", lazy.layout.grow_down(),
        desc="Grow window down"),
    Key([mod, "control"], "k", lazy.layout.grow_up(), desc="Grow window up"),
    Key([mod, "control"], "s", lazy.layout.toggle_split(),
        desc="Toggle between split and unsplit sides of stack"),
    Key([mod, "shift", "control"], "h", lazy.layout.swap_column_left(),
        desc="Swaps the current window stack to the left"),
    Key([mod, "shift", "control"], "l", lazy.layout.swap_column_right(),
        desc="Swaps the current window stack to the right"),
    Key([mod], "n", lazy.layout.normalize(), desc="Reset all window sizes"),
    Key([mod], "space", lazy.next_layout(), desc="Toggle between layouts"),
]

# Get help

SUFIX_CMDH: str = 'rofi -dmenu -i -mesg "Keyboard shortcuts"'
cmdh: str = f'echo "{parse_keys(keys)}" | {SUFIX_CMDH}'
keys.extend([Key([mod], "F1",
                 lazy.spawn(cmdh, shell=True),
                 desc="Display defined keybindings")])

# Define groups (workspaces)

groups: list[Group | ScratchPad] = [
    ScratchPad("scratchpad", [
        DropDown("term", "alacritty -e fish",
                 x=0.0,
                 y=0.0,
                 width=1.0,
                 height=1.0,
                 opacity=0.9,
                 on_focus_lost_hide=True),
        DropDown("calculator", "alacritty -e numbat",
                 opacity=0.95,
                 on_focus_lost_hide=False),
        DropDown("bqn", cbqn,
                 x=0.0,
                 y=0.0,
                 width=1.0,
                 height=1.0,
                 opacity=0.95,
                 on_focus_lost_hide=False)]),
    Group("dev", layout="max",
          matches=[Match(
              wm_class=re.compile(r"^(Code|Emacs)$")),
          ]),
    Group("tty", layout="monadtall"),
    Group("doc", layout="monadtall"),
    Group("www", layout="monadtall",
          matches=[Match(
              wm_class=re.compile(r"^(firefox|Brave\-browser|Nyxt)$")),
          ]),
    Group("msg", layout="monadtall",
          matches=[Match(
              wm_class=re.compile(r"^(Mattermost|Slack|TelegramDesktop)$"),
          )]),
    Group("com", layout="monadtall",
          matches=[Match(
              wm_class=re.compile(r"^(Skype|zoom)$"),
          )]),
    Group("rnd", layout="monadtall",
          matches=[Match(
              wm_class=re.compile(r"^(retroarch)$")),
          ]),
    Group("art", layout="floating"),
]

# Layouts

layout_theme: dict[str, str | int] = {
    "border_width": 1,
    "border_focus": "#8f3d3d",
    "border_normal": "#267CB9",
}

layouts: list[Any] = [
    # No need for more than this
    layout.Max(**layout_theme),
    layout.MonadTall(**layout_theme,
                     single_border_width=0,
                     single_margin=0,
                     margin=6,
                     new_client_position="bottom"),
    layout.Columns(**layout_theme,
                   margin=4,
                   margin_on_single=0),
    layout.Floating(**layout_theme),
]

# Widgets configuration

widget_defaults: dict[str, str | int] = {
    "font": "Fira Code",
    "fontsize": 14,
    "padding": 3,
}

extension_defaults: dict[str, str | int] = widget_defaults.copy()

# Screens configuration

WIDGETS: list[Any] = [
    widget.Image(
        filename="~/.config/qtile/python_icon.png",
        scale="True",
        mouse_callbacks={
            "Button1":
            lambda: qtile.spawn("alacritty -e xonsh")},
    ),
    widget.Spacer(length=5),
    widget.Sep(
        linewidth=3,
        padding=10,
        foreground=cl_pal["deepr"],
    ),
    widget.GroupBox(
        fontsize=15,
        margin_y=3,
        margin_x=0,
        padding_y=5,
        padding_x=3,
        active=cl_pal["cazure"],
        inactive=cl_pal["sunglow"],
        highlight_method="block",
        block_highlight_text_color=cl_pal["amag"],
        borderwidth=3,
        rounded=True,
    ),
    widget.Sep(
        linewidth=3,
        padding=10,
        foreground=cl_pal["deepr"],
    ),
    widget.Prompt(),
    widget.WindowName(max_chars=50,
                      foreground=cl_pal["cazure"]),
    widget.CurrentLayoutIcon(scale=0.8),
    widget.Sep(
        linewidth=3,
        padding=10,
        foreground=cl_pal["deepr"],
    ),
    widget.PulseVolume(
        fmt="Vol: {}",
        padding=5,
    ),
    widget.Sep(
        linewidth=3,
        padding=10,
        foreground=cl_pal["deepr"],
    ),
    widget.CPU(
        format="CPU {load_percent}%",
        mouse_callbacks={
            "Button1":
            lambda: qtile.spawn("alacritty -e htop"),
        },
    ),
    widget.Sep(
        linewidth=3,
        padding=10,
        foreground=cl_pal["deepr"],
    ),
    widget.Battery(
        format="Bat{char}: {percent:2.0%}",
        charge_char="▲",
        discharge_char="▼",
        empty_char="∅",
        unknown_char="◆",
        foreground=cl_pal["sunglow"],
        low_foreground="FF0000",
        notify_below=0.1,
        low_percentage=0.2),
    widget.Sep(
        linewidth=3,
        padding=10,
        foreground=cl_pal["deepr"],
    ),
    widget.Systray(),
    widget.Sep(
        linewidth=3,
        padding=10,
        foreground=cl_pal["deepr"],
    ),
    widget.Clock(format="%d.%m %a %I:%M %p",
                 mouse_callbacks={
                     "Button1":
                     lambda: qtile.spawn(
                         "gnome-calendar"),
                 }),
    widget.Sep(
        linewidth=3,
        padding=10,
        foreground=cl_pal["deepr"],
    ),
    widget.KeyboardLayout(
        configured_keyboards=["us"],
        foreground=cl_pal["sunglow"]),
]

screens: list[Screen] = [
    Screen(
        top=bar.Bar(
            WIDGETS,
            28,
        ),
        wallpaper=f"{Path.home()}/.config/qtile/PiN_EFOehme.jpg",
        wallpaper_mode="fill",
    ),
    Screen(
        wallpaper=f"{Path.home()}/.config/qtile/PiN_EFOehme.jpg",
        wallpaper_mode="fill",
    ),
]

# Floating window control

mouse: list[Drag | Click] = [
    Drag([mod], "Button1", lazy.window.set_position_floating(),
         start=lazy.window.get_position()),
    Drag([mod], "Button3", lazy.window.set_size_floating(),
         start=lazy.window.get_size()),
    Click([mod], "Button2", lazy.window.bring_to_front()),
]

# Internal Qtile options

dgroups_app_rules: list[Any] = []
follow_mouse_focus: bool = True
bring_front_click: bool = True
cursor_warp: bool = True

floating_layout = layout.Floating(float_rules=[
    *layout.Floating.default_float_rules,
    Match(wm_class="ssh-askpass"),  # ssh-askpass
    Match(title="pinentry"),  # GPG key password entry
    Match(wm_class="Gnome-screenshot"),  # A screenshot utility
    Match(wm_class="mpv"),  # A powerful media player
    Match(wm_class="matplotlib"),  # It is all about plotting
    Match(wm_class="Thunar"),  # Better float than sorry
    Match(wm_class="File-roller"),  # Better float than sorry
])

auto_fullscreen: bool = True
focus_on_window_activation: str = "smart"
reconfigure_screens: bool = True
auto_minimize: bool = True

# Screen event hook


@hook.subscribe.screen_change
def screen_event(_: str) -> None:
    """Reload xrandr configuration in case of screen changes.

    This hook ensures that only one monitor will be used at the time,
    defaulting to external.
    """
    script_path = Path.home() / ".config/scripts/randr_conf.sh"
    try:
        result = subprocess.run(
            [script_path], capture_output=True, text=True, check=True)
        logging.info("Successfully executed xrandr hook: %s", {result.stdout})
    except subprocess.CalledProcessError:
        logging.exception("Failed to execute xrandr hook")


# Dirty Java hack


wmname: str = "LG3D"
