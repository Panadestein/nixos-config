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
import XMonad.Actions.CycleWS

-- Data
import Data.Maybe (fromJust)
import qualified Data.Map as M

-- Layouts
import XMonad.Layout.Spacing

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
myLayout = Tall 1 (3/100) (1/2)
        ||| Mirror (Tall 1 (3/100) (1/2))
        ||| Full

-- Change focused color
myFocusedBorderColor = "#267CB9"

-- Workspaces
myWorkspaces = ["dev", "tty", "doc", "www", "msg", "art", "rnd"]
myWorkspaceIndices = M.fromList $ zipWith (,) myWorkspaces [1..] -- (,) == \x y -> (x,y)

clickable ws = "<action=xdotool key super+"++show i++">"++ws++"</action>"
           where i = fromJust $ M.lookup ws myWorkspaceIndices

-- Configuration
myConfig = def
    {
      modMask = mod4Mask -- Rebind Mod to Super key
    , layoutHook = spacingRaw True (Border 0 5 5 5) True (Border 5 5 5 5) True
                 $ myLayout
    , handleEventHook    = fullscreenEventHook
    , startupHook        = myStartupHook
    , manageHook         = myManageHook
    , focusedBorderColor = myFocusedBorderColor
    , workspaces         = myWorkspaces
    }
    `additionalKeysP`
    [
      -- Keybinding for useful programs
      ("M-<Return>" , spawn "alacritty")
    , ("M-S-<Return>" , spawn "alacritty -e ipython")
    , ("M-w" , spawn "firefox")
    , ("M-r" , spawn "rofi -show drun")
    , ("M-e" , spawn "emacsclient -c")
    , ("M-S-f" , spawn "nautilus")
    , ("M-f" , spawn "alacritty -e ranger")
    , ("<Print>" , spawn "maim -s | xclip -selection clipboard -t image/png")
      -- Multiple screens
    , ("M-m" , spawn "$HOME/.config/scripts/randr_conf.sh && nitrogen --restore &")
      -- Helpful commands
    , ("M-S-l" , spawn "dm-tool lock")
    , ("M-<Left>" , prevWS)
    , ("M-<Right>" , nextWS)
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
    [ className =? "Gimp"            --> doFloat
    , className =? "TelegramDesktop" --> doFloat 
    , isDialog                       --> doFloat
    , isFullscreen                   --> doFullFloat
    , className =? "Firefox"         --> doShift ( myWorkspaces !! 3 )
    , className =? "Slack"           --> doShift ( myWorkspaces !! 4 )
    , className =? "Mattermost"      --> doShift ( myWorkspaces !! 4 )
    , className =? "Skype"           --> doShift ( myWorkspaces !! 6 )
    , className =? "zoom"            --> doShift ( myWorkspaces !! 6 )
    ]

-- Startup hook
myStartupHook :: X ()
myStartupHook = do
  spawn "killall trayer"
  spawn ("sleep 2 && trayer --edge top --align right --SetDockType true --SetPartialStrut true --expand true --width 3 --transparent true --tint 0x5f5f5f --height 21 --iconspacing 1")
  spawnOnce "nitrogen --restore &"
  spawnOnce "volumeicon"

-- Xmobar configuration
myXmobarPP :: PP
myXmobarPP = def
    { ppSep             = magenta " • "
    , ppTitleSanitize   = xmobarStrip
    , ppTitle           = blued . shorten 30
    , ppCurrent         = blue . wrap (blue "[") (blue "]")
    , ppHidden          = blued . wrap " " "" . clickable
    , ppHiddenNoWindows = lowWhite . wrap " " "" . clickable
    , ppUrgent          = red . wrap (yellow "!") (yellow "!")
    }
  where
    blue, lowWhite, magenta, red, white, yellow :: String -> String
    magenta  = xmobarColor "#ff79c6" ""
    blue     = xmobarColor "#bd93f9" ""
    blued    = xmobarColor "#267CB9" ""
    white    = xmobarColor "#f8f8f2" ""
    yellow   = xmobarColor "#f1fa8c" ""
    red      = xmobarColor "#ff5555" ""
    lowWhite = xmobarColor "#bbbbbb" ""
