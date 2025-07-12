-- NÚT 2: Bay đến cửa tầng 2 > bay đến ESPBase > bay đến ESP_LOCK_POINT
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local UIS = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

local teleportEnabled = false

local doorPositions = {
	Vector3.new(-519.3, 12.9, -134.7), Vector3.new(-519.4, 12.9, -25.7),
	Vector3.new(-520.3, 12.9, 80.5), Vector3.new(-520.5, 12.9, 188.0),
	Vector3.new(-299.4, 12.9, -65.5), Vector3.new(-300.7, 12.9, 145.5),
	Vector3.new(-300.8, 12.9, 39.2), Vector3.new(-299.5, 12.9, 254.9),
}

local function getESPBase()
	local base = workspace:FindFirstChild("ESPBase")
	return base and base.Position
end

local function getESP_Locks()
	local parts = {}
	for _, obj in ipairs(workspace:GetChildren()) do
		if obj:IsA("BasePart") and obj.Name == "ESP_LOCK_POINT" then
			table.insert(parts, obj)
		end
	end
	return parts
end

local function getClosestDoor()
	local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
	local closest, minDist = nil, math.huge
	if not hrp then return end
	for _, pos in ipairs(doorPositions) do
		local dist = (hrp.Position - pos).Magnitude
		if dist < minDist then
			minDist = dist
			closest = pos
		end
	end
	return closest
end

local function smoothMove(targetPos, speed)
	local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
	if not hrp then return end
	while (hrp.Position - targetPos).Magnitude > 3 and teleportEnabled do
		local dir = (targetPos - hrp.Position).Unit
		hrp.CFrame = hrp.CFrame + dir * (speed / 60)
		task.wait(1/60)
	end
end

local function run()
	local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
	if not hrp then return end
	local door = getClosestDoor()
	if door then smoothMove(door, 49) end

	task.wait(0.1)
	hrp.CFrame = hrp.CFrame + Vector3.new(0, 200, 0)
	task.wait(0.1)

	local base = getESPBase()
	if base then smoothMove(Vector3.new(base.X, hrp.Position.Y, base.Z), 49) end

	hrp.CFrame = CFrame.new(hrp.Position.X, 190, hrp.Position.Z)
	for _, part in ipairs(getESP_Locks()) do
		smoothMove(part.Position + Vector3.new(0, 5, 0), 49)
	end
end

-- UI nút
local gui = Instance.new("ScreenGui", CoreGui)
gui.Name = "Button2"
gui.ResetOnSpawn = false

local btn = Instance.new("TextButton")
btn.Parent = gui
btn.Size = UDim2.new(0, 40, 0, 40)
btn.Position = UDim2.new(0, 60, 0.5, -30)
btn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
btn.TextColor3 = Color3.fromRGB(0, 255, 127)
btn.Text = "2"
btn.TextScaled = true
btn.Font = Enum.Font.GothamBold
btn.BorderSizePixel = 0

Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 12)
local stroke = Instance.new("UIStroke", btn)
stroke.Thickness = 2
stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

local gradient = Instance.new("UIGradient", stroke)
gradient.Color = ColorSequence.new{
	ColorSequenceKeypoint.new(0, Color3.fromRGB(255,0,0)),
	ColorSequenceKeypoint.new(0.2, Color3.fromRGB(255,127,0)),
	ColorSequenceKeypoint.new(0.4, Color3.fromRGB(255,255,0)),
	ColorSequenceKeypoint.new(0.6, Color3.fromRGB(0,255,0)),
	ColorSequenceKeypoint.new(0.8, Color3.fromRGB(0,0,255)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(255,0,255))
}
task.spawn(function()
	while true do gradient.Rotation += 1 task.wait(0.03) end
end)

-- Kéo nút
local dragging, dragStart, startPos = false
btn.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = true dragStart = input.Position startPos = btn.Position
		input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end)
	end
end)
UIS.InputChanged:Connect(function(input)
	if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
		local delta = input.Position - dragStart
		btn.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X,
		                         startPos.Y.Scale, startPos.Y.Offset + delta.Y)
	end
end)

btn.MouseButton1Click:Connect(function()
	if teleportEnabled then return end
	teleportEnabled = true
	btn.Text = "..."
	btn.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
	run()
	teleportEnabled = false
	btn.Text = "2"
	btn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
end)
