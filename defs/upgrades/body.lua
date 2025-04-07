
	--scale = 50,
	--width = 2.1,
	--height = 1.4,
	--hullFriction = 0.65,
	--hullBounce = 0.05,
	--wheelOffX = 0.82,
	--wheelOffY = 0.6,
	
	
local data = {
	humanName = "Chassis",
	textLine = 1,
	applyFunc = function (spec, option)
		spec.width = option.width or spec.width
		spec.height = option.height or spec.height
		spec.wheelOffX = option.wheelOffX or spec.wheelOffX
		spec.wheelOffY = option.wheelOffY or spec.wheelOffY
		spec.wheelRadius = option.wheelRadius or spec.wheelRadius
		spec.wheelCount = option.wheelCount or spec.wheelCount
		spec.wheelMass = option.wheelMass or spec.wheelMass
		spec.pickupRadius = option.pickupRadius or spec.pickupRadius
		spec.ballastProp = option.ballastProp or spec.ballastProp
		spec.spawnOffset = option.spawnOffset
		spec.hydroRotation = option.hydroRotation
		
		spec.carImage = option.carImage or spec.carImage
		spec.carImageScale = option.carImageScale or spec.carImageScale
		spec.carImageOffset = option.carImageOffset or spec.carImageOffset

		spec.torque = spec.motorTorque * (option.torque or 1)
		spec.motorMaxSpeed = spec.motorMaxSpeed * (option.speed or 1)
		spec.jumpForce = spec.jumpForce * (option.jumpForce or 1)
		spec.hullRotateMult     = spec.hullRotateMult     * (option.hullRotateMult or 1)
		spec.hydrofoilForceMult = spec.hydrofoilForceMult * (option.hydrofoilForceMult or 1)
		spec.jumpMax = spec.jumpMax * (option.jumpMaxMult or 1)
		spec.jumpChargeRate = spec.jumpChargeRate * (option.jumpChargeRate or 1)
		spec.airSeconds = spec.airSeconds * (option.airMult or 1)
		spec.massScale = spec.massScale + (option.mass or 0)
		
		return spec
	end,
	showDepth = Global.DEPTHS[3],
	options = {
		{
			name = "Brick",
			cost = 0,
			spawnOffset = {0, -4},
		},
		{
			name = "Flat",
			cost = 400,
			carImage = "cool_car",
			carImageScale = 1.1,
			carImageOffset = {0, -9},
			depth = Global.DEPTHS[3],
			spawnOffset = {35, 10},
			pickupRadius = 60,
			width = 3.5,
			height = 0.63,
			wheelOffX = 1.5,
			wheelOffY = 0.22,
			wheelRadius = 0.65,
			speed = 1.1,
			wheelMass = 0.018,
			hullRotateMult = 1.4,
			hydrofoilForceMult = 0.95,
		},
		{
			name = "Monster",
			cost = 1000,
			depth = Global.DEPTHS[4],
			spawnOffset = {38, 0},
			pickupRadius = 60,
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
			name = "Mino",
			cost = 1200,
			depth = Global.DEPTHS[5],
			spawnOffset = {0, 6},
			pickupRadius = 45,
			width = 1.8,
			height = 1,
			wheelOffX = 0.8,
			wheelOffY = 0.5,
			wheelMass = 0.01,
			wheelRadius = 0.45,
			hullRotateMult = 0.6,
			hydrofoilForceMult = 0.6,
			jumpForce = 0.85,
			mass = -6,
		},
		{
			name = "Whale",
			cost = 2500,
			depth = Global.DEPTHS[6],
			spawnOffset = {50, -22},
			pickupRadius = 80,
			width = 3.6,
			height = 2.2,
			wheelOffX = 1.6,
			wheelOffY = 0.8,
			wheelRadius = 0.72,
			wheelMass = 0.02,
			wheelCount = 3,
			torque = 1.3,
			hydrofoilForceMult = 1.25,
			hullRotateMult = 1.6,
			jumpMax = 1.5,
			jumpChargeRate = 1.1,
			jumpForce = 1.25,
			airMult = 1.2,
			mass = 7,
		},
		{
			name = "Rocket",
			cost = 5000,
			depth = Global.DEPTHS[8],
			spawnOffset = {35, -46},
			pickupRadius = 60,
			width = 1.2,
			height = 3.2,
			wheelOffX = 0.5,
			wheelOffY = 1.5,
			wheelMass = 0.005,
			wheelRadius = 0.45,
			hullRotateMult = 2,
			hydrofoilForceMult = 1,
			jumpForce = 1.2,
			jumpChargeRate = 1.25,
			mass = -2,
			hydroRotation = math.pi/2,
			ballastProp = -0.4,
		},
	},
}

return data
