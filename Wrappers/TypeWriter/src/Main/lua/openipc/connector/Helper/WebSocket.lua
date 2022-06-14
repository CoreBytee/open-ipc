local CoroWebsocket = require("coro-websocket")

return function (Url)
    return CoroWebsocket.connect(CoroWebsocket.parseUrl(Url))
end