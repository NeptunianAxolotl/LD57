
local data = {
	humanName = "Boost\nSupply",
	textLine = 2,
	applyFunc = function (spec, option)
		spec.jumpMax = spec.jumpMax * (option.jumpMax or 1)
		spec.jumpChargeRate = spec.jumpChargeRate * (option.jumpChargeRate or 1)
		spec.massScale = spec.massScale + (option.mass or 0)
		return spec
	end,
	showDepth = 450,
	options = {
		{
			name = "Basic",
			cost = 0,
		},
		{
			name = "Volume\nMk 1",
			textLine = 2,
			cost = 800,
			depth = 700,
			showDepth = 450,
			jumpMax = 1.5,
			mass = 0.1,
		},
		{
			name = "Rate\nMk 1",
			textLine = 2,
			cost = 800,
			depth = 700,
			showDepth = 450,
			jumpChargeRate = 1.2,
			mass = 0.3,
		},
		{
			name = "Volume\nMk 2",
			textLine = 2,
			cost = 1000,
			depth = 900,
			showDepth = 700,
			jumpMax = 2,
			jumpChargeRate = 0.8,
			mass = 0.15,
		},
		{
			name = "Rate\nMk 2",
			textLine = 2,
			cost = 1400,
			depth = 900,
			showDepth = 700,
			jumpMax = 0.75,
			jumpChargeRate = 1.3,
			mass = 0.65,
		},
		{
			name = "Jumbo",
			cost = 2400,
			depth = 2000,
			showDepth = 1200,
			jumpMax = 2.5,
			jumpChargeRate = 1,
			mass = 1.5,
		},
	},
}

return data
