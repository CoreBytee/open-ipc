local Proxy = Object:extend()
local Json = require("json")

function Proxy:initialize()
    self.Connections = {}
end

function Proxy:NewConnection(Request, Read, Write)
    local Connections = self.Connections
    if not Connections[Request.params.Channel] then
        Connections[Request.params.Channel] = {}
    end
    Connections[Request.params.Channel][Request.params.Name] = {
        Read = Read,
        Write = Write
    }
    local Connection = Connections[Request.params.Channel][Request.params.Name]
    p(Request)
    for Message in Read do
        p(Message)
    end
end



return Proxy