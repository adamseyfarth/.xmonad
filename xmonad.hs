import XMonad
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Util.Run(spawnPipe)
import XMonad.Util.EZConfig(additionalKeys)
import System.IO

myLayouts = tiled ||| Full
  where
    tiled = Tall nmaster delta ratio
    -- The default number of windows in the master pane
    nmaster = 1

    -- Default portion of screen occupied by master pane
    ratio = 7/12

    -- Portion of screen to increment by when resizing panes
    delta = 1/60

main :: IO ()
main = do
  xmproc <- spawnPipe "/usr/bin/xmobar /home/aseyfarth/.xmobarrc"
  xmonad $ defaultConfig
    { manageHook = manageDocks <+> manageHook defaultConfig
    , layoutHook = avoidStruts myLayouts
    , modMask = mod4Mask
    , terminal = "urxvt"
    , logHook = dynamicLogWithPP xmobarPP
                { ppOutput = hPutStrLn xmproc
                , ppTitle = xmobarColor "green" "" . shorten 50
                }
    } `additionalKeys`
    [ ((mod4Mask .|. shiftMask, xK_z), spawn "xscreensaver-command -lock")
    -- Allow/disallow covering of xmobar+trayer
    , ((mod4Mask, xK_b), sendMessage ToggleStruts)
    ]
