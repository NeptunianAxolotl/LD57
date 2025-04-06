
local data = {
	applyFunc = function (spec, option)
		spec.motorMaxSpeed = spec.motorMaxSpeed * (option.speed or 1)
		spec.torque = spec.motorTorque * (option.torque or 1)
		spec.accelMult = spec.accelMult * (option.accelMult or 1)
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
			name = "improved",
			cost = 0,
			depth = 0,
			speed = 1,
			torque = 1.2,
			accelMult = 1.5,
			mass = 0.15,
		},
		{
			name = "speed",
			cost = 0,
			depth = 0,
			speed = 2,
			accelMult = 1.4,
			torque = 0.9,
			mass = 0.18,
		},
		{
			name = "accel",
			cost = 0,
			depth = 0,
			speed = 0.9,
			torque = 1.6,
			accelMult = 4,
			mass = 0.25,
		},
		{
			name = "speed+",
			cost = 0,
			depth = 0,
			speed = 10,
			torque = 1.2,
			accelMult = 1.8,
			mass = 0.38,
		},
		{
			name = "accel+",
			cost = 0,
			depth = 0,
			speed = 2,
			torque = 2.8,
			accelMult = 8,
			mass = 0.45,
		},
	},
}

return data
