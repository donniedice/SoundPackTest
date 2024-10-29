-- core.lua

-- Load necessary libraries and core initialization
local LibStub = LibStub
local AceGUI = LibStub("AceGUI-3.0", true)
local media = LibStub("LibSharedMedia-3.0", true)

if not AceGUI or not media then
    print("MyAddon: Required libraries (AceGUI-3.0 and LibSharedMedia-3.0) are not loaded.")
    return
end

local addonName, addon = ...
MyAddon = MyAddon or {}
MyAddon.db = MyAddon.db or {}
MyAddon.db.profile = MyAddon.db.profile or {}
MyAddon.Modules = MyAddon.Modules or {}

MyAddon.VersionNumber = "v1.0.0"
MyAddon_L = MyAddon_L or addon.L or {}

-- Load initialization and utility files as defined in init.lua
