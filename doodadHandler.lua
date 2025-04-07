
local DoodadDefs = require("defs/doodadDefs")
local NewDoodad = require("objects/doodad")

local self = {}
local api = {}

function api.DrawDoodad(def, pos, rotation, scale)
	if def.image then
		Resources.DrawImage(imageOverride or def.image, pos[1], pos[2], rotation, alpha, scale)
	else
		love.graphics.setColor(0, 0, 0, 1)
		love.graphics.rectangle("fill", pos[1] - def.width/2, pos[2] - def.height/2, def.width, def.height)
	end
end

function api.AddDoodad(doodadType, pos, angle)
	local doodadDef = DoodadDefs.defs[doodadType]
	local newDoodad = NewDoodad(doodadDef, pos, angle)
	IterableMap.Add(self.doodadList, newDoodad)
	return newDoodad
end

function api.RemoveDoodads(pos)
	local count = IterableMap.Count(self.doodadList)
	IterableMap.ApplySelf(self.doodadList, "RemoveAtPos", pos)
	return count ~= IterableMap.Count(self.doodadList)
end

--------------------------------------------------
-- Level Editing
--------------------------------------------------

function api.MousePressed(x, y, button)
	if not self.world.GetEditMode() or button ~= 1 then
		return false
	end
	
	if self.editMode == "place" then
		local mousePos = self.world.GetMousePosition()
		self.recentDoodad = api.AddDoodad(DoodadDefs.doodadList[self.placeType], mousePos)
	elseif self.editMode == "delete" then
		local mousePos = self.world.GetMousePosition()
		self.recentDoodad = false
		api.RemoveDoodads(mousePos)
	end
end

function api.KeyPressed(key, scancode, isRepeat)
	if not self.world.GetEditMode() then
		return false
	end
	local index = tonumber(string.sub(key, 3, 3))
	if index == 0 then
		index = 10
	end
	if index then
		if DoodadDefs.doodadList[index] then
			self.editMode = "place"
			self.placeType = index
		end
	elseif key == "kp+" then
		self.editMode = "delete"
	end
end

function api.Update(dt)
	if self.recentDoodad and love.mouse.isDown(2) then
		self.recentDoodad.ShiftRotation(5*dt)
	end
end

--------------------------------------------------
-- Init
--------------------------------------------------

local function SetupWorld()
	local levelData = self.world.GetLevelData()
	if levelData.doodads then
		for i = 1, #levelData.doodads do
			local doodad = levelData.doodads[i]
			api.AddDoodad(doodad[1], doodad[2], doodad[3])
		end
	end
end

function api.ShiftEverything(vector)
	IterableMap.ApplySelf(self.doodadList, "ShiftPosition", vector)
end

local function DistSqTo(data, pos)
	return util.DistSqVectors(data.pos, pos)
end

function api.ExportObjects()
	local objList = IterableMap.ApplySelfMapToList(self.doodadList, "WriteSaveData")
	return objList
end

function api.Draw(drawQueue)
	IterableMap.ApplySelf(self.doodadList, "Draw", drawQueue)
	if self.editMode == "place" and self.placeType and self.world.GetEditMode() then
		drawQueue:push({y=1000; f=function()
			local mousePos = self.world.GetMousePosition()
			api.DrawDoodad(DoodadDefs.defs[DoodadDefs.doodadList[self.placeType]], mousePos)
		end})
	end
end

function api.Initialize(world)
	self = {
		doodadList = IterableMap.New(),
		world = world,
	}
	SetupWorld()
end

return api
