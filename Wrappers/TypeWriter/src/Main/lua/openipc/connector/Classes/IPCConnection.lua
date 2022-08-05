local Connection = Import("ga.corebyte.BetterEmitter"):extend()
local WebSocket = Import("openipc.connector.Helper.WebSocket")
local StartHost = Import("openipc.connector.Helper.StartHost")
local Json = require("json")

function Connection:initialize(Channel, Name)
    self.Channel = Channel
    self.Name = Name
    self.Handlers = {}

    StartHost()

    local Response, Read, Write = WebSocket(
        string.format(
            "ws://localhost:25665/v1/connect/%s/%s",
            Channel,
            Name
        )    
    )
    self.Connection = {
        Read = Read,
        Write = Write
    }

    coroutine.wrap(function ()
        self:Emit("Connected")
        TypeWriter.Logger.Info("OpenIPC > Connected to the host.")
        for Message in Read do
            local Payload = Message.payload
            local Decoded = Json.decode(Payload)
            self:HandleIncoming(Decoded)
        end
        self:Emit("Disconnected")
        self:Emit("Return", {Disconnected = true})
    end)()
end

function Connection:RegisterMessage(Message, Fn)
    self.Handlers[Message] = Fn
    return self
end

function Connection:HandleIncoming(D)
    if D.MessageType == "Return" then
        self:Emit("Return", D)
        return
    end
    if self.Handlers[D.Name] == nil then
        TypeWriter.Logger.Info("Tried to handle a not existsing message (%s)", D.Name)
        return
    end
    local ReturnData = self.Handlers[D.Name](D.Data, Return, D.From, D.Sequence)
    self:Write(
        "Message",
        {
            To = D.From,
            Sequence = D.Sequence,
            Data = ReturnData,
            MessageType = "Return"
        }
    )
end

function Connection:Write(Type, Payload)
    local Data = {
        Type = Type,
        Payload = Payload
    }
    self.Connection.Write(
        {
            payload = Json.encode(Data)
        }
    )
end

function Connection:Send(To, Name, Payload)
    local Sequence = string.random(16)
    self:Write(
        "Message",
        {
            To = To,
            Sequence = Sequence,
            Data = Payload,
            Name = Name,
            MessageType = "Message"
        }
    )
    local Returned, ReturnedData = self:WaitFor("Return", nil,
        function (Data)
            return Data.Sequence == Sequence or Data.Disconnected == true
        end
    )
    if ReturnedData.Disconnected == true then
        return {IPC_DISCONNECTED = true, IPC_ERROR = true}
    else
        return ReturnedData.Data
    end
end

function Connection:Disconnect()
    self.Connection.Write()
end

return Connection