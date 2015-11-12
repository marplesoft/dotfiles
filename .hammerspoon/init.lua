local hyper = {"cmd", "alt", "ctrl", "shift"}

-- App shortcut hotkeys
local appKeys = {
    O = "Microsoft Outlook",
    B = "Sublime Text",
    S = "Safari",
    C = "Google Chrome",
    X = "Microsoft Excel",
    F = "Finder",
    L = "Slack",
    T = "Terminal",
    W = "Microsoft Word",
    P = "TaskPaper",
    Y = "Colloquy"
}
for key, app in pairs(appKeys) do
    hs.hotkey.bind(hyper, key, function()
        hs.application.launchOrFocus(app)
    end)
end

-- make window moves quick
hs.window.animationDuration = 0

-- window grid stuff
hs.grid.GRIDWIDTH = 4
hs.grid.GRIDHEIGHT = 4
hs.grid.MARGINX = 0
hs.grid.MARGINY = 0

-- Hotkeys to interact with the window grid
hs.hotkey.bind(hyper, 'Left', hs.grid.pushWindowLeft)
hs.hotkey.bind(hyper, 'Right', hs.grid.pushWindowRight)
hs.hotkey.bind(hyper, 'Up', hs.grid.pushWindowUp)
hs.hotkey.bind(hyper, 'Down', hs.grid.pushWindowDown)

-- Quasi-hotkeys (via URL events) for resizing of windows in the grid
hs.urlevent.bind('hypershiftleft', function() hs.grid.resizeWindowThinner(hs.window.focusedWindow()) end)
hs.urlevent.bind('hypershiftright', function() hs.grid.resizeWindowWider(hs.window.focusedWindow()) end)
hs.urlevent.bind('hypershiftup', function() hs.grid.resizeWindowShorter(hs.window.focusedWindow()) end)
hs.urlevent.bind('hypershiftdown', function() hs.grid.resizeWindowTaller(hs.window.focusedWindow()) end)

function moveWindowTo(window, x, y, w, h) 
    window:moveToUnit(hs.geometry.rect(x, y, w, h))
end

function moveCurrentWindowTo(x, y, w, h) 
    moveWindowTo(hs.window.focusedWindow(), x, y, w, h)
end

-- move windows between spaces
function moveWindowOneSpace(direction)
    local mouseOrigin = hs.mouse.getAbsolutePosition()
    local win = hs.window.focusedWindow()
    local clickPoint = win:zoomButtonRect()

    clickPoint.x = clickPoint.x + clickPoint.w + 5
    clickPoint.y = clickPoint.y + (clickPoint.h / 2)

    local mouseClickEvent = hs.eventtap.event.newMouseEvent(hs.eventtap.event.types.leftMouseDown, clickPoint)
    mouseClickEvent:post()
    hs.timer.usleep(150000)

    local nextSpaceDownEvent = hs.eventtap.event.newKeyEvent({"ctrl"}, direction, true)
    nextSpaceDownEvent:post()
    hs.timer.usleep(150000)

    local nextSpaceUpEvent = hs.eventtap.event.newKeyEvent({"ctrl"}, direction, false)
    nextSpaceUpEvent:post()
    hs.timer.usleep(150000)

    local mouseReleaseEvent = hs.eventtap.event.newMouseEvent(hs.eventtap.event.types.leftMouseUp, clickPoint)
    mouseReleaseEvent:post()
    hs.timer.usleep(150000)

    hs.mouse.setAbsolutePosition(mouseOrigin)
end

hs.hotkey.bind(hyper, "1", function() moveWindowOneSpace("left") end)   -- move left one space
hs.hotkey.bind(hyper, "2", function() moveWindowOneSpace("right") end)  -- move right one space

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
