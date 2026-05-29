-- [[ Helix Hub - Anti-Cheat Bypass Module ]]
if not pcall(function() return game.ContextMenu -- 익스플로잇 가동 환경 체크
end) then return end

local HookedMethods = {}
local RawMeta = getrawmetatable(game)
local OldIndex = RawMeta.__index
local OldNewIndex = RawMeta.__newindex

-- 안티치트의 메모리 검증 및 변수 탐지 우회 레이어
setreadonly(RawMeta, false)

RawMeta.__index = newcclosure(function(self, key)
    -- 안티치트가 WalkSpeed나 JumpPower를 강제로 변조 확인하는 것을 차단
    if not checkcaller() and _G.HelixConfig.BypassEnabled then
        if self:IsA("Humanoid") then
            if key == "WalkSpeed" then
                return 16 -- 기본 속도값으로 속여서 반환
            elseif key == "JumpPower" then
                return 50 -- 기본 점프력으로 속여서 반환
            end
        end
    end
    return OldIndex(self, key)
end)

RawMeta.__newindex = newcclosure(function(self, key, value)
    -- 외부 스크립트가 게임 내부 핵심 값을 변조할 때 필터링
    if checkcaller() and _G.HelixConfig.BypassEnabled then
        -- Helix 내부에서 변경하는 값은 정상 통과
        return OldNewIndex(self, key, value)
    end
    return OldNewIndex(self, key, value)
end)

setreadonly(RawMeta, true)
print("[Helix Core] Anti-Cheat Bypass Successfully Loaded.")