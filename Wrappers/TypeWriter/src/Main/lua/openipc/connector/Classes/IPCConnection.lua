local Connection = Import("ga.corebyte.BetterEmitter"):extend()
local WebSocket = Import("openipc.connector.Helper.WebSocket")
function Connection:initialize(Channel, Name)
    self.Channel = Channel
    self.Name = Name

    local Connection = WebSocket(
        string.format(
            "ws://localhost:25665/v1/connect/%s/%s",
            Channel,
            Name
        )    
    )
end

return Connection