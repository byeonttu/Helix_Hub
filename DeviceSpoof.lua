-- [[ Helix Hub - Device Hardware ID Spoof Module ]]
if not pcall(function() return game.ContextMenu end) then return end

local HttpService = game:GetService("HttpService")
local RbxAnalyticsService = game:GetService("RbxAnalyticsService")

-- 무작위 가짜 하드웨어 식별자(GUID) 생성 함수
local function GenerateFakeGUID()
    return HttpService:GenerateGUID(false)
end

local FakeHWID = GenerateFakeGUID()
local FakeClientId = GenerateFakeGUID()

-- 메타메서드 수정을 통한 기기 정보 수집 차단 및 변조
local RawMeta = getrawmetatable(game)
local OldIndex = RawMeta.__index
local OldNamecall = RawMeta.__namecall
setreadonly(RawMeta, false)

-- 1. 속성 및 변수 접근 가로채기 (__index)
RawMeta.__index = newcclosure(function(self, key)
    if _G.HelixConfig.DeviceSpoofEnabled and not checkcaller() then
        -- 플레이어 고유 기기 식별자 요청 시 가짜 값 반환
        if self:IsA("Player") and (key == "DataHubId" or key == "OsPlatform") then
            if key == "OsPlatform" then
                return "Win32" -- 플랫폼 고정 (필요 시 조절)
            end
            return FakeHWID
        end
    end
    return OldIndex(self, key)
end)

-- 2. 서비스 함수 호출 가로채기 (__namecall)
RawMeta.__namecall = newcclosure(function(self, ...)
    local method = getnamecallmethod()
    
    if _G.HelixConfig.DeviceSpoofEnabled and not checkcaller() then
        -- 분석 서비스에서 클라이언트 ID나 기기 고유 식별값 추출 시도를 추적
        if self == RbxAnalyticsService or self:IsA("RbxAnalyticsService") then
            if method == "GetClientId" then
                return FakeClientId
            end
        end
        
        -- 하드웨어 고유 식별 함수 탐지 우회
        if method == "GetHWID" or method == "GetHardwareId" then
            return FakeHWID
        end
    end
    
    return OldNamecall(self, ...)
end)

setreadonly(RawMeta, true)
print("[Helix Core] Device Spoofer Successfully Loaded.")