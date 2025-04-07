
local data = {
	humanName = "Boost\nAngle",
	textLine = 2,
	applyFunc = function (spec, option)
		spec.jumpVector = option.jumpVector or spec.jumpVector
		spec.jumpForce = spec.jumpForce * (option.jumpForce or 1)
		spec.jumpAngleName = option.name
		spec.massScale = spec.massScale + (option.mass or 0)
		return spec
	end,
	showDepth = Global.DEPTHS[4],
	options = {
		{
			name = "Up",
			cost = 0,
		},
		{
			name = "Front",
			cost = 400,
			depth = Global.DEPTHS[4],
			jumpVector = {1, 0},
			jumpForce = 0.8,
			mass = 0.02,
		},
		{
			name = "Angled",
			cost = 600,
			depth = Global.DEPTHS[5],
			jumpForce = 0.9,
			jumpVector = {math.sqrt(2), -math.sqrt(2)},
			mass = 0.1,
		},
		{
			name = "Adapt",
			cost = 1200,
			depth = Global.DEPTHS[6],
			jumpVector = "adaptive",
			jumpForce = 1.2,
			mass = 0.15,
		},
		{
			name = "Down",
			cost = 300,
			depth = Global.DEPTHS[6],
			jumpVector = {0, 1},
			jumpForce = 1.5,
			mass = 0.05,
		},
	},
}

return data
