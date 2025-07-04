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

-- Rainbow color effect
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

-- Button creator: toggle hoặc 1 lần
local function createButton(text, callback, isToggle)
    local btn = Instance.new("TextButton", scroller)
    btn.Size = UDim2.new(0.85, 0, 0, 32)
    btn.BackgroundColor3 = Color3.fromRGB(170, 0, 0)
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Text = text
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 14
    btn.AutoButtonColor = false
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    if isToggle then
        local state = false
        btn.MouseButton1Click:Connect(function()
            state = not state
            btn.BackgroundColor3 = state and Color3.fromRGB(0, 170, 0) or Color3.fromRGB(170, 0, 0)
            callback(state)
        end)
    else
        btn.MouseButton1Click:Connect(function()
            callback()
        end)
    end
end

local function createRunButton(text, callback)
    createButton(text, callback, false)
end

-- === Teleport to Sky ===
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

local teleportEnabled = true

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

createRunButton("Teleport to Floor1", function()
    if not teleportEnabled then return end
    local hrp = Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart")
    local target = getClosestDoor()
    if not target then return end
    while teleportEnabled and (hrp.Position - target).Magnitude > 5 do
        local dir = (target - hrp.Position).Unit
        hrp.CFrame = hrp.CFrame + dir * (80 / 60)
        task.wait(1/60)
    end
    if teleportEnabled then
        hrp.CFrame = CFrame.new(hrp.Position + Vector3.new(0, 200, 0))
    end
end)

createRunButton("Fall Down", function()
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
end, true)

-- === Infinite Jump ===
local infJumpConn
createButton("Infinite Jump", function(state)
    if state then
        if infJumpConn then infJumpConn:Disconnect() end
        infJumpConn = UserInputService.JumpRequest:Connect(function()
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
                LocalPlayer.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end)
    else
        if infJumpConn then infJumpConn:Disconnect() infJumpConn = nil end
    end
end, true)

-- === Godmode ===
local godConn
createButton("Godmode", function(state)
    local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local hum = char:WaitForChild("Humanoid")
    if state then
        if godConn then godConn:Disconnect() end
        godConn = hum:GetPropertyChangedSignal("Health"):Connect(function()
            if hum.Health < 100 then
                hum.Health = 100
            end
        end)
    else
        if godConn then
            godConn:Disconnect()
            godConn = nil
        end

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local LocalPlayer = Players.LocalPlayer

local espEnabled = true
local espFolder = Instance.new("Folder", CoreGui)
espFolder.Name = "PHUCMAX_ESP_FOLDER"

local highlights = {}
local nametags = {}

-- Kiểm tra người chơi có tàng hình không
local function isCharacterInvisible(character)
	for _, part in ipairs(character:GetDescendants()) do
		if part:IsA("BasePart") and part.Transparency < 1 then
			return false
		end
	end
	return true
end

-- Xoá toàn bộ ESP
local function clearESP()
	for _, obj in pairs(highlights) do if obj then obj:Destroy() end end
	for _, obj in pairs(nametags) do if obj then obj:Destroy() end end
	highlights = {}
	nametags = {}
end

-- Tạo ESP cho người chơi
local function createESP()
	clearESP()			

	for _, player in ipairs(Players:GetPlayers()) do
		if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
			local character = player.Character
			local isInvisible = isCharacterInvisible(character)

			-- Tạo viền sáng
			local hl = Instance.new("Highlight")
			hl.Adornee = character
			hl.FillTransparency = 0.2
			hl.OutlineTransparency = 0
			hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
			hl.Parent = espFolder
			highlights[player] = {highlight = hl, invisible = isInvisible}

			-- Tạo bảng tên trên đầu
			local head = character:FindFirstChild("Head")
			if head then
				local tag = Instance.new("BillboardGui")
				tag.Name = "NameTag"
				tag.Adornee = head
				tag.Size = UDim2.new(0, 100, 0, 20)
				tag.StudsOffset = Vector3.new(0, 2.5, 0)
				tag.AlwaysOnTop = true
				tag.ResetOnSpawn = false
				tag.Parent = espFolder

				local text = Instance.new("TextLabel")
				text.Size = UDim2.new(1, 0, 1, 0)
				text.BackgroundTransparency = 1
				text.Text = player.Name
				text.TextColor3 = Color3.fromRGB(0, 255, 0)
				text.Font = Enum.Font.GothamBold
				text.TextScaled = true
				text.Parent = tag

				nametags[player] = tag
			end
		end
	end
end

-- Tạo ESP liên tục
spawn(function()
	while espEnabled do
		createESP()
		wait(1.5)
	end
end)

-- Rainbow glow viền
spawn(function()
	local hue = 0
	while espEnabled do
		hue = (hue + 0.01) % 1
		local color = Color3.fromHSV(hue, 1, 1)
		for _, data in pairs(highlights) do
			if data and data.highlight then
				data.highlight.FillColor = color
				data.highlight.OutlineColor = color
			end
		end
		RunService.Heartbeat:Wait()
	end
end)

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")

local dodgeActive = false

-- Nút bật né đòn
createButton("dodge", function(state)
	dodgeActive = state
end)

-- Theo dõi bị đánh → né ra xa
spawn(function()
	while true do
		if dodgeActive and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
			local hrp = LocalPlayer.Character.HumanoidRootPart
			for _, player in pairs(Players:GetPlayers()) do
				if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
					local target = player.Character.HumanoidRootPart
					local dist = (hrp.Position - target.Position).Magnitude
					if dist < 5 then -- Bị tiếp cận gần
						local dir = (hrp.Position - target.Position).Unit
						hrp.Velocity = dir * 100 -- Né cực nhanh
						wait(0.25)
					end
				end
			end
		end
		RunService.Heartbeat:Wait()
	end
end)			

-- === Invisibility ===
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
end, true)

			-- Webhook báo người dùng script
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- Webhook của bạn (đổi lại đúng)
local webhookUrl = "https://discord.com/api/webhooks/1390711606458978455/8rcy4C1gm5atHDuIc1b2Jje4Q73BztxRs7TZoLOM1m1592G_8bxhKCiNa2gfFDkGiqaO"

-- Chặn gửi lại nhiều lần
if not getgenv().__DaGuiWebhook then
    getgenv().__DaGuiWebhook = true

    local name = player.Name
    local displayName = player.DisplayName
    local order = math.random(1, 99999) -- Giả lập số thứ tự

    local data = {
        ["embeds"] = {{
            ["title"] = "+1 bé ",
            ["description"] = string.format("👤 **%s** (@%s)\n🔢 Số thứ tự: **%d**", name, displayName, order),
            ["color"] = tonumber(0x00ccff),
            ["footer"] = {
                ["text"] = "Script  tung tung"
            },
            ["timestamp"] = DateTime.now():ToIsoDate()
        }}
    }

    local success, response = pcall(function()
        return HttpService:PostAsync(webhookUrl, HttpService:JSONEncode(data), Enum.HttpContentType.ApplicationJson)
    end)

    if success then
        print("[Webhook] Đã gửi thông báo người dùng script.")
    else
        warn("[Webhook] Gửi thất bại:", response)
    end
			end
