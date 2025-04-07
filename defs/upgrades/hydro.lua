
local data = {
	humanName = "Fins",
	textLine = 1,
	applyFunc = function (spec, option)
		spec.hullRotateMult     = spec.hullRotateMult     * (1 + (option.power or 0) / (1 + (option.power or 0)))
		spec.baseDrag           = spec.baseDrag           / ((option.dragDown or 0) + 1)
		spec.hydrofoilForceMult = spec.hydrofoilForceMult * ((option.power or 0)*0.1 + 1) * (option.hydroMult or 1)
		spec.hyroDragReduce     = spec.hyroDragReduce + (1 - spec.hyroDragReduce) * (option.dragDown or 0) / (0.6 + (option.dragDown or 0))
		spec.hydroPerpEffect    = spec.hydroPerpEffect + (option.power or 0) / (1 + (option.power or 0))
		spec.massScale = spec.massScale + (option.power or 0)*0.33 + (option.dragDown or 0)*0.3 + (option.mass or 0)
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
			cost = 400,
			depth = 450,
			dragDown = 0.7,
			hydroMult = 0.75,
		},
		{
			name = "Glide\nMk 1",
			textLine = 2,
			cost = 500,
			depth = 450,
			power = 0.7,
			dragDown = -0.1,
		},
		{
			name = "Sleek\nMk 2",
			textLine = 2,
			cost = 1200,
			depth = 700,
			dragDown = 1,
			hydroMult = 0.5,
		},
		{
			name = "Glide\nMk 2",
			textLine = 2,
			cost = 1400,
			depth = 700,
			power = 0.95,
			dragDown = -0.15,
			hydroMult = 1.05,
		},
		{
			name = "Sleek\nMk 3",
			textLine = 2,
			cost = 1800,
			depth = 1400,
			dragDown = 3,
			hydroMult = 0.15,
		},
		{
			name = "Glide\nMk 3",
			textLine = 2,
			cost = 2000,
			depth = 1400,
			power = 1.4,
			dragDown = -0.2,
			hydroMult = 1.1,
		},
		{
			name = "Ultra Sleek",
			textLine = 2,
			cost = 1800,
			depth = 1400,
			dragDown = 15,
			hydroMult = 0.05,
			mass = -2.05, -- counteract autocalculated
		},
	},
}

return data
