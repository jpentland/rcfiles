import Graphics.X11.ExtraTypes.XF86
import System.IO
import XMonad
import XMonad.Actions.CycleWS
import XMonad.Actions.GridSelect
import XMonad.Actions.WindowGo
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.FloatNext
import XMonad.Hooks.InsertPosition
import XMonad.Hooks.InsertPosition
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.SetWMName
import XMonad.Hooks.UrgencyHook
import XMonad.Layout.BoringWindows
import XMonad.Layout.NoBorders
import XMonad.Layout.ResizableTile
import XMonad.Layout.Simplest
import XMonad.Layout.Spacing
import XMonad.Layout.SubLayouts
import XMonad.Layout.Tabbed
import XMonad.Layout.WindowNavigation
import XMonad.Prompt
import XMonad.Prompt.Window
import XMonad.Util.EZConfig(additionalKeys)
import XMonad.Util.NamedScratchpad
import XMonad.Util.Run(spawnPipe)
import XMonad.Util.Themes
import qualified Data.Map as M
import qualified XMonad.Layout.Renamed as XLR
import qualified XMonad.StackSet as W

resizableTall = ResizableTall 1 (3/100) (1/2) []

role = stringProperty "WM_WINDOW_ROLE"

mySpacing = spacingRaw True (Border 5 5 5 5) True (Border 5 5 5 5) True

myLayout = avoidStruts $ smartBorders $ windowNavigation $ boringWindows
  (XLR.renamed [ XLR.Replace "Tall" ] $ mySpacing $ mySubLayout $ resizableTall)
  ||| (noBorders Full)
  ||| (XLR.renamed [ XLR.Replace "Tabbed" ] $ tabbed shrinkText myTheme)

mySubLayout = subLayout [0,1,2] $
  (Tall 1 (3/100) (1/2))
  ||| (addTabs shrinkText myTheme Simplest)

myStartup = spawn "~/.xmonad/startup.sh"

myTerminal = "st"

customManageHooks = composeAll
    [ resource =? "Do"    --> doFloat,
      resource =? "Yakuake" --> doFloat,
      resource =? "yakuake" --> doFloat,
      resource =? "yad" --> doFloat,
      className =? "Surf" --> insertPosition End Newer]

myManageHook = manageDocks <+>
               customManageHooks <+>
               insertPosition Master Newer <+>
               floatNextHook <+>
               manageHook def <+>
               namedScratchpadManageHook myScratchpads

myTheme = def { fontName = "xft:SauceCodePro Nerd Font:antialias=true:autohint=true:style=Medium,Regular:size=12" }

myScratchpads = [
  NS "terminal" (myTerminal ++ " -c scratchpad") (className =? "scratchpad") (customFloating $ W.RationalRect 0 0.02 1 0.3),
  NS "mixer" "pavucontrol" (className =? "Pavucontrol") (customFloating $ W.RationalRect 0 0.02 1 0.4),
  NS "spotify" "spotify" (className =? "Spotify") (customFloating $ W.RationalRect 0 0 0.4 1),
  NS "pidgin_list" "pidgin" (role =? "buddy_list") (customFloating $ W.RationalRect 0 0.2 0.2 0.8),
  NS "pidgin_conversation" "pidgin" (role =? "conversation") (customFloating $ W.RationalRect 0.6 0.6 0.4 0.4)
  ]

data PidginUrgencyHook = PidginUrgencyHook deriving (Read, Show)
instance UrgencyHook PidginUrgencyHook where
  urgencyHook PidginUrgencyHook w = do
    runQuery (role =? "conversation") w
    namedScratchpadAction myScratchpads "pidgin_conversation"

main = do
  xmproc <- spawnPipe "xmobar"
  xmonad $ withUrgencyHook PidginUrgencyHook $ def
    { borderWidth    = 2
    , terminal    = myTerminal
    , normalBorderColor = "#444444"
    , focusedBorderColor = "#8888dd"
    , keys          = \c -> mykeys c `M.union` keys def c
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
    , handleEventHook = docksEventHook <+> handleEventHook def
    }
  where
  mykeys XConfig {modMask = modm} = M.fromList
    [ ((modm , xK_g), goToSelected def)
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
    , ((modm, xK_e),        toggleFloatNext)
    , ((modm .|. shiftMask, xK_e),  toggleFloatAllNew)
    , ((modm .|. controlMask, xK_h), sendMessage $ pullGroup L)
    , ((modm .|. controlMask, xK_l), sendMessage $ pullGroup R)
    , ((modm .|. controlMask, xK_k), sendMessage $ pullGroup U)
    , ((modm .|. controlMask, xK_j), sendMessage $ pullGroup D)
    , ((modm .|. mod1Mask, xK_period), sendMessage MirrorExpand)
    , ((modm .|. mod1Mask, xK_comma), sendMessage MirrorShrink)

    , ((modm .|. controlMask, xK_m), withFocused (sendMessage . MergeAll))
    , ((modm .|. controlMask, xK_u), withFocused (sendMessage . UnMerge))
    , ((modm .|. controlMask, xK_space), toSubl NextLayout)
    , ((modm .|. controlMask, xK_comma), toSubl (IncMasterN 1))
    , ((modm .|. controlMask, xK_period), toSubl (IncMasterN (-1)))

    , ((modm, xK_j), windows W.focusDown)
    , ((modm, xK_k), windows W.focusUp)
    , ((modm .|. mod1Mask, xK_j), focusDown)
    , ((modm .|. mod1Mask, xK_k), focusUp)

    , ((modm, xK_b), sendMessage ToggleStruts)
    , ((modm, xK_s), toggleWindowSpacingEnabled >> toggleScreenSpacingEnabled)
    , ((modm, xK_d), incWindowSpacing 2 >> incScreenSpacing 2)
    , ((modm, xK_a), decWindowSpacing 2 >> decScreenSpacing 2)

    , ((modm, xK_p), spawn "dmenu_run -l 10")

    , ((0, xF86XK_AudioRaiseVolume), spawn "pactl set-sink-volume @DEFAULT_SINK@ +1.5%")
    , ((0, xF86XK_AudioLowerVolume), spawn "pactl set-sink-volume @DEFAULT_SINK@  -1.5%")
    , ((0, xF86XK_AudioMute), spawn "pactl set-sink-mute @DEFAULT_SINK@ toggle")
    , ((modm, xK_equal), spawn "pactl set-sink-volume @DEFAULT_SINK@ +1.5%")
    , ((modm, xK_minus), spawn "pactl set-sink-volume @DEFAULT_SINK@  -1.5%")
    , ((modm, xK_0), spawn "pactl set-sink-mute @DEFAULT_SINK@ toggle")

    , ((0, xF86XK_MonBrightnessUp), spawn "backlight.sh +5")
    , ((0, xF86XK_MonBrightnessDown), spawn "backlight.sh -5")
    , ((modm .|. shiftMask, xK_equal), spawn "backlight.sh +5")
    , ((modm .|. shiftMask, xK_minus), spawn "backlight.sh -5")

    , ((0, xF86XK_AudioPause), spawn "playerctl pause")
    , ((0, xF86XK_AudioPlay), spawn "playerctl play")
    , ((0, xF86XK_AudioNext), spawn "playerctl next")
    , ((0, xF86XK_AudioPrev), spawn "playerctl previous")
    , ((modm .|. shiftMask, xK_i), windowPrompt def { autoComplete = Just 50000 } Goto allWindows)
    , ((0, xK_F12), namedScratchpadAction myScratchpads "terminal")
    , ((modm, xK_F12), namedScratchpadAction myScratchpads "mixer")
    , ((0 .|. mod1Mask, xK_F12), namedScratchpadAction myScratchpads "spotify")
    , ((modm .|. shiftMask, xK_p), namedScratchpadAction myScratchpads "pidgin_list")
    , ((modm .|. mod1Mask, xK_p), namedScratchpadAction myScratchpads "pidgin_conversation")
    , ((modm .|. shiftMask, xK_x), spawn "btmenu")
    , ((modm, xK_x), spawn "networkmanager_dmenu")
    , ((modm, xK_q), spawn "~/rcfiles/dmenu-emoji/dmenu-emoji.sh -l 10")
    , ((modm, xK_w), spawn "bookmark")
    , ((modm .|. shiftMask, xK_w), spawn "bookmark -n")
    , ((modm, xK_m), spawn "mpw-dmenu")
    , ((modm .|. shiftMask, xK_m), spawn "dmenu-pass")
    , ((modm .|. mod1Mask, xK_m), spawn "dmenu-pass add")
    ]

myMouseBindings XConfig {XMonad.modMask = modMask} = M.fromList
    [ ((modMask, button1), \w -> focus w >> mouseMoveWindow w)
    , ((modMask, button2), \w -> focus w >> windows W.swapMaster)
    , ((modMask, button3), \w -> focus w >> mouseResizeWindow w)
    , ((modMask, button5), const nextWS)
    , ((modMask, button4), const prevWS)
    ]

