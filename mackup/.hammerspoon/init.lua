local function keyCode(key, modifiers)
    modifiers = modifiers or {}

    return function()
        hs.eventtap.event.newKeyEvent(modifiers, string.lower(key), true):post()
        hs.timer.usleep(1000)
        hs.eventtap.event.newKeyEvent(modifiers, string.lower(key), false):post()
    end
end

local function remapKey(modifiers,key, keyCode)
    hs.hotkey.bind(modifiers,key,keyCode,nil, keyCode)
end

-- for vi mode
remapKey({'alt'}, 'l', keyCode('right'))
remapKey({'alt'}, 'h', keyCode('left'))
remapKey({'alt'}, 'j', keyCode('down'))
remapKey({'alt'}, 'k', keyCode('up'))
remapKey({'alt', 'shift'}, 'h', keyCode('left', {'shift'}))
remapKey({'alt', 'shift'}, 'j', keyCode('down', {'shift'}))
remapKey({'alt', 'shift'}, 'k', keyCode('up', {'shift'}))
remapKey({'alt', 'shift'}, 'l', keyCode('right', {'shift'}))
remapKey({'alt', 'cmd'}, 'h', keyCode('left', {'cmd'}))
remapKey({'alt', 'cmd'}, 'j', keyCode('down', {'cmd'}))
remapKey({'alt', 'cmd'}, 'k', keyCode('up', {'cmd'}))
remapKey({'alt', 'cmd'}, 'l', keyCode('right', {'cmd'}))
remapKey({'alt', 'shift', 'cmd'}, 'h', keyCode('left', {'shift', 'cmd'}))
remapKey({'alt', 'shift', 'cmd'}, 'j', keyCode('down', {'shift', 'cmd'}))
remapKey({'alt', 'shift', 'cmd'}, 'k', keyCode('up', {'shift', 'cmd'}))
remapKey({'alt', 'shift', 'cmd'}, 'l', keyCode('right', {'shift', 'cmd'}))
