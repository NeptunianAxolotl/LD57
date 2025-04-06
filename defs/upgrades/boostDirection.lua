
local data = {
	humanName = "Boost\nAngle",
	textLine = 2,
	applyFunc = function (spec, option)
		spec.jumpVector = option.jumpVector or spec.jumpVector
		spec.jumpForce = spec.jumpForce * (option.jumpForce or 1)
		spec.jumpAngleName = option.name
		return spec
	end,
	showDepth = 700,
	options = {
		{
			name = "Up",
			cost = 0,
		},
		{
			name = "Front",
			cost = 400,
			depth = 700,
			showDepth = 700,
			jumpVector = {1, 0},
			jumpForce = 0.8,
		},
		{
			name = "Angled",
			cost = 600,
			depth = 1200,
			showDepth = 700,
			jumpForce = 0.9,
			jumpVector = {math.sqrt(2), -math.sqrt(2)},
		},
		{
			name = "Down",
			cost = 200,
			depth = 1200,
			showDepth = 700,
			jumpVector = {0, 1},
			jumpForce = 1.5,
		},
	},
}

return data
