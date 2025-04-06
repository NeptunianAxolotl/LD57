
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
	showDepth = 250,
	options = {
		{
			name = "Basic",
			cost = 0,
		},
		{
			name = "Control",
			cost = 200,
			depth = 250,
			hullRotateMult = 1.4,
			wheelFriction = 1,
			reactionControl = 0.4,
			wheelDampen = 5,
			mass = 0.1,
		},
		{
			name = "Rotate",
			cost = 350,
			depth = 250,
			hullRotateMult = 2.2,
			mass = 0.08,
		},
		{
			name = "Control\nMk 2",
			textLine = 2,
			cost = 700,
			depth = 450,
			hullRotateMult = 1.9,
			wheelFriction = 1.5,
			reactionControl = 0.7,
			wheelDampen = 5,
			wheelFreq = 16,
			mass = 0.2,
		},
		{
			name = "Rotate\nMk 2",
			textLine = 2,
			cost = 900,
			depth = 700,
			hullRotateMult = 3.8,
			reactionControl = 0.35,
			mass = 0.22,
		},
		--{
		--	name = "Bounce",
		--	cost = 900,
		--	depth = 700,
		--	reactionControl = 0.25,
		--	wheelBounce = 0.9,
		--	hullBounce = 0.9,
		--	wheelDampen = 0.1,
		--	wheelFreq = 25,
		--	mass = 0.05,
		--},
		--{
		--	name = "Bounce\nMk 2",
		--	textLine = 2,
		--	cost = 1800,
		--	depth = 1100,
		--	reactionControl = 0.25,
		--	wheelBounce = 1.5,
		--	hullBounce = 1.5,
		--	wheelDampen = 0.01,
		--	wheelFreq = 60,
		--	mass = 0.1,
		--},
	},
}

return data
