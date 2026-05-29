-- [[ Helix Hub - No Recoil Module ]]
if not pcall(function() return game.ContextMenu end) then return end

local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- 총기 데이터가 모여 있는 모듈스크립트를 찾는 루틴 (맵 분석 결과 반영)
local function ApplyNoRecoil()
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("ModuleScript") and (v.Name:find("Config") or v.Name:find("Data")) then
            local success, weaponModule = pcall(require, v)
            if success and type(weaponModule) == "table" then
                -- 맵 분석으로 특정한 반동 관련 변수명들을 0으로 리라이트
                if weaponModule.Recoil or weaponModule.RecoilControl or weaponModule.Kick then
                    weaponModule.Recoil = 0
                    weaponModule.VerticalRecoil = 0
                    weaponModule.HorizontalRecoil = 0
                    weaponModule.GunKick = 0
                    weaponModule.CameraShake = 0
                end
            end
        end
    end
end

-- 실시간 검증 루프 (토글 상태 감시)
task.spawn(function()
    while task.wait(1) do
        if not _G.HelixConfig.NoRecoilEnabled then break end
        pcall(ApplyNoRecoil)
    end
end)

print("[Helix Combat] No Recoil Module Successfully Loaded.")