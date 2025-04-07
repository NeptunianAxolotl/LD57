
local names = util.GetDefDirList("resources/images/doodads", "png")
local newDoodads = {}
local doodadList = {}

local layer = {
	shell1 = 2,
	shell2 = 2,
	shell3 = 2,
	shell4 = 2,
	starfish = 2,
}
local scaleRand = {
	seaweed = 0.8,
	fish2 = 0.25,
	fish1 = 0.2,
	fish3 = 0.18,
}

for i = 1, #names do
	local name = names[i]
	newDoodads[name] = {
		name = name,
		image = name,
		drawLayer = layer[name] or -20,
		scaleRand = scaleRand[name] or 0.5,
	}
	doodadList[#doodadList + 1] = name
end
table.sort(doodadList)

local data = {
	doodadList = doodadList,
	defs = newDoodads,
}

return data
