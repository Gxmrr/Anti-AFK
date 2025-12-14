wait(0.5)local ba=Instance.new("ScreenGui")
local ca=Instance.new("TextLabel")local da=Instance.new("Frame")
local _b=Instance.new("TextLabel")local ab=Instance.new("TextLabel")ba.Parent=game.CoreGui
ba.ZIndexBehavior=Enum.ZIndexBehavior.Sibling;ca.Parent=ba;ca.Active=true
ca.BackgroundColor3=Color3.new(0.176471,0.176471,0.176471)
ca.BackgroundTransparency=0.4 
ca.Draggable=true
ca.Position=UDim2.new(0.698610067,0,0.098096624,0)ca.Size=UDim2.new(0,304,0,52)
ca.Font=Enum.Font.SourceSansSemibold;ca.Text="Anti Afk"ca.TextColor3=Color3.new(0,1,1)
ca.TextSize=22;da.Parent=ca
da.BackgroundColor3=Color3.new(0.196078,0.196078,0.196078)
da.BackgroundTransparency=0.4 
da.Position=UDim2.new(0,0,1.0192306,0)
da.Size=UDim2.new(0,304,0,107)_b.Parent=da
_b.BackgroundColor3=Color3.new(0.176471,0.176471,0.176471)
_b.BackgroundTransparency=0.4 
_b.Position=UDim2.new(0,0,0.800455689,0)
_b.Size=UDim2.new(0,304,0,21)_b.Font=Enum.Font.Arial;_b.Text="Gxmrr.t.me"
_b.TextColor3=Color3.new(1,1,1)_b.TextSize=20;ab.Parent=da
ab.BackgroundColor3=Color3.new(0.176471,0.176471,0.176471)
ab.BackgroundTransparency=0.4
ab.Position=UDim2.new(0,0,0.158377379,0)
ab.Size=UDim2.new(0,304,0,44)ab.Font=Enum.Font.ArialBold;ab.Text="⏱ Время работы: 00:00:00 / FPS: 0"
ab.TextColor3=Color3.new(1,1,1)ab.TextSize=20;local bb=game:service'VirtualUser'
-- Anti-AFK with ON/OFF toggle and improved UI

wait(0.5)

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local seconds = 0
local VirtualUser = game:GetService("VirtualUser")
local CoreGui = game:GetService("CoreGui")
local LocalPlayer = Players.LocalPlayer

local existingGui = CoreGui:FindFirstChild("AntiAFK")
if existingGui then
    existingGui:Destroy()
end

local gui = Instance.new("ScreenGui")
local window = Instance.new("Frame")
local header = Instance.new("TextLabel")
local statusLabel = Instance.new("TextLabel")
local footer = Instance.new("TextLabel")
local toggleButton = Instance.new("TextButton")
local corner = Instance.new("UICorner")
local stroke = Instance.new("UIStroke")
local gradient = Instance.new("UIGradient")

local enabled = false
local timerSeconds = 0
local currentFPS = 0
local timerThread = nil
local fpsConnection = nil
local idleConnection = nil

local colors = {
    background = Color3.fromRGB(28, 28, 32),
    panel = Color3.fromRGB(36, 36, 42),
    accent = Color3.fromRGB(0, 255, 255),
    success = Color3.fromRGB(46, 204, 113),
    danger = Color3.fromRGB(231, 76, 60),
    text = Color3.fromRGB(235, 235, 235)
}

local function formatTime(t)
    local h = math.floor(t / 3600)
    local m = math.floor((t % 3600) / 60)
    local s = t % 60
    return string.format("%02d:%02d:%02d", h, m, s)
end

spawn(function()
local function setStatus(text)
    statusLabel.Text = text
end

local function updateToggleVisual()
    if enabled then
        toggleButton.Text = "ON"
        toggleButton.BackgroundColor3 = colors.success
        header.Text = "Anti-AFK • Active"
    else
        toggleButton.Text = "OFF"
        toggleButton.BackgroundColor3 = colors.danger
        header.Text = "Anti-AFK • Inactive"
    end
end

local function stopTimer()
    if timerThread then
        task.cancel(timerThread)
        timerThread = nil
    end
end

local function stopAll()
    enabled = false

    stopTimer()
    currentFPS = 0
    timerSeconds = 0

    if fpsConnection then
        fpsConnection:Disconnect()
        fpsConnection = nil
    end

    if idleConnection then
        idleConnection:Disconnect()
        idleConnection = nil
    end

    updateToggleVisual()
end

local function startFpsTracking()
    if fpsConnection then
        fpsConnection:Disconnect()
    end

    local frameCount = 0
    local lastTime = tick()
    RunService.RenderStepped:Connect(function()
        frameCount = frameCount + 1

    fpsConnection = RunService.RenderStepped:Connect(function()
        frameCount += 1
        if tick() - lastTime >= 1 then
            currentFPS = frameCount
            frameCount = 0
            lastTime = tick()
        end
    end)
end)
end

local function startTimer()
    stopTimer()

    timerThread = task.spawn(function()
        while enabled do
            task.wait(1)
            if not enabled then
                break
            end
            timerSeconds += 1
            setStatus("⏱ Время работы: " .. formatTime(timerSeconds) .. " / FPS: " .. tostring(currentFPS))
        end

        timerThread = nil
    end)
end

spawn(function()
    while true do
        wait(1)
        seconds = seconds + 1
        ab.Text = "⏱" .. formatTime(seconds) .. " / FPS: " .. tostring(currentFPS)
local function startIdleProtection()
    if idleConnection then
        idleConnection:Disconnect()
    end
end)

game:service'Players'.LocalPlayer.Idled:connect(function()
    bb:CaptureController()bb:ClickButton2(Vector2.new())
    ab.Text="⚠️ ROBLOX tried to kick you... but I stepped in."
    wait(2)
    ab.Text = "⏱" .. formatTime(seconds) .. " / FPS: " .. tostring(currentFPS)
    idleConnection = LocalPlayer.Idled:Connect(function()
        if not enabled then
            return
        end
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new())
        setStatus("⚠️ ROBLOX tried to kick you... but I stepped in.")
        task.wait(2)
        setStatus("⏱ Время работы: " .. formatTime(timerSeconds) .. " / FPS: " .. tostring(currentFPS))
    end)
end

local function setEnabled(state)
    if state == enabled then
        return
    end

    enabled = state
    updateToggleVisual()

    if enabled then
        timerSeconds = 0
        setStatus("⏱ Время работы: 00:00:00 / FPS: " .. tostring(currentFPS))
        startFpsTracking()
        startTimer()
        startIdleProtection()
    else
        stopAll()
        setStatus("Anti-AFK выключен")
    end
end

-- UI layout

if syn and syn.protect_gui then
    syn.protect_gui(gui)
end

gui.Parent = game:GetService("CoreGui")
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

gui.Name = "AntiAFK"
window.Parent = gui
window.BackgroundColor3 = colors.background
window.BackgroundTransparency = 0.1
window.Position = UDim2.new(0.7, 0, 0.1, 0)
window.Size = UDim2.new(0, 320, 0, 170)
window.Active = true
window.Draggable = true

stroke.Parent = window
stroke.Color = colors.accent
stroke.Thickness = 1.5

corner.Parent = window
corner.CornerRadius = UDim.new(0, 8)

gradient.Parent = window
gradient.Rotation = 90
gradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(25, 25, 30)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(35, 35, 45))
})

header.Parent = window
header.BackgroundTransparency = 1
header.Position = UDim2.new(0, 12, 0, 8)
header.Size = UDim2.new(1, -24, 0, 24)
header.Font = Enum.Font.SourceSansBold
header.TextSize = 22
header.TextColor3 = colors.accent
header.TextXAlignment = Enum.TextXAlignment.Left
header.Text = "Anti-AFK • Inactive"

statusLabel.Parent = window
statusLabel.BackgroundColor3 = colors.panel
statusLabel.BackgroundTransparency = 0.15
statusLabel.Position = UDim2.new(0.0375, 0, 0.35, 0)
statusLabel.Size = UDim2.new(0.925, 0, 0, 60)
statusLabel.Font = Enum.Font.ArialBold
statusLabel.Text = "Anti-AFK выключен"
statusLabel.TextWrapped = true
statusLabel.TextSize = 18
statusLabel.TextColor3 = colors.text

local statusCorner = Instance.new("UICorner", statusLabel)
statusCorner.CornerRadius = UDim.new(0, 6)

footer.Parent = window
footer.BackgroundTransparency = 1
footer.Position = UDim2.new(0, 12, 0.78, 0)
footer.Size = UDim2.new(1, -24, 0, 20)
footer.Font = Enum.Font.SourceSans
footer.TextSize = 16
footer.TextColor3 = colors.text
footer.TextXAlignment = Enum.TextXAlignment.Left
footer.Text = "Gxmrr.t.me"

local footerStroke = Instance.new("UIStroke", footer)
footerStroke.Color = colors.accent
footerStroke.Thickness = 0.8

local footerCorner = Instance.new("UICorner", footer)
footerCorner.CornerRadius = UDim.new(0, 4)

toggleButton.Parent = window
toggleButton.Size = UDim2.new(0, 110, 0, 38)
toggleButton.Position = UDim2.new(0.6, 0, 0.12, 0)
toggleButton.Font = Enum.Font.SourceSansBold
toggleButton.TextSize = 20
toggleButton.TextColor3 = colors.text
toggleButton.AutoButtonColor = false
toggleButton.BackgroundColor3 = colors.danger

local toggleCorner = Instance.new("UICorner", toggleButton)
toggleCorner.CornerRadius = UDim.new(0, 6)

local toggleStroke = Instance.new("UIStroke", toggleButton)
toggleStroke.Color = Color3.fromRGB(255, 255, 255)
toggleStroke.Transparency = 0.2

toggleButton.MouseButton1Click:Connect(function()
    setEnabled(not enabled)
end)

-- Initialize visuals
updateToggleVisual()

-- Start in disabled state; user can toggle ON
setStatus("works")
