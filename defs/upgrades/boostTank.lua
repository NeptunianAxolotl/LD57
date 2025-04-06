
local data = {
	applyFunc = function (spec, option)
		spec.jumpMax = spec.jumpMax * (option.jumpMax or 1)
		spec.jumpChargeRate = spec.jumpChargeRate * (option.jumpChargeRate or 1)
		spec.massScale = spec.massScale + (option.mass or 0)
		return spec
	end,
	showDepth = 450,
	options = {
		{
			name = "basic",
			cost = 0,
		},
		{
			name = "Max",
			cost = 0,
			depth = 0,
			jumpMax = 1.5,
			mass = 0.1,
		},
		{
			name = "Rate",
			cost = 0,
			depth = 0,
			jumpChargeRate = 1.2,
			mass = 0.3,
		},
		{
			name = "Max+",
			cost = 0,
			depth = 0,
			jumpMax = 2,
			jumpChargeRate = 0.8,
			mass = 0.15,
		},
		{
			name = "Rate+",
			cost = 0,
			depth = 0,
			jumpMax = 0.75,
			jumpChargeRate = 1.3,
			mass = 0.65,
		},
		{
			name = "Heavy",
			cost = 0,
			depth = 0,
			jumpMax = 2,
			jumpChargeRate = 1.2,
			mass = 1.2,
		},
	},
}

return data
