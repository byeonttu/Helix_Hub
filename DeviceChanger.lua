-- [[ Helix Hub - Device Changer (Meme Edition) ]]
if not pcall(function() return game.ContextMenu end) then return end

local UserInputService = game:GetService("UserInputService")
local GuiService = game:GetService("GuiService")

-- 유튜브 유행 기기 목록 정의
local DevicePresets = {
    ["VR"] = { IsVR = true, Touch = false, Platform = "Oculus" },
    ["Refrigerator"] = { IsVR = false, Touch = true, Platform = "SmartFridge_OS" }, -- 스마트 냉장고
    ["WaterPurifier"] = { IsVR = false, Touch = true, Platform = "WaterPurifier_Android" }, -- 정수기
    ["Toilet"] = { IsVR = false, Touch = true, Platform = "TOTO_SmartToilet" }, -- 변기
    ["Bed"] = { IsVR = false, Touch = false, Platform = "SmartBed_Linux" } -- 침대
}

-- 유저가 선택한 모드 (예: 냉장고 모드)
local CurrentSelectedDevice = "Refrigerator" 
local Config = DevicePresets[CurrentSelectedDevice]

-- 메타메서드 가로채기로 기기 판정 시스템 속이기
local RawMeta = getrawmetatable(game)
local OldIndex = RawMeta.__index
local OldNamecall = RawMeta.__namecall
setreadonly(RawMeta, false)

RawMeta.__index = newcclosure(function(self, key)
    if not checkcaller() then
        -- 1. VR 접속으로 속이기
        if self == UserInputService and key == "VREnabled" then
            return Config.IsVR
        end
        -- 2. 냉장고/정수기 터치스크린 접속으로 속이기
        if self == UserInputService and (key == "TouchEnabled" or key == "KeyboardEnabled") then
            if key == "TouchEnabled" then return Config.Touch end
            if key == "KeyboardEnabled" then return not Config.Touch end
        end
    end
    return OldIndex(self, key)
end)

RawMeta.__namecall = newcclosure(function(self, ...)
    local method = getnamecallmethod()
    local args = {...}
    
    if not checkcaller() then
        -- 3. 라이벌즈 내부 서버가 기기 정보를 요청하여 패킷을 보낼 때 가로채기
        -- 맵 분석을 통해 밝혀낸 기기 정보 전송 리모트명 매칭 (예: "SendPlatform", "UpdateDevice")
        if method == "FireServer" and (self.Name:find("Device") or self.Name:find("Platform")) then
            -- 서버에 보낼 기기 문자열을 우리가 정의한 플랫폼명("SmartFridge_OS" 등)으로 강제 바꿔치기
            for i, arg in ipairs(args) do
                if type(arg) == "string" then
                    args[i] = Config.Platform
                end
            end
            return OldNamecall(self, unpack(args))
        end
    end
    return OldNamecall(self, ...)
end)

setreadonly(RawMeta, true)
print("[Helix Meme] Device Changed to: " .. CurrentSelectedDevice)