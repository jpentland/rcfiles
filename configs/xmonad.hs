import XMonad
import XMonad.Actions.GridSelect
import XMonad.Layout.Tabbed
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.InsertPosition
import XMonad.Util.Run(spawnPipe)
import XMonad.Util.EZConfig(additionalKeys)
import XMonad.Actions.CycleWS
import System.IO
import XMonad.Layout.NoBorders
import XMonad.Hooks.UrgencyHook
import XMonad.Hooks.FloatNext
import XMonad.Layout.SubLayouts
import XMonad.Layout.WindowNavigation
import XMonad.Layout.BoringWindows
import XMonad.Layout.ResizableTile
import XMonad.Hooks.SetWMName
import XMonad.Prompt
import XMonad.Prompt.Window
import Graphics.X11.ExtraTypes.XF86
import XMonad.Layout.NoBorders
import XMonad.Actions.WindowGo
import qualified XMonad.StackSet as W
import qualified XMonad.Layout.Renamed as XLR
import XMonad.Util.Themes
import XMonad.Util.NamedScratchpad

import qualified Data.Map as M

resizableTall = ResizableTall 1 (3/100) (1/2) []

myLayout = (avoidStruts $ smartBorders $
            (windowNavigation $ subTabbed $ boringWindows $ resizableTall)
            ||| (windowNavigation $ boringWindows $ Full)
            ||| (windowNavigation $ boringWindows $ tabbed shrinkText myTheme))

myStartup = do
    spawn "~/.xmonad/startup.sh"

myTerminal = "st"

customManageHooks = composeAll
    [ resource =? "Do"    --> doFloat,
      resource =? "Yakuake" --> doFloat,
      resource =? "yakuake" --> doFloat,
      resource =? "yad" --> doFloat]

myManageHook = manageDocks <+>
               customManageHooks <+>
               floatNextHook <+>
               manageHook defaultConfig <+>
               namedScratchpadManageHook myScratchpads

myTheme = defaultTheme { fontName = "xft:DejaVu Sans:size=12" }

myScratchpads = [
  NS "terminal" spawnTerm findTerm manageTerm,
  NS "mixer" spawnMixer findMixer manageMixer,
  NS "spotify" spawnSpotify findSpotify manageSpotify
  ]
  where
    spawnTerm = myTerminal ++ " -c scratchpad"
    findTerm = className =? "scratchpad"
    manageTerm = customFloating $ W.RationalRect l t w h
      where
        h = 0.3
        w = 1
        t = 0.02
        l = (1 - w) / 2
    spawnMixer = "pavucontrol"
    findMixer = className =? "Pavucontrol"
    manageMixer = customFloating $ W.RationalRect l t w h
      where
        h = 0.4
        w = 1
        t = 0.02
        l = (1 - w)/2
    spawnSpotify = "spotify"
    findSpotify = className =? "Spotify"
    manageSpotify = customFloating $ W.RationalRect l t w h
      where
        h = 1
        w = 0.4
        t = 0
        l = 0

main = do
  xmproc <- spawnPipe "xmobar"
  xmonad $ defaultConfig
    { borderWidth    = 1
    , terminal    = myTerminal
    , normalBorderColor = "#444444"
    , focusedBorderColor = "#8888dd"
    , keys          = \c -> mykeys c `M.union` keys defaultConfig c
    , mouseBindings = myMouseBindings
    , layoutHook = myLayout
    , manageHook = myManageHook
    , logHook = dynamicLogWithPP xmobarPP
                        { ppOutput = hPutStrLn xmproc
                        , ppTitle = xmobarColor "green" "" . shorten 50
                        }
    , modMask = mod4Mask
    , focusFollowsMouse = False
    , clickJustFocuses = False
    , startupHook = myStartup >> setWMName "LG3D"
    , handleEventHook = docksEventHook <+> handleEventHook defaultConfig
    }
  where
  mykeys (XConfig {modMask = modm}) = M.fromList $
    [ ((modm , xK_g), goToSelected defaultGSConfig)
    , ((modm , xK_z), spawn "slock")
    , ((modm .|. controlMask , xK_z), spawn "slock & sleep 2s && systemctl suspend")
    , ((modm,               xK_Right),  nextWS)
    , ((modm,               xK_Left),    prevWS)
    , ((modm .|. shiftMask, xK_Right),  shiftToNext)
    , ((modm .|. shiftMask, xK_Left),    shiftToPrev)
    , ((modm,               xK_Down), nextScreen)
    , ((modm,               xK_Up),  prevScreen)
    , ((modm .|. shiftMask, xK_Down), shiftNextScreen)
    , ((modm .|. shiftMask, xK_Up),  shiftPrevScreen)
    , ((modm, xK_x),        focusUrgent)
    , ((modm, xK_e),        toggleFloatNext)
    , ((modm .|. shiftMask, xK_e),  toggleFloatAllNew)
    , ((modm .|. controlMask, xK_h), sendMessage $ pullGroup L)
    , ((modm .|. controlMask, xK_l), sendMessage $ pullGroup R)
     , ((modm .|. controlMask, xK_k), sendMessage $ pullGroup U)
     , ((modm .|. controlMask, xK_j), sendMessage $ pullGroup D)
    , ((modm .|. mod1Mask, xK_k), sendMessage MirrorExpand)
    , ((modm .|. mod1Mask, xK_j), sendMessage MirrorShrink)

     , ((modm .|. controlMask, xK_m), withFocused (sendMessage . MergeAll))
     , ((modm .|. controlMask, xK_u), withFocused (sendMessage . UnMerge))

    , ((modm .|. controlMask, xK_period), onGroup W.focusDown')
    , ((modm .|. controlMask, xK_comma), onGroup W.focusUp')

    , ((modm, xK_j), focusDown)
    , ((modm, xK_k), focusUp)

    ,((modm, xK_b     ), sendMessage ToggleStruts)

    , ((modm, xK_p), spawn "exe=`dmenu_path | dmenu` && eval \"exec $exe\"")

    , ((0, xF86XK_AudioRaiseVolume), spawn "pactl set-sink-volume @DEFAULT_SINK@ +1.5%")
    , ((0, xF86XK_AudioLowerVolume), spawn "pactl set-sink-volume @DEFAULT_SINK@  -1.5%")
    , ((0, xF86XK_AudioMute), spawn "pactl set-sink-mute @DEFAULT_SINK@ toggle")

    , ((0, xF86XK_MonBrightnessUp), spawn "~/.local/bin/backlight.sh +5")
    , ((0, xF86XK_MonBrightnessDown), spawn "~/.local/bin/backlight.sh -5")

    , ((controlMask, xK_Pause), spawn "~/.xmonad/mediacontrol.sh playpause")
    , ((0, xF86XK_AudioPause), spawn "~/.xmonad/mediacontrol.sh pause")
    , ((0, xF86XK_AudioPlay), spawn "~/.xmonad/mediacontrol.sh play")
    , ((0, xF86XK_AudioNext), spawn "~/.xmonad/mediacontrol.sh next")
    , ((0, xF86XK_AudioPrev), spawn "~/.xmonad/mediacontrol.sh previous")
    , ((modm .|. shiftMask, xK_p), raise (className =? "Pidgin"))
    , ((modm .|. shiftMask, xK_o), raise (className =? "Spotify"))
    , ((modm .|. shiftMask, xK_i), windowPrompt def { autoComplete = Just 50000 } Goto allWindows)
    , ((0, xK_F12), namedScratchpadAction myScratchpads "terminal")
    , ((modm, xK_F12), namedScratchpadAction myScratchpads "mixer")
    , ((0, xK_F11), namedScratchpadAction myScratchpads "spotify")
    ]

myMouseBindings (XConfig {XMonad.modMask = modMask}) = M.fromList $
    [ ((modMask, button1), (\w -> focus w >> mouseMoveWindow w))
    , ((modMask, button2), (\w -> focus w >> windows W.swapMaster))
    , ((modMask, button3), (\w -> focus w >> mouseResizeWindow w))
    , ((modMask, button5), (\_ -> nextWS))
    , ((modMask, button4), (\_ -> prevWS))
    ]

