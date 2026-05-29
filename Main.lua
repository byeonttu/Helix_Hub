-- [[ Helix Hub - Main Controller ]]
local KavoLibrary = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()

-- [수정] UI 창이 잘리지 않도록 테마 구조를 완벽하게 빌드합니다.
local Window = KavoLibrary.CreateLib("Helix Hub | Premium v1.0", "DarkTheme")

-- 전역 설정 테이블
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
    HitSoundEnabled = false,
    SelectedHitSound = "neverlose",
    HitSoundVolume = 1.0
}

-- [[ Public 리포지토리 고정 경로 ]]
local BasePath = "https://raw.githubusercontent.com/byeonttu/Helix_Hub/main/"

-- 동적 로더 함수
local function LoadModule(fileName)
    local rawUrl = BasePath .. fileName
    local success, code = pcall(function()
        return game:HttpGet(rawUrl)
    end)
    
    if success and code and not code:find("404: Not Found") then
        local run, err = loadstring(code)
        if run then
            run()
        else
            warn("[Helix Error] 구문 오류 (" .. fileName .. "):", err)
        end
    else
        warn("[Helix Error] 파일 로드 실패 (" .. fileName .. ")")
    end
end

--------------------------------------------------------------------
-- [1] Main 탭 - 보안 및 우회 레이어
--------------------------------------------------------------------
local MainTab = Window:NewTab("Main")
local CoreSection = MainTab:NewSection("Core Security & Bypass")

CoreSection:NewToggle("Anti-Cheat Bypass", "안티치트 감시 시스템을 무력화합니다.", function(state)
    _G.HelixConfig.BypassEnabled = state
    if state then LoadModule("Bypass.lua") end
end)

CoreSection:NewToggle("Device Spoofer", "HWID 및 하드웨어 고유 식별자를 변조합니다.", function(state)
    _G.HelixConfig.DeviceSpoofEnabled = state
    if state then LoadModule("DeviceSpoof.lua") end
end)

--------------------------------------------------------------------
-- [2] Combat 탭 - 전투 기능 레이어
--------------------------------------------------------------------
local CombatTab = Window:NewTab("Combat")
local CombatSection = CombatTab:NewSection("Weapon Exploits")

CombatSection:NewToggle("Silent Aim (Remote Hook)", "가까운 적의 헤드로 발사 패킷을 가로챕니다.", function(state)
    _G.HelixConfig.SilentAimEnabled = state
    if state then LoadModule("RemoteHook.lua") end
end)

CombatSection:NewToggle("No Spread", "탄 퍼짐 현상을 완전히 제거합니다.", function(state)
    _G.HelixConfig.NoSpreadEnabled = state
    if state then LoadModule("NoSpread.lua") end
end)

CombatSection:NewToggle("No Recoil", "총기 반동 및 카메라 흔들림을 변조합니다.", function(state)
    _G.HelixConfig.NoRecoilEnabled = state
    if state then LoadModule("NoRecoil.lua") end
end)

--------------------------------------------------------------------
-- [3] Movement 탭 - 기동성 레이어
--------------------------------------------------------------------
local MovementTab = Window:NewTab("Movement")
local MoveSection = MovementTab:NewSection("Physics Manipulation")

MoveSection:NewToggle("Slide Boost", "슬라이딩 시 가속도를 증폭시킵니다.", function(state)
    _G.HelixConfig.SlideBoostEnabled = state
    if state then LoadModule("SlideBoost.lua") end
end)

--------------------------------------------------------------------
-- [4] Visuals & Sound 탭 - 시각 및 청각 레이어
--------------------------------------------------------------------
local VisualsTab = Window:NewTab("Visuals")
local VisualsSection = VisualsTab:NewSection("Render & ESP")

VisualsSection:NewToggle("Player ESP", "벽 뒤에 있는 적의 위치와 체력을 투과합니다.", function(state)
    _G.HelixConfig.EspEnabled = state
    if state then LoadModule("Esp.lua") end
end)

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
    if state then LoadModule("HitSound.lua") end
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
    if state then LoadModule("DeviceChanger.lua") end
end)

--------------------------------------------------------------------
-- [6] Credits 탭 - 정보 표기 레이어
--------------------------------------------------------------------
local CreditsTab = Window:NewTab("Credits")
local CreditsSection = CreditsTab:NewSection("Project Helix")
CreditsSection:NewLabel("Developed by Helix Team")
CreditsSection:NewLabel("UI Framework: Kavo UI")
CreditsSection:NewLabel("Status: Active (2026)")

--------------------------------------------------------------------
-- [7] UI 토글 시스템 (오른쪽 쉬프트 키 및 크기 강제 패치)
--------------------------------------------------------------------
local UserInputService = game:GetService("UserInputService")
local UIFrame = game:GetService("CoreGui"):FindFirstChild("Helix Hub | Premium v1.0") or game:GetService("Players").LocalPlayer:FindFirstChildOfClass("PlayerGui"):FindFirstChild("Helix Hub | Premium v1.0")

if UIFrame then
    -- Kavo UI 특유의 컨테이너를 찾아 가로 스케일이 잘리지 않도록 강제 보정합니다.
    local MainFrame = UIFrame:FindFirstChild("Main") or UIFrame:FindFirstChildOfClass("Frame")
    if MainFrame then
        MainFrame.Size = UDim2.new(0, 525, 0, 350) -- 가로 세로 비율 최적화 조정
    end

    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if not gameProcessed then
            if input.KeyCode == Enum.KeyCode.RightShift then
                UIFrame.Enabled = not UIFrame.Enabled
            end
        end
    end)
else
    warn("[Helix Error] 토글 시스템이 UI 오브젝트를 찾지 못했습니다.")
end