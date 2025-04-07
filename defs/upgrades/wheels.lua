
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
			name = "Control+",
			cost = 200,
			depth = Global.DEPTHS[2],
			hullRotateMult = 1.2,
			wheelFriction = 1,
			reactionControl = 0.45,
			wheelDampen = 5,
			mass = 0.1,
		},
		{
			name = "Rotate+",
			cost = 350,
			depth = Global.DEPTHS[3],
			hullRotateMult = 2.2,
			mass = 0.08,
		},
		{
			name = "Super\nControl+",
			textLine = 2,
			cost = 600,
			depth = Global.DEPTHS[4],
			hullRotateMult = 1.8,
			wheelFriction = 1.5,
			reactionControl = 0.8,
			wheelDampen = 5,
			wheelFreq = 16,
			mass = 0.2,
		},
		{
			name = "Super\nRotate+",
			textLine = 2,
			cost = 900,
			depth = Global.DEPTHS[5],
			hullRotateMult = 3.2,
			reactionControl = 0.35,
			mass = 0.22,
		},
		{
			name = "Ultra\nControl+",
			textLine = 2,
			cost = 2000,
			depth = Global.DEPTHS[6],
			hullRotateMult = 2,
			wheelFriction = 1.5,
			reactionControl = 1.2,
			wheelDampen = 5,
			wheelFreq = 16,
			mass = 0.25,
		},
		{
			name = "Ultra\nRotate+",
			textLine = 2,
			cost = 2500,
			depth = Global.DEPTHS[7],
			hullRotateMult = 5.5,
			reactionControl = 0.2,
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
