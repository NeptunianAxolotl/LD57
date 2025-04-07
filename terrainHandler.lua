
local Font = require("include/font")local SurfaceDefs, SurfaceDefNames = util.LoadDefNames("defs/surfaceDefs")local PickupDefs, PickupDefNames = util.LoadDefNames("defs/pickupDefs")

local MapDefs = util.LoadDefDirectory("defs/maps")

local self = {}
local api = {}
---------------------------------------------------- Util--------------------------------------------------local function DistSqTo(data, pos)	return util.DistSqVectors(data.pos, pos)endlocal function GetClosestShape(pos)	local closePoly, polyDist = IterableMap.GetMinimum(self.polygons, DistSqTo, pos)	local closeCircle, circleDist = IterableMap.GetMinimum(self.circles, DistSqTo, pos)	local closePickup, pickupDist = IterableMap.GetMinimum(self.pickups, DistSqTo, pos)	local check = {		{closePoly, polyDist, "poly"},		{closeCircle, circleDist, "circle"},		{closePickup, pickupDist, "pickup"},	}	local minShape, minDist, minKey = false, false, false	local minDist = false	local minKey = false	for i = 1, #check do		local this = check[i]		if this[2] and ((not minDist) or this[2] < minDist) then			minShape, minDist, minKey = this[3], this[2], this[1].map_key		end	end	if not minShape then		return false	end	return {		shape = minShape,		key = minKey,	}end---------------------------------------------------- Initialisation--------------------------------------------------local function SetupSurface(fixture, def)	fixture:setFriction(def.friction)	fixture:setRestitution(def.bounce)endlocal function NewPolygon(points, surface)	surface = surface or "default"	local def = SurfaceDefNames[surface]	local flatVerts = {}	local left, right, top, bot = points[1][1], points[1][1], points[1][2], points[1][2]	for i = 1, #points do		flatVerts[#flatVerts + 1] = points[i][1]		flatVerts[#flatVerts + 1] = points[i][2]		left, right = math.min(left, points[i][1]), math.max(right, points[i][1])		top, bot = math.min(top, points[i][2]), math.max(bot, points[i][2])	end	local pos = {(left + right)/2, (top + bot)/2}		local body = love.physics.newBody(self.world.GetPhysicsWorld(), 0, 0, "static")	local shape = love.physics.newPolygonShape(unpack(flatVerts))	local fixture = love.physics.newFixture(body, shape, 1)	SetupSurface(fixture, def)		local drawVerts = {}	for i = 1, #points do		drawVerts[#drawVerts + 1] = points[i][1]		drawVerts[#drawVerts + 1] = points[i][2]	end		local polygon = {		points = points,		def = def,		drawVerts = drawVerts,		body = body,		shape = shape,		fixture = fixture,		pos = pos,	}	IterableMap.Add(self.polygons, polygon)endlocal function NewCircle(pos, radius, surface)	surface = surface or "default"	local def = SurfaceDefNames[surface]	local body = love.physics.newBody(self.world.GetPhysicsWorld(), pos[1], pos[2], "static")	local shape = love.physics.newCircleShape(radius)	local fixture = love.physics.newFixture(body, shape, 1)	SetupSurface(fixture, def)	local circle = {		pos = pos,		def = def,		radius = radius,		body = body,		shape = shape,		fixture = fixture,	}	IterableMap.Add(self.circles, circle)endlocal function NewPickup(pos, defName)	local def = PickupDefNames[defName]	local pickup = {		pos = pos,		def = def,	}	if def.money then		self.spawnedMoneySum = self.spawnedMoneySum + def.money	end	IterableMap.Add(self.pickups, pickup)endlocal function SetupLevel(levelData)	for i = 1, #levelData.polygons do		NewPolygon(levelData.polygons[i].points, levelData.polygons[i].surface)	end	for i = 1, #levelData.circles do		NewCircle(levelData.circles[i].pos, levelData.circles[i].radius, levelData.circles[i].surface)	end	for i = 1, #levelData.pickups do		NewPickup(levelData.pickups[i].pos, levelData.pickups[i].defName)	end	self.waterline = levelData.waterlineend---------------------------------------------------- Level Editing--------------------------------------------------function api.SaveLevel(name)	love.filesystem.createDirectory("levels")	local save = {		waterline = self.levelData.waterline,		playerSpawn = self.levelData.playerSpawn,		polygons = {},		circles = {},		pickups = {},	}	for _, polygon in IterableMap.Iterator(self.polygons) do		save.polygons[#save.polygons + 1] = {			points = util.CopyTable(polygon.points),			surface = polygon.def.name,		}	end	for _, circle in IterableMap.Iterator(self.circles) do		save.circles[#save.circles + 1] = {			pos = circle.pos,			radius = circle.radius,			surface = circle.def.name,		}	end	for _, pickup in IterableMap.Iterator(self.pickups) do		save.pickups[#save.pickups + 1] = {			pos = pickup.pos,			defName = pickup.def.name,		}	end	for _, pickup in IterableMap.Iterator(self.collectedPickups) do		save.pickups[#save.pickups + 1] = {			pos = pickup.pos,			defName = pickup.def.name,		}	end		local saveTable = util.TableToString(save, Global.SAVE_ORDER, util.ListToMask(Global.SAVE_INLINE))	saveTable = "local data = " .. saveTable .. [[return data]]	local success, message = love.filesystem.write("levels/" .. name .. ".lua", saveTable)	if success then		EffectsHandler.SpawnEffect("error_popup", {900, 15}, {text = "Level saved to " .. (love.filesystem.getSaveDirectory() or "DIR_ERROR") .. "/" .. name .. ".", velocity = {0, 4}})	else		EffectsHandler.SpawnEffect("error_popup", {900, 15}, {text = "Save error: " .. (message or "NO MESSAGE"), velocity = {0, 4}})	end	return successendfunction api.MousePressed(x, y, button)	if not self.world.GetEditMode() then		return false	end	if self.editMode == "poly" then		if button == 2 then			if self.placingPoly and #self.placingPoly > 2 then				NewPolygon(self.placingPoly)				self.placingPoly = false			end		elseif (not self.placingPoly) or #self.placingPoly < 8 then			self.placingPoly = self.placingPoly or {}			self.placingPoly[#self.placingPoly + 1] = self.world.GetMousePosition()			if not util.ArePointsConvex(self.placingPoly) then				self.placingPoly[#self.placingPoly] = nil			end		end	elseif self.editMode == "circle" then		if button == 2 then			self.placingCircle = false		elseif self.placingCircle then			local radius = util.DistVectors(self.placingCircle, self.world.GetMousePosition())			if radius > 10 then				NewCircle(self.placingCircle, radius)				self.placingCircle = false			end		else			self.placingCircle = self.world.GetMousePosition()		end	elseif self.editMode == "delete" then		if self.closeShape.shape == "circle" then			IterableMap.Get(self.circles, self.closeShape.key).body:destroy()			IterableMap.Remove(self.circles, self.closeShape.key)		elseif self.closeShape.shape == "poly" then			IterableMap.Get(self.polygons, self.closeShape.key).body:destroy()			IterableMap.Remove(self.polygons, self.closeShape.key)		elseif self.closeShape.shape == "pickup" then			IterableMap.Remove(self.pickups, self.closeShape.key)		end	elseif self.editMode == "surfaceToggle" then		if self.closeShape.shape == "circle" or self.closeShape.shape == "poly" then			local objMap = ((self.closeShape.shape == "circle") and self.circles) or self.polygons			local obj = IterableMap.Get(objMap, self.closeShape.key)			local newDef = SurfaceDefs[obj.def.index%#SurfaceDefs + 1]			SetupSurface(obj.fixture, newDef)			obj.def = newDef		elseif self.closeShape.shape == "pickup" then			local obj = IterableMap.Get(self.pickups, self.closeShape.key)			local newDef = PickupDefs[obj.def.index%#PickupDefs + 1]			obj.def = newDef		end	elseif self.editMode == "pickup" then		NewPickup(self.world.GetMousePosition(), self.editType)	endendfunction api.KeyPressed(key, scancode, isRepeat)	if not self.world.GetEditMode() then		return false	end	if key == "v" then		self.editMode = "poly"		if self.placingPoly and #self.placingPoly > 0 then			self.placingPoly[#self.placingPoly] = nil		else			self.placingPoly = false		end	elseif key == "c" then		self.editMode = "circle"		self.placingCircle = false	elseif key == "k" then		api.SaveLevel("level")	elseif key == "r" then		self.editMode = "delete"	elseif key == "t" then		self.editMode = "surfaceToggle"	elseif key == "b" then		self.editMode = "pickup"		self.editType = "coin"	endend---------------------------------------------------- API--------------------------------------------------function api.GetDepth(y)	return (y - self.waterline)/Global.DEPTH_SCALEendfunction api.DepthToWorld(depth)	return depth*Global.DEPTH_SCALE + self.waterlineendfunction api.UpdateSpeedLimit(body)	local vx, vy = body:getLinearVelocity()	local speedSq = util.DistSq(0, 0, vx, vy)	if speedSq < Global.SPEED_LIMIT * Global.SPEED_LIMIT then		body:setLinearDamping(0)		return	end	local speed = math.sqrt(speedSq)	body:setLinearDamping((speed - Global.SPEED_LIMIT) / Global.SPEED_LIMIT)endfunction api.TryCollectPickup(pos, radius)	local closePickup, pickupDistSq = IterableMap.GetMinimum(self.pickups, DistSqTo, pos)	if not pickupDistSq then		return false	end	if pickupDistSq > math.pow(radius + closePickup.def.radius, 2) then		return	end	if not closePickup.def.portalEntrance then		IterableMap.Remove(self.pickups, closePickup.map_key)		IterableMap.Add(self.collectedPickups, closePickup)	end	return closePickupendfunction api.HandlePortal(pickup)	if pickup.def.portalEntrance then		if self.activePortals[pickup.def.portalEntrance] then			PlayerHandler.SetCarPos(self.activePortals[pickup.def.portalEntrance])			local vel = PlayerHandler.GetVelocity()			PlayerHandler.SetCarVelocity(util.Mult(0.5, vel))		end	elseif pickup.def.portalExit then		self.activePortals[pickup.def.portalExit] = pickup.pos	endend---------------------------------------------------- Updates--------------------------------------------------

function api.Draw(drawQueue)	drawQueue:push({y=-1000; f=function()		Resources.DrawImage("sea_back", 0, self.waterline)		Resources.DrawImage("sky_back", 0, self.waterline)	end})
	drawQueue:push({y=0; f=function()		self.closeShape = false		local debugMode = self.world.GetEditMode()		if (self.editMode == "delete" or self.editMode == "surfaceToggle") and debugMode then			self.closeShape = GetClosestShape(self.world.GetMousePosition())		end		Font.SetSize(3)		local _, pickupKey, pickupData = IterableMap.GetBarbarianData(self.pickups)		for i = 1, #pickupKey do			local pickup = pickupData[pickupKey[i]]			if not (pickup.def.portalEntrance and not self.activePortals[pickup.def.portalEntrance]) or debugMode then				if self.closeShape and self.closeShape.shape == "pickup" and self.closeShape.key == pickupKey[i] then					if self.editMode == "delete" then						love.graphics.setColor(1, 0.1, 0.1, 1)					else						love.graphics.setColor(unpack(pickup.def.col))					end					local pos = self.world.GetMousePosition()					love.graphics.line(pos[1], pos[2], pickup.pos[1], pickup.pos[2])				else					love.graphics.setColor(unpack(pickup.def.col))				end				love.graphics.circle("line", pickup.pos[1], pickup.pos[2], pickup.def.radius)				love.graphics.printf(pickup.def.name, pickup.pos[1] - 250, pickup.pos[2] - 20, 500, "center")			end		end				local _, circleKey, circleData = IterableMap.GetBarbarianData(self.circles)		for i = 1, #circleKey do			local circle = circleData[circleKey[i]]			if self.closeShape and self.closeShape.shape == "circle" and self.closeShape.key == circleKey[i] then				if self.editMode == "delete" then					love.graphics.setColor(1, 0.1, 0.1, 1)				else					love.graphics.setColor(unpack(circle.def.col))				end				local pos = self.world.GetMousePosition()				love.graphics.line(pos[1], pos[2], circle.pos[1], circle.pos[2])			elseif debugMode then				love.graphics.setColor(unpack(circle.def.col))			else				love.graphics.setColor(0, 0, 0, 1)			end			love.graphics.circle(debugMode and "line" or "fill", circle.pos[1], circle.pos[2], circle.radius)			if debugMode then				love.graphics.printf(circle.def.name, circle.pos[1] - 250, circle.pos[2] - 20, 500, "center")			end		end				local _, polyKey, polyData = IterableMap.GetBarbarianData(self.polygons)		for i = 1, #polyKey do			local polygon = polyData[polyKey[i]]			if self.closeShape and self.closeShape.shape == "poly" and self.closeShape.key == polyKey[i] then				if self.editMode == "delete" then					love.graphics.setColor(1, 0.1, 0.1, 1)				else					love.graphics.setColor(unpack(polygon.def.col))				end				local pos = self.world.GetMousePosition()				love.graphics.line(pos[1], pos[2], polygon.pos[1], polygon.pos[2])			elseif debugMode then				love.graphics.setColor(unpack(polygon.def.col))			else				love.graphics.setColor(0, 0, 0, 1)			end			love.graphics.polygon(debugMode and "line" or "fill", unpack(polygon.drawVerts))			if debugMode then				love.graphics.printf(polygon.def.name, polygon.pos[1] - 250, polygon.pos[2] - 20, 500, "center")			end		end				--love.graphics.setColor(0.2, 0.3, 1, 1)		--love.graphics.line(-1000, self.waterline, 10000000, self.waterline)				love.graphics.setColor(0.5, 1, 0.5, 1)		if self.world.GetEditMode() then			if self.editMode == "poly" and self.placingPoly and #self.placingPoly > 0 then				for i = 1, #self.placingPoly - 1 do					local thisVert = self.placingPoly[i]					local nextVert = self.placingPoly[i+1]					love.graphics.line(thisVert[1], thisVert[2], nextVert[1], nextVert[2])				end				local pos = self.world.GetMousePosition()				local thisVert = self.placingPoly[#self.placingPoly]				love.graphics.line(thisVert[1], thisVert[2], pos[1], pos[2])			elseif self.editMode == "circle" and self.placingCircle then				local radius = util.DistVectors(self.placingCircle, self.world.GetMousePosition())				love.graphics.circle("line", self.placingCircle[1], self.placingCircle[2], radius)			end		end
	end})
end

function api.Initialize(world, levelData)
	self = {
		world = world,		levelData = levelData,		circles = IterableMap.New(),		polygons = IterableMap.New(),		pickups = IterableMap.New(),		activePortals = {			start = {-80, -800},		},		collectedPickups = IterableMap.New(),		spawnedMoneySum = 0,
	}
	
	SetupLevel(levelData)	print("spawnedMoneySum", self.spawnedMoneySum)
end

return api
