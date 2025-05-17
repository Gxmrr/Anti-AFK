wait(0.5)-- ANIMATION: Fade in GUI and text
local TweenService = game:GetService("TweenService")

-- Set elements transparent initially
ca.BackgroundTransparency = 1
ca.TextTransparency = 1
da.BackgroundTransparency = 1
_b.TextTransparency = 1
ab.TextTransparency = 1

-- Create tween settings
local tweenInfo = TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

-- Animate ca (main title bar)
TweenService:Create(ca, tweenInfo, {BackgroundTransparency = 0}):Play()
TweenService:Create(ca, tweenInfo, {TextTransparency = 0}):Play()

-- Animate da (frame block)
TweenService:Create(da, tweenInfo, {BackgroundTransparency = 0}):Play()

-- Animate _b (bottom text)
TweenService:Create(_b, tweenInfo, {TextTransparency = 0}):Play()

-- Animate ab (status)
TweenService:Create(ab, tweenInfo, {TextTransparency = 0}):Play()
local ba=Instance.new("ScreenGui") 
local ca=Instance.new("TextLabel")local da=Instance.new("Frame") 
local _b=Instance.new("TextLabel")local ab=Instance.new("TextLabel")ba.Parent=game.CoreGui 
ba.ZIndexBehavior=Enum.ZIndexBehavior.Sibling;ca.Parent=ba;ca.Active=true 
ca.BackgroundColor3=Color3.new(0.176471,0.176471,0.176471)ca.Draggable=true 
ca.Position=UDim2.new(0.698610067,0,0.098096624,0)ca.Size=UDim2.new(0,370,0,52) 
ca.Font=Enum.Font.SourceSansSemibold;ca.Text="Anti AFK Script"ca.TextColor3=Color3.new(0,1,1) 
ca.TextSize=22;da.Parent=ca 
da.BackgroundColor3=Color3.new(0.196078,0.196078,0.196078)da.Position=UDim2.new(0,0,1.0192306,0) 
da.Size=UDim2.new(0,370,0,107)_b.Parent=da 
_b.BackgroundColor3=Color3.new(0.176471,0.176471,0.176471)_b.Position=UDim2.new(0,0,0.800455689,0) 
_b.Size=UDim2.new(0,370,0,21)_b.Font=Enum.Font.Arial;_b.Text="сусляк" 
_b.TextColor3=Color3.new(0,1,1)_b.TextSize=20;ab.Parent=da 
ab.BackgroundColor3=Color3.new(0.176471,0.176471,0.176471)ab.Position=UDim2.new(0,0,0.158377,0) 
ab.Size=UDim2.new(0,370,0,44)ab.Font=Enum.Font.ArialBold;ab.Text="Status: Active" 
ab.TextColor3=Color3.new(0,1,1)ab.TextSize=20;local bb=game:service'VirtualUser' 
game:service'Players'.LocalPlayer.Idled:connect(function() 
bb:CaptureController()bb:ClickButton2(Vector2.new()) 
ab.Text="Roblox tried to kick u but i kicked him instead"wait(2)ab.Text="Status : Active"end)
