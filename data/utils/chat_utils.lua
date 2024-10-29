-- chat_utils.lua

function MyAddon:Print(message)
    print("|cFF33FF99MyAddon|r: " .. message)
end

function MyAddon:PrintSuccess(message)
    if MyAddon.db.profile.debugMode then
        MyAddon:Print(message)
    end
end

function MyAddon:PrintError(message)
    print("|cFFFF3333MyAddon|r: " .. message)
end
