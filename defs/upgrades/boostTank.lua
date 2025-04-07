
local data = {
	humanName = "Boost\nSupply",
	textLine = 2,
	applyFunc = function (spec, option)
		spec.jumpMax = spec.jumpMax * (option.jumpMax or 1)
		spec.jumpChargeRate = spec.jumpChargeRate * (option.jumpChargeRate or 1)
		spec.massScale = spec.massScale + (option.mass or 0)
		return spec
	end,
	showDepth = Global.DEPTHS[3],
	options = {
		{
			name = "Basic",
			cost = 0,
		},
		{
			name = "Volume+",
			cost = 400,
			depth = Global.DEPTHS[3],
			jumpMax = 1.5,
			mass = 0.1,
		},
		{
			name = "Charge+",
			cost = 500,
			depth = Global.DEPTHS[3],
			jumpChargeRate = 1.2,
			mass = 0.3,
		},
		{
			name = "Super\nVolume+",
			textLine = 2,
			cost = 900,
			depth = Global.DEPTHS[4],
			jumpMax = 2,
			jumpChargeRate = 0.8,
			mass = 0.15,
		},
		{
			name = "Super\nCharge+",
			textLine = 2,
			cost = 1100,
			depth = Global.DEPTHS[5],
			jumpMax = 0.75,
			jumpChargeRate = 1.3,
			mass = 0.65,
		},
		{
			name = "Ultra\nVolume+",
			cost = 2000,
			depth = Global.DEPTHS[6],
			jumpMax = 2.5,
			jumpChargeRate = 1,
			mass = 1.4,
		},
		{
			name = "Ultra\nCharge+",
			cost = 4000,
			depth = Global.DEPTHS[6],
			jumpMax = 0.5,
			jumpChargeRate = 1.8,
			mass = 2,
		},
	},
}

return data
