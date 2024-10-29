-- saved_variables.lua

function MyAddon:InitSavedVariables()
    local defaults = {
        debugMode = false,
        showWelcomeMessage = true,
        selectedSoundPack = "Default",
        selectedSound = "None",
    }

    for key, value in pairs(defaults) do
        if self.db.profile[key] == nil then
            self.db.profile[key] = value
        end
    end
end
