local media = LibStub("LibSharedMedia-3.0", true)

-- Define an ignore list to exclude certain sounds from the dropdown
local ignore = {
    ["Custom"] = true,
    ["Sound by Kit ID"] = true,
    ["None"] = true
}

-- Function to build sound categories based on available sounds in LibSharedMedia
function MyAddon:BuildSoundCategories()
    local sounds = media:HashTable("sound")
    local soundCategories = {}

    if sounds then
        MyAddon:Print("LibSharedMedia Registered Sounds:")
        for soundName, soundPath in pairs(sounds) do
            if not ignore[soundName] and type(soundName) == "string" then
                local _, _, soundpackName = string.find(soundPath, "^Interface\\AddOns\\([^\\]+)\\")
                soundpackName = soundpackName or "Unknown"
                soundCategories[soundpackName] = soundCategories[soundpackName] or {}
                table.insert(soundCategories[soundpackName], soundName)
            else
                MyAddon:Print("Ignoring sound - " .. soundName)
            end
        end
    end
    return soundCategories
end
