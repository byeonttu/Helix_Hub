-- [[ Helix Hub - Player ESP & Visuals Module ]]
if not pcall(function() return game.ContextMenu end) then return end

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

local Cache = {}

-- 개별 플레이어의 시각화 객체(Box/Line)를 생성하는 함수
local function CreateEsp(player)
    if Cache[player] then return end

    local box = Drawing.new("Square")
    box.Color = Color3.fromRGB(255, 0, 0) -- 적군 기본 빨간색 표시
    box.Thickness = 1
    box.Filled = false
    box.Visible = false

    local nameTag = Drawing.new("Text")
    nameTag.Color = Color3.fromRGB(255, 255, 255)
    nameTag.Size = 14
    nameTag.Center = true
    nameTag.Outline = true
    nameTag.Visible = false

    Cache[player] = {Box = box, NameTag = nameTag}
end

-- 퇴장한 플레이어 잔상 제거
local function RemoveEsp(player)
    if Cache[player] then
        Cache[player].Box:Remove()
        Cache[player].NameTag:Remove()
        Cache[player] = nil
    end
end

-- 초기 플레이어 구성
for _, p in pairs(Players:GetPlayers()) do
    if p ~= LocalPlayer then CreateEsp(p) end
end
Players.PlayerAdded:Connect(CreateEsp)
Players.PlayerRemoving:Connect(RemoveEsp)

-- 매 프레임마다 적의 3D 좌표를 2D 화면에 렌더링
local EspConnection
EspConnection = RunService.RenderStepped:Connect(function()
    if not _G.HelixConfig.EspEnabled then
        for _, esp in pairs(Cache) do
            esp.Box.Visible = false
            esp.NameTag.Visible = false
        end
        if EspConnection then EspConnection:Disconnect() end
        return
    end

    for player, esp in pairs(Cache) do
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player.Character:FindFirstChild("Humanoid") and player.Character.Humanoid.Health > 0 then
            local hrp = player.Character.HumanoidRootPart
            local pos, onScreen = Camera:WorldToViewportPoint(hrp.Position)

            if onScreen then
                -- 캐릭터 크기에 비례하는 2D 박스 사이즈 연산
                local sizeX = 2000 / pos.Z
                local sizeY = 3000 / pos.Z

                esp.Box.Size = Vector2.new(sizeX, sizeY)
                esp.Box.Position = Vector2.new(pos.X - sizeX / 2, pos.Y - sizeY / 2)
                esp.Box.Visible = true

                esp.NameTag.Text = player.Name .. " [" .. math.floor(player.Character.Humanoid.Health) .. "HP]"
                esp.NameTag.Position = Vector2.new(pos.X, pos.Y - sizeY / 2 - 15)
                esp.NameTag.Visible = true
            else
                esp.Box.Visible = false
                esp.NameTag.Visible = false
            end
        else
            esp.Box.Visible = false
            esp.NameTag.Visible = false
        end
    end
end)

print("[Helix Visuals] Player ESP Module Successfully Loaded.")