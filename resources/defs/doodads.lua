
local names = util.GetDefDirList("resources/images/doodads", "png")
local data = {}

local scale = {
	shell1 = 0.6,
	shell2 = 0.6,
	shell3 = 0.6,
	shell4 = 0.6,
	starfish = 0.7,
}

for i = 1, #names do
	data[#data + 1] = {
		name = names[i],
		file = "resources/images/doodads/" .. names[i] .. ".png",
		form = "image",
		xScale = scale[name] or 0.8,
		yScale = scale[name] or 0.8,
		xOffset = 0.5,
		yOffset = 0.75,
	}
end

return data
