-- See https://github.com/Dot-lua/TypeWriter/wiki/package.info.lua-format for more info

return { InfoVersion = 1, -- Dont touch this

    ID = "IPC-Connector", -- A unique id 
    Name = "IPC-Connector",
    Description = "A IPC-Connector",
    Version = "1.0.0",

    Author = {
        Developers = {
            "CoreByte"
        },
        Contributors = {}
    },

    Dependencies = {
        Luvit = {
            "creationix/coro-spawn",
            "creationix/coro-http",
            "creationix/coro-websocket",
        },
        Git = {},
        Dua = {}
    },

    Contact = {
        Website = "",
        Source = "",
        Socials = {}
    },

    Entrypoints = {
        Main = "openipc.connector.Test"
    }

}
