wait(0.5)

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local VirtualUser = game:GetService("VirtualUser")
local CoreGui = game:GetService("CoreGui")
local LocalPlayer = Players.LocalPlayer

local gui = Instance.new("ScreenGui")
gui.Name = "AntiAFK"
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Parent = CoreGui

local window = Instance.new("Frame")
window.Parent = gui
window.BackgroundColor3 = Color3.fromRGB(28, 28, 32)
window.BackgroundTransparency = 0.1
window.Position = UDim2.new(0.7, 0, 0.1, 0)
window.Size = UDim2.new(0, 320, 0, 170)
window.Active = true
window.Draggable = true

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 10)
corner.Parent = window

local stroke = Instance.new("UIStroke")
stroke.Color = Color3.fromRGB(0, 122, 255)
stroke.Thickness = 1.5
stroke.Parent = window

local header = Instance.new("TextLabel")
header.Parent = window
header.BackgroundTransparency = 1
header.Position = UDim2.new(0, 14, 0, 10)
header.Size = UDim2.new(1, -28, 0, 28)
header.Font = Enum.Font.SourceSansBold
header.TextSize = 22
header.TextColor3 = Color3.fromRGB(235, 235, 235)
header.TextXAlignment = Enum.TextXAlignment.Left
header.Text = "Anti-AFK"

local status = Instance.new("TextLabel")
status.Parent = window
status.BackgroundTransparency = 1
status.Position = UDim2.new(0, 14, 0, 50)
status.Size = UDim2.new(1, -28, 0, 50)
status.Font = Enum.Font.SourceSans
status.TextSize = 18
status.TextColor3 = Color3.fromRGB(170, 170, 175)
status.TextXAlignment = Enum.TextXAlignment.Left
status.Text = "Starting..."

local timer = 0
local fps = 0
local frameCount = 0
local lastFPS = tick()

local function formatTime(seconds)
    local h = math.floor(seconds / 3600)
    local m = math.floor((seconds % 3600) / 60)
    local s = seconds % 60
    return string.format("%02d:%02d:%02d", h, m, s)
end

RunService.RenderStepped:Connect(function()
    frameCount += 1
    if tick() - lastFPS >= 1 then
        fps = frameCount
        frameCount = 0
        lastFPS = tick()
    end
end)

task.spawn(function()
    while gui.Parent do
        task.wait(1)
        timer += 1
        status.Text = "⏱ " .. formatTime(timer) .. "  /  FPS: " .. tostring(fps)
    end
end)

LocalPlayer.Idled:Connect(function()
    VirtualUser:CaptureController()
    VirtualUser:ClickButton2(Vector2.new())
    status.Text = "⚠️ AFK protection triggered"
    task.wait(2)
    status.Text = "⏱ " .. formatTime(timer) .. "  /  FPS: " .. tostring(fps)
end)
