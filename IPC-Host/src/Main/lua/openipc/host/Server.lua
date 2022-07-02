return function (Port, Host)
    if Host == nil then
        Host = "127.0.0.1"
    end
    require("weblit-websocket")
    local App = require("weblit").app
    local Proxy = Import("openipc.host.Proxy"):new()

    App.bind(
        {
            host = Host,
            port = Port
        }
    )
    
    App.use(require('weblit-auto-headers'))
    App.route(
        {
            method = "GET",
            path = "/",
        },
        function (Request, Response)
            Response.body = "Running version " .. TypeWriter.LoadedPackages["IPC-Host"].Package.Version
            Response.code = 200
        end
    )

    App.websocket(
        {
            path = "/v1/connect/:Channel/:Name"
        },
        function (Request, Read, Write)
            Proxy:NewConnection(Request, Read, Write)
        end
    )
    
    App.start()
end