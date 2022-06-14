local Connection = Import("ga.corebyte.BetterEmitter"):extend()

function Connection:initialize(Channel, Name)
    self.Channel = Channel
    self.Name = Name

    p(Import("openipc.connector.Helper.WebSocket")("ws://localhost:25665/v1/connect"))
end

return Connection