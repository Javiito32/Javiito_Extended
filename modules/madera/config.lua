rocas = { 
		{x = -557.61, y = 5419.43, z = 63.2, vida = 100, tipo = "Abedul", data = "abedul", max = 100, level = 4},
		{x = -561.81, y = 5421.32, z = 62.17, vida = 200, tipo = "Pino", data = "pino", max = 200, level = 0},
		{x = -577.57, y = 5427.06, z = 59.06, vida = 200, tipo = "Pino", data = "pino", max = 200, level = 0},
		{x = -551.8, y = 5445.49, z = 64.1, vida = 200, tipo = "Pino", data = "pino", max = 200, level = 0},
		{x = -586.12, y = 5447.83, z = 60.32, vida = 150, tipo = "Roble", data = "roble", max = 150, level = 3},
		{x = -591.61, y = 5449.7, z = 59.6, vida = 200, tipo = "Pino", data = "pino", max = 200, level = 0},
		{x = -594.04, y = 5451.61, z = 59.44, vida = 200, tipo = "Pino", data = "pino", max = 200, level = 0},
		{x = -582.08, y = 5470.29, z = 59.48, vida = 200, tipo = "Pino", data = "pino", max = 200, level = 0},
		{x = -577.1, y = 5468.9, z = 60.75, vida = 100, tipo = "Nogal", data = "nogal", max = 100, level = 2},
		{x = -572.57, y = 5468.12, z = 61.43, vida = 200, tipo = "Pino", data = "pino", max = 200, level = 0},
		{x = -560.16, y = 5460.29, z = 63.63, vida = 150, tipo = "Abeto", data = "abeto", max = 150, level = 1},
		{x = -563.14, y = 5457.28, z = 63.15, vida = 200, tipo = "Pino", data = "pino", max = 200, level = 0},
}

Config = {}
Config.Uniforms = {
	job_wear = {
		male = {
			['tshirt_1'] = 15, ['tshirt_2'] = 0,
			['torso_1'] = 26, ['torso_2'] = 6,
			['decals_1'] = 0, ['decals_2'] = 0,
			['arms'] = 11,
			['pants_1'] = 9, ['pants_2'] = 3,
			['shoes_1'] = 35, ['shoes_2'] = 0,
			['helmet_1'] = 76, ['helmet_2'] = 13,
			['chain_1'] = 0, ['chain_2'] = 0,
			['ears_1'] = -1, ['ears_2'] = 0
		},
		female = {
			['tshirt_1'] = 15, ['tshirt_2'] = 0,
			['torso_1'] = 9, ['torso_2'] = 7,
			['decals_1'] = 0, ['decals_2'] = 0,
			['arms'] = 0,
			['pants_1'] = 45, ['pants_2'] = 1,
			['shoes_1'] = 52, ['shoes_2'] = 5,
			['helmet_1'] = 55, ['helmet_2'] = 0,
			['chain_1'] = 0, ['chain_2'] = 0,
			['ears_1'] = -1, ['ears_2'] = 0
		}
	},
}

Config.Vehicle = "TipTruck"
Config.DeleteVeh = "TIPTRUCK"
Config.VehicleMoney = 1500

Config.Zones = {
	deleteVehicle = {
		coords = vector3(1205.41, -1282.41, 34.70),
		help = "Pulsa ~INPUT_CONTEXT~ para devolver el vehiculo",
		color = {r = 255, g = 1, b = 1},
		size = 5.5,
		height = 0.5

	},
	spawnMenu = {
		coords = vector3(1200.33, -1274.0, 34.70),
		area = vector3(1220.36, -1289.54, 34.30),
		heading = 266.81,
		help = "Pulsa ~INPUT_CONTEXT~ para obtener el vehículo de trabajo",
		color = {r = 1, g = 255, b = 1},
		size = 1.5,
		height = 1.5
	}
}