-- event_registration.lua

local eventFrame = CreateFrame("Frame")
eventFrame:RegisterEvent("ADDON_LOADED")
eventFrame:RegisterEvent("PLAYER_LOGIN")
eventFrame:SetScript("OnEvent", function(self, event, arg1)
    if event == "ADDON_LOADED" then
        MyAddon:OnAddonLoaded(arg1)
    elseif event == "PLAYER_LOGIN" then
        MyAddon:OnPlayerLogin()
    end
end)
