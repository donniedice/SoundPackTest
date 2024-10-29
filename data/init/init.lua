-- init.lua

-- Define MyAddon globally to ensure availability in other files
local addonName, addon = ...
MyAddon = MyAddon or {}
MyAddon_L = MyAddon_L or addon.L or {}  -- Localization table
MyAddon.Modules = MyAddon.Modules or {}
MyAddon.db = MyAddon.db or {}
MyAddon.db.profile = MyAddon.db.profile or {}
MyAddon.VersionNumber = "v1.0.0"

-- Load necessary libraries using LibStub
local LibStub = LibStub
local AceGUI = LibStub("AceGUI-3.0", true)
local media = LibStub("LibSharedMedia-3.0", true)

-- Ensure that AceGUI and LibSharedMedia are available
if not AceGUI or not media then
    print("MyAddon: Required libraries (AceGUI-3.0 and LibSharedMedia-3.0) are not loaded.")
    return
end

-- No need to load modules here; XML will handle it
