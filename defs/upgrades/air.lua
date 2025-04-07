
local data = {
	humanName = "Air\nSupply",
	textLine = 2,
	applyFunc = function (spec, option)
		spec.airSeconds = spec.airSeconds * (option.airMult or 1)
		spec.massScale = spec.massScale + (option.mass or 0)
		return spec
	end,
	showDepth = Global.DEPTHS[1],
	options = {
		{
			name = "None",
			cost = 0,
		},
		{
			name = "Gasp",
			cost = 100,
			depth = Global.DEPTHS[1],
			airMult = 30/15,
			mass = 0.05,
		},
		{
			name = "Breath",
			cost = 300,
			depth = Global.DEPTHS[2],
			airMult = 40/15,
			mass = 0.1,
		},
		{
			name = "Breeze",
			cost = 500,
			depth = Global.DEPTHS[3],
			airMult = 60/15,
			mass = 0.2,
		},
		{
			name = "Wind",
			cost = 800,
			depth = Global.DEPTHS[4],
			airMult = 75/15,
			mass = 0.3,
		},
		{
			name = "Gale",
			cost = 1200,
			depth = Global.DEPTHS[5],
			airMult = 100/15,
			mass = 0.6,
		},
		{
			name = "Storm",
			cost = 2000,
			depth = Global.DEPTHS[6],
			airMult = 150/15,
			mass = 1,
		},
	},
}

return data
