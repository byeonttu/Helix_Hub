-- [[ Helix Hub - Main Controller ]]
local KavoLibrary = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = KavoLibrary.CreateLib("Helix Hub | Premium v1.0", "DarkTheme")

-- 전역 설정 테이블 (모든 모듈의 가동 상태 및 옵션을 실시간 제어)
_G.HelixConfig = {
    BypassEnabled = false,
    DeviceSpoofEnabled = false,
    SilentAimEnabled = false,
    NoSpreadEnabled = false,
    NoRecoilEnabled = false,
    SlideBoostEnabled = false,
    EspEnabled = false,
    MemeDeviceEnabled = false,
    SelectedMemeDevice = "Refrigerator",
    -- 히트사운드 설정 추가
    HitSoundEnabled = false,
    SelectedHitSound = "neverlose",
    HitSoundVolume = 1.0
}

-- 유저님의 GitHub 아이디(byeonttu)를 반영한 Raw 파일 경로 설정
local BasePath = "https://raw.githubusercontent.com/byeonttu/Helix_Hub/main/Modules/"

--------------------------------------------------------------------
-- [1] Main 탭 - 보안 및 우회 레이어
--------------------------------------------------------------------
local MainTab = Window:NewTab("Main")
local CoreSection = MainTab:NewSection("Core Security & Bypass")

CoreSection:NewToggle("Anti-Cheat Bypass", "안티치트 감시 시스템을 무력화합니다.", function(state)
    _G.HelixConfig.BypassEnabled = state
    if state then
        local success, err = pcall(function()
            loadstring(game:HttpGet(BasePath .. "Bypass.lua"))()
        end)
        if not success then warn("[Helix Error] Bypass 로드 실패:", err) end
    end
end)

CoreSection:NewToggle("Device Spoofer", "HWID 및 하드웨어 고유 식별자를 변조합니다.", function(state)
    _G.HelixConfig.DeviceSpoofEnabled = state
    if state then
        local success, err = pcall(function()
            loadstring(game:HttpGet(BasePath .. "DeviceSpoof.lua"))()
        end)
        if not success then warn("[Helix Error] DeviceSpoof 로드 실패:", err) end
    end
end)

--------------------------------------------------------------------
-- [2] Combat 탭 - 전투 기능 레이어
--------------------------------------------------------------------
local CombatTab = Window:NewTab("Combat")
local CombatSection = CombatTab:NewSection("Weapon Exploits")

CombatSection:NewToggle("Silent Aim (Remote Hook)", "가까운 적의 헤드로 발사 패킷을 가로챕니다.", function(state)
    _G.HelixConfig.SilentAimEnabled = state
    if state then
        local success, err = pcall(function()
            loadstring(game:HttpGet(BasePath .. "RemoteHook.lua"))()
        end)
        if not success then warn("[Helix Error] RemoteHook 로드 실패:", err) end
    end
end)

CombatSection:NewToggle("No Spread", "탄 퍼짐 현상을 완전히 제거합니다.", function(state)
    _G.HelixConfig.NoSpreadEnabled = state
    if state then
        local success, err = pcall(function()
            loadstring(game:HttpGet(BasePath .. "NoSpread.lua"))()
        end)
        if not success then warn("[Helix Error] NoSpread 로드 실패:", err) end
    end
end)

CombatSection:NewToggle("No Recoil", "총기 반동 및 카메라 흔들림을 변조합니다.", function(state)
    _G.HelixConfig.NoRecoilEnabled = state
    if state then
        local success, err = pcall(function()
            loadstring(game:HttpGet(BasePath .. "NoRecoil.lua"))()
        end)
        if not success then warn("[Helix Error] NoRecoil 로드 실패:", err) end
    end
end)

--------------------------------------------------------------------
-- [3] Movement 탭 - 기동성 레이어
--------------------------------------------------------------------
local MovementTab = Window:NewTab("Movement")
local MoveSection = MovementTab:NewSection("Physics Manipulation")

MoveSection:NewToggle("Slide Boost", "슬라이딩 시 가속도를 증폭시킵니다.", function(state)
    _G.HelixConfig.SlideBoostEnabled = state
    if state then
        local success, err = pcall(function()
            loadstring(game:HttpGet(BasePath .. "SlideBoost.lua"))()
        end)
        if not success then warn("[Helix Error] SlideBoost 로드 실패:", err) end
    end
end)

--------------------------------------------------------------------
-- [4] Visuals & Sound 탭 - 시각 및 청각 레이어
--------------------------------------------------------------------
local VisualsTab = Window:NewTab("Visuals")
local VisualsSection = VisualsTab:NewSection("Render & ESP")

VisualsSection:NewToggle("Player ESP", "벽 뒤에 있는 적의 위치와 체력을 투과합니다.", function(state)
    _G.HelixConfig.EspEnabled = state
    if state then
        local success, err = pcall(function()
            loadstring(game:HttpGet(BasePath .. "Esp.lua"))()
        end)
        if not success then warn("[Helix Error] ESP 로드 실패:", err) end
    end
end)

-- [[ 히트사운드 체인저 UI 전용 섹션 통합 ]]
local HitSoundSection = VisualsTab:NewSection("Hit Sound Customizer")

HitSoundSection:NewDropdown("Select Hit Sound", "상대가 맞았을 때 재생할 소리를 고르세요.", {"neverlose", "spakle", "window", "window2"}, function(currentOption)
    _G.HelixConfig.SelectedHitSound = currentOption
    print("[Helix UI] 선택된 히트 사운드:", currentOption)
end)

HitSoundSection:NewSlider("Sound Volume", "히트 사운드의 음량을 조절합니다.", 2, 0, function(value)
    _G.HelixConfig.HitSoundVolume = value
end)

HitSoundSection:NewToggle("Enable Hit Sound Changer", "기본 타격음을 소거하고 커스텀 사운드로 교체합니다.", function(state)
    _G.HelixConfig.HitSoundEnabled = state
    if state then
        local success, err = pcall(function()
            loadstring(game:HttpGet(BasePath .. "HitSound.lua"))()
        end)
        if not success then warn("[Helix Error] HitSound 모듈 로드 실패:", err) end
    end
end)

--------------------------------------------------------------------
-- [5] Meme Changer 탭 - 유튜브 유행 기기 변조 레이어
--------------------------------------------------------------------
local MemeTab = Window:NewTab("Meme Changer")
local MemeSection = MemeTab:NewSection("Fake Device Connection")

MemeSection:NewDropdown("Target Device", "서버 및 타인에게 보여질 기기를 선택하세요.", {"VR", "Refrigerator", "WaterPurifier", "Toilet", "Bed"}, function(currentOption)
    _G.HelixConfig.SelectedMemeDevice = currentOption
    print("[Helix UI] 선택된 밈 기기:", currentOption)
end)

MemeSection:NewToggle("Enable Device Changer", "선택한 기기로 접속 환경 패킷을 변조합니다.", function(state)
    _G.HelixConfig.MemeDeviceEnabled = state
    if state then
        local success, err = pcall(function()
            loadstring(game:HttpGet(BasePath .. "DeviceChanger.lua"))()
        end)
        if not success then warn("[Helix Error] DeviceChanger 로드 실패:", err) end
    end
end)

--------------------------------------------------------------------
-- [6] Credits 탭 - 정보 표기 레이어
--------------------------------------------------------------------
local CreditsTab = Window:NewTab("Credits")
local CreditsSection = CreditsTab:NewSection("Project Helix")
CreditsSection:NewLabel("Developed by Helix Team")
CreditsSection:NewLabel("UI Framework: Kavo UI")
CreditsSection:NewLabel("Status: Active (2026)")