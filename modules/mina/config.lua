rocas = { 
		{x = 2972.36, y = 2775.44, z = 39.24, vida = 150, tipo = "Oro", data = "oro", max = 150, level = 1},
		{x = 2968.64, y = 2775.64, z = 39.48, vida = 200, tipo = "Hierro", data = "hierro", max = 200, level = 0},
		{x = 2964.44, y = 2773.96, z = 40.04, vida = 200, tipo = "Hierro", data = "hierro", max = 200, level = 0},
		{x = 2951.16, y = 2768.52, z = 39.84, vida = 200, tipo = "Hierro", data = "hierro", max = 200, level = 0},
		{x = 2947.2, y = 2765.96, z = 40.36, vida = 150, tipo = "Oro", data = "oro", max = 150, level = 1},
		{x = 2937.2, y = 2771.92, z = 39.88, vida = 200, tipo = "Hierro", data = "hierro", max = 200, level = 0},
		{x = 2927.28, y = 2792.41, z = 40.49, vida = 200, tipo = "Hierro", data = "hierro", max = 200, level = 0},
		{x = 2925.56, y = 2796.48, z = 41.44, vida = 200, tipo = "Hierro", data = "hierro", max = 200, level = 0},
		{x = 2921.44, y = 2799.32, z = 42.16, vida = 150, tipo = "Oro", data = "oro", max = 150, level = 1},
		{x = 2938.52, y = 2812.64, z = 43.4, vida = 200, tipo = "Hierro", data = "hierro", max = 200, level = 0},
		{x = 2951.32, y = 2816.32, z = 42.92, vida = 200, tipo = "Hierro", data = "hierro", max = 200, level = 0},
		{x = 2971.96, y = 2798.68, z = 42.16, vida = 200, tipo = "Hierro", data = "hierro", max = 200, level = 0},
		{x = 2979.08, y = 2790.48, z = 41.6, vida = 150, tipo = "Oro", data = "oro", max = 150, level = 1},
}

ConfigMina = {}

ConfigMina.Uniforms = {
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

ConfigMina.Vehicle = "Rubble"
ConfigMina.DeleteVeh = "RUBBLE"
ConfigMina.VehicleMoney = 1500

ConfigMina.Zones = {
	deleteVehicle = {
		coords = vector3(1589.16, -1717.87, 87.60),
		help = "Pulsa ~INPUT_CONTEXT~ para devolver el vehiculo",
		color = {r = 255, g = 1, b = 1},
		size = 5.5,
		height = 0.5

	},
	spawnMenu = {
		coords = vector3(1597.83, -1727.66, 87.48),
		area = vector3(1585.93, -1732.91, 88.1),
		heading = 158.82,
		help = "Pulsa ~INPUT_CONTEXT~ para obtener el vehículo de trabajo",
		color = {r = 1, g = 255, b = 1},
		size = 1.5,
		height = 1.5
	}
}


