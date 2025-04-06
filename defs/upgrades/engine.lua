
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
			name = "Speed\nMk 1",
			textLine = 2,
			cost = 800,
			depth = 100,
			showDepth = 100,
			speed = 2,
			accelMult = 1.8,
			torque = 0.9,
			mass = 0.18,
			downMult = 1.1,
		},
		{
			name = "Accel\nMk 1",
			textLine = 2,
			cost = 1100,
			depth = 400,
			showDepth = 100,
			speed = 0.9,
			torque = 1.6,
			accelMult = 4,
			mass = 0.28,
			downMult = 1.3,
		},
		{
			name = "Speed\nMk 2",
			textLine = 2,
			cost = 1200,
			depth = 700,
			showDepth = 450,
			speed = 10,
			torque = 1.8,
			accelMult = 2.4,
			mass = 0.35,
			downMult = 1.2,
		},
		{
			name = "Accel\nMk 2",
			textLine = 2,
			cost = 2200,
			depth = 2000,
			showDepth = 1200,
			speed = 3,
			torque = 3,
			accelMult = 8,
			mass = 0.5,
			downMult = 1.5,
		},
		{
			name = "Mega\nAccel",
			textLine = 2,
			cost = 3600,
			depth = 2000,
			showDepth = 1200,
			speed = 6,
			torque = 4.2,
			accelMult = 12,
			mass = 1.1,
			downMult = 2.2,
		},
	},
}

return data
