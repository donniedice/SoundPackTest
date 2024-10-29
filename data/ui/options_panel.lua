local AceGUI = LibStub("AceGUI-3.0", true)

-- Function to open the options panel
function MyAddon:OpenOptionsPanel()
    if self.optionsFrame and self.optionsFrame:IsShown() then
        self.optionsFrame:Hide()
        return
    end

    local frame = AceGUI:Create("Frame")
    frame:SetTitle("MyAddon - Sound Settings")
    frame:SetStatusText("Configure your sound settings")
    frame:SetLayout("Flow")
    frame:SetWidth(400)
    frame:SetHeight(300)
    self.optionsFrame = frame

    local heading = AceGUI:Create("Heading")
    heading:SetText("Sound Selection")
    heading:SetFullWidth(true)
    frame:AddChild(heading)

    -- Initialize sound categories and dropdown
    local soundCategories = MyAddon:BuildSoundCategories()  -- Ensure this function is called
    MyAddon:InitializeDropdownMenu(frame, soundCategories)  -- Pass the sound categories to initialize the dropdown
end
