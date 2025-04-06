
local data = {
	applyFunc = function (spec, option)
		spec.airSeconds = spec.airSeconds * (option.airMult or 1)
		spec.massScale = spec.massScale + (option.mass or 0)
		return spec
	end,
	showDepth = 100,
	options = {
		{
			name = "basic",
			cost = 0,
		},
		{
			name = "efficient",
			cost = 200,
			depth = 100,
			showDepth = 100,
			airMult = 30/20,
			mass = 0.02,
		},
		{
			name = "efficient+",
			cost = 350,
			depth = 200,
			showDepth = 100,
			airMult = 45/20,
			mass = 0.04,
		},
		{
			name = "bulk",
			cost = 500,
			depth = 200,
			showDepth = 250,
			airMult = 60/20,
			mass = 0.15,
		},
		{
			name = "bulk+",
			cost = 700,
			depth = 450,
			showDepth = 250,
			airMult = 90/20,
			mass = 0.25,
		},
		{
			name = "bulk++",
			cost = 1000,
			depth = 800,
			showDepth = 450,
			airMult = 150/20,
			mass = 0.6,
		},
		{
			name = "bulk+++",
			cost = 1800,
			depth = 1200,
			showDepth = 700,
			airMult = 360/20,
			mass = 1,
		},
	},
}

return data
