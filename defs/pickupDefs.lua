local defs = {
	{
		name = "coin",
		radius = 40,
		money = 50,
		col = {1, 0.8, 0, 1},
	},
	{
		name = "bigCoin",
		radius = 50,
		money = 200,
		col = {1, 0.8, 0, 1},
	},
	{
		name = "chest",
		radius = 60,
		money = 500,
		col = {1, 0.8, 0, 1},
	},
	{
		name = "bigChest",
		radius = 90,
		money = 5000,
		col = {1, 0.8, 0, 1},
		toolSkip = true,
	},
	{
		name = "portal_1",
		radius = 80,
		portalExit = 1,
		col = {0.9, 0.2, 1, 1},
		toolSkip = true,
	},
	{
		name = "portal_1_entrance",
		radius = 120,
		portalEntrance = 1,
		col = {0.9, 0.2, 1, 1},
		toolSkip = true,
	},
	{
		name = "portal_2",
		radius = 80,
		portalExit = 2,
		col = {0.9, 0.2, 1, 1},
		toolSkip = true,
	},
	{
		name = "portal_2_entrance",
		radius = 120,
		portalEntrance = 2,
		col = {0.9, 0.2, 1, 1},
		toolSkip = true,
	},
	{
		name = "start_portal",
		radius = 120,
		portalEntrance = "start",
		col = {0.9, 0.2, 1, 1},
		toolSkip = true,
	},
	{
		name = "ultraCoin",
		radius = 450,
		money = 20000,
		col = {1, 0.8, 0, 1},
		toolSkip = true,
	},
}

return defs
