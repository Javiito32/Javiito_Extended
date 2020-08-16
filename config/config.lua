Config = {}

Config.maxStock = 100

Config.Business = {
    minero = {
        pos = vector3(1054.68, -1952.77, 31.09),
        size = 1.3,
        stock_price = {
            {item = "carbon", value = 3, label = "Carbón"},
            {item = "plata", value = 2, label = "Plata"},
            {item = "lingote_hierro", value = 1, label = "Lingote de Hierro"}
        },
        reward = 500,
        initial_type = 'items',
        initial_pay = {
            {item = "carbon", value = 100},
            {item = "plata", value = 50},
            {item = "lingote_hierro", value = 30}
        }
    },
    madedero = {
        pos = vector3(-590.45, 5341.58, 70.23),
        size = 1.3,
        stock_price = {
            {item = "tablon_pino", value = 2, label = "Tablón de pino"},
            {item = "roble", value = 1, label = "Roble"}
        },
        reward = 500,
        initial_type = 'items',
        initial_pay = {
            {item = "pino", value = 100},
            {item = "roble", value = 50}
        }
    },
    trucker = {
        pos = vector3(173.54, 2778.49, 46.08),
        size = 1.3,
        stock_price = 100,
        reward = 500,
        initial_type = 'cash',
        initial_pay = 5000
    },
    fisherman = {
        pos = vector3(-271.33, -2690.64, 6.31),
        size = 1.3,
        stock_price = {
            {item = "anchoa", value = 5, label = "Anchoas"},
            {item = "salmon", value = 1, label = "Salmon"}
        },
        reward = 500,
        initial_type = 'items',
        initial_pay = {
            {item = "pez_espada", value = 10},
            {item = "rape", value = 20},
            {item = "anchoa", value = 90},
        }
    },
    farmer = {
        pos = vector3(95.78, 6363.76, 31.38),
        size = 1.3,
        stock_price = 100,
        reward = 500,
        initial_type = 'cash',
        initial_pay = 5000
    },
    works = {
        pos = vector3(2521.4, -414.37, 94.12),
        size = 1.3,
        stock_price = 100,
        reward = 500,
        initial_type = 'cash',
        initial_pay = 5000
    },
}

Config.WorkLabels = {
    minero = "Minero",
    madedero = "Leñador",
    trucker = "Camionero",
    fisherman = "Pescador",
}