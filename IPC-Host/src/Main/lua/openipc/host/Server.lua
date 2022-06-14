return function (Port, Host)
    if Host == nil then
        Host = "127.0.0.1"
    end
    require("weblit-websocket")
    local App = require("weblit").app

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
            path = "/v1/connect"
        },
        function (Request, Read, Write)
            -- Log the request headers
            p(req)
            -- Log and echo all messages
            for message in read do
                write(message)
            end
            -- End the stream
            write()
        end
    )
    
    App.start()
end