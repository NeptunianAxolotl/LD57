
local data = {
	applyFunc = function (spec, option)
		spec.motorMaxSpeed = spec.motorMaxSpeed * (option.speed or 1)
		spec.hullRotateMult = spec.hullRotateMult * (option.hullRotate or 1)
		spec.torque = spec.motorTorque * (option.torque or 1)
		spec.accelMult = spec.accelMult * (option.accelMult or 1)
		spec.massScale = spec.massScale + (option.mass or 0)
		return spec
	end,
	options = {
		{
			name = "basic",
			cost = 0,
		},
		{
			name = "other",
			cost = 150,
			speed = 2.5,
			torque = 1.5,
			mass = 0.5,
			depth = 300,
		},
	},
}

return data
