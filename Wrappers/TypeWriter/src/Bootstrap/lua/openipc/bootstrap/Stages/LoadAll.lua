local FS = require("fs")

local ApplicationDataFolder = TypeWriter.Folder .. "/ApplicationData/Open-IPC/"

return function (SkipUpdate)
    if SkipUpdate ~= true or FS.existsSync(ApplicationDataFolder .. "/Version.txt") == false then
        Import("openipc.bootstrap.Stages.Download")()
    end
    TypeWriter.Runtime.LoadFile(ApplicationDataFolder .. "/IPC-Connector.twr")
    return Import("openipc.connector")
end