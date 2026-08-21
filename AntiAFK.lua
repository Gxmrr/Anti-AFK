--// Anti-AFK — macOS Style UI
--// Gxmrr.t.me

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local VirtualUser = game:GetService("VirtualUser")
local CoreGui = game:GetService("CoreGui")
local LocalPlayer = Players.LocalPlayer

local oldGui = CoreGui:FindFirstChild("AntiAFK")
if oldGui then oldGui:Destroy() end

local enabled = true
local minimized = false
local seconds = 0
local currentFPS = 0

local COLORS = {
    window = Color3.fromRGB(30, 30, 34),
    titlebar = Color3.fromRGB(36, 36, 40),
    card = Color3.fromRGB(43, 43, 48),
    text = Color3.fromRGB(245, 245, 247),
    secondary = Color3.fromRGB(150, 150, 155),
    blue = Color3.fromRGB(0, 122, 255),
    switchOff = Color3.fromRGB(120, 120, 128),
    yellow = Color3.fromRGB(255, 189, 68),
    green = Color3.fromRGB(52, 199, 89),
    border = Color3.fromRGB(255, 255, 255)
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
end

local function stroke(parent, transparency, thickness)
    local s = Instance.new("UIStroke")
    s.Color = COLORS.border
    s.Transparency = transparency or 0.9
    s.Thickness = thickness or 1
    s.Parent = parent
end

local function tween(object, time, properties, style, direction)
    local info = TweenInfo.new(time, style or Enum.EasingStyle.Quint, direction or Enum.EasingDirection.Out)
    local animation = TweenService:Create(object, info, properties)
    animation:Play()
end

local gui = Instance.new("ScreenGui")
gui.Name = "AntiAFK"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Parent = CoreGui

local window = Instance.new("Frame")
window.Name = "Window"
window.Size = UDim2.fromOffset(370, 225)
window.Position = UDim2.new(0.5, -185, 0.16, 0)
window.BackgroundColor3 = COLORS.window
window.BackgroundTransparency = 0.04
window.BorderSizePixel = 0
window.Active = true
window.Draggable = true
window.Parent = gui
corner(window, 17)
stroke(window, 0.86, 1)

local shadow = Instance.new("UIStroke")
shadow.Name = "Glow"
shadow.Color = COLORS.blue
shadow.Transparency = 0.97
shadow.Thickness = 6
shadow.Parent = window

local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 52)
titleBar.BackgroundColor3 = COLORS.titlebar
titleBar.BackgroundTransparency = 0.18
titleBar.BorderSizePixel = 0
titleBar.Parent = window
corner(titleBar, 17)

local titleMask = Instance.new("Frame")
titleMask.Size = UDim2.new(1, 0, 0, 18)
titleMask.Position = UDim2.new(0, 0, 1, -18)
titleMask.BackgroundColor3 = COLORS.titlebar
titleMask.BackgroundTransparency = 0.18
titleMask.BorderSizePixel = 0
titleMask.Parent = titleBar

local minimize = Instance.new("TextButton")
minimize.Size = UDim2.fromOffset(14, 14)
minimize.Position = UDim2.fromOffset(16, 19)
minimize.BackgroundColor3 = COLORS.yellow
minimize.BorderSizePixel = 0
minimize.Text = ""
minimize.AutoButtonColor = false
minimize.Parent = titleBar
corner(minimize, 100)
stroke(minimize, 0.82, 1)

local minimizeLine = Instance.new("Frame")
minimizeLine.Size = UDim2.fromOffset(6, 1)
minimizeLine.Position = UDim2.fromOffset(4, 7)
minimizeLine.BackgroundColor3 = Color3.fromRGB(120, 80, 0)
minimizeLine.BackgroundTransparency = 1
minimizeLine.BorderSizePixel = 0
minimizeLine.Parent = minimize

local title = Instance.new("TextLabel")
title.BackgroundTransparency = 1
title.Position = UDim2.fromOffset(42, 13)
title.Size = UDim2.new(1, -84, 0, 24)
title.Font = Enum.Font.GothamMedium
title.Text = "Anti-AFK"
title.TextSize = 15
title.TextColor3 = COLORS.text
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = titleBar

local subtitle = Instance.new("TextLabel")
subtitle.BackgroundTransparency = 1
subtitle.Position = UDim2.fromOffset(42, 31)
subtitle.Size = UDim2.new(1, -84, 0, 13)
subtitle.Font = Enum.Font.Gotham
subtitle.Text = "Roblox protection"
subtitle.TextSize = 9
subtitle.TextColor3 = COLORS.secondary
subtitle.TextXAlignment = Enum.TextXAlignment.Left
subtitle.Parent = titleBar

local statusDot = Instance.new("Frame")
statusDot.Size = UDim2.fromOffset(8, 8)
statusDot.Position = UDim2.new(1, -24, 0, 22)
statusDot.BackgroundColor3 = COLORS.green
statusDot.BorderSizePixel = 0
statusDot.Parent = titleBar
corner(statusDot, 100)

local statusGlow = Instance.new("UIStroke")
statusGlow.Color = COLORS.green
statusGlow.Transparency = 0.7
statusGlow.Thickness = 2
statusGlow.Parent = statusDot

local content = Instance.new("Frame")
content.Size = UDim2.new(1, -32, 1, -68)
content.Position = UDim2.fromOffset(16, 60)
content.BackgroundTransparency = 1
content.Parent = window

local timeCard = Instance.new("Frame")
timeCard.Size = UDim2.new(0.62, -6, 0, 72)
timeCard.BackgroundColor3 = COLORS.card
timeCard.BackgroundTransparency = 0.18
timeCard.BorderSizePixel = 0
timeCard.Parent = content
corner(timeCard, 13)
stroke(timeCard, 0.93, 1)

local timeTitle = Instance.new("TextLabel")
timeTitle.BackgroundTransparency = 1
timeTitle.Position = UDim2.fromOffset(14, 10)
timeTitle.Size = UDim2.new(1, -28, 0, 14)
timeTitle.Font = Enum.Font.GothamMedium
timeTitle.Text = "SESSION TIME"
timeTitle.TextSize = 9
timeTitle.TextColor3 = COLORS.secondary
timeTitle.TextXAlignment = Enum.TextXAlignment.Left
timeTitle.Parent = timeCard

local timeValue = Instance.new("TextLabel")
timeValue.BackgroundTransparency = 1
timeValue.Position = UDim2.fromOffset(13, 26)
timeValue.Size = UDim2.new(1, -26, 0, 34)
timeValue.Font = Enum.Font.Code
timeValue.Text = "00:00:00"
timeValue.TextSize = 22
timeValue.TextColor3 = COLORS.text
timeValue.TextXAlignment = Enum.TextXAlignment.Left
timeValue.Parent = timeCard

local fpsCard = Instance.new("Frame")
fpsCard.Size = UDim2.new(0.38, -2, 0, 72)
fpsCard.Position = UDim2.new(0.62, 8, 0, 0)
fpsCard.BackgroundColor3 = COLORS.card
fpsCard.BackgroundTransparency = 0.18
fpsCard.BorderSizePixel = 0
fpsCard.Parent = content
corner(fpsCard, 13)
stroke(fpsCard, 0.93, 1)

local fpsTitle = Instance.new("TextLabel")
fpsTitle.BackgroundTransparency = 1
fpsTitle.Position = UDim2.fromOffset(12, 10)
fpsTitle.Size = UDim2.new(1, -24, 0, 14)
fpsTitle.Font = Enum.Font.GothamMedium
fpsTitle.Text = "FPS"
fpsTitle.TextSize = 9
fpsTitle.TextColor3 = COLORS.secondary
fpsTitle.TextXAlignment = Enum.TextXAlignment.Left
fpsTitle.Parent = fpsCard

local fpsValue = Instance.new("TextLabel")
fpsValue.BackgroundTransparency = 1
fpsValue.Position = UDim2.fromOffset(12, 26)
fpsValue.Size = UDim2.new(1, -24, 0, 34)
fpsValue.Font = Enum.Font.Code
fpsValue.Text = "0"
fpsValue.TextSize = 22
fpsValue.TextColor3 = COLORS.blue
fpsValue.TextXAlignment = Enum.TextXAlignment.Left
fpsValue.Parent = fpsCard

local toggleRow = Instance.new("Frame")
toggleRow.Size = UDim2.new(1, 0, 0, 55)
toggleRow.Position = UDim2.fromOffset(0, 82)
toggleRow.BackgroundTransparency = 1
toggleRow.Parent = content

local toggleTitle = Instance.new("TextLabel")
toggleTitle.BackgroundTransparency = 1
toggleTitle.Position = UDim2.fromOffset(4, 7)
toggleTitle.Size = UDim2.new(1, -90, 0, 21)
toggleTitle.Font = Enum.Font.GothamMedium
toggleTitle.Text = "Anti-AFK"
toggleTitle.TextSize = 13
toggleTitle.TextColor3 = COLORS.text
toggleTitle.TextXAlignment = Enum.TextXAlignment.Left
toggleTitle.Parent = toggleRow

local toggleSubtitle = Instance.new("TextLabel")
toggleSubtitle.BackgroundTransparency = 1
toggleSubtitle.Position = UDim2.fromOffset(4, 28)
toggleSubtitle.Size = UDim2.new(1, -90, 0, 15)
toggleSubtitle.Font = Enum.Font.Gotham
toggleSubtitle.Text = "Prevent automatic idle kick"
toggleSubtitle.TextSize = 9
toggleSubtitle.TextColor3 = COLORS.secondary
toggleSubtitle.TextXAlignment = Enum.TextXAlignment.Left
toggleSubtitle.Parent = toggleRow

local switch = Instance.new("TextButton")
switch.Size = UDim2.fromOffset(48, 28)
switch.Position = UDim2.new(1, -48, 0, 12)
switch.BackgroundColor3 = COLORS.blue
switch.BorderSizePixel = 0
switch.Text = ""
switch.AutoButtonColor = false
switch.Parent = toggleRow
corner(switch, 100)

local switchKnob = Instance.new("Frame")
switchKnob.Size = UDim2.fromOffset(24, 24)
switchKnob.Position = UDim2.new(1, -26, 0, 2)
switchKnob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
switchKnob.BorderSizePixel = 0
switchKnob.Parent = switch
corner(switchKnob, 100)

local footer = Instance.new("TextLabel")
footer.BackgroundTransparency = 1
footer.Position = UDim2.new(0, 4, 1, -3)
footer.Size = UDim2.new(1, -8, 0, 14)
footer.Font = Enum.Font.Gotham
footer.Text = "Gxmrr.t.me"
footer.TextSize = 8
footer.TextColor3 = COLORS.secondary
footer.TextXAlignment = Enum.TextXAlignment.Left
footer.Parent = content

local mini = Instance.new("TextButton")
mini.Size = UDim2.fromOffset(150, 42)
mini.Position = window.Position
mini.BackgroundColor3 = COLORS.window
mini.BackgroundTransparency = 0.03
mini.BorderSizePixel = 0
mini.Text = ""
mini.AutoButtonColor = false
mini.Active = true
mini.Draggable = true
mini.Visible = false
mini.Parent = gui
corner(mini, 14)
stroke(mini, 0.86, 1)

local miniDot = Instance.new("Frame")
miniDot.Size = UDim2.fromOffset(11, 11)
miniDot.Position = UDim2.fromOffset(14, 15)
miniDot.BackgroundColor3 = COLORS.yellow
miniDot.BorderSizePixel = 0
miniDot.Parent = mini
corner(miniDot, 100)

local miniTitle = Instance.new("TextLabel")
miniTitle.BackgroundTransparency = 1
miniTitle.Position = UDim2.fromOffset(34, 0)
miniTitle.Size = UDim2.new(1, -46, 1, 0)
miniTitle.Font = Enum.Font.GothamMedium
miniTitle.Text = "Anti-AFK"
miniTitle.TextSize = 12
miniTitle.TextColor3 = COLORS.text
miniTitle.TextXAlignment = Enum.TextXAlignment.Left
miniTitle.Parent = mini

local miniStatus = Instance.new("Frame")
miniStatus.Size = UDim2.fromOffset(7, 7)
miniStatus.Position = UDim2.new(1, -17, 0.5, -4)
miniStatus.BackgroundColor3 = COLORS.green
miniStatus.BorderSizePixel = 0
miniStatus.Parent = mini
corner(miniStatus, 100)

local function updateToggle()
    if enabled then
        tween(switch, 0.25, {BackgroundColor3 = COLORS.blue})
        tween(switchKnob, 0.25, {Position = UDim2.new(1, -26, 0, 2)})
        tween(statusDot, 0.25, {BackgroundColor3 = COLORS.green})
        tween(statusGlow, 0.25, {Color = COLORS.green, Transparency = 0.7})
        miniStatus.BackgroundColor3 = COLORS.green
    else
        tween(switch, 0.25, {BackgroundColor3 = COLORS.switchOff})
        tween(switchKnob, 0.25, {Position = UDim2.new(0, 2, 0, 2)})
        tween(statusDot, 0.25, {BackgroundColor3 = COLORS.switchOff})
        tween(statusGlow, 0.25, {Color = COLORS.switchOff, Transparency = 0.9})
        miniStatus.BackgroundColor3 = COLORS.switchOff
    end
end

switch.MouseButton1Click:Connect(function()
    enabled = not enabled
    updateToggle()
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

minimize.MouseEnter:Connect(function()
    tween(minimize, 0.15, {Size = UDim2.fromOffset(16, 16)})
    tween(minimizeLine, 0.15, {BackgroundTransparency = 0})
end)

minimize.MouseLeave:Connect(function()
    tween(minimize, 0.15, {Size = UDim2.fromOffset(14, 14)})
    tween(minimizeLine, 0.15, {BackgroundTransparency = 1})
end)

LocalPlayer.Idled:Connect(function()
    if not enabled then return end
    VirtualUser:CaptureController()
    VirtualUser:ClickButton2(Vector2.new())
    statusDot.BackgroundColor3 = COLORS.blue
    task.delay(0.25, function()
        if enabled then statusDot.BackgroundColor3 = COLORS.green end
    end)
end)

-- Accurate FPS counter with no visual animation.
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

-- Status glow animation only; FPS has no animation.
task.spawn(function()
    while gui.Parent do
        if enabled and not minimized then
            tween(statusGlow, 1.2, {Transparency = 0.35}, Enum.EasingStyle.Sine)
            task.wait(1.2)
            tween(statusGlow, 1.2, {Transparency = 0.8}, Enum.EasingStyle.Sine)
            task.wait(1.2)
        else
            task.wait(0.5)
        end
    end
end)

updateToggle()
