
local data = {
	humanName = "Engine",
	textLine = 1,
	applyFunc = function (spec, option)
		spec.motorMaxSpeed = spec.motorMaxSpeed * (option.speed or 1)
		spec.motorTorque = spec.motorTorque * (option.torque or 1)
		spec.accelMult = spec.accelMult * (option.accelMult or 1)
		spec.wheelDownforce = spec.wheelDownforce * (option.downMult or 1)
		spec.topSpeedAccel = spec.topSpeedAccel * (option.topSpeedAccel or 1)
		
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
			name = "Speed+",
			cost = 350,
			depth = Global.DEPTHS[1],
			speed = 2.5,
			accelMult = 1,
			torque = 0.9,
			topSpeedAccel = 1.2,
			mass = 0.06,
			downMult = 1.8,
		},
		{
			name = "Power+",
			cost = 500,
			depth = Global.DEPTHS[2],
			speed = 1,
			topSpeedAccel = 0.8,
			torque = 1.6,
			accelMult = 2,
			mass = 0.28,
			downMult = 1.5,
		},
		{
			name = "Super\nSpeed+",
			textLine = 2,
			cost = 800,
			depth = Global.DEPTHS[3],
			speed = 10,
			topSpeedAccel = 1.45,
			torque = 1.2,
			accelMult = 1.4,
			mass = 0.35,
			downMult = 1.6,
		},
		{
			name = "Super\nPower+",
			textLine = 2,
			cost = 1200,
			depth = Global.DEPTHS[4],
			speed = 6,
			topSpeedAccel = 1,
			torque = 2.2,
			accelMult = 3.2,
			mass = 0.5,
			downMult = 1.8,
		},
		{
			name = "Mega\nSpeed+",
			textLine = 2,
			cost = 2600,
			depth = Global.DEPTHS[5],
			speed = 100,
			topSpeedAccel = 1.8,
			torque = 2,
			accelMult = 2,
			mass = 0.3,
			downMult = 2.5,
		},
		{
			name = "Mega\nPower+",
			textLine = 2,
			cost = 3000,
			depth = Global.DEPTHS[6],
			speed = 20,
			topSpeedAccel = 1.15,
			torque = 6,
			accelMult = 8,
			mass = 0.7,
			downMult = 2.5,
		},
	},
}

return data
