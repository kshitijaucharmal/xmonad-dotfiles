--
-- xmonad example config file.
--
-- A template showing all available configuration hooks,
-- and how to override the defaults in your own xmonad.hs conf file.
--
-- Normally, you'd only override those defaults you care about.
--

import XMonad
import Data.Monoid
import System.Exit
import XMonad.Util.SpawnOnce
import XMonad.Util.Cursor
import XMonad.Util.Run
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.DynamicLog
import XMonad.Layout.Spacing
import XMonad.Layout.ToggleLayouts
import qualified XMonad.StackSet as W
import qualified Data.Map        as M
import System.IO
import XMonad.Hooks.WorkspaceHistory
import XMonad.Actions.CycleWS
import XMonad.Layout.Fullscreen
--import XMonad.Util.ClickableWorkspaces

import Control.Monad (liftM2)
import XMonad.Hooks.ManageHelpers
import XMonad.Hooks.SetWMName
import XMonad.Hooks.FadeInactive
import XMonad.Layout.Fullscreen
import XMonad.Layout.NoBorders
import XMonad.Layout.Spiral
import XMonad.Layout.Tabbed
import XMonad.Layout.ThreeColumns
import XMonad.Actions.GridSelect
import XMonad.Util.Themes
import XMonad.Layout.MultiToggle.Instances (StdTransformers(FULL, NBFULL, MIRROR, NOBORDERS))

import qualified XMonad.Layout.MultiToggle as MT (Toggle(..))

-- The preferred terminal program, which is used in a binding below and by
-- certain contrib modules.
--
myTerminal      = "alacritty"

-- Whether focus follows the mouse pointer.
myFocusFollowsMouse :: Bool
myFocusFollowsMouse = True

-- Whether clicking on a window to focus also passes the click to the window
myClickJustFocuses :: Bool
myClickJustFocuses = False

-- Width of the window border in pixels.
--
myBorderWidth   = 2

-- modMask lets you specify which modkey you want to use. The default
-- is mod1Mask ("left alt").  You may also consider using mod3Mask
-- ("right alt"), which does not conflict with emacs keybindings. The
-- "windows key" is usually mod4Mask.
--
myModMask       = mod4Mask

-- The default number of workspaces (virtual screens) and their names.
-- By default we use numeric strings, but any string may be used as a
-- workspace name. The number of workspaces is determined by the length
-- of this list.
--
-- A tagging example:
--
-- > workspaces = [" \xf269 ", "irc", " \xf121 " ] ++ map show [4..9]
--
-- \xf269 firefox
xmobarEscape = concatMap doubleLts
  where doubleLts '<' = "<<"
        doubleLts x    = [x]

-- icons for workspaces
web = " \xf269 "
code = " \xf121 "
files = " \xf07b "
music = " \xf001 "
game = " \xf11b "
video = " \xf03d "

myClickableWorkspaces    = clickable . (map xmobarEscape) $ [ web, code, files, music, game, video]
    where                                                                       
         clickable l = [ "<action=xdotool key super+" ++ show (n) ++ ">" ++ ws ++ "</action>" |
                             (i,ws) <- zip [1..7] l,                                        
                            let n = i ]

myWorkspaces = [ web, code, files, music, game, video]
------------------------------------------------------------------------
-- Window rules:

-- Execute arbitrary actions and WindowSet manipulations when managing
-- a new window. You can use this to, for example, always float a
-- particular program, or have a client always appear on a particular
-- workspace.
--
-- To find the property name associated with a program, use
-- > xprop | grep WM_CLASS
-- and click on the client you're interested in.
--
-- To match on the WM_NAME, you can use 'title' in the same way that
-- 'className' and 'resource' are used below.
--
myManageHook :: Query (Data.Monoid.Endo WindowSet)
myManageHook = composeAll
    [ className =? "MPlayer"        --> doFloat
    -- , className =? "Gimp-2.10"      --> doFloat
    , className =? "Brave-browser"  --> doShift "<action=xdotool key super+1> \xf269 </action>" --  web

    , className =? "Subl"           --> doShift "<action=xdotool key super+2> \xf121 </action>" -- code
    , className =? "code-oss"       --> doShift "<action=xdotool key super+2> \xf121 </action>" -- code
    , className =? "Atom"           --> doShift "<action=xdotool key super+2> \xf121 </action>" -- code
    , className =? "MonoDevelop"           --> doShift "<action=xdotool key super+2> \xf121 </action>" -- code

    -- , className =? "Org.gnome.Nautilus" --> doShift "<action=xdotool key super+3> \xf07b </action>" -- files
    , className =? "DesktopEditors" --> doShift "<action=xdotool key super+3> \xf07b </action>" -- files

    , className =? "Spotify"        --> doShift "<action=xdotool key super+4> \xf001 </action>" -- music

    , className =? "UnityHub"       --> doShift "<action=xdotool key super+5> \xf11b </action>" -- game
    , className =? "Unity"          --> doShift "<action=xdotool key super+5> \xf11b </action>" -- game
    , className =? "Blender"        --> doShift "<action=xdotool key super+5> \xf11b </action>" -- game
    , className =? "Lutris"         --> doShift "<action=xdotool key super+5> \xf11b </action>" -- game
    , className =? "hollow knight.exe"  --> doShift "<action=xdotool key super+5> \xf11b </action>" -- game
    , className =? "retroarch"       --> doShift "<action=xdotool key super+5> \xf11b </action>" -- game

    , className =? "obs"            --> doShift "<action=xdotool key super+6> \xf03d 77</action>" -- video
    , className =? "VirtualBox Manager" --> doFloat
    , resource  =? "desktop_window" --> doIgnore
    , resource  =? "kdesktop"       --> doIgnore ]

-- Border colors for unfocused and focused windows, respectively.
--
myNormalBorderColor  = "#000000";
myFocusedBorderColor = "#0597F2"

------------------------------------------------------------------------
-- Key bindings. Add, modify or remove key bindings here.
--
myKeys conf@(XConfig {XMonad.modMask = modm}) = M.fromList $

    -- launch a terminal
    [ ((modm,               xK_Return), spawn $ XMonad.terminal conf)

    -- launch dmenu
    , ((modm,               xK_p     ), spawn "LC_CTYPE=en_US.UTF-8 dmenu_run")

    -- launch gmrun
    , ((modm .|. shiftMask, xK_p     ), spawn "gmrun")

    -- launch quicklinks
    , ((modm .|. shiftMask, xK_l     ), spawn "quicklinks")

    -- launch blender
    , ((modm,               xK_b     ), spawn "blender")

    -- lauch Atom
    , ((modm,               xK_a     ), spawn "atom")

    -- launch files
    , ((modm,               xK_x     ), spawn "GTK_THEME=Sweet-Dark-v40 nautilus")

    -- , ((modm .|. shiftMask, xK_Down  ), shiftToPrev <+> prevWS)

    -- , ((modm .|. shiftMask, xK_Up    ), shiftToNext <+> nextWS)

    , ((modm,               xK_Down  ), prevWS)

    , ((modm,               xK_Up    ), nextWS)

    -- launch rofi
    , ((controlMask,        xK_space ), spawn "GTK_THEME=Sweet-Dark-v40 rofi -show drun")

    -- launch spotify
    , ((modm,               xK_s     ), spawn "snap run spotify")

    -- launch UnityHub
    , ((modm,               xK_u     ), spawn "~/Applications/UnityHub.AppImage")

    -- launch vimb
    , ((modm,               xK_v     ), spawn "vimb https://duckduckgo.com")

    -- toggle hide xmobar
    , ((modm,               xK_z     ), sendMessage NextLayout >> sendMessage ToggleStruts)

    -- reboot
    , ((modm .|. shiftMask, xK_z     ), spawn "systemctl reboot")

    -- poweroff
    , ((modm .|. shiftMask, xK_x     ), spawn "systemctl poweroff")

    -- increase volume 
    , ((modm .|. shiftMask, xK_Right ), spawn "amixer set Master 5%+ unmute")

    -- decrease volume
    , ((modm .|. shiftMask, xK_Left  ), spawn "amixer set Master 5%- unmute")

    -- increase brightness 
    , ((modm .|. shiftMask, xK_Up    ), spawn "lux -a 5%")

    -- decrease brightness
    , ((modm .|. shiftMask, xK_Down  ), spawn "lux -s 5%")

    -- launch browser
    , ((modm,               xK_f     ), spawn "brave")

    -- launch firefox
    , ((modm .|. shiftMask, xK_p     ), spawn "rofi-pass --last-used")

    -- launch vimb
    , ((modm .|. shiftMask, xK_f     ), spawn "vimb www.duckduckgo.com")

    -- close focused window
    , ((modm,               xK_c     ), kill)

     -- Rotate through the available layout algorithms
    , ((modm,               xK_space ), sendMessage NextLayout)

    --  Reset the layouts on the current workspace to default
    , ((modm .|. shiftMask, xK_space ), setLayout $ XMonad.layoutHook conf)

    -- Resize viewed windows to the correct size
    , ((modm,               xK_n     ), refresh)

    -- Move focus to the next window
    , ((modm,               xK_Tab   ), windows W.focusDown)

    -- Move focus to the next window
    , ((modm,               xK_j     ), windows W.focusDown)

    -- Move focus to the previous window
    , ((modm,               xK_k     ), windows W.focusUp  )

    -- Move focus to the master window
    , ((modm,               xK_m     ), windows W.focusMaster  )

    -- Swap the focused window and the master window
    , ((modm .|. shiftMask, xK_Return), windows W.swapMaster)

    -- Swap the focused window with the next window
    , ((modm .|. shiftMask, xK_j     ), windows W.swapDown  )

    -- Swap the focused window with the previous window
    , ((modm .|. shiftMask, xK_k     ), windows W.swapUp    )

    -- Shrink the master area
    , ((modm,               xK_h     ), sendMessage Shrink)

    -- Expand the master area
    , ((modm,               xK_l     ), sendMessage Expand)

    -- Push window back into tiling
    , ((modm,               xK_t     ), withFocused $ windows . W.sink)

    -- Increment the number of windows in the master area
    , ((modm              , xK_comma ), sendMessage (IncMasterN 1))

    -- Deincrement the number of windows in the master area
    , ((modm              , xK_period), sendMessage (IncMasterN (-1)))

    -- Toggle the status bar gap
    -- Use this binding with avoidStruts from Hooks.ManageDocks.
    -- See also the statusBar function from Hooks.DynamicLog.
    --
    -- , ((modm              , xK_b     ), sendMessage ToggleStruts)

    -- Quit xmonad
    , ((modm .|. shiftMask, xK_q     ), io (exitWith ExitSuccess))

    -- Restart xmonad
    , ((modm              , xK_q     ), spawn "killall xmobar; xmonad --recompile; xmonad --restart")

    -- Run xmessage with a summary of the default keybindings (useful for beginners)
    , ((modm .|. shiftMask, xK_slash ), spawn ("echo \"" ++ help ++ "\" | xmessage -file -"))
    ]
    ++

    --
    -- mod-[1..9], Switch to workspace N
    -- mod-shift-[1..9], Move client to workspace N
    --
    [((m .|. modm, k), windows $ f i)
        | (i, k) <- zip (XMonad.workspaces conf) [xK_1 .. xK_9]
        , (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]]
    ++

    --
    -- mod-{w,e,r}, Switch to physical/Xinerama screens 1, 2, or 3
    -- mod-shift-{w,e,r}, Move client to screen 1, 2, or 3
    --
    [((m .|. modm, key), screenWorkspace sc >>= flip whenJust (windows . f))
        | (key, sc) <- zip [xK_w, xK_e, xK_r] [0..]
        , (f, m) <- [(W.view, 0), (W.shift, shiftMask)]]


------------------------------------------------------------------------
-- Mouse bindings: default actions bound to mouse events
--
myMouseBindings (XConfig {XMonad.modMask = modm}) = M.fromList $

    -- mod-button1, Set the window to floating mode and move by dragging
    [ ((modm, button1), (\w -> focus w >> mouseMoveWindow w
                                       >> windows W.shiftMaster))

    -- mod-button2, Raise the window to the top of the stack
    , ((modm, button2), (\w -> focus w >> windows W.shiftMaster))

    -- mod-button3, Set the window to floating mode and resize by dragging
    , ((modm, button3), (\w -> focus w >> mouseResizeWindow w
                                       >> windows W.shiftMaster))

    -- you may also bind events to the mouse scroll wheel (button4 and button5)
    ]

------------------------------------------------------------------------
-- Layouts:

-- You can specify and transform your layouts by modifying these values.
-- If you change layout bindings be sure to use 'mod-shift-space' after
-- restarting (with 'mod-q') to reset your layout state to the new
-- defaults, as xmonad preserves your old layout settings by default.
--
-- The available layouts.  Note that each layout is separated by |||,
-- which denotes layout choice.
--

myLayout = smartBorders tiled ||| noBorders Full -- ||| Mirror tiled
 where
    -- default tiling algorithm partitions the screen into two panes
    tiled  = spacing 3 $ Tall nmaster delta ratio

    -- The default number of windows in the master pane
    nmaster = 1

    -- Default proportion of screen occupied by master pane
    ratio   = 1/2

    -- Percent of screen to increment by when resizing panes
    delta   = 3/100

-- Color of current window title in xmobar.

------------------------------------------------------------------------
-- Event handling

-- * EwmhDesktops users should change this to ewmhDesktopsEventHook
--
-- Defines a custom handler function for X Events. The function should
-- return (All True) if the default handler is to be run afterwards. To
-- combine event hooks use mappend or mconcat from Data.Monoid.
--
myEventHook = fullscreenEventHook

------------------------------------------------------------------------
-- Status bars and logging

-- Perform an arbitrary action on each internal state change or X event.
-- See the 'XMonad.Hooks.DynamicLog' extension for examples.
--
myLogHook = return ()

------------------------------------------------------------------------
-- Startup hook

-- Perform an arbitrary action each time xmonad starts or is restarted
-- with mod-q.  Used by, e.g., XMonad.Layout.PerWorkspace to initialize
-- per-workspace layout choices.
--
-- By default, do nothing.
myStartupHook = do 
    spawnOnce "nitrogen --restore &"
    spawnOnce "export GTK_THEME=Sweet-Dark-v40"
    spawnOnce "picom &"
    spawnOnce "xsetroot -cursor_name left_ptr &"

------------------------------------------------------------------------
-- Now run xmonad with all the defaults we set up.

-- Run xmonad with the settings you specify. No need to modify this.
--

  -- Used to be #00CC00
xmobarCurrentWorkspaceColor = "#BFE640"
xmobarVisibleColor = "#ff00ff"
xmobarHiddenColor = "#E63F29"
xmobarHiddenNoWindowsColor = "#53E5EB"
xmobarTitleColor = "#00CC00"

                                        -- >> hPutStrLn xmproc2 x
main = do 
  xmproc <- spawnPipe ("xmobar -x 0 /home/kshitij/.config/xmobar/xmobarrc")
  xmonad $ docks defaults {
            -- this adds a fixup for docks
            layoutHook = avoidStruts $ myLayout
            , workspaces = myClickableWorkspaces

            -- this adds Xmobar to Xmonad
            , logHook = workspaceHistoryHook <+> myLogHook <+> dynamicLogWithPP xmobarPP
                    {
                    	  ppOutput = \x -> hPutStrLn xmproc x
			, ppCurrent = xmobarColor xmobarCurrentWorkspaceColor ""
			, ppTitle = xmobarColor xmobarTitleColor "" . shorten 60
			, ppVisible = xmobarColor xmobarVisibleColor ""
			, ppHidden = xmobarColor xmobarHiddenColor ""
			, ppHiddenNoWindows = xmobarColor xmobarHiddenNoWindowsColor ""
			, ppSep = " | "
                    }

            -- this adds a second fixup for docks
            , manageHook = manageDocks <+> myManageHook <+> manageHook def
	        --, startupHook = setWMName "LG3D"
            }

-- A structure containing your configuration settings, overriding
-- fields in the default config. Any you don't override, will
-- use the defaults defined in xmonad/XMonad/Config.hs
--
-- No need to modify this.
--
defaults = def {
      -- simple stuff
        terminal           = myTerminal,
        focusFollowsMouse  = myFocusFollowsMouse,
        clickJustFocuses   = myClickJustFocuses,
        borderWidth        = myBorderWidth,
        modMask            = myModMask,
        workspaces         = myWorkspaces,
        normalBorderColor  = myNormalBorderColor,
        focusedBorderColor = myFocusedBorderColor,

      -- key bindings
        keys               = myKeys,
        mouseBindings      = myMouseBindings,

      -- hooks, layouts
        layoutHook         = myLayout,
        manageHook         = myManageHook,
        handleEventHook    = myEventHook,
        logHook            = myLogHook,
        startupHook        = myStartupHook
    }

-- | Finally, a copy of the default bindings in simple textual tabular format.
help :: String
help = unlines ["The default modifier key is 'alt'. Default keybindings:",
    "",
    "-- launching and killing programs",
    "mod-Shift-Enter  Launch xterminal",
    "mod-p            Launch dmenu",
    "mod-Shift-p      Launch gmrun",
    "mod-Shift-c      Close/kill the focused window",
    "mod-Space        Rotate through the available layout algorithms",
    "mod-Shift-Space  Reset the layouts on the current workSpace to default",
    "mod-n            Resize/refresh viewed windows to the correct size",
    "",
    "-- move focus up or down the window stack",
    "mod-Tab        Move focus to the next window",
    "mod-Shift-Tab  Move focus to the previous window",
    "mod-j          Move focus to the next window",
    "mod-k          Move focus to the previous window",
    "mod-m          Move focus to the master window",
    "",
    "-- modifying the window order",
    "mod-Return   Swap the focused window and the master window",
    "mod-Shift-j  Swap the focused window with the next window",
    "mod-Shift-k  Swap the focused window with the previous window",
    "",
    "-- resizing the master/slave ratio",
    "mod-h  Shrink the master area",
    "mod-l  Expand the master area",
    "",
    "-- floating layer support",
    "mod-t  Push window back into tiling; unfloat and re-tile it",
    "",
    "-- increase or decrease number of windows in the master area",
    "mod-comma  (mod-,)   Increment the number of windows in the master area",
    "mod-period (mod-.)   Deincrement the number of windows in the master area",
    "",
    "-- quit, or restart",
    "mod-Shift-q  Quit xmonad",
    "mod-q        Restart xmonad",
    "mod-[1..9]   Switch to workSpace N",
    "",
    "-- Workspaces & screens",
    "mod-Shift-[1..9]   Move client to workspace N",
    "mod-{w,e,r}        Switch to physical/Xinerama screens 1, 2, or 3",
    "mod-Shift-{w,e,r}  Move client to screen 1, 2, or 3",
    "",
    "-- Mouse bindings: default actions bound to mouse events",
    "mod-button1  Set the window to floating mode and move by dragging",
    "mod-button2  Raise the window to the top of the stack",
    "mod-button3  Set the window to floating mode and resize by dragging"]
