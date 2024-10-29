-- core.lua

-- Load necessary libraries using LibStub
local LibStub = LibStub
local AceGUI = LibStub("AceGUI-3.0", true)
local media = LibStub("LibSharedMedia-3.0", true)

-- Ensure that AceGUI and LibSharedMedia are loaded
if not AceGUI or not media then
    print("MyAddon: Required libraries (AceGUI-3.0 and LibSharedMedia-3.0) are not loaded.")
    return
end

-- Initialize the MyAddon table within a protected environment
local addonName, addon = ...
MyAddon = MyAddon or {}
MyAddon.db = MyAddon.db or {}
MyAddon.db.profile = MyAddon.db.profile or {}
MyAddon.Modules = MyAddon.Modules or {}

-- Version Information
MyAddon.VersionNumber = "v1.0.0"

-- Load localization (if applicable)
MyAddon_L = MyAddon_L or addon.L or {}  -- Ensure the localization table is loaded

--=====================================================================================
-- Sound Management
--=====================================================================================

-- Define an ignore list to exclude certain sounds from the dropdown
local ignore = {
    ["Custom"] = true,
    ["Sound by Kit ID"] = true,
    ["None"] = true
}

--=====================================================================================
-- Initialization of Saved Variables
--=====================================================================================
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

--=====================================================================================
-- Utility Functions - ui_helpers.lua
--=====================================================================================

-- Print helper functions with debug mode support
function MyAddon:Print(message)
    print("|cFF33FF99MyAddon|r: " .. message)
end

function MyAddon:PrintSuccess(message)
    if self.db.profile.debugMode then
        self:Print(message)
    end
end

function MyAddon:PrintError(message)
    print("|cFFFF3333MyAddon|r: " .. message)
end

--=====================================================================================
-- Sound Management Functions
--=====================================================================================

-- Function to handle sound playback when a sound is selected
local function PlaySelectedSound(soundName, soundType)
    if soundName and soundName ~= "None" then
        local soundPath = media:Fetch("sound", soundName)
        if soundPath and soundPath ~= "1" then
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
    else
        MyAddon:PrintSuccess(string.format("No sound selected or 'None' selected for %s sound.", soundType))
    end
end

--=====================================================================================
-- UI Panel Creation
--=====================================================================================

-- Function to open the options panel with a single nested dropdown
function MyAddon:OpenOptionsPanel()
    -- Check if a frame already exists to prevent multiple frames
    if self.optionsFrame and self.optionsFrame:IsShown() then
        self.optionsFrame:Hide()
        return
    end

    -- Create a new frame for the options panel using AceGUI
    local frame = AceGUI:Create("Frame")
    frame:SetTitle("MyAddon - Sound Settings")
    frame:SetStatusText("Configure your sound settings")
    frame:SetLayout("Flow")
    frame:SetWidth(400)
    frame:SetHeight(300)
    self.optionsFrame = frame  -- Store reference to frame

    -- Add a heading
    local heading = AceGUI:Create("Heading")
    heading:SetText("Sound Selection")
    heading:SetFullWidth(true)
    frame:AddChild(heading)

    -- Build soundCategories by grouping sounds based on their soundpack names
    local sounds = media:HashTable("sound")
    local soundCategories = {}

    if sounds then
        MyAddon:Print("LibSharedMedia Registered Sounds:")
        for soundName, soundPath in pairs(sounds) do
            MyAddon:Print("- " .. soundName .. " | Path: " .. soundPath)
            -- Exclude sounds present in the ignore list and ensure soundName is a string
            if not ignore[soundName] and type(soundName) == "string" then
                -- Extract the soundpack name from the sound's file path using pattern matching
                local _, _, soundpackName = string.find(soundPath, "^Interface\\AddOns\\([^\\]+)\\")
                soundpackName = soundpackName or "Unknown"

                -- Initialize the category table if it doesn't exist
                if not soundCategories[soundpackName] then
                    soundCategories[soundpackName] = {}
                end

                -- Add the sound to its respective category
                table.insert(soundCategories[soundpackName], soundName)
            else
                MyAddon:Print("Ignoring sound - " .. soundName)
            end
        end
    else
        MyAddon:Print("LibSharedMedia sounds not loaded.")
    end

    -- Create a button that will trigger the dropdown
    local dropdownButton = CreateFrame("Button", "MyAddon_SoundDropdown", frame.frame, "UIPanelButtonTemplate")
    dropdownButton:SetSize(150, 30)
    dropdownButton:SetText("Select Sound")
    dropdownButton:SetPoint("TOPLEFT", 20, -50)

    -- Create the UIDropDownMenu frame
    local dropdownFrame = CreateFrame("Frame", "MyAddon_UIDropDownMenu", UIParent, "UIDropDownMenuTemplate")

    -- Function to initialize the dropdown menu with nested submenus
    local function InitializeDropDown()
        local menuList = {}
        for categoryName, soundsList in pairs(soundCategories) do
            if type(soundsList) == "table" and #soundsList > 0 then
                -- Add category as a parent menu item with a submenu
                table.insert(menuList, {
                    text = categoryName,
                    hasArrow = true,
                    notCheckable = true,
                    menuList = {}
                })

                -- Populate the submenu with sounds
                for _, soundName in ipairs(soundsList) do
                    table.insert(menuList[#menuList].menuList, {
                        text = soundName,
                        func = function()
                            -- Set the dropdown button text to the selected sound
                            UIDropDownMenu_SetSelectedValue(dropdownFrame, soundName)
                            dropdownButton:SetText(soundName)

                            -- Play the selected sound
                            PlaySelectedSound(soundName, "Selected")
                        end,
                        notCheckable = true,
                    })
                end
            else
                MyAddon:Print("Category '" .. categoryName .. "' has no sounds or is invalid.")
            end
        end

        -- Add "Default" option at the beginning
        table.insert(menuList, 1, {
            text = "Default",
            func = function()
                UIDropDownMenu_SetSelectedValue(dropdownFrame, "Default")
                dropdownButton:SetText("Default")
                -- Define default sound behavior if needed
                PlaySelectedSound("Default", "Default")
            end,
            notCheckable = true,
        })

        UIDropDownMenu_Initialize(dropdownFrame, function(self, level, menuListArg)
            local info = UIDropDownMenu_CreateInfo()
            if level == 1 then
                for _, menuItem in ipairs(menuList) do
                    info.text = menuItem.text
                    info.hasArrow = menuItem.hasArrow
                    info.notCheckable = menuItem.notCheckable
                    info.func = menuItem.func
                    info.menuList = menuItem.menuList
                    UIDropDownMenu_AddButton(info, level)
                end
            elseif level == 2 and menuListArg then
                for _, subItem in ipairs(menuListArg) do
                    info.text = subItem.text
                    info.func = subItem.func
                    info.notCheckable = subItem.notCheckable
                    UIDropDownMenu_AddButton(info, level)
                end
            end
        end, "MENU")
    end

    -- Set the dropdown menu on button click
    dropdownButton:SetScript("OnClick", function(self)
        ToggleDropDownMenu(1, nil, dropdownFrame, "cursor", 0, 0)
    end)

    -- Initialize the Dropdown Menu
    InitializeDropDown()

    -- Set initial text
    dropdownButton:SetText("Select Sound")

    -- Add tooltip if desired
    dropdownButton:SetScript("OnEnter", function(self)
        GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
        GameTooltip:SetText("Select a sound to play.")
        GameTooltip:Show()
    end)
    dropdownButton:SetScript("OnLeave", function()
        GameTooltip:Hide()
    end)
end

--=====================================================================================
-- Register a Slash Command to Open the Options Panel
--=====================================================================================

-- Register a slash command to open the custom options panel
SLASH_MYADDON1 = "/myaddon"
SlashCmdList["MYADDON"] = function(msg)
    if msg:lower() == "help" then
        print("MyAddon Commands:\n  /myaddon - Open sound settings\n  /myaddon help - Show help")
    else
        MyAddon:OpenOptionsPanel()
    end
end

--=====================================================================================
-- Event Handling and Initialization
--=====================================================================================

-- Function called when addon is loaded
function MyAddon:OnAddonLoaded(arg1)
    if arg1 ~= addonName then return end
    self:PrintSuccess("Addon loaded.")

    -- Initialize saved variables
    self:InitSavedVariables()

    -- Load custom sounds if any
    self:LoadCustomSounds()
end

-- Function called when player logs in
function MyAddon:OnPlayerLogin()
    self:PrintSuccess("Player logged in.")
    -- Show welcome message if enabled
    if self.db.profile.showWelcomeMessage then
        self:Print("Welcome to MyAddon! Enjoy your enhanced sound experience.")
    end

    -- Initialize options panel
    -- Optionally, you can open the options panel on login
    -- self:OpenOptionsPanel()
end

-- Define the main event frame
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

--=====================================================================================
-- Loading Custom Sounds (Optional)
--=====================================================================================

function MyAddon:LoadCustomSounds()
    -- Register custom sounds with LibSharedMedia
    -- Ensure that the sound files exist at these paths and are in supported formats (e.g., .ogg, .mp3)
    media:Register("sound", "Achievement_Default", "Interface\\Addons\\MyAddon\\sounds\\achievement_default_med.ogg")
    media:Register("sound", "QuestAccept_Custom", "Interface\\Addons\\MyAddon\\sounds\\quest_accept_custom.ogg")
    media:Register("sound", "QuestTurnIn_Custom", "Interface\\Addons\\MyAddon\\sounds\\quest_turnin_custom.ogg")
    -- Add more custom sounds as needed

    self:PrintSuccess("Custom sounds loaded successfully.")
end
