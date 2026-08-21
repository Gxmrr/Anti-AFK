--// Anti-AFK — macOS Style
--// Gxmrr.t.me

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local VirtualUser = game:GetService("VirtualUser")
local CoreGui = game:GetService("CoreGui")

local LocalPlayer = Players.LocalPlayer

local oldGui = CoreGui:FindFirstChild("AntiAFK")
if oldGui then
    oldGui:Destroy()
end

local enabled = true
local minimized = false
local seconds = 0
local currentFPS = 0

local COLORS = {
    window = Color3.fromRGB(30, 30, 34),
    titlebar = Color3.fromRGB(42, 42, 46),
    card = Color3.fromRGB(48, 48, 53),
    text = Color3.fromRGB(245, 245, 247),
    secondary = Color3.fromRGB(155, 155, 160),
    blue = Color3.fromRGB(10, 132, 255),
    switchOff = Color3.fromRGB(110, 110, 115),
    yellow = Color3.fromRGB(255, 189, 68),
    green = Color3.fromRGB(52, 199, 89),
    white = Color3.fromRGB(255, 255, 255)
}

local function formatTime(t)
    local h = math.floor(t / 3600)
    local m = math.floor((t % 3600) / 60)
    local s = t % 60
    return string.format("%02d:%02d:%02d", h, m, s)
end

local function corner(parent, radius)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, radius)
    c.Parent = parent
    return c
end

local function stroke(parent, transparency, thickness)
    local s = Instance.new("UIStroke")
    s.Color = COLORS.white
    s.Transparency = transparency or 0.9
    s.Thickness = thickness or 1
    s.Parent = parent
    return s
end

local function tween(object, duration, properties, style)
    local info = TweenInfo.new(
        duration,
        style or Enum.EasingStyle.Quint,
        Enum.EasingDirection.Out
    )
    local animation = TweenService:Create(object, info, properties)
    animation:Play()
    return animation
end

local gui = Instance.new("ScreenGui")
gui.Name = "AntiAFK"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Parent = CoreGui

local window = Instance.new("Frame")
window.Name = "Window"
window.Size = UDim2.fromOffset(380, 235)
window.Position = UDim2.new(0.5, -190, 0.16, 0)
window.BackgroundColor3 = COLORS.window
window.BackgroundTransparency = 0.03
window.BorderSizePixel = 0
window.Active = true
window.Draggable = true
window.Parent = gui
corner(window, 18)
stroke(window, 0.86, 1)

local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 58)
titleBar.BackgroundColor3 = COLORS.titlebar
titleBar.BackgroundTransparency = 0.08
titleBar.BorderSizePixel = 0
titleBar.Parent = window
corner(titleBar, 18)

local titleMask = Instance.new("Frame")
titleMask.Size = UDim2.new(1, 0, 0, 18)
titleMask.Position = UDim2.new(0, 0, 1, -18)
titleMask.BackgroundColor3 = COLORS.titlebar
titleMask.BackgroundTransparency = 0.08
titleMask.BorderSizePixel = 0
titleMask.Parent = titleBar

local minimize = Instance.new("TextButton")
minimize.Name = "Minimize"
minimize.Size = UDim2.fromOffset(17, 17)
minimize.Position = UDim2.fromOffset(18, 20)
minimize.BackgroundColor3 = COLORS.yellow
minimize.BorderSizePixel = 0
minimize.Text = ""
minimize.AutoButtonColor = false
minimize.Parent = titleBar
corner(minimize, 100)

local minimizeLine = Instance.new("Frame")
minimizeLine.Size = UDim2.fromOffset(7, 1)
minimizeLine.Position = UDim2.fromOffset(5, 8)
minimizeLine.BackgroundColor3 = Color3.fromRGB(120, 80, 0)
minimizeLine.BackgroundTransparency = 1
minimizeLine.BorderSizePixel = 0
minimizeLine.Parent = minimize

local title = Instance.new("TextLabel")
title.BackgroundTransparency = 1
title.Position = UDim2.fromOffset(48, 13)
title.Size = UDim2.new(1, -100, 0, 22)
title.Font = Enum.Font.GothamMedium
title.Text = "Anti-AFK"
title.TextSize = 16
title.TextColor3 = COLORS.text
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = titleBar

local subtitle = Instance.new("TextLabel")
subtitle.BackgroundTransparency = 1
subtitle.Position = UDim2.fromOffset(48, 32)
subtitle.Size = UDim2.new(1, -100, 0, 14)
subtitle.Font = Enum.Font.Gotham
subtitle.Text = "Roblox protection"
subtitle.TextSize = 9
subtitle.TextColor3 = COLORS.secondary
subtitle.TextXAlignment = Enum.TextXAlignment.Left
subtitle.Parent = titleBar

local statusDot = Instance.new("Frame")
statusDot.Name = "Status"
statusDot.Size = UDim2.fromOffset(13, 13)
statusDot.Position = UDim2.new(1, -30, 0, 22)
statusDot.BackgroundColor3 = COLORS.green
statusDot.BorderSizePixel = 0
statusDot.Parent = titleBar
corner(statusDot, 100)

local statusStroke = stroke(statusDot, 0.7, 1)
statusStroke.Color = COLORS.green

local content = Instance.new("Frame")
content.Size = UDim2.new(1, -32, 1, -74)
content.Position = UDim2.fromOffset(16, 66)
content.BackgroundTransparency = 1
content.Parent = window

local timeCard = Instance.new("Frame")
timeCard.Size = UDim2.new(0.63, -6, 0, 76)
timeCard.Position = UDim2.fromOffset(0, 0)
timeCard.BackgroundColor3 = COLORS.card
timeCard.BackgroundTransparency = 0.08
timeCard.BorderSizePixel = 0
timeCard.Parent = content
corner(timeCard, 14)
stroke(timeCard, 0.93, 1)

local timeLabel = Instance.new("TextLabel")
timeLabel.BackgroundTransparency = 1
timeLabel.Position = UDim2.fromOffset(14, 10)
timeLabel.Size = UDim2.new(1, -28, 0, 14)
timeLabel.Font = Enum.Font.GothamMedium
timeLabel.Text = "SESSION TIME"
timeLabel.TextSize = 9
timeLabel.TextColor3 = COLORS.secondary
timeLabel.TextXAlignment = Enum.TextXAlignment.Left
timeLabel.Parent = timeCard

local timeValue = Instance.new("TextLabel")
timeValue.BackgroundTransparency = 1
timeValue.Position = UDim2.fromOffset(13, 27)
timeValue.Size = UDim2.new(1, -26, 0, 35)
timeValue.Font = Enum.Font.Code
timeValue.Text = "00:00:00"
timeValue.TextSize = 23
timeValue.TextColor3 = COLORS.text
timeValue.TextXAlignment = Enum.TextXAlignment.Left
timeValue.Parent = timeCard

local fpsCard = Instance.new("Frame")
fpsCard.Size = UDim2.new(0.37, -2, 0, 76)
fpsCard.Position = UDim2.new(0.63, 8, 0, 0)
fpsCard.BackgroundColor3 = COLORS.card
fpsCard.BackgroundTransparency = 0.08
fpsCard.BorderSizePixel = 0
fpsCard.Parent = content
corner(fpsCard, 14)
stroke(fpsCard, 0.93, 1)

local fpsLabel = Instance.new("TextLabel")
fpsLabel.BackgroundTransparency = 1
fpsLabel.Position = UDim2.fromOffset(12, 10)
fpsLabel.Size = UDim2.new(1, -24, 0, 14)
fpsLabel.Font = Enum.Font.GothamMedium
fpsLabel.Text = "FPS"
fpsLabel.TextSize = 9
fpsLabel.TextColor3 = COLORS.secondary
fpsLabel.TextXAlignment = Enum.TextXAlignment.Left
fpsLabel.Parent = fpsCard

local fpsValue = Instance.new("TextLabel")
fpsValue.BackgroundTransparency = 1
fpsValue.Position = UDim2.fromOffset(12, 27)
fpsValue.Size = UDim2.new(1, -24, 0, 35)
fpsValue.Font = Enum.Font.Code
fpsValue.Text = "0"
fpsValue.TextSize = 23
fpsValue.TextColor3 = COLORS.blue
fpsValue.TextXAlignment = Enum.TextXAlignment.Left
fpsValue.Parent = fpsCard

local toggleRow = Instance.new("Frame")
toggleRow.Size = UDim2.new(1, 0, 0, 56)
toggleRow.Position = UDim2.fromOffset(0, 88)
toggleRow.BackgroundTransparency = 1
toggleRow.Parent = content

local toggleTitle = Instance.new("TextLabel")
toggleTitle.BackgroundTransparency = 1
toggleTitle.Position = UDim2.fromOffset(4, 5)
toggleTitle.Size = UDim2.new(1, -100, 0, 21)
toggleTitle.Font = Enum.Font.GothamMedium
toggleTitle.Text = "Anti-AFK"
toggleTitle.TextSize = 13
toggleTitle.TextColor3 = COLORS.text
toggleTitle.TextXAlignment = Enum.TextXAlignment.Left
toggleTitle.Parent = toggleRow

local toggleSubtitle = Instance.new("TextLabel")
toggleSubtitle.BackgroundTransparency = 1
toggleSubtitle.Position = UDim2.fromOffset(4, 27)
toggleSubtitle.Size = UDim2.new(1, -100, 0, 15)
toggleSubtitle.Font = Enum.Font.Gotham
toggleSubtitle.Text = "Prevent automatic idle kick"
toggleSubtitle.TextSize = 9
toggleSubtitle.TextColor3 = COLORS.secondary
toggleSubtitle.TextXAlignment = Enum.TextXAlignment.Left
toggleSubtitle.Parent = toggleRow

local switch = Instance.new("TextButton")
switch.Name = "Toggle"
switch.Size = UDim2.fromOffset(50, 29)
switch.Position = UDim2.new(1, -50, 0, 10)
switch.BackgroundColor3 = COLORS.blue
switch.BorderSizePixel = 0
switch.Text = ""
switch.AutoButtonColor = false
switch.Parent = toggleRow
corner(switch, 100)

local knob = Instance.new("Frame")
knob.Size = UDim2.fromOffset(25, 25)
knob.Position = UDim2.new(1, -27, 0, 2)
knob.BackgroundColor3 = COLORS.white
knob.BorderSizePixel = 0
knob.Parent = switch
corner(knob, 100)

local footer = Instance.new("TextLabel")
footer.BackgroundTransparency = 1
footer.Position = UDim2.new(0, 4, 1, -8)
footer.Size = UDim2.new(1, -8, 0, 14)
footer.Font = Enum.Font.Gotham
footer.Text = "Gxmrr.t.me"
footer.TextSize = 8
footer.TextColor3 = COLORS.secondary
footer.TextXAlignment = Enum.TextXAlignment.Left
footer.Parent = content

local mini = Instance.new("TextButton")
mini.Name = "MiniWindow"
mini.Size = UDim2.fromOffset(170, 44)
mini.Position = window.Position
mini.BackgroundColor3 = COLORS.window
mini.BackgroundTransparency = 0.02
mini.BorderSizePixel = 0
mini.Text = ""
mini.AutoButtonColor = false
mini.Active = true
mini.Draggable = true
mini.Visible = false
mini.Parent = gui
corner(mini, 15)
stroke(mini, 0.86, 1)

local miniDot = Instance.new("Frame")
miniDot.Size = UDim2.fromOffset(13, 13)
miniDot.Position = UDim2.fromOffset(15, 15)
miniDot.BackgroundColor3 = COLORS.green
miniDot.BorderSizePixel = 0
miniDot.Parent = mini
corner(miniDot, 100)

local miniTitle = Instance.new("TextLabel")
miniTitle.BackgroundTransparency = 1
miniTitle.Position = UDim2.fromOffset(36, 0)
miniTitle.Size = UDim2.new(1, -48, 1, 0)
miniTitle.Font = Enum.Font.GothamMedium
miniTitle.Text = "Anti-AFK"
miniTitle.TextSize = 12
miniTitle.TextColor3 = COLORS.text
miniTitle.TextXAlignment = Enum.TextXAlignment.Left
miniTitle.Parent = mini

local function updateToggle()
    if enabled then
        tween(switch, 0.22, {BackgroundColor3 = COLORS.blue})
        tween(knob, 0.22, {Position = UDim2.new(1, -27, 0, 2)})
        tween(statusDot, 0.22, {BackgroundColor3 = COLORS.green})
        tween(statusStroke, 0.22, {Color = COLORS.green})
        miniDot.BackgroundColor3 = COLORS.green
    else
        tween(switch, 0.22, {BackgroundColor3 = COLORS.switchOff})
        tween(knob, 0.22, {Position = UDim2.new(0, 2, 0, 2)})
        tween(statusDot, 0.22, {BackgroundColor3 = COLORS.switchOff})
        tween(statusStroke, 0.22, {Color = COLORS.switchOff})
        miniDot.BackgroundColor3 = COLORS.switchOff
    end
end

switch.MouseButton1Click:Connect(function()
    enabled = not enabled
    updateToggle()
end)

minimize.MouseEnter:Connect(function()
    tween(minimize, 0.12, {Size = UDim2.fromOffset(19, 19)})
    tween(minimizeLine, 0.12, {BackgroundTransparency = 0})
end)

minimize.MouseLeave:Connect(function()
    tween(minimize, 0.12, {Size = UDim2.fromOffset(17, 17)})
    tween(minimizeLine, 0.12, {BackgroundTransparency = 1})
end)

minimize.MouseButton1Click:Connect(function()
    if minimized then return end

    minimized = true
    mini.Position = window.Position
    mini.Visible = true
    window.Visible = false
end)

mini.MouseButton1Click:Connect(function()
    if not minimized then return end

    minimized = false
    window.Position = mini.Position
    window.Visible = true
    mini.Visible = false
end)

LocalPlayer.Idled:Connect(function()
    if not enabled then return end

    VirtualUser:CaptureController()
    VirtualUser:ClickButton2(Vector2.new())

    statusDot.BackgroundColor3 = COLORS.blue

    task.delay(0.25, function()
        if enabled then
            statusDot.BackgroundColor3 = COLORS.green
        end
    end)
end)

-- Accurate FPS counter without visual animation.
do
    local frames = 0
    local elapsed = 0
    local accumulator = 0

    RunService.RenderStepped:Connect(function(deltaTime)
        frames += 1
        elapsed += deltaTime
        accumulator += deltaTime

        if accumulator >= 0.25 then
            currentFPS = math.floor((frames / elapsed) + 0.5)
            frames = 0
            elapsed = 0
            accumulator = 0
            fpsValue.Text = tostring(currentFPS)
        end
    end)
end

-- Session timer
task.spawn(function()
    while gui.Parent do
        task.wait(1)

        if enabled then
            seconds += 1
            timeValue.Text = formatTime(seconds)
        end
    end
end)

-- Start
updateToggle()
