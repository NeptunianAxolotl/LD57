
local data = {
	humanName = "Control",
	textLine = 1,
	applyFunc = function (spec, option)
		spec.reactionControl = option.reactionControl or spec.reactionControl
		spec.wheelBounce = option.wheelBounce or spec.wheelBounce
		spec.hullBounce = option.hullBounce or spec.hullBounce
		spec.wheelDampen = option.wheelDampen or spec.wheelDampen
		spec.wheelFreq = option.wheelFreq or spec.wheelFreq
		spec.wheelFriction = option.wheelFriction or spec.wheelFriction
		spec.angularDampen = option.angularDampen or spec.angularDampen
		
		spec.wheelImage = option.wheelImage or spec.wheelImage
		spec.hullRotateMult     = spec.hullRotateMult     * (option.hullRotateMult or 1)
		spec.massScale = spec.massScale + (option.mass or 0)
		return spec
	end,
	showDepth = Global.DEPTHS[2],
	options = {
		{
			name = "Basic",
			hullRotateMult = 1.2,
			cost = 0,
		},
		{
			name = "Stable+",
			cost = 200,
			depth = Global.DEPTHS[2],
			hullRotateMult = 1.5,
			wheelFriction = 1,
			reactionControl = 0.8,
			wheelDampen = 5,
			angularDampen = 1.2,
			mass = 0.1,
		},
		{
			name = "Spin+",
			cost = 350,
			depth = Global.DEPTHS[3],
			hullRotateMult = 2.5,
			reactionControl = 0.4,
			mass = 0.08,
		},
		{
			name = "Super\nStable+",
			textLine = 2,
			cost = 600,
			depth = Global.DEPTHS[4],
			hullRotateMult = 1.8,
			wheelFriction = 1.5,
			reactionControl = 0.9,
			wheelDampen = 5,
			wheelFreq = 16,
			angularDampen = 1.6,
			mass = 0.2,
		},
		{
			name = "Super\nSpin+",
			textLine = 2,
			cost = 900,
			depth = Global.DEPTHS[5],
			hullRotateMult = 4,
			reactionControl = 0.75,
			angularDampen = 1.1,
			mass = 0.22,
		},
		{
			name = "Ultra\nStable+",
			textLine = 2,
			cost = 2000,
			depth = Global.DEPTHS[6],
			hullRotateMult = 2.5,
			wheelFriction = 1.5,
			reactionControl = 1,
			wheelDampen = 5,
			wheelFreq = 16,
			angularDampen = 2,
			mass = 0.25,
		},
		{
			name = "Ultra\nSpin+",
			textLine = 2,
			cost = 2500,
			depth = Global.DEPTHS[7],
			hullRotateMult = 7,
			reactionControl = 0.8,
			angularDampen = 1.2,
			mass = 0.3,
		},
		--{
		--	name = "Bounce",
		--	cost = 500,
		--	depth = Global.DEPTHS[6],
		--	reactionControl = 0.4,
		--	wheelBounce = 2,
		--	hullBounce = 2,
		--	wheelDampen = 0.1,
		--	wheelFreq = 25,
		--	mass = 0.05,
		--},
	},
}

return data
