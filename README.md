wait(0.5)

-- Create GUI elements
local screenGui = Instance.new("ScreenGui")
local frame = Instance.new("Frame")
local label1 = Instance.new("TextLabel")
local label2 = Instance.new("TextLabel")
local label3 = Instance.new("TextLabel")

-- Parent GUI to CoreGui
screenGui.Parent = game.CoreGui

-- Frame settings
frame.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
frame.BackgroundColor3 = Color3.new(0.176471, 0.176471, 0.176471)
frame.Size = UDim2.new(0, 370, 0, 52)
frame.Position = UDim2.new(0.698160767, 0, 0.089906864, 0)
frame.Draggable = true
frame.Active = true
frame.Parent = screenGui

-- Label 1: Title
label1.Size = UDim2.new(0, 370, 0, 18)
label1.Position = UDim2.new(0, 0, 0.0192306, 0)
label1.BackgroundColor3 = Color3.new(0.196078, 0.196078, 0.196078)
label1.Font = Enum.Font.SourceSansSemibold
label1.Text = "Anti AFK Script"
label1.TextColor3 = Color3.new(1, 1, 1)
label1.TextSize = 22
label1.Parent = frame

-- Label 2: Status
label2.Size = UDim2.new(0, 370, 0, 21)
label2.Position = UDim2.new(0, 0, 0.800455689, 0)
label2.BackgroundColor3 = Color3.new(0.176471, 0.176471, 0.176471)
label2.Font = Enum.Font.Arial
label2.Text = "Status: Active"
label2.TextColor3 = Color3.new(1, 1, 1)
label2.TextSize = 20
label2.Parent = frame

-- Label 3: Message
label3.Size = UDim2.new(0, 370, 0, 14)
label3.Position = UDim2.new(0, 0, 0.158377, 0)
label3.BackgroundColor3 = Color3.new(0.176471, 0.176471, 0.176471)
label3.Font = Enum.Font.ArialBold
label3.Text = "Roblox tried to kick, but I stayed active"
label3.TextColor3 = Color3.new(1, 1, 1)
label3.TextSize = 20
label3.Parent = frame

-- Anti-AFK functionality
game:GetService("Players").LocalPlayer.Idled:connect(function()
	local virtualUser = game:service("VirtualUser")
	virtualUser:CaptureController()
	virtualUser:ClickButton2(Vector2.new())
	label2.Text = "Status: Active"
end)

-- Tween animation for smooth appearance
local TweenService = game:GetService("TweenService")

-- Make all elements transparent at start
frame.BackgroundTransparency = 1
for _, child in pairs(frame:GetDescendants()) do
	if child:IsA("TextLabel") then
		child.TextTransparency = 1
	end
end

-- Create and play tweens
local tweenInfo = TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

local tweenFrame = TweenService:Create(frame, tweenInfo, {BackgroundTransparency = 0})
tweenFrame:Play()

for _, child in pairs(frame:GetDescendants()) do
	if child:IsA("TextLabel") then
		local tweenText = TweenService:Create(child, tweenInfo, {TextTransparency = 0})
		tweenText:Play()
	end
end
