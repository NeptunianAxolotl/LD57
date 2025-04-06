
local data = {
	humanName = "Fins",
	textLine = 1,
	applyFunc = function (spec, option)
		spec.hullRotateMult     = spec.hullRotateMult     * (1 + (option.power or 0) / (1 + (option.power or 0)))
		spec.baseDrag           = spec.baseDrag           / ((option.dragDown or 0) + 1)
		spec.hydrofoilForceMult = spec.hydrofoilForceMult * ((option.power or 0)*0.1 + 1) * (option.hydroMult or 1)
		spec.hyroDragReduce     = spec.hyroDragReduce + (1 - spec.hyroDragReduce) * (option.dragDown or 0) / (0.6 + (option.dragDown or 0))
		spec.hydroPerpEffect    = spec.hydroPerpEffect + (option.power or 0) / (1 + (option.power or 0))
		spec.massScale = spec.massScale + (option.power or 0)*0.33 + (option.dragDown or 0)*0.3
		return spec
	end,
	showDepth = 450,
	options = {
		{
			name = "None",
			cost = 0,
		},
		{
			name = "Sleek\nMk 1",
			textLine = 2,
			cost = 800,
			depth = 700,
			showDepth = 450,
			dragDown = 0.6,
			hydroMult = 0.8,
		},
		{
			name = "Lift\nMk 1",
			textLine = 2,
			cost = 800,
			depth = 700,
			showDepth = 450,
			power = 0.45,
			dragDown = -0.05,
		},
		{
			name = "Sleek\nMk 2",
			textLine = 2,
			cost = 1400,
			depth = 900,
			showDepth = 700,
			dragDown = 1,
			hydroMult = 0.6,
		},
		{
			name = "Lift\nMk 2",
			textLine = 2,
			cost = 1400,
			depth = 900,
			showDepth = 700,
			power = 0.9,
			dragDown = -0.2,
			hydroMult = 1.05,
		},
		{
			name = "Sleek\nMk 3",
			textLine = 2,
			cost = 2400,
			depth = 2000,
			showDepth = 1200,
			dragDown = 2.5,
			hydroMult = 0.2,
		},
		{
			name = "Lift\nMk 3",
			textLine = 2,
			cost = 2400,
			depth = 2000,
			showDepth = 1200,
			power = 1.25,
			dragDown = -0.35,
			hydroMult = 1.15,
		},
	},
}

return data
