local defs = {
	{
		name = "default",
		friction = 0.85,
		bounce = 0.2,
		col = {1, 1, 1, 1},
	},
	{
		name = "sand",
		friction = 0.2,
		bounce = 0.7,
		col = {1, 1, 0.1, 1},
	},
	{
		name = "bounce",
		friction = 0.5,
		bounce = 2,
		col = {1, 0.2, 1, 1},
	},
}

return defs
