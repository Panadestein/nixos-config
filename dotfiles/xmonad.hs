-----------------------------------------
-- __  ____  __                       _ 
-- \ \/ /  \/  | ___  _ __   __ _  __| |
--  \  /| |\/| |/ _ \| '_ \ / _` |/ _` |
--  /  \| |  | | (_) | | | | (_| | (_| |
-- /_/\_\_|  |_|\___/|_| |_|\__,_|\__,_|
--
--        Panadestein's XMonad
-----------------------------------------

-- General imports
import XMonad
import XMonad.Util.EZConfig
import XMonad.Util.SpawnOnce
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.ManageHelpers

-- Xmobar related imports
import XMonad.Hooks.DynamicLog
import XMonad.Util.Loggers

-- Main function
main :: IO ()
main = xmonad
     . ewmh
   =<< statusBar "xmobar" myXmobarPP toggleStrutsKey myConfig
  where
    toggleStrutsKey :: XConfig Layout -> (KeyMask, KeySym)
    toggleStrutsKey XConfig{ modMask = m } = (m, xK_b)

-- Define layout
myLayout = Tall 1 (3/100) (1/2) ||| Full

-- Configuration
myConfig = def
    {
      modMask = mod4Mask -- Rebind Mod to Super key
    , layoutHook = myLayout
    , handleEventHook = fullscreenEventHook
    , startupHook = myStartupHook
    , manageHook = myManageHook
    }
    `additionalKeysP`
    [
      -- Keybinding for useful programs
      ("M-<Return>" , spawn "alacritty")
    , ("M-S-<Return>" , spawn "alacritty -e jupyter-console")
    , ("M-w" , spawn "firefox")
    , ("M-r" , spawn "rofi -show drun")
    , ("M-e" , spawn "emacsclient -c")
      -- Multiple screens
    , ("M-m" , spawn "xrandr --output HDMI-A-0 --auto --output eDP --off")
    , ("M-S-m" , spawn "xrandr --output eDP --auto --output HDMI-A-0 --off")
      -- Helpful commands
    , ("M-S-l" , spawn "dm-tool lock")
    , ("<XF86AudioLowerVolume>" , spawn "amixer set Master 5%- unmute")
    , ("<XF86AudioRaiseVolume>" , spawn "amixer set Master 5%+ unmute")
    , ("<XF86MonBrightnessDown>" , spawn "brightnessctl -q s 10%-")
    , ("<XF86MonBrightnessUp>" , spawn "brightnessctl -q s +10%")
      -- Manage sessions
    , ("M-S-x" , spawn "shutdown now")
    , ("M-<Backspace>" , spawn "reboot")
    , ("M-q" , kill) -- Kills focused window
    , ("M-z" , spawn "if type xmonad; then xmonad --recompile && xmonad --restart; else xmessage xmonad not in \\$PATH: \"$PATH\"; fi") -- Refreshes xmonad
    ]

-- Manage hook
myManageHook :: ManageHook
myManageHook = composeAll
    [ className =? "Gimp" --> doFloat
    , className =? "TelegramDesktop" --> doFloat 
    , isDialog            --> doFloat
    ]

-- Startup hook
myStartupHook :: X ()
myStartupHook = do
  spawnOnce "nitrogen --restore &"

-- Xmobar configuration
myXmobarPP :: PP
myXmobarPP = def
    { ppSep             = magenta " • "
    , ppTitleSanitize   = xmobarStrip
    , ppCurrent         = wrap (blue "[") (blue "]")
    , ppHidden          = white . wrap " " ""
    , ppHiddenNoWindows = lowWhite . wrap " " ""
    , ppUrgent          = red . wrap (yellow "!") (yellow "!")
    }
  where
    ppWindow :: String -> String
    ppWindow = xmobarRaw . (\w -> if null w then "untitled" else w) . shorten 30

    blue, lowWhite, magenta, red, white, yellow :: String -> String
    magenta  = xmobarColor "#ff79c6" ""
    blue     = xmobarColor "#bd93f9" ""
    white    = xmobarColor "#f8f8f2" ""
    yellow   = xmobarColor "#f1fa8c" ""
    red      = xmobarColor "#ff5555" ""
    lowWhite = xmobarColor "#bbbbbb" ""
