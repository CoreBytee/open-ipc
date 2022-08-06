var ConnectionClass = require('./openipc-node/index.js')

const Connection = new ConnectionClass(
    "Test",
    2
);

Connection.RegisterMessage(
    "Echo",
    async function (Data, From, Sequence) {
        console.log("Echo", Data, From, Sequence)
        return Data
    }
);

(async function () {
    var Data = await Connection.Send(
        1,
        "Echo",
        {
            Message: "Hello World"
        }
    )

    console.log(Data)
}());