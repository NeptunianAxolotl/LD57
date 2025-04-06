
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
			name = "Cabin\nOnly",
			textLine = 2,
			cost = 0,
		},
		{
			name = "Mk 1",
			cost = 200,
			depth = 100,
			showDepth = 100,
			airMult = 25/15,
			mass = 0.05,
		},
		{
			name = "Mk 2",
			cost = 400,
			depth = 200,
			showDepth = 100,
			airMult = 40/15,
			mass = 0.1,
		},
		{
			name = "Mk 3",
			cost = 700,
			depth = 1100,
			showDepth = 450,
			airMult = 60/15,
			mass = 0.2,
		},
		{
			name = "Mk 4",
			cost = 1200,
			depth = 1100,
			showDepth = 450,
			airMult = 80/15,
			mass = 0.3,
		},
		{
			name = "Mk 5",
			cost = 2000,
			depth = 1200,
			showDepth = 900,
			airMult = 120/15,
			mass = 0.6,
		},
		{
			name = "Mk 6",
			cost = 3200,
			depth = 2000,
			showDepth = 1200,
			airMult = 240/15,
			mass = 1,
		},
	},
}

return data
