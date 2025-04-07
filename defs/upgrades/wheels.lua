
local data = {
	humanName = "Wheels",
	textLine = 1,
	applyFunc = function (spec, option)
		spec.reactionControl = option.reactionControl or spec.reactionControl
		spec.wheelBounce = option.wheelBounce or spec.wheelBounce
		spec.hullBounce = option.hullBounce or spec.hullBounce
		spec.wheelDampen = option.wheelDampen or spec.wheelDampen
		spec.wheelFreq = option.wheelFreq or spec.wheelFreq
		spec.wheelFriction = option.wheelFriction or spec.wheelFriction
		
		spec.hullRotateMult     = spec.hullRotateMult     * (option.hullRotateMult or 1)
		spec.massScale = spec.massScale + (option.mass or 0)
		return spec
	end,
	showDepth = Global.DEPTHS[2],
	options = {
		{
			name = "Basic",
			cost = 0,
		},
		{
			name = "Control",
			cost = 200,
			depth = Global.DEPTHS[2],
			hullRotateMult = 1.4,
			wheelFriction = 1,
			reactionControl = 0.4,
			wheelDampen = 5,
			mass = 0.1,
		},
		{
			name = "Rotate",
			cost = 350,
			depth = Global.DEPTHS[3],
			hullRotateMult = 2.2,
			mass = 0.08,
		},
		{
			name = "Super\nControl",
			textLine = 2,
			cost = 700,
			depth = Global.DEPTHS[4],
			hullRotateMult = 1.9,
			wheelFriction = 1.5,
			reactionControl = 0.7,
			wheelDampen = 5,
			wheelFreq = 16,
			mass = 0.2,
		},
		{
			name = "Super\nRotate",
			textLine = 2,
			cost = 1000,
			depth = Global.DEPTHS[4],
			hullRotateMult = 3.8,
			reactionControl = 0.35,
			mass = 0.22,
		},
		{
			name = "Ultra\nControl",
			textLine = 2,
			cost = 1500,
			depth = Global.DEPTHS[5],
			hullRotateMult = 1.9,
			wheelFriction = 1.5,
			reactionControl = 0.99,
			wheelDampen = 5,
			wheelFreq = 16,
			mass = 0.25,
		},
		{
			name = "Bounce",
			cost = 500,
			depth = Global.DEPTHS[6],
			reactionControl = 0.4,
			wheelBounce = 2,
			hullBounce = 2,
			wheelDampen = 0.1,
			wheelFreq = 25,
			mass = 0.05,
		},
	},
}

return data
