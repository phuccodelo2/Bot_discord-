local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local UIS = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer
local teleportEnabled = false

-- Danh sách các cửa tầng 2
local doorPositions = {
    Vector3.new(-519.3, 12.9, -134.7),
    Vector3.new(-519.4, 12.9, -25.7),
    Vector3.new(-520.3, 12.9, 80.5),
    Vector3.new(-520.5, 12.9, 188.0),
    Vector3.new(-299.4, 12.9, -65.5),
    Vector3.new(-300.7, 12.9, 145.5),
    Vector3.new(-300.8, 12.9, 39.2),
    Vector3.new(-299.5, 12.9, 254.9),
}

-- Tìm cửa gần nhất
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

-- Lấy vị trí ESP base
local function getESPBase()
	local base = workspace:FindFirstChild("ESPBase")
	return base and base.Position
end

-- Bay mượt
local function smoothMove(targetPos)
	local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
	if not hrp then return end
	while (hrp.Position - targetPos).Magnitude > 3 and teleportEnabled do
		local dir = (targetPos - hrp.Position).Unit
		hrp.CFrame = hrp.CFrame + dir * (90/60)
		task.wait(1/60)
	end
end

-- Chức năng chính
local function teleportToF2()
	local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
	if not hrp then return end
	local door = getClosestDoor()
	if not door then return end

	smoothMove(door)
	task.wait(0.1)
	hrp.CFrame = hrp.CFrame + Vector3.new(0, 200, 0)
	task.wait(0.2)

	local basePos = getESPBase()
	if basePos then
		local targetXZ = Vector3.new(basePos.X, hrp.Position.Y, basePos.Z)
		smoothMove(targetXZ)
	end
end

-- UI
local gui = Instance.new("ScreenGui", CoreGui)
gui.Name = "PhucTeleportF2"
gui.ResetOnSpawn = false

local btn = Instance.new("TextButton")
btn.Parent = gui
btn.Size = UDim2.new(0, 40, 0, 40)
btn.Position = UDim2.new(1, -80, 0.5, -30)
btn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
btn.TextColor3 = Color3.fromRGB(0, 255, 127)
btn.Text = "2"
btn.TextScaled = true
btn.BorderSizePixel = 0
btn.Font = Enum.Font.GothamBold

-- Bo góc và viền 7 màu
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
	while true do
		gradient.Rotation += 1
		task.wait(0.03)
	end
end)

-- Kéo nút
local dragging = false
local dragStart, startPos
btn.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = true
		dragStart = input.Position
		startPos = btn.Position
		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
			end
		end)
	end
end)

UIS.InputChanged:Connect(function(input)
	if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
		local delta = input.Position - dragStart
		btn.Position = UDim2.new(
			startPos.X.Scale, startPos.X.Offset + delta.X,
			startPos.Y.Scale, startPos.Y.Offset + delta.Y
		)
	end
end)

-- Khi nhấn nút
btn.MouseButton1Click:Connect(function()
	if teleportEnabled then return end
	teleportEnabled = true
	btn.Text = "..."
	btn.BackgroundColor3 = Color3.fromRGB(0, 200, 0)

	teleportToF2()

	teleportEnabled = false
	btn.Text = "F2"
	btn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
end)
