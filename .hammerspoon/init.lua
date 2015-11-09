local hyper = {"cmd", "alt", "ctrl", "shift"}

--
-- Begin app keys
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
    P = "TaskPaper"
}

for key, app in pairs(appKeys) do
    hs.hotkey.bind(hyper, key, function()
        hs.application.launchOrFocus(app)
    end)
end
-- End app keys
-- 

--
-- Begin window movement
hs.window.animationDuration = 0

function moveWindowTo(window, x, y, w, h) 
    window:moveToUnit(hs.geometry.rect(x, y, w, h))
end

function moveCurrentWindowTo(x, y, w, h) 
    moveWindowTo(hs.window.focusedWindow(), x, y, w, h)
end

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

hs.hotkey.bind(hyper, "=", function() moveCurrentWindowTo(0.0, 0.0, 1.0, 1.0) end)  -- full screen
hs.hotkey.bind(hyper, "[", function() moveCurrentWindowTo(0.0, 0.0, 0.5, 1.0) end)  -- left half
hs.hotkey.bind(hyper, "]", function() moveCurrentWindowTo(0.5, 0.0, 0.5, 1.0) end)  -- right helf
hs.hotkey.bind(hyper, "-", function() moveCurrentWindowTo(0.2, 0.0, 0.6, 1.0) end)  -- right helf
hs.hotkey.bind(hyper, "9", function() moveCurrentWindowTo(0.0, 0.0, 0.7, 1.0) end)  -- left 70%
hs.hotkey.bind(hyper, "0", function() moveCurrentWindowTo(0.7, 0.0, 0.3, 1.0) end)  -- right 30%

hs.hotkey.bind(hyper, "1", function() moveWindowOneSpace("left") end)   -- move left one space
hs.hotkey.bind(hyper, "2", function() moveWindowOneSpace("right") end)  -- move right one space
-- End window movement
--

--
-- Begin custom layouts
function getApp(name)
    local app = hs.application.get(name)
    if app == nil then
        app = hs.application.open(name, 3, true)
    elseif app:mainWindow() == nil then
        hs.activate()
    end
    return app
end

hs.hotkey.bind(hyper, "Z", function()
    hs.application.open("Microsoft Outlook", 3, true):mainWindow():setFrame(hs.geometry.rect(0.0,23.0,1397.0,884.0))
    hs.application.open("TaskPaper", 3, true):mainWindow():setFrame(hs.geometry.rect(0.0,913.0,642.0,523.0))
    hs.application.open("My Day", 3, true):allWindows()[1]:setFrame(hs.geometry.rect(646.0,913.0,298.0,525.0))
    hs.application.open("TextEdit", 3, true):mainWindow():setFrame(hs.geometry.rect(948.0,914.0,450.0,527.0))
    hs.application.open("Slack", 3, true):mainWindow():setFrame(hs.geometry.rect(1404.0,23.0,1112.0,1417.0))     
end)
--
-- End custom layouts

--
-- Begin other bindings
hs.hotkey.bind(hyper, "`", function()
    hs.reload()
    hs.alert.show("Hammerspoon reloaded")
end)

hs.hotkey.bind(hyper, ";", function()
    hs.execute("/usr/local/bin/subl ~/.hammerspoon/init.lua")
end)
-- End other bindings
--
