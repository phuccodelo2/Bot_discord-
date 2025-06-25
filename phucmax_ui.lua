repeat wait() until game:IsLoaded()
local UIS = game:GetService("UserInputService")
local TS = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")

-- 🌀 Viền 7 màu chạy quanh
local function rainbowStroke(target)
	local stroke = Instance.new("UIStroke", target)
	stroke.Thickness = 2
	stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	local grad = Instance.new("UIGradient", stroke)
	grad.Rotation = 0
	grad.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)),
		ColorSequenceKeypoint.new(0.2, Color3.fromRGB(255, 255, 0)),
		ColorSequenceKeypoint.new(0.4, Color3.fromRGB(0, 255, 0)),
		ColorSequenceKeypoint.new(0.6, Color3.fromRGB(0, 255, 255)),
		ColorSequenceKeypoint.new(0.8, Color3.fromRGB(0, 0, 255)),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 0, 255)),
	})
	coroutine.wrap(function()
		while grad and grad.Parent do
			grad.Rotation = (grad.Rotation + 1) % 360
			wait(0.02)
		end
	end)()
end

-- UI
local gui = Instance.new("ScreenGui", CoreGui)
gui.Name = "ScriptTongHop"
gui.ResetOnSpawn = false

-- Logo bật menu
local logo = Instance.new("ImageButton", gui)
logo.Size = UDim2.new(0, 60, 0, 60)
logo.Position = UDim2.new(0, 10, 0.35, 0)
logo.Image = "rbxassetid://139344694264003"
logo.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
logo.AutoButtonColor = true
Instance.new("UICorner", logo).CornerRadius = UDim.new(0, 14)
logo.Active = true
logo.Draggable = true
rainbowStroke(logo)

-- Menu chính
local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0, 500, 0, 360)
main.Position = UDim2.new(0.5, -250, 0.5, -180)
main.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
main.Visible = true
main.Active = true
main.Draggable = true
Instance.new("UICorner", main).CornerRadius = UDim.new(0, 10)
rainbowStroke(main)

logo.MouseButton1Click:Connect(function()
	main.Visible = not main.Visible
end)

-- Tab bar
local tabFrame = Instance.new("Frame", main)
tabFrame.Size = UDim2.new(1, 0, 0, 50)
tabFrame.Position = UDim2.new(0, 0, 0, 0)
tabFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Instance.new("UICorner", tabFrame).CornerRadius = UDim.new(0, 6)

local tabScroll = Instance.new("ScrollingFrame", tabFrame)
tabScroll.Size = UDim2.new(1, 0, 1, 0)
tabScroll.CanvasSize = UDim2.new(0, 700, 0, 0)
tabScroll.ScrollBarThickness = 2
tabScroll.BackgroundTransparency = 1
tabScroll.ScrollingDirection = Enum.ScrollingDirection.X

-- Các tab
local scriptLinks = {
    "https://pastebin.com/raw/xxxxxxxx", -- Script1
    "https://pastebin.com/raw/yyyyyyyy", -- Script2
    "https://pastebin.com/raw/zzzzzzzz", -- Script3
    "https://pastebin.com/raw/aaaaaaaa", -- Script4
}
local tabNames = {"Script1", "Script2", "Script3", "Script4"}
local tabPages = {}

local function createScroll(parent)
	local frame = Instance.new("Frame", parent)
	frame.Size = UDim2.new(1, -20, 1, -20)
	frame.Position = UDim2.new(0, 10, 0, 10)
	frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
	Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 6)

	local scroll = Instance.new("ScrollingFrame", frame)
	scroll.Size = UDim2.new(1, 0, 1, 0)
	scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
	scroll.CanvasSize = UDim2.new(0, 0, 0, 600)
	scroll.ScrollBarThickness = 4
	scroll.BackgroundTransparency = 1
	scroll.ScrollingDirection = Enum.ScrollingDirection.Y
	scroll.Name = "Content"

	return scroll
end

for i, name in ipairs(tabNames) do
	local btn = Instance.new("TextButton", tabScroll)
	btn.Size = UDim2.new(0, 120, 0, 38)
	btn.Position = UDim2.new(0, (i - 1) * 125 + 10, 0, 6)
	btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
	btn.TextColor3 = Color3.fromRGB(255, 255, 255)
	btn.Font = Enum.Font.GothamBold
	btn.TextSize = 14
	btn.Text = name
	Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)

	btn.MouseEnter:Connect(function()
		TS:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(70, 70, 70)}):Play()
	end)
	btn.MouseLeave:Connect(function()
		TS:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(50, 50, 50)}):Play()
	end)

	local page = Instance.new("Frame", main)
	page.Size = UDim2.new(1, -20, 1, -60)
	page.Position = UDim2.new(0, 10, 0, 55)
	page.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
	page.Visible = (i == 1)
	Instance.new("UICorner", page).CornerRadius = UDim.new(0, 8)
	tabPages[name] = page

	local scroll = createScroll(page)
	local runBtn = Instance.new("TextButton", scroll)
	runBtn.Size = UDim2.new(1, -20, 0, 44)
	runBtn.Position = UDim2.new(0, 10, 0, 10)
	runBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
	runBtn.TextColor3 = Color3.new(1, 1, 1)
	runBtn.Font = Enum.Font.GothamBold
	runBtn.TextSize = 16
	runBtn.Text = " CHẠY SCRIPT"
	Instance.new("UICorner", runBtn).CornerRadius = UDim.new(0, 8)

	runBtn.MouseButton1Click:Connect(function()
		local link = scriptLinks[i]
		if link then
			pcall(function()
				loadstring(game:HttpGet(link))()
			end)
		end
	end)

	runBtn.MouseEnter:Connect(function()
		TS:Create(runBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(80, 160, 100)}):Play()
	end)
	runBtn.MouseLeave:Connect(function()
		TS:Create(runBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(60, 120, 80)}):Play()
	end)

	btn.MouseButton1Click:Connect(function()
		for _, p in pairs(tabPages) do p.Visible = false end
		page.Visible = true
	end)
end
