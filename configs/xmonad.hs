import XMonad
import XMonad.Actions.GridSelect
import XMonad.Layout.Tabbed
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
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
import qualified XMonad.StackSet as W

import qualified Data.Map as M

myLayout =  (windowNavigation $ subTabbed $ boringWindows $ Tall 1 (3/100) (1/2))
		||| Full
		||| simpleTabbed

myStartup = do
	spawn "xrandr --output eDP1 --auto --output DP2 --right-of eDP1"
	spawn "feh --bg-scale $(cat ~/.xmonadbg)"
	spawn "trayer --expand true --widthtype request --align left"
	spawn "xsetroot -cursor_name left_ptr"
	spawn "nm-applet"
	spawn "volumeicon"
	spawn "gnome-do"

myManageHook = composeAll
	[ resource =? "Do"	--> doFloat ]

main = do
  xmproc <- spawnPipe "xmobar"
  xmonad $ defaultConfig
	{ borderWidth	= 1
	, terminal	= "konsole"
	, normalBorderColor = "#444444"
	, focusedBorderColor = "#8888dd"
	, keys          = \c -> mykeys c `M.union` keys defaultConfig c
	, layoutHook = avoidStruts $ smartBorders $ myLayout
	, manageHook = manageDocks <+> myManageHook <+> floatNextHook <+> manageHook defaultConfig
	, logHook = dynamicLogWithPP xmobarPP
                        { ppOutput = hPutStrLn xmproc
                        , ppTitle = xmobarColor "green" "" . shorten 50
                        }
	, modMask = mod4Mask
	, focusFollowsMouse = False
	, clickJustFocuses = False
	, startupHook = myStartup
	}
 where
  mykeys (XConfig {modMask = modm}) = M.fromList $
	[ ((modm , xK_g), goToSelected defaultGSConfig)
	, ((modm , xK_z), spawn "slock")
	, ((modm,               xK_Right),  nextWS)
	, ((modm,               xK_Left),    prevWS)
	, ((modm .|. shiftMask, xK_Right),  shiftToNext)
	, ((modm .|. shiftMask, xK_Left),    shiftToPrev)
	, ((modm,               xK_Down), nextScreen)
	, ((modm,               xK_Up),  prevScreen)
	, ((modm .|. shiftMask, xK_Down), shiftNextScreen)
	, ((modm .|. shiftMask, xK_Up),  shiftPrevScreen)
	, ((modm, xK_x),		focusUrgent)
	, ((modm, xK_e),		toggleFloatNext)
	, ((modm .|. shiftMask, xK_e),  toggleFloatAllNew)
	, ((modm .|. controlMask, xK_h), sendMessage $ pullGroup L)
	, ((modm .|. controlMask, xK_l), sendMessage $ pullGroup R)
 	, ((modm .|. controlMask, xK_k), sendMessage $ pullGroup U)
 	, ((modm .|. controlMask, xK_j), sendMessage $ pullGroup D)

 	, ((modm .|. controlMask, xK_m), withFocused (sendMessage . MergeAll))
 	, ((modm .|. controlMask, xK_u), withFocused (sendMessage . UnMerge))

	, ((modm .|. controlMask, xK_period), onGroup W.focusDown')
	, ((modm .|. controlMask, xK_comma), onGroup W.focusUp')

	, ((modm, xK_j), focusDown)
	, ((modm, xK_k), focusUp)

	]

