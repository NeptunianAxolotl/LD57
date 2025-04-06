
local data = {
	applyFunc = function (spec, option)
		spec.jumpVector = option.jumpVector or spec.jumpVector
		spec.jumpForce = spec.jumpForce * (option.jumpForce or 1)
		return spec
	end,
	showDepth = 700,
	options = {
		{
			name = "basic",
			cost = 0,
		},
		{
			name = "front",
			cost = 0,
			depth = 0,
			jumpVector = {1, 0},
			jumpForce = 0.8,
		},
		{
			name = "diag",
			cost = 0,
			depth = 0,
			jumpForce = 0.9,
			jumpVector = {math.sqrt(2), -math.sqrt(2)},
		},
		{
			name = "down",
			cost = 0,
			depth = 0,
			jumpVector = {0, 1},
			jumpForce = 1.5,
		},
	},
}

return data
