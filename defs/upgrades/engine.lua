
local data = {
	applyFunc = function (spec, option)
		spec.motorMaxSpeed = spec.motorMaxSpeed * (option.speed or 1)
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
			name = "speedy",
			cost = 150,
			speed = 2.5,
			torque = 1.5,
			mass = 0.5,
			depth = 20,
		},
		{
			name = "powerful",
			cost = 100,
			speed = 60,
			torque = 100,
			accelMult = 200,
			mass = 1.2,
			depth = 0,
		},
	},
}

return data
