-- [[ Helix Hub - Remote Hooking & Silent Aim Module ]]
if not pcall(function() return game.ContextMenu end) then return end

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- 가장 가까운 타깃(적)을 찾는 함수
local function GetClosestPlayer()
    local closestPlayer = nil
    local shortestDistance = math.huge

    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player.Character:FindFirstChild("Humanoid") and player.Character.Humanoid.Health > 0 then
            -- 팀 확인 로직이 필요하다면 여기에 추가 가능
            local pos, onScreen = Camera:WorldToViewportPoint(player.Character.HumanoidRootPart.Position)
            if onScreen then
                local mousePos = LocalPlayer:GetMouse()
                local magnitude = (Vector2.new(pos.X, pos.Y) - Vector2.new(mousePos.X, mousePos.Y)).Magnitude
                if magnitude < shortestDistance then
                    closestPlayer = player
                    shortestDistance = magnitude
                end
            end
        end
    end
    return closestPlayer
end

-- 게임 내부의 메타메서드(__namecall)를 가로채서 리모트 패킷 변조
local RawMeta = getrawmetatable(game)
local OldNamecall = RawMeta.__namecall
setreadonly(RawMeta, false)

RawMeta.__namecall = newcclosure(function(self, ...)
    local method = getnamecallmethod()
    local args = {...}

    -- 토글이 켜져 있고, 호출된 메서드가 FireServer(리모트 이벤트 전송)일 때
    if _G.HelixConfig.SilentAimEnabled and method == "FireServer" then
        -- 분석한 서버 측 총기 발사 리모트 이벤트 이름 식별 (예시: "Shoot", "Hit" 등 실제 리모트명으로 대체 가능)
        if self.Name == "ShootRemote" or self.ClassName == "RemoteEvent" then
            local target = GetClosestPlayer()
            if target and target.Character and target.Character:FindFirstChild("Head") then
                -- 패킷 인자 구조가 [타깃 좌표, 히트 파트] 형태인 취약점을 공략
                -- 맵 분석 결과를 토대로 인자(args)의 인덱스 번호를 맞춰 변조합니다.
                args[1] = target.Character.Head.Position -- 발사 궤적의 목적지를 적의 머리로 강제 변경
                args[2] = target.Character.Head         -- 히트 판정 대상을 적의 머리로 강제 변경
                
                return OldNamecall(self, unpack(args))
            end
        end
    end

    return OldNamecall(self, ...)
end)

setreadonly(RawMeta, true)
print("[Helix Combat] Remote Hooking Module Successfully Loaded.")