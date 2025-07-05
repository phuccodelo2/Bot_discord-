local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")

local teleportEnabled = false

-- Danh sách các tọa độ cửa
local doorPositions = {
    Vector3.new(-519.3, 12.9, -134.7),  -- Noledaxanh
    Vector3.new(-519.4, 12.9, -25.7),
    Vector3.new(-520.3, 12.9, 80.5),  -- LinhCut1
    Vector3.new(-520.5, 12.9, 188.0),
    Vector3.new(-299.4, 12.9, -65.5),
    Vector3.new(-300.7, 12.9, 145.5),
    Vector3.new(-300.8, 12.9, 39.2),
    Vector3.new(-299.5, 12.9, 254.9),
}

-- Tìm cửa gần nhất
local function getClosestDoor()
	local hrp = Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart")
	local closest, minDist = nil, math.huge
	for _, pos in ipairs(doorPositions) do
		local dist = (hrp.Position - pos).Magnitude
		if dist < minDist then
			minDist = dist
			closest = pos
		end
	end
	return closest
end

-- Teleport tới cửa gần nhất
local function teleportToClosest()
	local hrp = Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart")
	local target = getClosestDoor()
	if not target then return end

	while teleportEnabled and (hrp.Position - target).Magnitude > 5 do
		local dir = (target - hrp.Position).Unit
		hrp.CFrame = hrp.CFrame + dir * (100 / 60)
		task.wait(1/60)
	end

	if teleportEnabled then
		hrp.CFrame = CFrame.new(hrp.Position + Vector3.new(0, 200, 0))
	end
end

-- Giao diện bật/tắt
local gui = Instance.new("ScreenGui", CoreGui)
gui.Name = "Teleport to Floor2"
gui.ResetOnSpawn = false

local btn = Instance.new("TextButton", gui)
btn.Size = UDim2.new(0, 50, 0, 50)
btn.Position = UDim2.new(0.5, -25, 0.45, 0)
btn.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
btn.TextColor3 = Color3.new(1, 1, 1)
btn.Text = "▶ Tele 2 "
btn.Font = Enum.Font.GothamBold
btn.TextSize = 16
btn.Draggable = true
btn.Active = true
Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)

btn.MouseButton1Click:Connect(function()
	if teleportEnabled then return end
	teleportEnabled = true
	btn.Text = "teleport"
	btn.BackgroundColor3 = Color3.fromRGB(0, 200, 0)

	teleportToClosest()

	teleportEnabled = false
	btn.Text = "teleport"
	btn.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
end)
