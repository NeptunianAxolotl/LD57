
local data = {
	humanName = "Air\nSupply",
	textLine = 2,
	applyFunc = function (spec, option)
		spec.airSeconds = spec.airSeconds * (option.airMult or 1)
		spec.massScale = spec.massScale + (option.mass or 0)
		return spec
	end,
	showDepth = 100,
	options = {
		{
			name = "None",
			cost = 0,
		},
		{
			name = "Gasp",
			cost = 100,
			depth = 100,
			airMult = 30/15,
			mass = 0.05,
		},
		{
			name = "Breath",
			cost = 300,
			depth = 250,
			airMult = 40/15,
			mass = 0.1,
		},
		{
			name = "Breeze",
			cost = 500,
			depth = 700,
			airMult = 60/15,
			mass = 0.2,
		},
		{
			name = "Wind",
			cost = 800,
			depth = 1100,
			airMult = 80/15,
			mass = 0.3,
		},
		{
			name = "Gale",
			cost = 1200,
			depth = 1600,
			airMult = 120/15,
			mass = 0.6,
		},
		{
			name = "Storm",
			cost = 2000,
			depth = 3000,
			airMult = 240/15,
			mass = 1,
		},
	},
}

return data
