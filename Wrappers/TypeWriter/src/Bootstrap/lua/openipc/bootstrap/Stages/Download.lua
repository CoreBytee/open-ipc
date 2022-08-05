local Request = require("coro-http").request
local Json = require("json")
local FS = require("fs")

local ApplicationDataFolder = TypeWriter.Folder .. "/ApplicationData/Open-IPC/"
local LatestReleaseURL = "https://api.github.com/repos/CoreBytee/open-ipc/releases/latest"
local FileUrl = "https://github.com/CoreBytee/open-ipc/releases/download/%s/%s"

local function IsConnected()
    local Success = pcall(Request, "GET", "https://github.com/CoreBytee/open-ipc")
    return Success
end

local function GetLatestTag()
    local Response, Body = Request(
        "GET",
        LatestReleaseURL,
        {
            {"User-Agent", "open-ipc (https://github.com/CoreBytee/open-ipc)"}
        }
    )
    return Json.parse(Body).tag_name
end

local Files = {
    "IPC-Bootstrap.twr",
    "IPC-Connector.twr",
    "IPC-Host.twr"
}

local function DownloadFiles(Tag)
    for Index, FileName in pairs(Files) do
        TypeWriter.Logger.Info("OpenIPC > Downloading " .. FileName .. "...")
        local Response, Body = Request(
            "GET",
            string.format(
                FileUrl,
                Tag,
                FileName
            ),
            {
                {"User-Agent", "open-ipc (https://github.com/CoreBytee/open-ipc)"}
            }
        )
        FS.writeFileSync(ApplicationDataFolder .. FileName, Body)
    end
end

return function ()
    local MustFinish = FS.existsSync(ApplicationDataFolder .. "/Version.txt") == false
    FS.mkdirSync(ApplicationDataFolder)
    if IsConnected() == false then
        TypeWriter.Logger.Error("Not connected to the internet.")
        if MustFinish == true then
            process:exit(0)
        end
        return false
    end

    local Tag = GetLatestTag()

    if MustFinish == true then
        DownloadFiles(Tag)
        FS.writeFileSync(ApplicationDataFolder .. "/Version.txt", Tag)
    else
        local CurrentVersion = FS.readFileSync(ApplicationDataFolder .. "/Version.txt")
        if CurrentVersion ~= Tag then
            DownloadFiles(Tag)
            FS.writeFileSync(ApplicationDataFolder .. "/Version.txt", Tag)
        end
    end

    return true
end