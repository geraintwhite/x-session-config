import XMonad hiding ((|||))
import XMonad.Actions.SpawnOn
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.FadeInactive as FI
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.ManageHelpers
import XMonad.Hooks.UrgencyHook
import XMonad.Layout.DecorationMadness
import XMonad.Layout.IM
import XMonad.Layout.LayoutCombinators (JumpToLayout (..), (|||))
import XMonad.Layout.Named
import XMonad.Layout.NoBorders
import XMonad.Layout.PerWorkspace
import XMonad.Layout.Reflect
import XMonad.Layout.Grid
import XMonad.Prompt
import XMonad.Prompt.Man
import XMonad.Prompt.Input
import qualified XMonad.StackSet as W
import XMonad.Util.Run (spawnPipe)
import XMonad.Util.EZConfig(additionalKeysP)
import qualified Data.Map as M
import Data.Ratio
import System.Exit
import System.IO

myTerminal = "urxvt"
myWorkspaces = ["1:main","2:web","3:social","4:media"] ++ map show [5..9]

basic :: Tall a
basic = Tall nmaster delta ratio
  where
	-- The default number of windows in the master pane
	nmaster = 1
	-- Percent of screen to increment by when resizing panes
	delta   = 3/100
	-- Default proportion of screen occupied by master pane
	ratio   = 1/2
 
myLayout = smartBorders $ onWorkspace "3:social" imLayout $ onWorkspace "1:main" codeLayout $ onWorkspace "4:media" mediaLayout standardLayouts
  where
	standardLayouts = tall ||| wide ||| full ||| circle
	tall   = named "tall"   $ avoidStruts basic
	wide   = named "wide"   $ avoidStruts $ Mirror basic
	circle = named "circle" $ avoidStruts circleSimpleDefaultResizable
	full   = named "full"   $ noBorders Full
 
   -- IM layout (http://pbrisbin.com/posts/xmonads_im_layout)
	imLayout =
		named "im" $ avoidStruts $ withIM (1%9) pidginRoster $ reflectHoriz $
								   withIM (1%8) skypeRoster standardLayouts
	pidginRoster = ClassName "Pidgin" `And` Role "buddy_list"
	skypeRoster  = ClassName "Skype"  `And` Role ""

	codeLayout =
		named "code" $ avoidStruts $ Mirror $ Tall nmaster delta ratio
	  where
		nmaster = 1
		ratio = 80/100
		delta = 2/100

	mediaLayout =
		named "media" $ avoidStruts $ Tall nmaster delta ratio
	  where
		nmaster = 1
		ratio = 59/100
		delta = 2/100

-- Set up the Layout prompt
myLayoutPrompt :: X ()
myLayoutPrompt = inputPromptWithCompl myXPConfig "Layout"
				 (mkComplFunFromList' allLayouts) ?+ (sendMessage . JumpToLayout)
  where
	allLayouts = ["tall", "wide", "circle", "full"]
 
	myXPConfig :: XPConfig
	myXPConfig = defaultXPConfig { 
		autoComplete= Just 1000
	}

myManageHook :: ManageHook
myManageHook = manageSpawn <+> manageDocks
			   <+> fullscreenManageHook <+> myFloatHook
			   <+> manageHook defaultConfig
  where fullscreenManageHook = composeOne [ isFullscreen -?> doFullFloat ]
  
myFloatHook = composeAll
	[ className =? "Gnome-system-monitor"  --> doFloat
	, className =? "QtTest.py"             --> doFloat
    , className =? "Thunderbird"           --> moveToWeb
    , className =? "Google-chrome"         --> moveToWeb
    , className =? "Pidgin"                --> moveToIM
    , classNotRole ("Pidgin", "buddy_list")--> doFloat
    , className =? "Skype"                 --> moveToIM
    , classNotRole ("Skype", "")           --> doFloat
    , className =? "Mumble"                --> moveToIM
    , className =? "nuvolaplayer"          --> moveToMedia
    , className =? "Subl"                  --> moveToMain
    , className =? "URxvt"                 --> moveToMain
	, manageDocks]
  where
	moveToIM    = doF $ W.shift "3:social"
	moveToWeb   = doF $ W.shift "2:web"
	moveToMedia = doF $ W.shift "4:media"
	moveToMain  = doF $ W.shift "1:main"

	classNotRole :: (String, String) -> Query Bool
	classNotRole (c,r) = className =? c <&&> role /=? r

	role = stringProperty "WM_WINDOW_ROLE"

myStatusBar = "xmobar ~/.xmonad/xmobar2.hs" --define first xmobar

myStartupHook :: X ()
myStartupHook = do
	spawn "gnome-settings-daemon"
	spawn "xmobar ~/.xmonad/xmobar.hs" --start second xmobar
	spawn "trayer --edge top --align right --SetDockType true --SetPartialStrut true --expand true --width 10 --transparent true --tint 0x000000 --height 16"

defaults = defaultConfig { workspaces = myWorkspaces
		, layoutHook = myLayout
		, manageHook = myManageHook
		, startupHook = myStartupHook
		, terminal = myTerminal
		, normalBorderColor  = "#7c7c7c"
		, focusedBorderColor = "#ffb6b0"
		, borderWidth = 1
		, modMask = mod4Mask
		} `additionalKeysP`
		[ ("M4-C-<Delete>", spawn "gnome-system-monitor")
		, ("M4-C-l", spawn "xscreensaver-command -lock")
		, ("M4-S-<Return>", spawnHere "urxvt")
		, ("<Print>", spawn "scrot -e 'mv $f ~/Pictures/screenshots; python ~/python/copyImg.py ~/Pictures/screenshots/$f'")
		, ("M4-<Print>", spawn "sleep 0.2; scrot -u -e 'mv $f ~/Pictures/screenshots; python ~/python/copyImg.py ~/Pictures/screenshots/$f'")
		, ("M4-C-<Print>", spawn "sleep 0.2; scrot -s -e 'mv $f ~/Pictures/screenshots; python ~/python/copyImg.py ~/Pictures/screenshots/$f'")
		, ("M4-p", spawn "exe=`dmenu_path | yeganesh -- -i -b -sb orange -nb black -nf grey` && eval \"exec $exe\"")   
		, ("M4-q",spawn "killall trayer stalonetray xmobar" >> restart "xmonad" True)
		, ("M4-C-<Space>", myLayoutPrompt)
		, ("<XF86HomePage>", spawnHere "google-chrome")
		, ("<XF86Mail>", spawn "thunderbird")
		, ("<XF86Calculator>", spawn "gnome-calculator")
		, ("<XF86Explorer>", spawn "pcmanfm")
		, ("<XF86Tools>", windows $ W.greedyView "4:media")
		, ("<XF86AudioMute>", spawn "amixer -q -D pulse set Master 1+ toggle")
		, ("<XF86AudioRaiseVolume>", spawn "amixer -q set Master 2+ unmute")
		, ("<XF86AudioLowerVolume>", spawn "amixer -q set Master 2- unmute")
		]

main = do
	din <- spawnPipe myStatusBar
	xmonad $ withUrgencyHook NoUrgencyHook defaults {
        logHook = do FI.fadeInactiveLogHook 0xbbbbbbbb
                     dynamicLogWithPP $ xmobarPP {
                           ppOutput = hPutStrLn din
                         , ppTitle  = xmobarColor "#ff66ff" "" . shorten 50
                         , ppUrgent = xmobarColor "yellow" "red" . xmobarStrip
                     }
    }