local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- UI chính
local gui = Instance.new("ScreenGui", CoreGui)
gui.Name = "PhucTeleESPBaseUI"
gui.ResetOnSpawn = false

local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0, 200, 0, 100)
main.Position = UDim2.new(0.5, -100, 0.4, -50)
main.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
main.Active = true
main.Draggable = true
Instance.new("UICorner", main).CornerRadius = UDim.new(0, 10)

-- Nút TELE
local teleBtn = Instance.new("TextButton", main)
teleBtn.Size = UDim2.new(0.45, -5, 0, 40)
teleBtn.Position = UDim2.new(0, 10, 0, 10)
teleBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
teleBtn.TextColor3 = Color3.new(1, 1, 1)
teleBtn.Text = "▶ TELE BASE"
teleBtn.Font = Enum.Font.GothamBold
teleBtn.TextSize = 14
Instance.new("UICorner", teleBtn).CornerRadius = UDim.new(0, 6)

-- Nút STOP
local stopBtn = Instance.new("TextButton", main)
stopBtn.Size = UDim2.new(0.45, -5, 0, 40)
stopBtn.Position = UDim2.new(0.55, 0, 0, 10)
stopBtn.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
stopBtn.TextColor3 = Color3.new(1, 1, 1)
stopBtn.Text = "■ STOP"
stopBtn.Font = Enum.Font.GothamBold
stopBtn.TextSize = 14
Instance.new("UICorner", stopBtn).CornerRadius = UDim.new(0, 6)

-- Label trạng thái
local status = Instance.new("TextLabel", main)
status.Size = UDim2.new(1, -20, 0, 30)
status.Position = UDim2.new(0, 10, 0, 60)
status.BackgroundTransparency = 1
status.TextColor3 = Color3.fromRGB(255, 255, 255)
status.Font = Enum.Font.Gotham
status.TextSize = 14
status.Text = "Trạng thái: Đang tắt"
status.TextXAlignment = Enum.TextXAlignment.Left

-- Biến chạy loop
local running = false

-- Hàm Teleport tới ESPBase
local function teleportToESPBase()
	local char = LocalPlayer.Character
	local hrp = char and char:FindFirstChild("HumanoidRootPart")
	local esp = workspace:FindFirstChild("ESPBase")

	if hrp and esp then
		hrp.CFrame = CFrame.new(esp.Position - Vector3.new(0, 2, 0))
	end
end

-- Bắt đầu teleport
teleBtn.MouseButton1Click:Connect(function()
	if running then return end
	running = true
	status.Text = "Trạng thái: Đang TELE..."

	while running do
		teleportToESPBase()
		task.wait(0.1)
	end
end)

-- Dừng teleport
stopBtn.MouseButton1Click:Connect(function()
	running = false
	status.Text = "Trạng thái: Đang tắt"
end)
