repeat wait() until game:IsLoaded()
local UIS = game:GetService("UserInputService")
local TS = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")

-- Hiệu ứng viền bảy màu
local function rainbow(uiframe)
	local border = Instance.new("UIStroke", uiframe)
	border.Thickness = 2
	local g = Instance.new("UIGradient", border)
	g.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)),
		ColorSequenceKeypoint.new(0.2, Color3.fromRGB(255, 255, 0)),
		ColorSequenceKeypoint.new(0.4, Color3.fromRGB(0, 255, 0)),
		ColorSequenceKeypoint.new(0.6, Color3.fromRGB(0, 255, 255)),
		ColorSequenceKeypoint.new(0.8, Color3.fromRGB(0, 0, 255)),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 0, 255)),
	})
	task.spawn(function()
		while g do
			g.Rotation = (g.Rotation + 1) % 360
			wait(0.02)
		end
	end)
end

-- GUI
local gui = Instance.new("ScreenGui", CoreGui)
gui.Name = "PhucMaxSuperUI"
gui.ResetOnSpawn = false

-- Logo vuông, bo góc, kéo được, có viền bảy màu
local logo = Instance.new("ImageButton", gui)
logo.Size = UDim2.new(0, 60, 0, 60)
logo.Position = UDim2.new(0, 10, 0.35, 0)
logo.Image = "rbxassetid://139344694264003"
logo.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
logo.BorderSizePixel = 0
logo.AutoButtonColor = true
Instance.new("UICorner", logo).CornerRadius = UDim.new(0, 12)
rainbow(logo)
logo.Active = true
logo.Draggable = true

-- Main menu - nền mờ, viền bảy màu
local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0, 640, 0, 420)
main.Position = UDim2.new(0.5, -320, 0.5, -210)
main.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
main.BackgroundTransparency = 0.15
main.Visible = true
main.Active = true
main.Draggable = true
Instance.new("UICorner", main).CornerRadius = UDim.new(0, 10)
rainbow(main)

logo.MouseButton1Click:Connect(function()
	main.Visible = not main.Visible
end)

-- Tab bar container
local tabFrame = Instance.new("Frame", main)
tabFrame.Size = UDim2.new(1, 0, 0, 50)
tabFrame.Position = UDim2.new(0, 0, 0, 0)
tabFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Instance.new("UICorner", tabFrame).CornerRadius = UDim.new(0, 6)

local tabScroll = Instance.new("ScrollingFrame", tabFrame)
tabScroll.Size = UDim2.new(1, 0, 1, 0)
tabScroll.CanvasSize = UDim2.new(0, 640, 0, 0)
tabScroll.ScrollBarThickness = 2
tabScroll.BackgroundTransparency = 1
tabScroll.ScrollingDirection = Enum.ScrollingDirection.X

-- Tạo tab
local tabNames = {"General", "Farm", "Items", "Combat"}
local tabPages = {}

for i, name in ipairs(tabNames) do
	local tabBtn = Instance.new("TextButton", tabScroll)
	tabBtn.Size = UDim2.new(0, 150, 0, 40)
	tabBtn.Position = UDim2.new(0, (i - 1) * 160 + 10, 0, 5)
	tabBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
	tabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
	tabBtn.Font = Enum.Font.GothamBold
	tabBtn.Text = name
	tabBtn.TextSize = 14
	tabBtn.AutoButtonColor = false
	Instance.new("UICorner", tabBtn).CornerRadius = UDim.new(0, 6)

	-- Hover hiệu ứng
	local function tweenColor(btn, to)
		TS:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = to}):Play()
	end
	tabBtn.MouseEnter:Connect(function() tweenColor(tabBtn, Color3.fromRGB(70, 70, 70)) end)
	tabBtn.MouseLeave:Connect(function() tweenColor(tabBtn, Color3.fromRGB(50, 50, 50)) end)

	local page = Instance.new("Frame", main)
	page.Size = UDim2.new(1, -20, 1, -60)
	page.Position = UDim2.new(0, 10, 0, 55)
	page.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
	page.BackgroundTransparency = 0.2
	page.Visible = (i == 1)
	Instance.new("UICorner", page).CornerRadius = UDim.new(0, 8)
	tabPages[name] = page

	tabBtn.MouseButton1Click:Connect(function()
		for _, p in pairs(tabPages) do p.Visible = false end
		page.Visible = true
	end)
end

-- Tạo nội dung scroll 1 bên
local function createScroll(parent)
	local col = Instance.new("Frame", parent)
	col.Size = UDim2.new(1, -20, 1, -20)
	col.Position = UDim2.new(0, 10, 0, 10)
	col.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
	Instance.new("UICorner", col).CornerRadius = UDim.new(0, 8)

	local scroll = Instance.new("ScrollingFrame", col)
	scroll.Size = UDim2.new(1, 0, 1, 0)
	scroll.CanvasSize = UDim2.new(0, 0, 0, 600)
	scroll.ScrollBarThickness = 4
	scroll.BackgroundTransparency = 1
	scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
	scroll.ScrollingDirection = Enum.ScrollingDirection.Y
	scroll.Name = "Content"

	return scroll
end

-- Toggle có animation hover
local function createToggle(text, parent, y)
	local t = Instance.new("TextButton", parent)
	t.Size = UDim2.new(1, -20, 0, 38)
	t.Position = UDim2.new(0, 10, 0, y)
	t.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
	t.TextColor3 = Color3.fromRGB(255, 255, 255)
	t.TextXAlignment = Enum.TextXAlignment.Left
	t.Font = Enum.Font.GothamSemibold
	t.TextSize = 14
	t.Text = "   ✅ " .. text
	t.AutoButtonColor = false
	Instance.new("UICorner", t).CornerRadius = UDim.new(0, 6)

	local on = true
	t.MouseButton1Click:Connect(function()
		on = not on
		t.Text = (on and "   ✅ " or "   ❌ ") .. text
	end)

	t.MouseEnter:Connect(function()
		TS:Create(t, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(80, 80, 80)}):Play()
	end)
	t.MouseLeave:Connect(function()
		TS:Create(t, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(60, 60, 60)}):Play()
	end)
end

-- Nội dung Tab General
local genScroll = createScroll(tabPages["General"])
local features = {"Auto Farm Level", "Boss Farm", "Auto Haki", "Fast Attack", "Bypass TP", "Hide Damage", "Skill Spam Z/X"}
for i, v in ipairs(features) do
	createToggle(v, genScroll, (i - 1) * 45)
end
