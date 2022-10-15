TypeWriter.Runtime.LoadInternal("BetterEmitter")
local AppData = TypeWriter.ApplicationData .. "/Open-IPC/"
local FS = require("fs")
FS.mkdirSync(AppData)
FS.writeFileSync(
    AppData .. "IPC-Host.twr",
    TypeWriter.LoadedPackages["OpenIPC-TypeWriter"].Resources["/IPC-Host.twr"]
)
return Import("openipc.connector.Classes.IPCConnection")