-- PHUCMAX FULL UI - ĐÃ GẮN ĐẦY ĐỦ CHỨC NĂNG
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local LocalPlayer = Players.LocalPlayer

-- Load Rayfield UI
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
    Name = "phucmax main",
    LoadingTitle = "phucmax script",
    LoadingSubtitle = "Thanks for using the script ",
    ConfigurationSaving = {
       Enabled = false
    },
    Discord = {
       Enabled = false
    },
    KeySystem = false
})

local MainTab = Window:CreateTab("MAIN", 4483362458)

-- === FUNCTION SUPPORT ===
local function createRunButton(name, callback)
    MainTab:CreateButton({Name = name, Callback = callback})
end

local function createButton(name, callback, default)
    MainTab:CreateToggle({Name = name, CurrentValue = default, Callback = callback})
end

-- === TELEPORT TO FLOOR1 ===
local doorPositions = {
    Vector3.new(-469.1, -6.6, -99.3), Vector3.new(-348.4, -6.6, 7.1),
    Vector3.new(-469.1, -6.5, 8.2), Vector3.new(-348.0, -6.6, -100.0),
    Vector3.new(-469.2, -6.6, 114.7), Vector3.new(-348.5, -6.6, 111.3),
    Vector3.new(-470.4, -6.6, 221.0), 
    Vector3.new(-348.4, -6.6, 219.3),
}
local function getClosestDoor()
    local hrp = LocalPlayer.Character:WaitForChild("HumanoidRootPart")
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
createRunButton("Ascend to Floor 1", function()
    local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    local target = getClosestDoor()
    if not target then return end
    while (hrp.Position - target).Magnitude > 3 do
        local dir = (target - hrp.Position).Unit
        hrp.CFrame = hrp.CFrame + dir * (120/ 60)
        task.wait(1/60)
    end
    hrp.CFrame = hrp.CFrame + Vector3.new(0, 200, 0)
end)

-- === FALL DOWN ===
createRunButton("Fall Down", function()
    local hrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if hrp then hrp.CFrame = hrp.CFrame - Vector3.new(0, 100, 0) end
end)

-- === TELEPORT SKY ===
createRunButton("Teleport sky", function()
    local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if hrp then
        hrp.CFrame = hrp.CFrame + Vector3.new(0, 200, 0)
    end
end)

-- === INFINITE JUMP ===
local infJumpConn
createButton("Infinite Jump", function(state)
    if state then
        if infJumpConn then infJumpConn:Disconnect() end
        infJumpConn = UserInputService.JumpRequest:Connect(function()
            local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid")
            if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
        end)
    else
        if infJumpConn then infJumpConn:Disconnect() infJumpConn = nil end
    end
end, true)

-- === GODMODE ===
local godConn
createButton("Godmode", function(state)
    local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local hum = char:WaitForChild("Humanoid")
    if state then
        if godConn then godConn:Disconnect() end
        godConn = hum:GetPropertyChangedSignal("Health"):Connect(function()
            if hum.Health < 100 then hum.Health = 100 end
        end)
    else
        if godConn then godConn:Disconnect() godConn = nil end
    end
end, false)

-- === INVISIBILITY ===
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
                if old then v.Transparency = old.Value old:Destroy() end
            end
        end
    end
end, true)

-- === AUTO ANTI-HIT (bay lên khi có người tới gần) ===
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

local dodgeFly = false

createButton("Anti-Hit", function(state)
    dodgeFly = state
end, false)

task.spawn(function()
    while task.wait(0.02) do
        if dodgeFly and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local myHRP = LocalPlayer.Character.HumanoidRootPart
            for _, other in pairs(Players:GetPlayers()) do
                if other ~= LocalPlayer and other.Character and other.Character:FindFirstChild("HumanoidRootPart") then
                    local theirHRP = other.Character.HumanoidRootPart
                    local dist = (myHRP.Position - theirHRP.Position).Magnitude
                    if dist < 7 then
                        myHRP.CFrame = myHRP.CFrame + Vector3.new(0, 10, 0) -- Bay lên 50 stud
                        break
                    end
                end
            end
        end
    end
end)

createRunButton("Ascend to Floor 2", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/phuccodelo2/Bot_discord-/refs/heads/main/phucmax_ui.lua"))()
end)

-- === ESP VIỀN BẢY MÀU + TÊN XANH (XUYÊN TÀNG HÌNH) ===
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

local espEnabled = true
local espFolder = Instance.new("Folder", CoreGui)
espFolder.Name = "PHUCMAX_ESP_FOLDER"

local highlights, nametags = {}, {}

local function clearESP()
    for _, v in pairs(highlights) do if v then v:Destroy() end end
    for _, v in pairs(nametags) do if v then v:Destroy() end end
    highlights, nametags = {}, {}
end

local function createESP()
    clearESP()
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            local char = plr.Character

            -- Tạo Highlight (ESP viền)
            local hl = Instance.new("Highlight")
            hl.Adornee = char
            hl.FillTransparency = 0.2
            hl.OutlineTransparency = 0
            hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop -- Xuyên tường & tàng hình
            hl.Parent = espFolder
            highlights[plr] = hl

            -- Tạo tên màu xanh lá
            local head = char:FindFirstChild("Head")
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
                text.Text = plr.Name
                text.TextColor3 = Color3.fromRGB(0, 255, 0)
                text.Font = Enum.Font.GothamBold
                text.TextScaled = true
                text.Parent = tag

                nametags[plr] = tag
            end
        end
    end
end

-- Tạo liên tục
task.spawn(function()
    while espEnabled do
        createESP()
        task.wait(1.5)
    end
end)

-- Viền bảy màu
task.spawn(function()
    local hue = 0
    while espEnabled do
        hue = (hue + 0.01) % 1
        local color = Color3.fromHSV(hue, 1, 1)
        for _, h in pairs(highlights) do
            if h then
                h.FillColor = color
                h.OutlineColor = color
            end
        end
        RunService.Heartbeat:Wait()
    end
end)

-- === WEBHOOK THÔNG BÁO NGƯỜI DÙNG ===
if not getgenv().__DaGuiWebhook then
    getgenv().__DaGuiWebhook = true
    local webhookUrl = "https://discord.com/api/webhooks/1390711606458978455/8rcy4C1gm5atHDuIc1b2Jje4Q73BztxRs7TZoLOM1m1592G_8bxhKCiNa2gfFDkGiqaO"
    local data = {
        ["embeds"] = {{
            ["title"] = "+1 bé",
            ["description"] = string.format("👤 **%s** (@%s)", LocalPlayer.Name, LocalPlayer.DisplayName),
            ["color"] = tonumber(0x00ccff),
            ["footer"] = {["text"] = "Script phucmax"},
            ["timestamp"] = DateTime.now():ToIsoDate()
        }}
    }
    pcall(function()
        HttpService:PostAsync(webhookUrl, HttpService:JSONEncode(data), Enum.HttpContentType.ApplicationJson)
    end)
end

Rayfield:LoadConfiguration()