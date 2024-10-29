-- sound_management.lua

local media = LibStub("LibSharedMedia-3.0", true)
if not media then
    print("MyAddon: LibSharedMedia-3.0 not loaded.")
    return
end

-- Define an ignore list to exclude specific sounds
local ignore = {
    ["Custom"] = true,
    ["Sound by Kit ID"] = true,
    ["None"] = true
}

-- Load custom sounds for the addon
function MyAddon:LoadCustomSounds()
    media:Register("sound", "Achievement_Default", "Interface\\Addons\\MyAddon\\sounds\\achievement_default_med.ogg")
    media:Register("sound", "QuestAccept_Custom", "Interface\\Addons\\MyAddon\\sounds\\quest_accept_custom.ogg")
    media:Register("sound", "QuestTurnIn_Custom", "Interface\\Addons\\MyAddon\\sounds\\quest_turnin_custom.ogg")
    MyAddon:PrintSuccess("Custom sounds loaded successfully.")
end

-- Handle sound playback based on the selected sound and type
function MyAddon:PlaySelectedSound(soundName, soundType)
    local soundPath = media:Fetch("sound", soundName)
    if soundPath and soundName ~= "None" then
        local success, errorMessage = pcall(function()
            PlaySoundFile(soundPath, "Master")
        end)
        if success then
            MyAddon:PrintSuccess(string.format("Playing %s sound: %s", soundType, soundName))
        else
            MyAddon:PrintError(string.format("Failed to play %s sound: %s", soundType, tostring(errorMessage)))
        end
    else
        MyAddon:PrintError(string.format("Sound path not found or invalid for %s sound: %s", soundType, tostring(soundName)))
    end
end
