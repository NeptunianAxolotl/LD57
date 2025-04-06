
local data = {
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
	options = {
		{
			name = "basic",
			cost = 0,
		},
		{
			name = "bounce",
			cost = 0,
			depth = 0,
			reactionControl = 0.25,
			wheelBounce = 0.9,
			hullBounce = 0.9,
			wheelDampen = 1,
			wheelFreq = 25,
			mass = 0,
		},
		{
			name = "control",
			cost = 0,
			depth = 0,
			hullRotateMult = 1.3,
			wheelFriction = 1,
			reactionControl = 0.4,
			wheelDampen = 5,
			mass = 0.06,
		},
		{
			name = "control+",
			cost = 0,
			depth = 0,
			hullRotateMult = 1.7,
			wheelFriction = 1.5,
			reactionControl = 0.6,
			wheelDampen = 5,
			wheelFreq = 16,
			mass = 0.1,
		},
	},
}

return data
