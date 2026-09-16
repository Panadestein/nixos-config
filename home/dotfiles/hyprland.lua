-- Native Lua configuration for Hyprland.

local mod = "SUPER"
local terminal = "ghostty"

hl.monitor({
    output = "",
    mode = "highres",
    position = "auto",
    scale = 1.25,
})

hl.env("XCURSOR_SIZE", "25")
hl.env("HYPRCURSOR_SIZE", "25")

hl.config({
    general = {
        gaps_in = 6,
        gaps_out = 10,
        border_size = 2,
        col = {
            active_border = { colors = { "rgba(@blue@ee)", "rgba(@magenta@ee)" }, angle = 45 },
            inactive_border = "rgba(@muted@dd)",
        },
        resize_on_border = true,
        layout = "dwindle",
    },
    decoration = {
        rounding = 10,
        active_opacity = 1.0,
        inactive_opacity = 0.94,
        shadow = {
            enabled = true,
            range = 12,
            render_power = 3,
            color = "rgba(@darkerBackground@99)",
        },
        blur = {
            enabled = true,
            size = 4,
            passes = 2,
        },
    },
    animations = { enabled = true },
    input = {
        kb_layout = "us,bqn",
        kb_options = "grp:switch",
        follow_mouse = 1,
        touchpad = {
            natural_scroll = true,
            tap_to_click = true,
        },
    },
    dwindle = {
        preserve_split = true,
        force_split = 2,
    },
    misc = {
        disable_hyprland_logo = true,
        force_default_wallpaper = 0,
        focus_on_activate = true,
    },
})

hl.gesture({ fingers = 3, direction = "horizontal", action = "workspace" })

hl.on("hyprland.start", function()
    hl.exec_cmd("pidof hyprlock || hyprlock")
end)

local shortcutHelp = {}

local function bind(keys, dispatcher, description, options)
    options = options or {}
    options.description = description
    hl.bind(keys, dispatcher, options)
    shortcutHelp[#shortcutHelp + 1] = string.format("%-32s %s", keys, description)
end

local function shellQuote(value)
    return "'" .. value:gsub("'", "'\\''") .. "'"
end

local function toggleSpecial(name)
    hl.dispatch(hl.dsp.workspace.toggle_special(name))
end

local pendingScratchpads = {}

local function launchScratchpad(name, command, rules)
    -- A failed process never emits window.open. Allow a retry after a bounded
    -- wait, and keep old timers from clearing a newer launch attempt.
    local attempt = {}
    pendingScratchpads[name] = attempt
    hl.timer(function()
        if pendingScratchpads[name] == attempt then
            pendingScratchpads[name] = nil
            hl.notification.create({
                text = "Scratchpad " .. name .. " did not open; press its shortcut to retry",
                timeout = 5000,
            })
        end
    end, { timeout = 15000, type = "oneshot" })
    hl.exec_cmd(command, rules)
end

local function scratchpad(name, command, rules)
    local workspace = "special:" .. name
    rules = rules or {}
    rules.workspace = workspace .. " silent"
    rules.float = true
    rules.center = true

    return function()
        if #hl.get_workspace_windows(workspace) > 0 then
            toggleSpecial(name)
            return
        end

        if pendingScratchpads[name] then
            return
        end

        launchScratchpad(name, command, rules)
    end
end

-- Fish uses a dedicated Ghostty class rather than exec_cmd placement rules.
-- This prevents programs launched from it (such as a browser opened from a URL)
-- from inheriting the special workspace.
local fishDropdownClass = "com.mitchellh.ghostty.scratchpad-fish"
hl.window_rule({
    name = "fish-dropdown",
    match = { class = "^" .. fishDropdownClass .. "$" },
    workspace = "special:term silent",
    float = true,
    -- Match the usable area of a single regular window: Waybar reserves 34px
    -- at the top and the normal outer edge (gap + border) is 12px.
    size = { "monitor_w-24", "monitor_h-58" },
    move = { "12", "46" },
    no_max_size = true,
    opacity = 0.96,
})

local function fishDropdown()
    local workspace = "special:term"
    if #hl.get_workspace_windows(workspace) > 0 then
        toggleSpecial("term")
        return
    end

    if pendingScratchpads.term then
        return
    end

    launchScratchpad("term",
        terminal
            .. " --gtk-single-instance=false --class="
            .. fishDropdownClass
            .. " -e fish"
    )
end

-- Some applications inherit the terminal's activation workspace when launched
-- from a link. Keep the scratchpad exclusive to its Fish window, then reveal
-- the application on the monitor's ordinary workspace.
hl.on("window.open", function(window)
    if window == nil then
        return
    end

    if pendingScratchpads.term and window.class == fishDropdownClass then
        pendingScratchpads.term = nil
        toggleSpecial("term")
        return
    end

    if window.workspace ~= nil then
        for name, pending in pairs(pendingScratchpads) do
            if pending and window.workspace.name == "special:" .. name then
                pendingScratchpads[name] = nil
                toggleSpecial(name)
                return
            end
        end
    end

    if window.class == fishDropdownClass then
        return
    end

    if window.workspace ~= nil and window.workspace.name == "special:term" then
        local workspace = window.monitor and window.monitor.active_workspace
        if workspace ~= nil then
            hl.dispatch(hl.dsp.window.move({ workspace = workspace.name, window = window }))
            toggleSpecial("term")
        end
    end
end)

-- Applications
bind(mod .. " + RETURN", hl.dsp.exec_cmd(terminal), "Launch Ghostty")
bind(mod .. " + SHIFT + RETURN", hl.dsp.exec_cmd(terminal .. " -e ipython"), "Launch a Jupyter session")
bind(mod .. " + R", hl.dsp.exec_cmd("rofi -show drun -show-icons"), "Open the application launcher")
bind(mod .. " + TAB", hl.dsp.exec_cmd("rofi -show window -show-icons"), "Open the window switcher")
bind(mod .. " + SHIFT + R", hl.dsp.exec_cmd("rofi -show run"), "Run a command")
bind(mod .. " + P", hl.dsp.exec_cmd("passmenu"), "Open password menu")
bind(mod .. " + SHIFT + P", hl.dsp.exec_cmd("passmenu --type"), "Type password from menu")
bind(mod .. " + W", hl.dsp.exec_cmd("firefox"), "Launch Firefox")
bind(mod .. " + C", hl.dsp.exec_cmd("chromium"), "Launch Chromium")
bind(mod .. " + E", hl.dsp.exec_cmd("emacsclient -c"), "Launch an Emacs client frame")
bind(mod .. " + V", hl.dsp.exec_cmd("code"), "Launch VS Code")
bind(mod .. " + SHIFT + F", hl.dsp.exec_cmd("nautilus --new-window"), "Launch Nautilus")
bind(mod .. " + F", hl.dsp.exec_cmd(terminal .. " -e yazi"), "Launch Yazi")
bind(mod .. " + SHIFT + W", hl.dsp.exec_cmd("waypaper --folder $HOME/.local/share/wallpapers/oehme --backend hyprpaper"), "Choose a wallpaper")
bind(mod .. " + CTRL + W", hl.dsp.exec_cmd("wallpaper-next"), "Cycle to the next wallpaper")
bind("PRINT", hl.dsp.exec_cmd("hyprshot -m region -o $HOME/Pictures/Screenshots"), "Capture a region")

-- Keyboard layout and scratchpads
bind(mod .. " + I", hl.dsp.exec_cmd("hyprctl switchxkblayout all next"), "Cycle keyboard layouts")
bind("F12", fishDropdown, "Toggle the Fish drop-down terminal")
bind(mod .. " + N", scratchpad("calculator", terminal .. " --gtk-single-instance=false -e numbat", {
    size = "70% 70%",
    opacity = 0.95,
}), "Toggle the Numbat scratchpad")
bind(
    mod .. " + A",
    hl.dsp.exec_cmd(terminal .. " --gtk-single-instance=false --font-family='BQN386 Unicode' --font-size=30 -e bqn"),
    "Launch BQN"
)

-- Media keys
local defaultAudioSink = "@" .. "DEFAULT_AUDIO_SINK" .. "@"
bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume " .. defaultAudioSink .. " 5%-"), "Lower volume", { locked = true, repeating = true })
bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1 " .. defaultAudioSink .. " 5%+"), "Raise volume", { locked = true, repeating = true })
bind("XF86AudioMute", hl.dsp.exec_cmd("wpctl set-mute " .. defaultAudioSink .. " toggle"), "Toggle mute", { locked = true })
bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl -q set 5%-"), "Decrease brightness", { locked = true, repeating = true })
bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl -q set +5%"), "Increase brightness", { locked = true, repeating = true })

-- Session controls
bind(mod .. " + O", hl.dsp.exec_cmd("hyprlock"), "Lock the screen")
bind(mod .. " + SHIFT + X", hl.dsp.exec_cmd("shutdown now"), "Shut down")
bind(mod .. " + SHIFT + BACKSPACE", hl.dsp.exec_cmd("reboot"), "Reboot")
bind(mod .. " + CTRL + R", function()
    hl.notification.create({ text = "Reloading Hyprland configuration", timeout = 1500 })
    hl.exec_cmd("hyprctl reload")
end, "Reload the active Hyprland configuration")
bind(mod .. " + CTRL + Q", hl.dsp.exec_cmd("uwsm stop"), "Exit Hyprland")

-- The first five workspaces are always visible in Waybar; the remaining
-- numbered bindings create their workspace when first selected.
for index = 1, 10 do
    if index <= 5 then
        hl.workspace_rule({ workspace = tostring(index), persistent = true })
    end

    local key = index % 10
    bind(mod .. " + " .. key, hl.dsp.focus({ workspace = index }), "Switch to workspace " .. index)
    bind(mod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = index }), "Move window to workspace " .. index)
end

bind(mod .. " + RIGHT", hl.dsp.focus({ workspace = "e+1" }), "Switch to the next workspace")
bind(mod .. " + LEFT", hl.dsp.focus({ workspace = "e-1" }), "Switch to the previous workspace")
bind(mod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }), "Switch to the next workspace", { mouse = true })
bind(mod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }), "Switch to the previous workspace", { mouse = true })

-- Window and layout controls
bind(mod .. " + Q", hl.dsp.window.close(), "Close the focused window")
bind("CTRL + ALT + Delete", function()
    local active = hl.get_active_workspace()
    local name = active and active.name or "1"
    for _, w in ipairs(hl.get_workspace_windows(name)) do
        hl.dispatch(hl.dsp.window.close({ window = w }))
    end
end, "Close all windows on the active workspace")
bind(mod .. " + G", hl.dsp.group.toggle(), "Toggle window grouping")
bind(mod .. " + ALT + G", hl.dsp.exec_raw("moveoutofgroup"), "Move window out of group")
bind(mod .. " + ALT + TAB", hl.dsp.group.next(), "Cycle between windows in group")
bind(mod .. " + U", hl.dsp.window.fullscreen(), "Toggle fullscreen")
bind(mod .. " + T", hl.dsp.window.float({ action = "toggle" }), "Toggle floating")
bind(mod .. " + H", hl.dsp.focus({ direction = "left" }), "Focus left")
bind(mod .. " + L", hl.dsp.focus({ direction = "right" }), "Focus right")
bind(mod .. " + J", hl.dsp.focus({ direction = "down" }), "Focus down")
bind(mod .. " + K", hl.dsp.focus({ direction = "up" }), "Focus up")
bind(mod .. " + SHIFT + TAB", hl.dsp.window.cycle_next(), "Focus the next window")
bind(mod .. " + SHIFT + H", hl.dsp.window.move({ direction = "left" }), "Move window left")
bind(mod .. " + SHIFT + L", hl.dsp.window.move({ direction = "right" }), "Move window right")
bind(mod .. " + SHIFT + J", hl.dsp.window.move({ direction = "down" }), "Move window down")
bind(mod .. " + SHIFT + K", hl.dsp.window.move({ direction = "up" }), "Move window up")
bind(mod .. " + CTRL + H", hl.dsp.window.resize({ x = -40, y = 0, relative = true }), "Shrink window horizontally")
bind(mod .. " + CTRL + L", hl.dsp.window.resize({ x = 40, y = 0, relative = true }), "Grow window horizontally")
bind(mod .. " + CTRL + J", hl.dsp.window.resize({ x = 0, y = 40, relative = true }), "Grow window vertically")
bind(mod .. " + CTRL + K", hl.dsp.window.resize({ x = 0, y = -40, relative = true }), "Shrink window vertically")
bind(mod .. " + CTRL + S", hl.dsp.layout("togglesplit"), "Toggle the dwindle split")
bind(mod .. " + SHIFT + G", function()
    local compact = hl.get_config("general.gaps_in").top == 0
    hl.config({
        general = {
            gaps_in = compact and 6 or 0,
            gaps_out = compact and 10 or 0,
        },
        decoration = {
            rounding = compact and 10 or 0,
        },
    })
    hl.notification.create({
        text = compact and "Restored window spacing" or "Enabled compact window layout",
        timeout = 1500,
    })
end, "Toggle compact window spacing")
bind(mod .. " + SHIFT + CTRL + H", hl.dsp.window.swap({ direction = "left" }), "Swap window left")
bind(mod .. " + SHIFT + CTRL + L", hl.dsp.window.swap({ direction = "right" }), "Swap window right")
-- Mouse bindings
bind(mod .. " + mouse:272", hl.dsp.window.drag(), "Move a floating window", { mouse = true })
bind(mod .. " + mouse:273", hl.dsp.window.resize(), "Resize a floating window", { mouse = true })
bind(mod .. " + mouse:274", hl.dsp.window.bring_to_top(), "Bring window to the front", { mouse = true })

for _, rule in ipairs({
    { name = "ssh-askpass", class = "^(ssh-askpass)$" },
    { name = "pinentry", title = "^(pinentry)$" },
    { name = "mpv", class = "^(mpv)$" },
    { name = "matplotlib", class = "^(matplotlib)$" },
    { name = "zoom", class = "^([Zz]oom.*|zoom-us)$" },
    { name = "zoom-menus", title = "^([Zz]oom.*|menu window)$" },
}) do
    local match = {}
    if rule.class then match.class = rule.class end
    if rule.title then match.title = rule.title end
    hl.window_rule({ name = "float-" .. rule.name, match = match, float = true })
end

-- Add the help binding last so the menu contains every shortcut.
local helpText = table.concat(shortcutHelp, "\n")
bind(mod .. " + F1", hl.dsp.exec_cmd(
    "printf '%s\\n' " .. shellQuote(helpText) .. " | rofi -dmenu -i -p 'Keyboard shortcuts'"
), "Display defined keybindings")
