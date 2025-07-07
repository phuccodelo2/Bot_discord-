local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

-- UI setup
local screenGui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
screenGui.Name = "PhucmaxUI"
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Toggle Button
local toggleBtn = Instance.new("ImageButton", screenGui)
toggleBtn.Name = "ToggleBtn"
toggleBtn.Size = UDim2.new(0, 50, 0, 50)
toggleBtn.Position = UDim2.new(0, 20, 0.5, -25)
toggleBtn.Image = "rbxassetid://113632547593752"
toggleBtn.BackgroundTransparency = 1
toggleBtn.ZIndex = 2
Instance.new("UICorner", toggleBtn).CornerRadius = UDim.new(1, 0)

-- Hiệu ứng phóng to
local info = TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local enlarge = TweenService:Create(toggleBtn, info, {Size = UDim2.new(0, 58, 0, 58)})
local shrink = TweenService:Create(toggleBtn, info, {Size = UDim2.new(0, 50, 0, 50)})
toggleBtn.MouseButton1Down:Connect(function() enlarge:Play() end)
toggleBtn.MouseButton1Up:Connect(function() shrink:Play() end)

-- Main UI
local main = Instance.new("Frame", screenGui)
main.Size = UDim2.new(0, 200, 0, 280)
main.Position = UDim2.new(0.5, -150, 0.5, -200)
main.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
main.BackgroundTransparency = 0.3
main.Visible = false
main.ZIndex = 1
Instance.new("UICorner", main).CornerRadius = UDim.new(0, 12)

-- Close Button
local closeBtn = Instance.new("TextButton", main)
closeBtn.Text = "X"
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(1, -35, 0, 5)
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(1, 0)
closeBtn.MouseButton1Click:Connect(function()
	main.Visible = false
end)

-- Title
local title = Instance.new("TextLabel", main)
title.Size = UDim2.new(1, 0, 0, 40)
title.Position = UDim2.new(0, 0, 0, 10)
title.BackgroundTransparency = 1
title.Text = "Phucmax"
title.Font = Enum.Font.GothamBold
title.TextSize = 24
title.TextColor3 = Color3.fromRGB(255, 255, 255)

-- Avatar
local avatar = Instance.new("ImageLabel", main)
avatar.Size = UDim2.new(0, 80, 0, 80)
avatar.Position = UDim2.new(0.5, -40, 0, 60)
avatar.BackgroundTransparency = 1
avatar.Image = "rbxthumb://type=AvatarHeadShot&id=" .. LocalPlayer.UserId .. "&w=150&h=150"

-- Name
local uname = Instance.new("TextLabel", main)
uname.Size = UDim2.new(1, 0, 0, 30)
uname.Position = UDim2.new(0, 0, 0, 145)
uname.BackgroundTransparency = 1
uname.Text = LocalPlayer.Name
uname.TextColor3 = Color3.fromRGB(255, 255, 255)
uname.Font = Enum.Font.Gotham
uname.TextSize = 18

-- @Name
local tag = Instance.new("TextLabel", main)
tag.Size = UDim2.new(1, 0, 0, 25)
tag.Position = UDim2.new(0, 0, 0, 170)
tag.BackgroundTransparency = 1
tag.Text = "@" .. LocalPlayer.Name
tag.TextColor3 = Color3.fromRGB(150, 150, 150)
tag.Font = Enum.Font.Gotham
tag.TextSize = 14

-- Scroll Frame
local scrollFrame = Instance.new("ScrollingFrame", main)
scrollFrame.Size = UDim2.new(1, 0, 0, 170)
scrollFrame.Position = UDim2.new(0, 0, 0, 200)
scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 1000)
scrollFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
scrollFrame.ScrollBarThickness = 6
scrollFrame.BackgroundTransparency = 1
scrollFrame.ScrollingDirection = Enum.ScrollingDirection.Y

-- Button Creator
local y = 0
function createButton(name, callback, default)
	local btn = Instance.new("TextButton", scrollFrame)
	btn.Size = UDim2.new(0.9, 0, 0, 35)
	btn.Position = UDim2.new(0.05, 0, 0, y)
	y = y + 40
	btn.Text = name
	btn.TextColor3 = Color3.fromRGB(255, 255, 255)
	btn.Font = Enum.Font.Gotham
	btn.TextSize = 16
	btn.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
	btn.AutoButtonColor = false
	Instance.new("UICorner", btn).CornerRadius = UDim.new(1, 0)

	local state = default
	local function update()
		btn.BackgroundColor3 = state and Color3.fromRGB(30, 200, 30) or Color3.fromRGB(10, 10, 10)
	end
	btn.MouseButton1Click:Connect(function()
		state = not state
		update()
		callback(state)
	end)
	update()
end

function createRunButton(name, func)
	local btn = Instance.new("TextButton", scrollFrame)
	btn.Size = UDim2.new(0.9, 0, 0, 35)
	btn.Position = UDim2.new(0.05, 0, 0, y)
	y = y + 40
	btn.Text = name
	btn.TextColor3 = Color3.fromRGB(255, 255, 255)
	btn.Font = Enum.Font.Gotham
	btn.TextSize = 16
	btn.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
	btn.AutoButtonColor = false
	Instance.new("UICorner", btn).CornerRadius = UDim.new(1, 0)
	btn.MouseButton1Click:Connect(func)
end

-- === TOGGLE FUNCTIONS ===
-- Godmode
local godConn
createButton("Godmode", function(state)
    local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local hum = char:WaitForChild("Humanoid")
    if state then
        if godConn then godConn:Disconnect() end
        godConn = hum:GetPropertyChangedSignal("Health"):Connect(function()
            if hum.Health < 100 then hum.Health = 100 end
        end)
    else
        if godConn then godConn:Disconnect() godConn = nil end
    end
end, false)

-- Anti Hit (bay lên khi có người tới gần)
local dodgeFly = false
createButton("Anti-Hit", function(state) dodgeFly = state end, false)
task.spawn(function()
	while task.wait(0.02) do
		if dodgeFly and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
			local myHRP = LocalPlayer.Character.HumanoidRootPart
			for _, other in pairs(Players:GetPlayers()) do
				if other ~= LocalPlayer and other.Character and other.Character:FindFirstChild("HumanoidRootPart") then
					local theirHRP = other.Character.HumanoidRootPart
					if (myHRP.Position - theirHRP.Position).Magnitude < 7 then
						myHRP.CFrame = myHRP.CFrame + Vector3.new(0, 10, 0)
						break
					end
				end
			end
		end
	end
end)

-- Tàng hình
createButton("Invisible", function(state)
	local char = LocalPlayer.Character
	if char then
		for _, v in pairs(char:GetDescendants()) do
			if v:IsA("BasePart") and v.Name ~= "HumanoidRootPart" then
				v.Transparency = state and 1 or 0
			end
		end
	end
end, false)

-- Nhảy vô hạn
local jumpConn
createButton("Infinite Jump", function(state)
	if state then
		jumpConn = UIS.JumpRequest:Connect(function()
			local char = LocalPlayer.Character
			if char and char:FindFirstChild("Humanoid") then
				char:FindFirstChild("Humanoid"):ChangeState("Jumping")
			end
		end)
	else
		if jumpConn then jumpConn:Disconnect() end
	end
end, false)

-- === RUN FUNCTIONS ===
createRunButton("Teleport Sky", function()
	local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
	if hrp then hrp.CFrame = hrp.CFrame + Vector3.new(0, 200, 0) end
end)

createRunButton("Fall Down", function()
	local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
	if hrp then hrp.CFrame = hrp.CFrame - Vector3.new(0, 100, 0) end
end)

createRunButton("Ascend to Floor 1", function()
	loadstring(game:HttpGet("https://raw.githubusercontent.com/phuccodelo2/Bot_discord-/refs/heads/main/tungtung.txt"))()
end)

createRunButton("Ascend to Floor 2", function()
	loadstring(game:HttpGet("https://raw.githubusercontent.com/phuccodelo2/Bot_discord-/refs/heads/main/phucmax_ui.lua"))()
end)

-- Di chuyển UI
local function makeDraggable(frame)
	local dragging = false
	local startInputPos, startFramePos

	frame.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			startInputPos = input.Position
			startFramePos = frame.Position
			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then dragging = false end
			end)
		end
	end)

	UIS.InputChanged:Connect(function(input)
		if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
			local delta = input.Position - startInputPos
			frame.Position = UDim2.new(startFramePos.X.Scale, startFramePos.X.Offset + delta.X,
				startFramePos.Y.Scale, startFramePos.Y.Offset + delta.Y)
		end
	end)
end

makeDraggable(main)
makeDraggable(toggleBtn)

-- Toggle UI
toggleBtn.MouseButton1Click:Connect(function()
	main.Visible = not main.Visible
end)
