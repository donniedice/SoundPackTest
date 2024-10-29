-- commands.lua

SLASH_MYADDON1 = "/myaddon"
SlashCmdList["MYADDON"] = function(msg)
    if msg:lower() == "help" then
        print("MyAddon Commands:\n  /myaddon - Open sound settings\n  /myaddon help - Show help")
    else
        MyAddon:OpenOptionsPanel()
    end
end
