local Id = tonumber(TypeWriter.ArgumentParser:GetArgument("id", "id"))
local Connection = Import("openipc.connector"):new(
    "Test",
    Id
)
local Other = ({[1] = 2, [2] = 1})[Id]

Connection:RegisterMessage(
    "Echo",
    function (Data, From)
        p(Data)
        return Data
    end
)

Connection:Send(
    Other,
    "Echo",
    {
        Message = "Hello World"
    }
)