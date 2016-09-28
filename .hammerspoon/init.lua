local hyper = {"cmd", "alt", "ctrl"}

-- App shortcut hotkeys
local appKeys = {
    O = "Microsoft Outlook",
    B = "Sublime Text",
    S = "Safari",
    C = "Google Chrome",
    X = "Microsoft Excel",
    F = "Finder",
    L = "Slack",
    T = "iTerm",
    W = "Microsoft Word",
    P = "TaskPaper",
    N = "Notes"
}
for key, app in pairs(appKeys) do
    hs.hotkey.bind(hyper, key, function()
        hs.application.launchOrFocus(app)
    end)
end

-- make window moves quick
hs.window.animationDuration = 0

function moveWindowTo(window, x, y, w, h)
    local screenFrame = window:screen():frame()

    -- strip off space for the custom menu bar 
    local barHeightToExclude = 23
    screenFrame.y = screenFrame.y + barHeightToExclude
    screenFrame.h = screenFrame.h - barHeightToExclude
    
    local r = hs.geometry.fromUnitRect(hs.geometry.rect(x, y, w, h), screenFrame)
    
    applyPadding(r, 5)
    
    window:move(r)
end

function applyPadding(rect, padding)
    rect.x = rect.x + padding
    rect.y = rect.y + padding
    rect.w = rect.w - padding*2
    rect.h = rect.h - padding*2
    return rect
end

function moveCurrentWindowTo(x, y, w, h) 
    moveWindowTo(hs.window.focusedWindow(), x, y, w, h)
end

hs.hotkey.bind(hyper, "=", function() moveCurrentWindowTo(0.0, 0.0, 1.0, 1.0) end)  -- full screen
hs.hotkey.bind(hyper, "[", function() moveCurrentWindowTo(0.0, 0.0, 0.5, 1.0) end)  -- left half
hs.hotkey.bind(hyper, "]", function() moveCurrentWindowTo(0.5, 0.0, 0.5, 1.0) end)  -- right helf
hs.hotkey.bind(hyper, "-", function() moveCurrentWindowTo(0.2, 0.0, 0.6, 1.0) end)  -- right helf

-- reload hs config hotkey
hs.hotkey.bind(hyper, "`", function()
    hs.reload()
    hs.alert.show("Hammerspoon reloaded")
end)

-- edit init.lua hotkey
hs.hotkey.bind(hyper, ";", function()
    hs.execute("/usr/local/bin/subl ~/.hammerspoon/init.lua")
end)
