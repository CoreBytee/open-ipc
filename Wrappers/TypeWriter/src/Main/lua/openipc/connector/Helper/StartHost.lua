local Request = require("coro-http").request
local Spawn = require("coro-spawn")
local Json = require("json")
local FS = require("fs")

local ApplicationDataFolder = TypeWriter.Folder .. "/ApplicationData/Open-IPC/"

local function Check()
    local Success = pcall(Request, "GET", "http://localhost:25665/")
    return Success
end

local function Start()
    local Result, Error = Spawn(
        TypeWriter.This,
        {
            args = {
                "execute",
                "--input=" .. ApplicationDataFolder .. "IPC-Host.twr",
            },
            detached = true,
            hide = true
        }
    )
    repeat
        Sleep(50)
        TypeWriter.Logger.Warn("OpenIPC > Could not connect to the host. Retrying...")
    until Check()
end

return function ()
    local Running = Check()
    if not Running then
        Start()
        return false
    end
    return true
end