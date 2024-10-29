-- dropdown_menu.lua

-- Function to initialize the dropdown menu with categorized sounds
function MyAddon:InitializeDropdownMenu(parentFrame, soundCategories)
    local dropdownButton = CreateFrame("Button", "MyAddon_SoundDropdown", parentFrame.frame, "UIPanelButtonTemplate")
    dropdownButton:SetSize(150, 30)
    dropdownButton:SetText("Select Sound")
    dropdownButton:SetPoint("TOPLEFT", 20, -50)

    local dropdownFrame = CreateFrame("Frame", "MyAddon_UIDropDownMenu", UIParent, "UIDropDownMenuTemplate")

    local function InitializeDropDown()
        local menuList = {}
        for categoryName, soundsList in pairs(soundCategories) do
            if #soundsList > 0 then
                table.insert(menuList, {
                    text = categoryName,
                    hasArrow = true,
                    notCheckable = true,
                    menuList = {}
                })
                for _, soundName in ipairs(soundsList) do
                    table.insert(menuList[#menuList].menuList, {
                        text = soundName,
                        func = function()
                            UIDropDownMenu_SetSelectedValue(dropdownFrame, soundName)
                            dropdownButton:SetText(soundName)
                            MyAddon:PlaySelectedSound(soundName, "Selected")
                        end,
                        notCheckable = true,
                    })
                end
            end
        end

        -- Add "Default" option at the beginning
        table.insert(menuList, 1, {
            text = "Default",
            func = function()
                UIDropDownMenu_SetSelectedValue(dropdownFrame, "Default")
                dropdownButton:SetText("Default")
                MyAddon:PlaySelectedSound("Default", "Default")
            end,
            notCheckable = true,
        })

        UIDropDownMenu_Initialize(dropdownFrame, function(self, level, menuListArg)
            local info = UIDropDownMenu_CreateInfo()
            if level == 1 then
                for _, menuItem in ipairs(menuList) do
                    info.text = menuItem.text
                    info.hasArrow = menuItem.hasArrow
                    info.menuList = menuItem.menuList
                    info.notCheckable = menuItem.notCheckable
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

    dropdownButton:SetScript("OnClick", function(self)
        ToggleDropDownMenu(1, nil, dropdownFrame, "cursor", 0, 0)
    end)

    InitializeDropDown()
    dropdownButton:SetText("Select Sound")
end
