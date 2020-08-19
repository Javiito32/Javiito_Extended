ConfigFishing = {}

ConfigFishing.Levels = {
    salmon = 0,
    anchoa = 0,
    pescadilla = 1,
    sardinas = 1,
    merluza = 2,
    lubina = 2,
    rodaballo = 3,
    rape = 3,
    pez_espada = 4
}

ConfigFishing.Prices = {
    salmon = 7,
    anchoa = 7,
    pescadilla = 13,
    sardinas = 13,
    merluza = 20,
    lubina = 20,
    rodaballo = 27,
    rape = 27,
    pez_espada = 34
}

ConfigFishing.Vehicle = "tug"
ConfigFishing.TimeToSell = 10000
ConfigFishing.TimeToFish = 20000
ConfigFishing.Max = 7

ConfigFishing.Zones = {
    VehicleSpawner = {
        Pos = vector3(45.96, -2793.28, 5.32),
        type = 1,
        size = 1.0,
        color = {r = 255, g = 169, b = 83},
        workInProgress = false,
        DrawDistance = 10,
        HelpMessage = "Pulsa ~INPUT_CONTEXT~ para obtener tu vehículo",
        NoHelpMessage = "No puedes sacar otro vehículo sin recoger el anterior"
    },

    SellPoint = {
        Pos = vector3(-259.03, -2679.4, 6.16),
        type = 1,
        size = 1.0,
        color = {r = 83, g = 255, b = 140},
        workInProgress = false,
        DrawDistance = 10,
        HelpMessage = "Pulsa ~INPUT_CONTEXT~ para comenzar la venta",
        NoHelpMessage = "Recoge tu vehículo antes de comenzar la venta"
    },

    VehicleCollect = {
        Pos = vector3(35.21, -2780.68, 0.0),
        type = 1,
        size = 7.0,
        color = {r = 255, g = 83, b = 101},
        tp = vector3(43.29, -2757.62, 6.0),
        workInProgress = true,
        DrawDistance = 10,
        HelpMessage = "Pulsa ~INPUT_CONTEXT~ para devolver el barco",
        NoHelpMessage = nil
    }
}

ConfigFishing.Uniforms = {
	job_wear = {
		male = {
			['tshirt_1'] = 59, ['tshirt_2'] = math.random(0, 1),
			['torso_1'] = 5, ['torso_2'] = 0,
			['decals_1'] = 0, ['decals_2'] = 0,
			['arms'] = 15,
			['pants_1'] = 36, ['pants_2'] = 0,
			['shoes_1'] = 71, ['shoes_2'] = 0,
			['helmet_1'] = 0, ['helmet_2'] = 3,
			['chain_1'] = 0, ['chain_2'] = 0,
			['ears_1'] = -1, ['ears_2'] = 0
		},
		female = {
			['tshirt_1'] = 36, ['tshirt_2'] = 1,
			['torso_1'] = 11, ['torso_2'] = 11,
			['decals_1'] = 0, ['decals_2'] = 0,
			['arms'] = 24,
			['pants_1'] = 11, ['pants_2'] = 0,
			['shoes_1'] = 26, ['shoes_2'] = 0,
			['helmet_1'] = 0, ['helmet_2'] = 7,
			['chain_1'] = 0, ['chain_2'] = 0,
			['ears_1'] = -1, ['ears_2'] = 0
		}
	},
}

ConfigFishing.FishPoint = {
    {x = 25.38, y = -3028.97, z = 2.53},
    {x = -112.01, y = -2950.48, z = 2.53},
    {x = -172.19, y = -2878.72, z = 2.53},
    {x = -330.66, y = -2963.86, z = 2.53},
    {x = 1.22, y = -3012.43, z = 2.53},
    {x = -81.29, y = -3083.11, z = 2.53},
    {x = -260.15, y = -3110.68, z = 2.53},
    {x = -380.06, y = -3011.88, z = 2.53},
}