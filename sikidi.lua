
repeat wait() until game:IsLoaded()

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local StarterGui = game:GetService("StarterGui")
local player = Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local root = char:WaitForChild("HumanoidRootPart")

-- 🛡️ Bất tử toggle
local function makeGod()
    local hum = char:FindFirstChildOfClass("Humanoid")
    if hum then
        hum.MaxHealth = math.huge
        hum.Health = math.huge
        hum:GetPropertyChangedSignal("Health"):Connect(function()
            if hum.Health < math.huge then
                hum.Health = math.huge
            end
        end)
    end
end

-- 🏠 Toạ độ cửa
local doorPositions = {
    Vector3.new(-469, -7, -102),
    Vector3.new(-468, -7, 8),
    Vector3.new(-467, -7, 112),
    Vector3.new(-466, -8, 220),
    Vector3.new(-355, -8, 219),
    Vector3.new(-354, -8, 112),
    Vector3.new(-353, -7, 4),
    Vector3.new(-353, -7, -100)
}
local function getNearestDoor()
    local closest, minDist = nil, math.huge
    for _, door in ipairs(doorPositions) do
        local dist = (root.Position - door).Magnitude
        if dist < minDist then
            minDist = dist
            closest = door
        end
    end
    return closest
end

-- ☁️ Bay lên 200m
local function goUp()
    local door = getNearestDoor()
    if door then
        TweenService:Create(root, TweenInfo.new(1.2), {CFrame = CFrame.new(door)}):Play()
        wait(1.3)
        root.CFrame = root.CFrame + Vector3.new(0, 200, 0)
    end
end

-- ⛓ Rơi xuống đất
local function dropDown()
    root.CFrame = root.CFrame - Vector3.new(0, 50, 0)
end

-- 🌀 Nhảy cao x5 + nhảy vô hạn + rơi chậm
local jumpEnabled = false
UserInputService.JumpRequest:Connect(function()
    if jumpEnabled then
        local hum = player.Character:FindFirstChildOfClass("Humanoid")
        if hum then
            hum:ChangeState("Jumping")
        end
    end
end)

-- 🌈 UI Modern
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "PhucModernUI"
gui.ResetOnSpawn = false

local holder = Instance.new("Frame", gui)
holder.Size = UDim2.new(0, 250, 0, 40)
holder.Position = UDim2.new(0.5, -125, 0.05, 0)
holder.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
holder.Active = true
holder.Draggable = true

local UICorner = Instance.new("UICorner", holder)
UICorner.CornerRadius = UDim.new(0, 8)

local title = Instance.new("TextLabel", holder)
title.Size = UDim2.new(1, 0, 1, 0)
title.BackgroundTransparency = 1
title.Text = "phucmax"
title.Font = Enum.Font.FredokaOne
title.TextScaled = true
title.TextColor3 = Color3.new(1, 1, 1)

local minimize = Instance.new("TextButton", holder)
minimize.Size = UDim2.new(0, 30, 1, 0)
minimize.Position = UDim2.new(1, -60, 0, 0)
minimize.Text = "-"
minimize.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
minimize.TextColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", minimize).CornerRadius = UDim.new(0, 6)

local close = Instance.new("TextButton", holder)
close.Size = UDim2.new(0, 30, 1, 0)
close.Position = UDim2.new(1, -30, 0, 0)
close.Text = "X"
close.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
close.TextColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", close).CornerRadius = UDim.new(0, 6)

local content = Instance.new("Frame", gui)
content.Size = UDim2.new(0, 250, 0, 180)
content.Position = holder.Position + UDim2.new(0, 0, 1, 5)
content.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Instance.new("UICorner", content).CornerRadius = UDim.new(0, 8)
content.Visible = true

minimize.MouseButton1Click:Connect(function()
    content.Visible = not content.Visible
end)
close.MouseButton1Click:Connect(function()
    gui:Destroy()
end)

-- 🔘 Nút hiện đại
local function createButton(name, callback)
    local btn = Instance.new("TextButton", content)
    btn.Size = UDim2.new(1, -20, 0, 30)
    btn.Position = UDim2.new(0, 10, 0, #content:GetChildren() * 35 - 30)
    btn.Text = name
    btn.Font = Enum.Font.GothamBold
    btn.TextColor3 = Color3.new(1,1,1)
    btn.TextSize = 14
    btn.AutoButtonColor = false
    btn.BackgroundColor3 = Color3.fromRGB(170, 0, 0)
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    local state = false
    btn.MouseButton1Click:Connect(function()
        state = not state
        btn.BackgroundColor3 = state and Color3.fromRGB(0, 170, 0) or Color3.fromRGB(170, 0, 0)
        callback(state)
    end)
end

-- 🧩 Add buttons
createButton("Bay lên trời 200m", function(on) if on then goUp() end end)
createButton("Rơi xuống đất", function(on) if on then dropDown() end end)
createButton("Nhảy cao x5 + vô hạn + rơi chậm", function(on)
    local hum = char:FindFirstChildOfClass("Humanoid")
    if hum then
        hum.JumpPower = on and 250 or 50
    end
    jumpEnabled = on
end)
createButton("Bất tử", function(on)
    if on then
        makeGod()
        task.spawn(function()
            wait(0.5)
            char:BreakJoints()
        end)
    end
end)
