-- === CHỨC NĂNG TELEPORT BAY ĐẾN VỊ TRÍ GẦN NHẤT RỒI BAY LÊN TRỜI 200 ===

-- Danh sách các vị trí door
local doorPositions = {
	Vector3.new(-466, -1, 220), Vector3.new(-466, -2, 116),
	Vector3.new(-466, -2, 8), Vector3.new(-464, -2, -102),
	Vector3.new(-351, -2, -100), Vector3.new(-354, -2, 5),
	Vector3.new(-354, -2, 115), Vector3.new(-358, -2, 223)
}

-- Hàm tìm vị trí gần nhất
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

-- Hàm bay đến vị trí gần nhất và teleport lên trời
function goUp(onDone)
	local target = getClosestDoor()
	if not target then return end

	local hrp = game.Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart")
	local speed = 80-- tốc độ bay

	while (hrp.Position - target).Magnitude > 5 do
		local direction = (target - hrp.Position).Unit
		hrp.CFrame = hrp.CFrame + direction * (speed / 60)
		task.wait(1/60)
	end

	-- Khi đến gần, bay lên trời 200
	hrp.CFrame = hrp.CFrame + Vector3.new(0, 200, 0)

	-- Gọi hàm tắt nút sau khi xong
	if onDone then
		onDone()
	end
end
createButton("Rớt xuống", function(on)
	if on then
		local hrp = game.Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart")
		hrp.CFrame = hrp.CFrame - Vector3.new(0, 50, 0)
	end
end)
-- Hàm rơi xuống đến Y = 50


local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "PhucmaxUI"
gui.ResetOnSpawn = false

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
	Colorif root then
		root.CFrame = root.CFrame - Vector3.new(0, 50, 0)
	end
end3.fromRGB(255, 127, 0), 
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
			on = false -- tắt flag
		end)
	end
end)
createButton("rớt xuống", function(on) if on then goDown() end end)

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

	
	game:GetService("TweenService"):Create(notify, TweenInfo.new(0.5), {TextTransparency = 0, BackgroundTransparency = 0.2}):Play()
	wait(2.5)
	game:GetService("TweenService"):Create(notify, TweenInfo.new(0.5), {TextTransparency = 1, BackgroundTransparency = 1}):Play()
	wait(0.6)
	notify:Destroy()
end


showNotification("cảm ơn bạn đã sử dụng script ")
