Config = {}

Config.maxStock = 100

Config.Business = {
    minero = {
        pos = vector3(1054.68, -1952.77, 31.09),
        size = 1.3,
        stock_price = {
            {item = "tablon_pino", value = 2, label = "Tablón de pino"},
            {item = "roble", value = 1, label = "Roble"}
        },
        reward = 100,
        initial_pay = {
            {item = "pino", value = 100},
            {item = "roble", value = 100}
        }
    },
    madedero = {
        pos = vector3(1069.68, -1957.77, 31.09),
        size = 1.3,
        stock_price = {
            {item = "tablon_pino", value = 2, label = "Tablón de pino"},
            {item = "roble", value = 1, label = "Roble"}
        },
        reward = 100,
        initial_pay = {
            {item = "pino", value = 100},
            {item = "roble", value = 100}
        }
    },
    trucker = {
        pos = vector3(1069.68, -1957.77, 31.09),
        size = 1.3,
        stock_price = {
            {item = "tablon_pino", value = 2, label = "Tablón de pino"},
            {item = "roble", value = 1, label = "Roble"}
        },
        reward = 100,
        initial_pay = {
            {item = "pino", value = 100},
            {item = "roble", value = 100}
        }
    },
    fisherman = {
        pos = vector3(1069.68, -1957.77, 31.09),
        size = 1.3,
        stock_price = {
            {item = "tablon_pino", value = 2, label = "Tablón de pino"},
            {item = "roble", value = 1, label = "Roble"}
        },
        reward = 100,
        initial_pay = {
            {item = "pino", value = 100},
            {item = "roble", value = 100}
        }
    }
}

Config.WorkLabels = {
    minero = "Minero",
    madedero = "Leñador",
    trucker = "Camionero",
    fisherman = "Pescador",
}