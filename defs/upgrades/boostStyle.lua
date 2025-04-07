
local data = {
	humanName = "Boost\nType",
	textLine = 2,
	applyFunc = function (spec, option)
		spec.jumpMax = spec.jumpMax * (option.jumpMaxMult or 1)
		spec.jumpChargeRate = spec.jumpChargeRate * (option.chargeMult or 1)
		spec.jumpUseRate = option.jumpUseRate or spec.jumpUseRate
		spec.jumpPropRequired = option.jumpPropRequired or spec.jumpPropRequired
		spec.jumpForce = spec.jumpForce * (option.jumpForce or 1)
		spec.massScale = spec.massScale + (option.mass or 0)
		return spec
	end,
	showDepth = Global.DEPTHS[4],
	options = {
		{
			name = "Burst",
			cost = 0,
		},
		{
			name = "Steady",
			cost = 200,
			depth = Global.DEPTHS[4],
			jumpUseRate = 5,
			jumpMaxMult = 1.25,
			jumpPropRequired = 0,
			jumpForce = 1.4,
			mass = 0.1
		},
		{
			name = "Quick",
			cost = 300,
			depth = Global.DEPTHS[4],
			jumpUseRate = 10,
			jumpMaxMult = 0.75,
			jumpForce = 1.5,
			chargeMult = 1.1,
			jumpPropRequired = 0.5,
			mass = 0.35
		},
		{
			name = "Super\nBurst",
			textLine = 2,
			cost = 600,
			depth = Global.DEPTHS[5],
			jumpMaxMult = 1.2,
			chargeMult = 0.5,
			jumpForce = 1.6,
			mass = 0.5
		},
		{
			name = "Super\nSteady",
			textLine = 2,
			cost = 200,
			depth = Global.DEPTHS[6],
			jumpUseRate = 3,
			jumpMaxMult = 1.25,
			chargeMult = 0.75,
			jumpPropRequired = 0,
			jumpForce = 2.1,
			mass = 0.65
		},
	},
}

return data
