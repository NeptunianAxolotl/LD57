
local data = {
	applyFunc = function (spec, option)
		spec.hullRotateMult     = spec.hullRotateMult     * (0.5 + (option.power or 0) / (1 + (option.power or 0)))
		spec.baseDrag           = spec.baseDrag           / ((option.dragDown or 0) + 1)
		spec.hydrofoilForceMult = spec.hydrofoilForceMult * ((option.power or 0)*0.1 + 1) * (option.hydroMult or 1)
		spec.hyroDragReduce     = spec.hyroDragReduce + (1 - spec.hyroDragReduce) * (option.dragDown or 0) / (0.6 + (option.dragDown or 0))
		spec.hydroPerpEffect    = spec.hydroPerpEffect + (option.power or 0) / (1 + (option.power or 0))
		spec.massScale = spec.massScale + (option.power or 0)*0.33 + (option.dragDown or 0)*0.33
		return spec
	end,
	options = {
		{
			name = "basic",
			cost = 0,
		},
		{
			name = "drag",
			cost = 0,
			depth = 0,
			dragDown = 0.6,
			hydroMult = 0.8,
		},
		{
			name = "drag+",
			cost = 0,
			depth = 0,
			dragDown = 1,
			hydroMult = 0.6,
		},
		{
			name = "lift",
			cost = 0,
			depth = 0,
			power = 0.45,
			dragDown = -0.05,
		},
		{
			name = "lift+",
			cost = 0,
			depth = 0,
			power = 0.9,
			dragDown = -0.2,
			hydroMult = 1.05,
		},
	},
}

return data
