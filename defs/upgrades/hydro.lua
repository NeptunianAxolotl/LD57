
local data = {
	humanName = "Fins",
	textLine = 1,
	applyFunc = function (spec, option)
		spec.hullRotateMult     = spec.hullRotateMult     * (1 + (option.power or 0) / (1 + (option.power or 0)))
		spec.baseDrag           = spec.baseDrag           / ((option.dragDown or 0) + 1)
		spec.hydrofoilForceMult = spec.hydrofoilForceMult * ((option.power or 0)*0.1 + 1) * (option.hydroMult or 1)
		spec.hyroDragReduce     = spec.hyroDragReduce + (1 - spec.hyroDragReduce) * (option.dragDown or 0) / (0.6 + (option.dragDown or 0))
		spec.hydroPerpEffect    = spec.hydroPerpEffect + (option.power or 0) / (2 + (option.power or 0))
		spec.massScale = spec.massScale + (option.power or 0)*0.33 + (option.dragDown or 0)*0.3 + (option.mass or 0)
		return spec
	end,
	showDepth = Global.DEPTHS[2],
	options = {
		{
			name = "None",
			cost = 0,
			dragDown = 0.2,
			hydroMult = 0.95,
		},
		{
			name = "Slick+",
			cost = 400,
			depth = Global.DEPTHS[2],
			dragDown = 0.7,
			hydroMult = 0.75,
		},
		{
			name = "Glide+",
			cost = 500,
			depth = Global.DEPTHS[3],
			power = 0.7,
			dragDown = -0.1,
		},
		{
			name = "Mega\nSlick+",
			textLine = 2,
			cost = 1200,
			depth = Global.DEPTHS[4],
			dragDown = 1,
			hydroMult = 0.5,
		},
		{
			name = "Mega\nGlide+",
			textLine = 2,
			cost = 1400,
			depth = Global.DEPTHS[4],
			power = 0.95,
			dragDown = -0.05,
			hydroMult = 1.05,
		},
		{
			name = "Ultra\nSlick+",
			textLine = 2,
			cost = 2800,
			depth = Global.DEPTHS[5],
			dragDown = 3,
			hydroMult = 0.15,
		},
		{
			name = "Ultra\nGlide+",
			textLine = 2,
			cost = 3500,
			depth = Global.DEPTHS[6],
			power = 1.6,
			dragDown = 0,
			hydroMult = 1.15,
		},
		{
			name = "Omega\nSlick+",
			textLine = 2,
			cost = 4000,
			depth = Global.DEPTHS[7],
			dragDown = 15,
			hydroMult = 0.05,
			mass = -2.05, -- counteract autocalculated
		},
	},
}

return data
