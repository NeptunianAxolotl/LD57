
	--scale = 50,
	--width = 2.1,
	--height = 1.4,
	--hullFriction = 0.65,
	--hullBounce = 0.05,
	--wheelOffX = 0.82,
	--wheelOffY = 0.6,
	
	
local data = {
	applyFunc = function (spec, option)
		spec.width = option.width or spec.width
		spec.height = option.height or spec.height
		spec.wheelOffX = option.wheelOffX or spec.wheelOffX
		spec.wheelOffY = option.wheelOffY or spec.wheelOffY
		spec.wheelRadius = option.wheelRadius or spec.wheelRadius
		spec.wheelCount = option.wheelCount or spec.wheelCount
		spec.wheelMass = option.wheelMass or spec.wheelMass
		
		spec.torque = spec.motorTorque * (option.torque or 1)
		spec.motorMaxSpeed = spec.motorMaxSpeed * (option.speed or 1)
		spec.jumpForce = spec.jumpForce * (option.jumpForce or 1)
		spec.hullRotateMult     = spec.hullRotateMult     * (option.hullRotateMult or 1)
		spec.hydrofoilForceMult = spec.hydrofoilForceMult * (option.hyroMult or 1)
		spec.jumpMax = spec.jumpMax * (option.jumpMaxMult or 1)
		spec.jumpChargeRate = spec.jumpChargeRate * (option.jumpChargeRate or 1)
		spec.airSeconds = spec.airSeconds * (option.airMult or 1)
		spec.massScale = spec.massScale + (option.mass or 0)
		
		return spec
	end,
	showDepth = 200,
	options = {
		{
			name = "basic",
			cost = 0,
		},
		{
			name = "flatmobile",
			cost = 0,
			depth = 0,
			width = 3.5,
			height = 0.75,
			wheelOffX = 1.5,
			wheelOffY = 0.2,
			wheelRadius = 0.65,
			speed = 1.1,
			wheelMass = 0.018,
			hullRotateMult = 1.4,
			hydrofoilForceMult = 0.95,
			mass = -1,
		},
		{
			name = "monster",
			cost = 0,
			depth = 0,
			width = 2.6,
			height = 1.4,
			wheelOffX = 1.2,
			wheelOffY = 0.1,
			wheelRadius = 0.95,
			wheelMass = 0.03,
			torque = 1.2,
			hullRotateMult = 1.1,
			hydrofoilForceMult = 1.1,
			mass = 2,
		},
		{
			name = "light",
			cost = 0,
			depth = 0,
			width = 1.8,
			height = 1,
			wheelOffX = 0.8,
			wheelOffY = 0.5,
			wheelMass = 0.01,
			wheelRadius = 0.45,
			hullRotateMult = 0.6,
			hydrofoilForceMult = 0.6,
			jumpForce = 0.9,
			mass = -6,
		},
		{
			name = "semi",
			cost = 0,
			depth = 0,
			width = 3.6,
			height = 2.2,
			wheelOffX = 1.6,
			wheelOffY = 0.8,
			wheelRadius = 0.72,
			wheelMass = 0.02,
			wheelCount = 3,
			torque = 1.3,
			hydrofoilForceMult = 1.25,
			hullRotateMult = 1.2,
			jumpMax = 1.5,
			jumpChargeRate = 1.2,
			jumpForce = 1.25,
			airMult = 1.2,
			mass = 7,
		},
	},
}

return data
