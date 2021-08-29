-- Simple window management
local sizeup = {}

function sizeup.send_window_prev_monitor()
    hs.alert.show("Prev Monitor")
    local win = hs.window.focusedWindow()
    local nextScreen = win:screen():previous()
    win:moveToScreen(nextScreen)
end

function sizeup.send_window_next_monitor()
    hs.alert.show("Next Monitor")
    local win = hs.window.focusedWindow()
    local nextScreen = win:screen():next()
    win:moveToScreen(nextScreen)
end

function sizeup.resize_window()
    -- Determine which screens we have available
    local bigMon = (hs.screen 'Dell U3419W' or hs.screen 'BenQ EX3501R')
    local lappie = hs.screen 'Built%-in'
    local height = lappie:currentMode().h
    local width = lappie:currentMode().w

    local win = hs.window.focusedWindow()

    if (bigMon ~= nil) then
        height = bigMon:currentMode().h
        width = bigMon:currentMode().w
        local coords = win:screen():frame()
        win:setFrame({coords.x + 760, coords.y + 180, 1920, 1080})
    else
        win:setFrame({0, 0, width, width / ( 1920 / 1080 )})
    end
    
end

-- Reference: https://github.com/derekwyatt/dotfiles/blob/master/hammerspoon-init.lua
-- These are just convenient names for layouts. We can use numbers
-- between 0 and 1 for defining 'percentages' of screen real estate
-- so 'right30' is the window on the right of the screen where the
-- vertical split (x-axis) starts at 70% of the screen from the
-- left, and is 30% wide.
--
-- And so on...
units = {
    right30 = {x = 0.70, y = 0.00, w = 0.30, h = 1.00},
    right70 = {x = 0.30, y = 0.00, w = 0.70, h = 1.00},
    left70 = {x = 0.00, y = 0.00, w = 0.70, h = 1.00},
    left30 = {x = 0.00, y = 0.00, w = 0.30, h = 1.00},
    right50 = {x = 0.50, y = 0.00, w = 0.50, h = 1.00},
    left50 = {x = 0.00, y = 0.00, w = 0.50, h = 1.00},
    top50 = {x = 0.00, y = 0.00, w = 1.00, h = 0.50},
    bot50 = {x = 0.00, y = 0.50, w = 1.00, h = 0.50},
    bot80 = {x = 0.00, y = 0.20, w = 1.00, h = 0.80},
    bot87 = {x = 0.00, y = 0.20, w = 1.00, h = 0.87},
    bot90 = {x = 0.00, y = 0.20, w = 1.00, h = 0.90},
    upright30 = {x = 0.70, y = 0.00, w = 0.30, h = 0.50},
    botright30 = {x = 0.70, y = 0.50, w = 0.30, h = 0.50},
    upleft70 = {x = 0.00, y = 0.00, w = 0.70, h = 0.50},
    botleft70 = {x = 0.00, y = 0.50, w = 0.70, h = 0.50},
    right70top80 = {x = 0.70, y = 0.00, w = 0.30, h = 0.80},
    maximum = {x = 0.00, y = 0.00, w = 1.00, h = 1.00},
    center = {x = 0.05, y = 0.05, w = 0.90, h = 0.90},
    centerLeft = {x = 0.05, y = 0.05, w = 0.45, h = 0.90},
    centerRight = {x = 0.5, y = 0.05, w = 0.45, h = 0.90},
    center1080 = {x = 0.220, y = 0.1, w = 0.56, h = 0.75}
}

--- Multiple Monitor Actions ---
monitor_mash = {"ctrl", "cmd"}
-- Send Window Prev Monitor
hs.hotkey.bind(monitor_mash, "Left", function() sizeup.send_window_prev_monitor() end)
-- Send Window Next Monitor
hs.hotkey.bind(monitor_mash, "Right", function() sizeup.send_window_next_monitor() end)

-- Window actions
window_mash = {"ctrl", "alt"}
center_mash = {"ctrl", "alt", "cmd"}

-- We like to send windows half left and half right
hs.hotkey.bind(window_mash, "Left", function() hs.window.focusedWindow():move(units.left50, nil, true) end)
hs.hotkey.bind(window_mash, "Right", function() hs.window.focusedWindow():move(units.right50, nil, true) end)

-- And then sometimes we want either "full screen" or centered with a border
hs.hotkey.bind(window_mash, "c", function() hs.window.focusedWindow():move(units.center, nil, true) end)
hs.hotkey.bind(window_mash, "f", function() hs.window.focusedWindow():move(units.maximum, nil, true) end)

-- Finally, I use this with streaming when I need to go "center-left" or "center-right"
hs.hotkey.bind(center_mash, "Left", function() hs.window.focusedWindow():move(units.centerLeft, nil, true) end)
hs.hotkey.bind(center_mash, "Right", function() hs.window.focusedWindow():move(units.centerRight, nil, true) end)
-- hs.hotkey.bind(center_mash, "c", function() hs.window.focusedWindow():move(units.center1080, nil, true) end)
hs.hotkey.bind(center_mash, "c", function() sizeup.resize_window() end)

-- Register browser tab typist: Type URL of current tab of running browser in markdown format. i.e. [title](link)
-- This is pretty cool, but I've never really used it...
hstype_keys = {"alt", "V"}
hs.hotkey.bind({"alt"}, "V", function()
    local safari_running = hs.application.applicationsForBundleID("com.apple.Safari")
    local chrome_running = hs.application.applicationsForBundleID("com.google.Chrome")
    if #chrome_running > 0 then
        local stat, data = hs.applescript(
                               'tell application "Google Chrome" to get {URL, title} of active tab of window 1')
        if stat then hs.eventtap.keyStrokes("[" .. data[2] .. "](" .. data[1] .. ")") end
    end
end)

-- This would be pretty cool too!
-- osascript -e 'tell application "Google Chrome" to set active tab index of first window to 3'
-- https://superuser.com/questions/263198/switch-between-google-chrome-tabs-using-applescript

-- Another nice repo of hammerspoon examples: https://github.com/drn/dots/tree/master/hammerspoon

-- Begin splitting things out into modules
require("headphones")
