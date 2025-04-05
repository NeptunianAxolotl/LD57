
local Font = require("include/font")

local MapDefs = util.LoadDefDirectory("defs/maps")

local self = {}
local api = {}
---------------------------------------------------- Initialisation--------------------------------------------------local function NewPolygon(points)	local flatVerts = {}	local aveX, aveY = 0, 0	for i = 1, #points do		flatVerts[#flatVerts + 1] = points[i][1]		flatVerts[#flatVerts + 1] = points[i][2]		aveX, aveY = aveX + points[i][1], aveY + points[i][2]	end	aveX, aveY = aveX/#points, aveY/#points		local body = love.physics.newBody(self.world.GetPhysicsWorld(), 0, 0, "static")	local shape = love.physics.newPolygonShape(unpack(flatVerts))	local fixture = love.physics.newFixture(body, shape, 1)		local drawVerts = {}	for i = 1, #points do		drawVerts[#drawVerts + 1] = points[i][1]		drawVerts[#drawVerts + 1] = points[i][2]	end		local polygon = {		vertices = points,		drawVerts = drawVerts,		body = body,		shape = shape,		pos = {aveX, aveY},	}	self.polygons[#self.polygons + 1] = polygonendlocal function NewCircle(pos, radius)	local body = love.physics.newBody(self.world.GetPhysicsWorld(), pos[1], pos[2], "static")	local shape = love.physics.newCircleShape(radius)	local fixture = love.physics.newFixture(body, shape, 1)	local circle = {		pos = pos,		radius = radius,		body = body,		circle = body,	}	self.circles[#self.circles + 1] = circleend---------------------------------------------------- Level Editing--------------------------------------------------function api.MousePressed(x, y, button)	if not self.world.GetEditMode() then		return false	end	print(MousePressed)	if self.vertexMode then		if button == 2 then			if self.placingPoly and #self.placingPoly > 2 then				NewPolygon(self.placingPoly)				self.placingPoly = false			end		elseif (not self.placingPoly) or #self.placingPoly < 8 then			self.placingPoly = self.placingPoly or {}			self.placingPoly[#self.placingPoly + 1] = self.world.GetMousePosition()			if not util.ConvexPolygonPoints(self.placingPoly) then				self.placingPoly[#self.placingPoly] = nil			end		end	elseif self.circleMode then		if button == 2 then			self.placingCircle = false		elseif self.placingCircle then			local radius = util.DistVectors(self.placingCircle, self.world.GetMousePosition())			if radius > 10 then				NewCircle(self.placingCircle, radius)				self.placingCircle = false			end		else			self.placingCircle = self.world.GetMousePosition()		end	endendfunction api.KeyPressed(key, scancode, isRepeat)	if not self.world.GetEditMode() then		return false	end	self.vertexMode = false	self.circleMode = false	if key == "v" then		self.vertexMode = true		if self.placingPoly and #self.placingPoly > 0 then			self.placingPoly[#self.placingPoly] = nil		else			self.placingPoly = false		end	elseif key == "c" then		self.circleMode = true		self.placingCircle = false	endend---------------------------------------------------- Updates--------------------------------------------------

function api.UpdateSpeedLimit(body)
	local vx, vy = body:getLinearVelocity()
	local speedSq = util.DistSq(0, 0, vx, vy)
	if speedSq < Global.SPEED_LIMIT * Global.SPEED_LIMIT then
		body:setLinearDamping(0)
		return
	end
	local speed = math.sqrt(speedSq)
	body:setLinearDamping((speed - Global.SPEED_LIMIT) / Global.SPEED_LIMIT)
end

local function SetupLevel()
	-- TODO self.map = {}
	
end

function api.Draw(drawQueue)
	drawQueue:push({y=0; f=function()		love.graphics.setColor(1, 1, 1, 1)		for i = 1, #self.circles do			local circle = self.circles[i]			love.graphics.circle("line", circle.pos[1], circle.pos[2], circle.radius)		end		for i = 1, #self.polygons do			local polygon = self.polygons[i]			love.graphics.polygon("line", unpack(polygon.drawVerts))		end				love.graphics.setColor(0.5, 1, 0.5, 1)		if self.vertexMode and self.placingPoly and #self.placingPoly > 0 then			for i = 1, #self.placingPoly - 1 do				local thisVert = self.placingPoly[i]				local nextVert = self.placingPoly[i+1]				love.graphics.line(thisVert[1], thisVert[2], nextVert[1], nextVert[2])			end			local pos = self.world.GetMousePosition()			local thisVert = self.placingPoly[#self.placingPoly]			love.graphics.line(thisVert[1], thisVert[2], pos[1], pos[2])		elseif self.circleMode and self.placingCircle then			local radius = util.DistVectors(self.placingCircle, self.world.GetMousePosition())			love.graphics.circle("line", self.placingCircle[1], self.placingCircle[2], radius)		end
	end})
end

function api.Initialize(world, levelIndex, mapDataOverride)
	self = {
		world = world,		circles = {},		polygons = {},
	}
	
	SetupLevel(levelIndex, mapDataOverride)
end

return api
