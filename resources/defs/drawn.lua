
local names = util.GetDefDirList("resources/images/food", "png")
local data = {}

for i = 1, #names do
	data[#data + 1] = {
		name = names[i],
		file = "resources/images/drawn/" .. names[i] .. ".png",
		form = "image",
		xScale = 10,
		yScale = 10,
		xOffset = 0.5,
		yOffset = 0.5,
	}
end

return data
