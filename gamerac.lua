-- === CHỨC NĂNG TELEPORT BAY ĐẾN VỊ TRÍ GẦN NHẤT RỒI BAY LÊN TRỜI 200 ===

-- Danh sách các vị trí door
local doorPositions = {
	Vector3.new(-466, -1, 220), Vector3.new(-466, -2, 116),
	Vector3.new(-466, -2, 8), Vector3.new(-464, -2, -102),
	Vector3.new(-351, -2, -100), Vector3.new(-354, -2, 5),
	Vector3.new(-354, -2, 115), Vector3.new(-358, -2, 223)
}

-- Tìm vị trí gần nhất
local function getClosestDoor()
	local hrp = game.Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart")
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

-- Bay đến gần cửa rồi bay lên trời
function goUp(onDone)
	local target = getClosestDoor()
	if not target then return end

	local hrp = game.Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart")
	local speed = 80

	while (hrp.Position - target).Magnitude > 5 do
		local direction = (target - hrp.Position).Unit
		hrp.CFrame = hrp.CFrame + direction * (speed / 60)
		task.wait(1/60)
	end

	-- Bay lên trời
	hrp.CFrame = hrp.CFrame + Vector3.new(0, 200, 0)

	if onDone then onDone() end
end

function goDown()
	local hrp = game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
	if hrp then
		hrp.CFrame = hrp.CFrame - Vector3.new(0, 200, 0)
	end
end

local godModeEnabled = false
local godLoop

function setGodMode(state)
	godModeEnabled = state

	if godModeEnabled then
		local char = game.Players.LocalPlayer.Character
		local hum = char and char:FindFirstChildOfClass("Humanoid")

		if hum then
			hum.Health = hum.MaxHealth
		end

		-- Lặp để giữ máu đầy
		godLoop = task.spawn(function()
			while godModeEnabled do
				local char = game.Players.LocalPlayer.Character
				local hum = char and char:FindFirstChildOfClass("Humanoid")
				if hum then
					hum.Health = hum.MaxHealth
					hum:GetPropertyChangedSignal("Health"):Connect(function()
						if hum.Health < hum.MaxHealth then
							hum.Health = hum.MaxHealth
						end
					end)
				end
				task.wait(0.2)
			end
		end)
	else
		if godLoop then
			task.cancel(godLoop)
		end
	end
end

local infiniteJumpEnabled = false
local jumpConnection

function setInfiniteJump(state)
	infiniteJumpEnabled = state

	if infiniteJumpEnabled then
		jumpConnection = game:GetService("UserInputService").JumpRequest:Connect(function()
			local char = game.Players.LocalPlayer.Character
			local hrp = char and char:FindFirstChild("HumanoidRootPart")
			local hum = char and char:FindFirstChildOfClass("Humanoid")
			if hum and hrp then
				hum:ChangeState(Enum.HumanoidStateType.Jumping)
			end
		end)
	else
		if jumpConnection then
			jumpConnection:Disconnect()
			jumpConnection = nil
		end
	end
end
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local localPlayer = Players.LocalPlayer

-- Xóa toàn bộ ESP cũ
local function clearESP()
	for _, obj in pairs(workspace:GetDescendants()) do
		if obj:IsA("BillboardGui") and obj.Name == "PlayerESP" then
			obj:Destroy()
		end
	end
end

-- Tạo ESP cho 1 player
local function createESP(player)
	if player == localPlayer then return end
	local char = player.Character
	if not char or not char:FindFirstChild("Head") then return end

	-- Kiểm tra trùng
	if char.Head:FindFirstChild("PlayerESP") then return end

	local esp = Instance.new("BillboardGui", char.Head)
	esp.Name = "PlayerESP"
	esp.Size = UDim2.new(0, 100, 0, 30)
	esp.Adornee = char.Head
	esp.AlwaysOnTop = true
	esp.StudsOffset = Vector3.new(0, 2.5, 0)

	local text = Instance.new("TextLabel", esp)
	text.Size = UDim2.new(1, 0, 1, 0)
	text.BackgroundTransparency = 1
	text.Text = player.Name
	text.TextColor3 = Color3.fromRGB(0, 255, 0)
	text.Font = Enum.Font.FredokaOne
	text.TextScaled = true
end

-- Cập nhật toàn bộ ESP
local function updateESP()
	clearESP()
	for _, player in ipairs(Players:GetPlayers()) do
		createESP(player)
	end
end

-- Lắng nghe sự kiện người chơi mới vào / character được load lại
Players.PlayerAdded:Connect(function(p)
	p.CharacterAdded:Connect(function()
		wait(1)
		updateESP()
	end)
end)

-- Update liên tục mỗi 2 giây
task.spawn(function()
	while true do
		updateESP()
		task.wait(1)
	end
end)

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local lp = Players.LocalPlayer

RunService.Stepped:Connect(function()
	local char = lp.Character
	if not char then return end

	for _, v in ipairs(char:GetDescendants()) do
		if v:IsA("BoolValue") or v:IsA("StringValue") or v:IsA("IntValue") or v:IsA("ObjectValue") then
			local name = v.Name:lower()
			if name:find("stun") or name:find("ragdoll") or name:find("knock") or name:find("slow") then
				v:Destroy()
			end
		end
	end
end)

-- Giao diện
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "PhucmaxUI"
gui.ResetOnSplocal Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local lp = Players.LocalPlayer
local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0, 260, 0, 270)
main.Position = UDim2.new(0.5, -130, 0.4, -175)
main.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
main.Active = true
main.Draggable = true
Instance.new("UICorner", main).CornerRadius = UDim.new(0, 10)

local title = Instance.new("TextLabel", main)
title.Size = UDim2.new(1, 0, 0, 40)
title.BackgroundTransparency = 1
title.Text = "phucmax"
title.Font = Enum.Font.FredokaOne
title.TextScaled = true
title.TextColor3 = Color3.new(1, 1, 1)

local rainbowColors = {
	Color3.fromRGB(255, 0, 0),
	Color3.fromRGB(255, 127, 0),
	Color3.fromRGB(255, 255, 0),
	Color3.fromRGB(0, 255, 0),
	Color3.fromRGB(0, 255, 255),
	Color3.fromRGB(0, 0, 255),
	Color3.fromRGB(139, 0, 255)
}

spawn(function()
	while true do
		for _, color in ipairs(rainbowColors) do
			title.TextColor3 = color
			wait(0.1)
		end
	end
end)

local content = Instance.new("Frame", main)
content.Size = UDim2.new(1, 0, 1, -50)
content.Position = UDim2.new(0, 0, 0, 45)
content.BackgroundTransparency = 1

local logo = Instance.new("ImageButton")
logo.Name = "ToggleButton"
logo.Parent = gui
logo.Size = UDim2.new(0, 50, 0, 50)
logo.Position = UDim2.new(0, 10, 0.5, -25)
logo.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
logo.Image = "rbxassetid://113632547593752"
logo.Draggable = true
Instance.new("UICorner", logo).CornerRadius = UDim.new(0, 12)

logo.MouseButton1Click:Connect(function()
	main.Visible = not main.Visible
end)

local layout = Instance.new("UIListLayout", content)
layout.Padding = UDim.new(0, 8)
layout.SortOrder = Enum.SortOrder.LayoutOrder
layout.HorizontalAlignment = Enum.HorizontalAlignment.Center

local function createButton(text, callback)
	local btn = Instance.new("TextButton", content)
	btn.Size = UDim2.new(0.85, 0, 0, 32)
	btn.BackgroundColor3 = Color3.fromRGB(170, 0, 0)
	btn.TextColor3 = Color3.new(1, 1, 1)
	btn.Text = text
	btn.Font = Enum.Font.GothamBold
	btn.TextSize = 14
	btn.AutoButtonColor = false
	Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)

	local state = false
	btn.MouseButton1Click:Connect(function()
		state = not state
		btn.BackgroundColor3 = state and Color3.fromRGB(0, 170, 0) or Color3.fromRGB(170, 0, 0)
		callback(state)
	end)
end

createButton("Teleport to Sky", function(on)
	if on then
		goUp(function()
			-- không cần set on = false, vì button đã toggle rồi
		end)
	end
end)

createButton("Rớt xuống", function(on)
	if on then
		goDown()
	end
end)

createButton("Bất tử", function(on)
	setGodMode(on)
end)

createButton("Nhảy vô hạn", function(on)
	setInfiniteJump(on)
end)
createButton("ESP Player", function(on)
	if on then
		updateESP()
	else
		clearESP()
	end
end)
local antiStunRunning = false
local connection

createButton("Anti Stun/Văng", function(on)
	if on and not antiStunRunning then
		antiStunRunning = true
		connection = RunService.RenderStepped:Connect(function()
			pcall(removeStunEffects)
		end)
	elseif not on and antiStunRunning and connection then
		connection:Disconnect()
		antiStunRunning = false
	end
end)

local function showNotification(msg)
	local notify = Instance.new("TextLabel")
	notify.Parent = gui
	notify.Size = UDim2.new(0, 300, 0, 40)
	notify.Position = UDim2.new(1, -310, 1, -60)
	notify.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
	notify.TextColor3 = Color3.fromRGB(255, 255, 255)
	notify.Font = Enum.Font.GothamBold
	notify.TextSize = 18
	notify.Text = msg
	notify.TextStrokeTransparency = 0.5
	notify.TextStrokeColor3 = Color3.new(0, 0, 0)
	notify.BackgroundTransparency = 0.2

	Instance.new("UICorner", notify).CornerRadius = UDim.new(0, 8)

	game:GetService("TweenService"):Create(notify, TweenInfo.new(0.5), {
		TextTransparency = 0,
		BackgroundTransparency = 0.2
	}):Play()

	wait(2.5)

	game:GetService("TweenService"):Create(notify, TweenInfo.new(0.5), {
		TextTransparency = 1,
		BackgroundTransparency = 1
	}):Play()

	wait(0.6)
	notify:Destroy()
end

showNotification("cảm ơn bạn đã sử dụng script")
