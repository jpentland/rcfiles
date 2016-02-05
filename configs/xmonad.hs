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

import qualified Data.Map as M

myLayout = (layoutHook defaultConfig) ||| simpleTabbed
--myLayout = Tall 1 (1/2) (1/2) ||| simpleTabbed

myStartup = do
	spawn "feh --bg-scale $(cat ~/.xmonadbg)"
	spawn "trayer --expand true --widthtype request --align left"
	spawn "nm-applet"
	spawn "google-chrome"

main = do
  xmproc <- spawnPipe "xmobar"
  xmonad $ defaultConfig
	{ borderWidth	= 1
	, terminal	= "konsole"
	, normalBorderColor = "#444444"
	, focusedBorderColor = "#8888dd"
	, keys          = \c -> mykeys c `M.union` keys defaultConfig c
	, layoutHook = avoidStruts $ smartBorders $ myLayout
	, manageHook = manageDocks <+> floatNextHook <+> manageHook defaultConfig
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
	]

