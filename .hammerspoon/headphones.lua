-- I like to know if my bluetooth headphones connected to this device
-- Reference: https://github.com/zzamboni/hammerspoon-config/blob/master/audio/headphones_watcher.lua
headphonesName = 'WH-1000XM4'
function btHeadphonesConnected()
    localHeadphoneConnected = false
    devices = hs.audiodevice.allOutputDevices()
    for key, value in pairs(devices) do if value:name() == headphonesName then localHeadphoneConnected = true end end
    return localHeadphoneConnected
end

function audiowatch(arg)
    -- If this is a device (dis)connect event, loop through all the devices and see if our headphones appeared
    if arg == 'dev#' then
        newState = btHeadphonesConnected()
        if headphonesConnected ~= newState then
            if newState == true then
                headphonesConnected = true
                hs.alert.show("🎧🎵", {fillColor = {blue = 1}})
            end
            headphonesConnected = newState
        end
    end
end

-- Initialize headphone state and register a watcher to alert us when we connect our bluetooth headphones
headphonesConnected = btHeadphonesConnected()
hs.audiodevice.watcher.setCallback(audiowatch)
hs.audiodevice.watcher.start()


-- 
-- iconAscii = [[ASCII:
-- ............
-- ..1......1..
-- ............
-- ............
-- ............
-- ............
-- .31......14.
-- ............
-- ..1......1..
-- ............
-- ............
-- ............
-- .6........5.
-- ............
-- ]]
-- icon = hs.image.imageFromASCII(iconAscii)
-- menu = hs.menubar.new():setIcon(icon)