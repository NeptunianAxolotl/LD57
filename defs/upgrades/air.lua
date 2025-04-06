
local data = {
	applyFunc = function (spec, option)
		spec.airSeconds = spec.airSeconds * (option.airMult or 1)
		spec.massScale = spec.massScale + (option.mass or 0)
		return spec
	end,
	options = {
		{
			name = "basic",
			cost = 0,
		},
		{
			name = "efficient",
			cost = 0,
			depth = 0,
			airMult = 25/15,
			mass = 0.02,
		},
		{
			name = "efficient+",
			cost = 0,
			depth = 0,
			airMult = 40/15,
			mass = 0.04,
		},
		{
			name = "bulk",
			cost = 0,
			depth = 0,
			airMult = 60/15,
			mass = 0.4,
		},
		{
			name = "bulk+",
			cost = 0,
			depth = 0,
			airMult = 90/15,
			mass = 0.6,
		},
		{
			name = "bulk++",
			cost = 0,
			depth = 0,
			airMult = 120/15,
			mass = 1.1,
		},
	},
}

return data
