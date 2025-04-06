
local data = {
	applyFunc = function (spec, option)
		spec.jumpMax = spec.jumpMax * (option.jumpMaxMult or 1)
		spec.jumpChargeRate = spec.jumpChargeRate * (option.chargeMult or 1)
		spec.jumpUseRate = option.jumpUseRate or spec.jumpUseRate
		spec.jumpPropRequired = option.jumpPropRequired or spec.jumpPropRequired
		spec.jumpForce = spec.jumpForce * (option.jumpForce or 1)
		spec.massScale = spec.massScale + (option.mass or 0)
		return spec
	end,
	options = {
		{
			name = "burst",
			cost = 0,
		},
		{
			name = "sustain",
			cost = 0,
			depth = 0,
			jumpUseRate = 5,
			jumpMaxMult = 1.25,
			jumpPropRequired = 0,
			jumpForce = 1.4,
			mass = 0.15
		},
		{
			name = "mix",
			cost = 0,
			depth = 0,
			jumpUseRate = 10,
			jumpMaxMult = 0.75,
			jumpForce = 1.4,
			chargeMult = 1.1,
			jumpPropRequired = 0.5,
			mass = 0.35
		},
		{
			name = "superburst",
			cost = 0,
			depth = 0,
			jumpMaxMult = 1.2,
			chargeMult = 0.5,
			jumpForce = 1.6,
			mass = 0.6
		},
	},
}

return data
