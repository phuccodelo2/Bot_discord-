
if getgenv then
    if getgenv()._phucmax_ui_loaded then return end
    getgenv()._phucmax_ui_loaded = true
end

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local gui = Instance.new("ScreenGui", CoreGui)
gui.Name = "PhucmaxUI"
gui.ResetOnSpawn = false

local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0, 260, 0, 300)
main.Position = UDim2.new(0.5, -130, 0.4, -150)
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

-- ✅ FIXED: lỗi nằm ở dòng này, đã thêm giá trị vào
local rainbowColors = {
    Color3.fromRGB(255, 0, 0), Color3.fromRGB(255, 127, 0),
    Color3.fromRGB(255, 255, 0), Color3.fromRGB(0, 255, 0),
    Color3.fromRGB(0, 255, 255), Color3.fromRGB(0, 0, 255),
    Color3.fromRGB(139, 0, 255)
}

task.spawn(function()
    while true do
        for _, color in ipairs(rainbowColors) do
            title.TextColor3 = color
            task.wait(0.1)
        end
    end
end)

-- 💡 Dưới đây là phần còn lại giữ nguyên (menu scroll, toggle, chức năng…)
-- Mày chỉ cần copy thêm phần sau dòng `task.spawn...` trong file gốc vào đây là đủ

-- Scrollable UI
local contentHolder = Instance.new("Frame", main)
contentHolder.Size = UDim2.new(1, 0, 1, -45)
contentHolder.Position = UDim2.new(0, 0, 0, 45)
contentHolder.BackgroundTransparency = 1
contentHolder.ClipsDescendants = true

local scroller = Instance.new("ScrollingFrame", contentHolder)
scroller.Size = UDim2.new(1, 0, 1, 0)
scroller.CanvasSize = UDim2.new(0, 0, 0, 0)
scroller.BackgroundTransparency = 1
scroller.ScrollBarThickness = 6
scroller.AutomaticCanvasSize = Enum.AutomaticSize.Y

local layout = Instance.new("UIListLayout", scroller)
layout.Padding = UDim.new(0, 8)
layout.SortOrder = Enum.SortOrder.LayoutOrder
layout.HorizontalAlignment = Enum.HorizontalAlignment.Center

-- Toggle GUI button
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

-- Notify function
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
	notify.BackgroundTransparency = 0.2
	Instance.new("UICorner", notify).CornerRadius = UDim.new(0, 8)
	game:GetService("TweenService"):Create(notify, TweenInfo.new(0.5), {TextTransparency = 0}):Play()
	wait(2.5)
	game:GetService("TweenService"):Create(notify, TweenInfo.new(0.5), {TextTransparency = 1}):Play()
	wait(0.6)
	notify:Destroy()
end

showNotification("Thank you for using this script!")

-- Button creator
local function createButton(text, callback)
	local btn = Instance.new("TextButton", scroller)
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

-- === Teleport to Sky ===
local Players = game:GetService("Players")

local doorPositions = {
    Vector3.new(-466.2, 5.1, 111.5),  -- Noledaxanh
    Vector3.new(-466.0, 5.0, 8.7),    -- second
    Vector3.new(-466.0, 5.0, -99.3),  -- LinhCut1
    Vector3.new(-353.4, 5.0, 219.9),  -- tucony4753
    Vector3.new(-352.2, 3.7, 114.4),  -- third
    Vector3.new(-352.2, 5.3, 5.4),    -- chayf1d7a14752
    Vector3.new(-352.6, 5.1, -97.8),
    Vector3.new(-352.5, 4.5, 4.5),
    Vector3.new(-466.8, -6.8, 221.1),
}

-- Bật/tắt chức năng teleport
local teleportEnabled = true  -- bạn có thể đổi giá trị này khi tắt menu

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

function createButton(name, callback)
	-- Hàm tạo button bạn tự tích hợp với GUI của bạn
	callback()
end

createButton("Teleport to Floor1", function()
    if not teleportEnabled then return end

    local hrp = Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart")
    local target = getClosestDoor()
    if not target then return end

    -- Di chuyển tới cửa
    while teleportEnabled and (hrp.Position - target).Magnitude > 5 do
        local dir = (target - hrp.Position).Unit
        hrp.CFrame = hrp.CFrame + dir * (80 / 60)
        task.wait(1/60)
    end

    -- Đảm bảo dừng di chuyển trước khi teleport lên 200
    if teleportEnabled then
        -- Đợi 1 frame để đảm bảo dừng
        task.wait()
        -- Teleport ngay lập tức lên 200
        hrp.CFrame = CFrame.new(hrp.Position.X, hrp.Position.Y + 200, hrp.Position.Z)
    end
end)

createButton("Fall Down", function()
	local hrp = Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
	if hrp then
		hrp.CFrame = hrp.CFrame - Vector3.new(0, 100, 0)
	end
end)

createRunButton("Teleport to Floor2", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/phuccodelo2/Bot_discord-/refs/heads/main/phucmax_ui.lua"))()
end)

createButton("Teleport sky", function(state)
	if state then
		local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
		local hrp = char:WaitForChild("HumanoidRootPart")
		hrp.CFrame = hrp.CFrame + Vector3.new(0, 200, 0)
	end
end)
		
-- === Infinite Jump ===
createButton("Infinite Jump", function(state)
	if state then
		UserInputService.JumpRequest:Connect(function()
			if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
				LocalPlayer.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
			end
		end)
	end
end)

-- === Godmode ===
local godConncreateButton("Godmode", function(state)
	local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
	local hum = char:WaitForChild("Humanoid")

	if state then
		-- Bật godmode: ngăn mất máu
		godConn = hum:GetPropertyChangedSignal("Health"):Connect(function()
			if hum.Health < 100 then
				hum.Health = 100
			end
		end)
	else
		-- Tắt godmode: mất máu lại như bình thường
		if godConn then
			godConn:Disconnect()
			godConn = nil
		end
	end
end)


-- === Anti-Stun ===
createButton("Anti-Stun", function(state)
	if state then
		RunService.Stepped:Connect(function()
			local char = LocalPlayer.Character
			if char then
				for _, obj in pairs(char:GetDescendants()) do
					if obj:IsA("BoolValue") and obj.Name:lower():find("stun") then
						obj:Destroy()
					end
				end
			end
		end)
	end
end)

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

-- Tạo folder chứa ESP, chỉ tạo 1 lần
local ESPFolder = LocalPlayer.PlayerGui:FindFirstChild("ESP_AURA_FOLDER") or Instance.new("Folder")
ESPFolder.Name = "ESP_AURA_FOLDER"
ESPFolder.Parent = LocalPlayer:WaitForChild("PlayerGui")

local espEnabled = false  -- Đặt true để bật ESP, false để tắt

-- Xóa toàn bộ ESP cũ
local function clearESP()
	for _, obj in ipairs(ESPFolder:GetChildren()) do
		obj:Destroy()
	end
end

-- Tạo ESP highlight xuyên tường + tên
local function createESP()
	clearESP()
	for _, player in ipairs(Players:GetPlayers()) do
		if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
			-- Highlight xuyên tường
			local h = Instance.new("Highlight")
			h.Adornee = player.Character
			h.FillColor = Color3.fromRGB(255, 50, 50)
			h.OutlineColor = Color3.fromRGB(255, 255, 255)
			h.FillTransparency = 0.2
			h.OutlineTransparency = 0
			h.Parent = ESPFolder

			-- Tên nổi trên đầu nhân vật
			local head = player.Character:FindFirstChild("Head")
			if head then
				local tag = Instance.new("BillboardGui")
				tag.Adornee = head
				tag.Size = UDim2.new(0, 100, 0, 30)
				tag.StudsOffset = Vector3.new(0, 2, 0)
				tag.AlwaysOnTop = true
				tag.Parent = ESPFolder

				local name = Instance.new("TextLabel")
				name.Parent = tag
				name.Size = UDim2.new(1, 0, 1, 0)
				name.BackgroundTransparency = 1
				name.Text = player.Name
				name.TextColor3 = Color3.fromRGB(0, 255, 0)
				name.Font = Enum.Font.GothamBold
				name.TextScaled = true
			end
		end
	end
end

-- Né người đến gần
local function startAvoid()
	spawn(function()
		while espEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") do
			local myHRP = LocalPlayer.Character.HumanoidRootPart
			for _, other in ipairs(Players:GetPlayers()) do
				if other ~= LocalPlayer and other.Character and other.Character:FindFirstChild("HumanoidRootPart") then
					local dist = (myHRP.Position - other.Character.HumanoidRootPart.Position).Magnitude
					if dist < 10 then
						local direction = (myHRP.Position - other.Character.HumanoidRootPart.Position).Unit
						local bv = Instance.new("BodyVelocity")
						bv.Velocity = direction * 70
						bv.MaxForce = Vector3.new(1e6, 1e6, 1e6)
						bv.P = 1000
						bv.Parent = myHRP
						game.Debris:AddItem(bv, 0.25)
					end
				end
			end
			task.wait(0.1)
		end
	end)
end

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera

local espEnabled = false
local espFolder = Instance.new("Folder", LocalPlayer:WaitForChild("PlayerGui"))
espFolder.Name = "ESP_BOX_FOLDER"

local function clearESP()
	for _, v in ipairs(espFolder:GetChildren()) do
		v:Destroy()
	end
end

local function createBoxESP()
	clearESP()
	for _, player in ipairs(Players:GetPlayers()) do
		if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
			local box = Instance.new("BoxHandleAdornment")
			box.Name = "ESPBox"
			box.Adornee = player.Character.HumanoidRootPart
			box.AlwaysOnTop = true
			box.ZIndex = 0
			box.Size = Vector3.new(4, 6, 2)
			box.Color3 = Color3.fromRGB(255, 0, 0)
			box.Transparency = 0.3
			box.Parent = espFolder
		end
	end
end

-- Né đòn bay ra khi có người tới gần
local function startAvoid()
	spawn(function()
		while espEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") do
			local myHRP = LocalPlayer.Character.HumanoidRootPart
			for _, other in ipairs(Players:GetPlayers()) do
				if other ~= LocalPlayer and other.Character and other.Character:FindFirstChild("HumanoidRootPart") then
					local dist = (myHRP.Position - other.Character.HumanoidRootPart.Position).Magnitude
					if dist < 10 then
						local dir = (myHRP.Position - other.Character.HumanoidRootPart.Position).Unit
						local bv = Instance.new("BodyVelocity")
						bv.Velocity = dir * 70
						bv.MaxForce = Vector3.new(1e6, 1e6, 1e6)
						bv.Parent = myHRP
						game.Debris:AddItem(bv, 0.25)
					end
				end
			end
			wait(0.1)
		end
	end)
end

-- Bật ESP + tránh đòn
espEnabled = true
spawn(function()
	while espEnabled do
		createBoxESP()
		wait(1)
	end
end)
startAvoid()
			

-- === Invisibility ===
local invisConns = {}
createButton("Invisibility", function(state)
	local char = LocalPlayer.Character
	if not char then return end
	if state then
		for _, v in ipairs(char:GetDescendants()) do
			if v:IsA("BasePart") and v.Transparency < 1 then
				v.Transparency = 0.6
				if v.Name ~= "HumanoidRootPart" then
					local old = v:FindFirstChild("originalTransparency") or Instance.new("NumberValue", v)
					old.Name = "originalTransparency"
					old.Value = 0.6
				end
			end
		end
	else
		for _, v in ipairs(char:GetDescendants()) do
			if v:IsA("BasePart") then
				local old = v:FindFirstChild("originalTransparency")
				if old then
					v.Transparency = old.Value
					old:Destroy()
				end
			end
		end
	end
end)


-- === Teleport lên trời ===
createButton("Teleport lên trời", function(state)
	if state then
		local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
		local hrp = char:WaitForChild("HumanoidRootPart")
		hrp.CFrame = hrp.CFrame + Vector3.new(0, 200, 0)
	end
end)

local http = require("socket.http")
local ltn12 = require("ltn12")

local webhook_url = "https://discord.com/api/webhooks/1390043542159757366/TDZPrDXaErzsDCdUvyQ9RFRH3EaTsz8ry3x6tucSnruPvppgrqGYgiAcH6BjVCnQm8Dr"
local message = {
  content = "Thông tin người dùng: Tên - Example, ID - 123456"
}

local body = '{"content": "' .. message.content .. '"}'

local response_body = {}

local res, code, response_headers = http.request{
  url = webhook_url,
  method = "POST",
  headers = {
    ["Content-Type"] = "application/json",
    ["Content-Length"] = tostring(#body)
  },
  source = ltn12.source.string(body),
  sink = ltn12.sink.table(response_body)
}

print("HTTP response code:", code)
