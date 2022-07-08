local Proxy = Object:extend()
local Json = require("json")

function Proxy:initialize()
    self.Connections = {}
end

function Proxy:NewConnection(Request, Read, Write)
    local Connections = self.Connections

    local Channel = Request.params.Channel
    local Name = Request.params.Name

    if not Connections[Channel] then
        Connections[Channel] = {}
    end
    Connections[Channel][Name] = {
        Read = Read,
        Write = Write,
        Channel = Channel,
        Name = Name
    }
    TypeWriter.Logger.Info("New connection using channel %s and id %s", Channel, Name)
    local Connection = Connections[Channel][Name]
    for Message in Read do
        local Payload = Message.payload
        local Decoded = Json.decode(Payload)
        if Decoded ~= nil then
            self:HandleMessage(Connection, Decoded)
        end
    end
    TypeWriter.Logger.Info("Connection %s from channel %s closed", Name, Channel)
    Connections[Channel][Name] = nil
    local C = table.count(Connections[Channel])
    TypeWriter.Logger.Info("%s remaining connections on channel %s", C, Channel)
    if C == 0 then
        TypeWriter.Logger.Info("Shutting down channel %s", Channel)
        Connections[Channel] = nil
    end
end

local Handlers = {
    ["Message"] = function (self, Connection, Payload)
        local Channel = Connection.Channel
        local Name = Connection.Name
        local To = Payload.To

        Payload.From = Name
        Payload.Type = "Message"

        if self.Connections[Channel][To] == nil then
            TypeWriter.Logger.Info("Tried to send to a not existsing connection (%s)", To)
            return
        end
        self.Connections[Channel][To].Write(
            {payload = Json.encode(Payload)}
        )
    end
}

function Proxy:HandleMessage(Connection, Payload)
    local Channel = Connection.Channel
    local Name = Connection.Name
    TypeWriter.Logger.Info("Message received on channel %s from %s", Channel, Name)
    if Handlers[Payload.Type] ~= nil then
        Payload.Payload.To = tostring(Payload.Payload.To)
        Handlers[Payload.Type](self, Connection, Payload.Payload)
    else
        TypeWriter.Logger.Error("Unknown message type %s", Payload.Type)
    end
end



return Proxy