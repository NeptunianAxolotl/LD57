
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
	showDepth = Global.DEPTHS[1],
	options = {
		{
			name = "Basic",
			cost = 0,
		},
		{
			name = "Speed",
			cost = 400,
			depth = Global.DEPTHS[1],
			speed = 2,
			accelMult = 1.2,
			torque = 1.1,
			mass = 0.18,
			downMult = 1.2,
		},
		{
			name = "Power",
			cost = 600,
			depth = Global.DEPTHS[2],
			speed = 0.9,
			torque = 1.6,
			accelMult = 2,
			mass = 0.28,
			downMult = 1.2,
		},
		{
			name = "Super\nSpeed",
			textLine = 2,
			cost = 800,
			depth = Global.DEPTHS[3],
			speed = 10,
			torque = 1.4,
			accelMult = 1.8,
			mass = 0.35,
			downMult = 1.4,
		},
		{
			name = "Super\nPower",
			textLine = 2,
			cost = 1500,
			depth = Global.DEPTHS[4],
			speed = 3,
			torque = 2.2,
			accelMult = 2,
			mass = 0.5,
			downMult = 1.3,
		},
		{
			name = "Mega\nSpeed",
			textLine = 2,
			cost = 2200,
			depth = Global.DEPTHS[5],
			speed = 16,
			torque = 2.5,
			accelMult = 2,
			mass = 0.3,
			downMult = 3,
		},
		{
			name = "Mega\nPower",
			textLine = 2,
			cost = 3500,
			depth = Global.DEPTHS[6],
			speed = 5,
			torque = 5,
			accelMult = 8,
			mass = 0.7,
			downMult = 1.5,
		},
	},
}

return data
