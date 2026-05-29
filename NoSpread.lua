-- [[ Helix Hub - No Spread Module ]]
if not pcall(function() return game.ContextMenu end) then return end

local function ApplyNoSpread()
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("ModuleScript") and (v.Name:find("Config") or v.Name:find("Data")) then
            local success, weaponModule = pcall(require, v)
            if success and type(weaponModule) == "table" then
                -- 맵 분석으로 특정한 탄 퍼짐 관련 변수명들을 0으로 리라이트
                if weaponModule.Spread or weaponModule.Accuracy or weaponModule.MinSpread then
                    weaponModule.Spread = 0
                    weaponModule.MinSpread = 0
                    weaponModule.MaxSpread = 0
                    weaponModule.Accuracy = 100
                    weaponModule.Inaccuracy = 0
                end
            end
        end
    end
end

task.spawn(function()
    while task.wait(1) do
        if not _G.HelixConfig.NoSpreadEnabled then break end
        pcall(ApplyNoSpread)
    end
end)

print("[Helix Combat] No Spread Module Successfully Loaded.")