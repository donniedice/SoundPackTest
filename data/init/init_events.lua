-- init_events.lua

-- Function to handle the ADDON_LOADED event
function MyAddon:OnAddonLoaded(arg1)
    if arg1 ~= "MyAddon" then return end
    self:PrintSuccess("Addon loaded.")
    self:InitSavedVariables()
    self:LoadCustomSounds()
end

-- Function to handle the PLAYER_LOGIN event
function MyAddon:OnPlayerLogin()
    self:PrintSuccess("Player logged in.")
    if self.db.profile.showWelcomeMessage then
        self:Print("Welcome to MyAddon! Enjoy your enhanced sound experience.")
    end
end
