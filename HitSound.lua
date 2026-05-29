-- [[ Helix Hub - Hit Sound Changer Module ]]
if not pcall(function() return game.ContextMenu end) then return end

local Players = game:GetService("Players")
local SoundService = game:GetService("SoundService")
local LocalPlayer = Players.LocalPlayer

-- 유저님이 업로드한 사운드 매핑 데이터 (Asset ID 형식으로 구성)
-- (실제 배포 시에는 각 사운드의 로블록스 오디오 자산 ID 또는 유저님의 깃허브 raw 주소 자산으로 대체 가능합니다)
local SoundLibrary = {
    ["neverlose"] = "rbxassetid://9114144503", -- neverlose-sound.mp3 대칭 ID 예시
    ["spakle"] = "rbxassetid://9114227104",    -- spakle.mp3 대칭 ID 예시
    ["window"] = "rbxassetid://8433501230",    -- erro.mp3 (윈도우 경고음 스타일) 예시
    ["window2"] = "rbxassetid://1526435922"   -- preview_4.mp3 (윈도우 기동음 스타일) 예시
}

-- 기본 타격음 소거 및 커스텀 사운드 발생 함수
local function PlayCustomHitSound(targetPosition)
    -- 1. 원래 게임에서 발생하는 히트 사운드 인스턴스들을 실시간으로 찾아서 음소거(Mute) 처리
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("Sound") and (v.Name:lower():find("hit") or v.Name:lower():find("damage") or v.Name:lower():find("kill")) then
            v.Volume = 0 -- 원래 맞는 소리는 완전히 없앰
        end
    end

    -- 2. 유저가 선택한 커스텀 사운드 가동
    local selectedKey = _G.HelixConfig.SelectedHitSound or "neverlose"
    local soundId = SoundLibrary[selectedKey]

    if soundId then
        local hitSoundObj = Instance.new("Sound")
        hitSoundObj.SoundId = soundId
        hitSoundObj.Volume = _G.HelixConfig.HitSoundVolume or 1.0
        hitSoundObj.Parent = SoundService -- 사운드 서비스에 임시 귀속시켜 깔끔하게 전체 출력
        
        hitSoundObj:Play()
        
        -- 재생이 끝나면 메모리 확보를 위해 오브젝트 삭제
        hitSoundObj.Ended:Connect(function()
            hitSoundObj:Destroy()
        end)
    end
end

-- 라이벌즈(Rivals) 맵 취약점 분석 기반: 데미지/히트 리모트 신호 감지 인터셉트
local RawMeta = getrawmetatable(game)
local OldNamecall = RawMeta.__namecall
setreadonly(RawMeta, false)

RawMeta.__namecall = newcclosure(function(self, ...)
    local method = getnamecallmethod()
    local args = {...}

    if _G.HelixConfig.HitSoundEnabled and method == "FireServer" then
        -- 서버에 타격/데미지 패킷("Hit", "Damage", "RegisterShot" 등)이 전송되는 순간을 가로챔
        if self.Name:lower():find("hit") or self.Name:lower():find("shoot") then
            -- 상대방이 맞았다는 신호가 가동될 때 백그라운드에서 우리 사운드 스위치 실행
            task.spawn(function()
                PlayCustomHitSound()
            end)
        end
    end

    return OldNamecall(self, ...)
end)

setreadonly(RawMeta, true)
print("[Helix Visuals] Hit Sound Changer Successfully Loaded.")