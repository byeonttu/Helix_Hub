-- [[ Helix Hub - Slide Boost Module ]]
if not pcall(function() return game.ContextMenu end) then return end

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

local BoostMultiplier = 2.5 -- 가속 세기 (안티치트 무력화 수준에 따라 조절 가능)

local function GetMoveDirection()
    local character = LocalPlayer.Character
    if not character or not character:FindFirstChild("Humanoid") then return Vector3.new(0,0,0) end
    return character.Humanoid.MoveDirection
end

-- 물리 프레임마다 입력 및 속도 변조 연산
local BoostConnection
BoostConnection = RunService.Heartbeat:Connect(function()
    -- 토글이 꺼지면 연결 해제
    if not _G.HelixConfig.SlideBoostEnabled then
        if BoostConnection then BoostConnection:Disconnect() end
        return
    end

    local character = LocalPlayer.Character
    if character and character:FindFirstChild("HumanoidRootPart") and character:FindFirstChild("Humanoid") then
        local hrp = character.HumanoidRootPart
        local humanoid = character.Humanoid

        -- 유저가 움직이고 있고, 슬라이딩/앉기 키(예: LeftShift 또는 C)를 누르고 있는지 판정
        -- 게임마다 슬라이딩 키셋이 다르므로 맵 분석 기반 키 바인딩 대응 가능
        if humanoid.MoveDirection.Magnitude > 0 and (UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) or UserInputService:IsKeyDown(Enum.KeyCode.C)) then
            -- 전방 이동 방향 벡터를 기반으로 Velocity 순간 증폭
            local direction = GetMoveDirection()
            hrp.Velocity = Vector3.new(direction.X * (humanoid.WalkSpeed * BoostMultiplier), hrp.Velocity.Y, direction.Z * (humanoid.WalkSpeed * BoostMultiplier))
        end
    end
end)

print("[Helix Movement] Slide Boost Module Successfully Loaded.")