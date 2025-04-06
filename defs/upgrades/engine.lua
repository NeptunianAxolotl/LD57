
local data = {
	humanName = "Engine",
	textLine = 1,
	applyFunc = function (spec, option)
		spec.motorMaxSpeed = spec.motorMaxSpeed * (option.speed or 1)
		spec.motorTorque = spec.motorTorque * (option.torque or 1)
		spec.accelMult = spec.accelMult * (option.accelMult or 1)
		spec.wheelDownforce = spec.wheelDownforce * (option.downMult or 1)
		spec.massScale = spec.massScale + (option.mass or 0)
		return spec
	end,
	showDepth = 100,
	options = {
		{
			name = "Basic",
			cost = 0,
		},
		{
			name = "Speedy",
			cost = 400,
			depth = 100,
			speed = 2,
			accelMult = 1.8,
			torque = 1.1,
			mass = 0.18,
			downMult = 1.1,
		},
		{
			name = "Power",
			cost = 500,
			depth = 250,
			speed = 0.9,
			torque = 1.6,
			accelMult = 4,
			mass = 0.28,
			downMult = 1.3,
		},
		{
			name = "Super\nSpeedy",
			textLine = 2,
			cost = 1000,
			depth = 700,
			speed = 10,
			torque = 1.8,
			accelMult = 2.4,
			mass = 0.35,
			downMult = 1.2,
		},
		{
			name = "Super\nPower",
			textLine = 2,
			cost = 2200,
			depth = 2000,
			speed = 3,
			torque = 3,
			accelMult = 8,
			mass = 0.5,
			downMult = 1.5,
		},
		{
			name = "Mega\nPower",
			textLine = 2,
			cost = 3600,
			depth = 2000,
			speed = 6,
			torque = 4.2,
			accelMult = 12,
			mass = 1.1,
			downMult = 2.2,
		},
	},
}

return data
