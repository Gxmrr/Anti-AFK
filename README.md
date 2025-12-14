-- Anti-AFK with ON/OFF toggle and improved UI

wait(0.5)

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local VirtualUser = game:GetService("VirtualUser")
local LocalPlayer = Players.LocalPlayer

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

    if fpsConnection then
        fpsConnection:Disconnect()
        fpsConnection = nil
    end

    if idleConnection then
        idleConnection:Disconnect()
        idleConnection = nil
    end
end

local function startFpsTracking()
    if fpsConnection then
        fpsConnection:Disconnect()
    end

    local frameCount = 0
    local lastTime = tick()

    fpsConnection = RunService.RenderStepped:Connect(function()
        frameCount += 1
        if tick() - lastTime >= 1 then
            currentFPS = frameCount
            frameCount = 0
            lastTime = tick()
        end
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

local function startIdleProtection()
    if idleConnection then
        idleConnection:Disconnect()
    end

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
setStatus("Anti-AFK выключен")
