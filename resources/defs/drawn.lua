
local names = util.GetDefDirList("resources/images/drawn", "png")
local data = {}

local scale = {
	cool_wheel = 0.06,
	coin = 0.9,
	gem_1 = 1.1,
	treasure_chest_small = 1.2,
	treasure_chest = 1.8,
	portal_furled = 0.25,
	portal_unfurled = 0.25,
}

for i = 1, #names do
	data[#data + 1] = {
		name = names[i],
		file = "resources/images/drawn/" .. names[i] .. ".png",
		form = "image",
		xScale = scale[names[i]] or 0.5,
		yScale = scale[names[i]] or 0.5,
		xOffset = 0.5,
		yOffset = 0.5,
	}
end

return data
