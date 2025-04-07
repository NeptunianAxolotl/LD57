
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
			name = "15s",
			cost = 0,
		},
		{
			name = "30s",
			cost = 100,
			depth = Global.DEPTHS[1],
			airMult = 30/15,
			mass = 0.05,
		},
		{
			name = "40s",
			cost = 300,
			depth = Global.DEPTHS[2],
			airMult = 40/15,
			mass = 0.1,
		},
		{
			name = "60s",
			cost = 500,
			depth = Global.DEPTHS[3],
			airMult = 60/15,
			mass = 0.2,
		},
		{
			name = "90s",
			cost = 800,
			depth = Global.DEPTHS[4],
			airMult = 90/15,
			mass = 0.3,
		},
		{
			name = "150s",
			cost = 1500,
			depth = Global.DEPTHS[5],
			airMult = 150/15,
			mass = 0.6,
		},
		{
			name = "240s",
			cost = 3000,
			depth = Global.DEPTHS[6],
			airMult = 240/15,
			mass = 1,
		},
	},
}

return data
