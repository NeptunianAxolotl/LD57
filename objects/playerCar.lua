
local Resources = require("resourceHandler")
local Font = require("include/font")

local DEF = {
	density = 1,
	wheelDensity = 1.6,
	scaleFactor = 50,
	width = 2,
	height = 1.4,
	wheelOffX = 0.72,
	wheelOffY = 0.55,
	wheelRadius = 0.52,
	jumpReload = 4,
}

local function NewComponent(self, physicsWorld)
	-- pos
	self.animTime = 0
	self.def = DEF
	local def = self.def
	
	self.jumpReload = false
	
	local width, height = 2, 1.4
	local wheelOffX, wheelOffY = 0.72, 0.62
	local wheelRadius = 0.52
	
	local coords = {{def.width/2, def.height/2}, {-def.width/2, def.height/2}, {-def.width/2, -def.height/2}, {def.width/2, -def.height/2}}
	local modCoords = {}
	for i = 1, #coords do
		local pos = util.Mult(def.scaleFactor, coords[i])
		modCoords[#modCoords + 1] = pos[1]
		modCoords[#modCoords + 1] = pos[2]
		coords[i] = pos
	end
	
	self.hull = {}
	self.hull.body = love.physics.newBody(physicsWorld, self.pos[1], self.pos[2], "dynamic")
	self.hull.shape = love.physics.newPolygonShape(unpack(modCoords))
	self.hull.fixture = love.physics.newFixture(self.hull.body, self.hull.shape, def.density)
	self.hull.body:setAngularDamping(9)
	
	self.wheels = {}
	for i = 1, 2 do
		local front = 3 - i*2
		local x = self.pos[1] + front * def.wheelOffX * def.scaleFactor
		local y = self.pos[2] + def.wheelOffY * def.scaleFactor
		local body = love.physics.newBody(physicsWorld, x, y, "dynamic")
		local shape = love.physics.newCircleShape(def.wheelRadius * def.scaleFactor)
		local fixture = love.physics.newFixture(body, shape, def.wheelDensity)
		local motor = love.physics.newWheelJoint(self.hull.body, body, body:getX(), body:getY(), 0, 1, false)
		self.wheels[i] = {
			body = body,
			shape = shape,
			fixture = fixture,
			motor = motor,
		}
	end
	
	
	if self.initVelocity then
		self.hull.body:setLinearVelocity(self.initVelocity[1], self.initVelocity[2])
	end
	
	function self.Update(dt)
		self.animTime = self.animTime + dt
		TerrainHandler.UpdateSpeedLimit(self.hull.body)
		
		if love.keyboard.isDown("space") and not self.jumpReload then
			local vx, vy = self.hull.body:getWorldVector(0, -1)
			local force = 1200
			local forceVec = util.Mult(force, util.Unit({vx, vy}))
			self.hull.body:applyForce(forceVec[1], forceVec[2])
			for i = 1, #self.wheels do
				self.wheels[i].body:applyForce(forceVec[1]*0.8, forceVec[2]*0.8)
			end
			self.jumpReload = def.jumpReload
		end
		if self.jumpReload then
			self.jumpReload = self.jumpReload - dt
		end
		
		for i = 1, #self.wheels do
			if love.keyboard.isDown("a") or love.keyboard.isDown("left") then
				self.wheels[i].motor:setMotorEnabled(true)
				self.wheels[i].motor:setMotorSpeed(-1)
				self.wheels[i].motor:setMaxMotorTorque(1)
			elseif love.keyboard.isDown("d") or love.keyboard.isDown("right") then
				self.wheels[i].motor:setMotorEnabled(true)
				self.wheels[i].motor:setMotorSpeed(10)
				self.wheels[i].motor:setMaxMotorTorque(100)
			else
				self.wheels[i].motor:setMotorEnabled(false)
			end
		end
		
		local turnAmount = false
		if love.keyboard.isDown("w") or love.keyboard.isDown("up") then
			turnAmount = -1
		elseif love.keyboard.isDown("s") or love.keyboard.isDown("down") then
			turnAmount = 1
		end
		
		if turnAmount then
			local vx, vy = self.hull.body:getLinearVelocity()
			local speed = util.Dist(0, 0, vx, vy)
			turnAmount = turnAmount * Global.TURN_MULT
			turnAmount = turnAmount * (0.2 + 0.8 * (1 - speed / (speed + 600)))
			self.hull.body:applyTorque(turnAmount)
		end
	end
	
	function self.GetPos()
		local x, y = self.hull.body:getPosition()
		return {x, y}
	end
	
	function self.GetVelocity()
		local x, y = self.hull.body:getLinearVelocity()
		return {x, y}
	end
	
	function self.Draw(drawQueue)
		drawQueue:push({y=0; f=function()
			local x, y = self.hull.body:getPosition()
			local angle = self.hull.body:getAngle()
			love.graphics.push()
				love.graphics.translate(x, y)
				love.graphics.rotate(angle)
				for i = 1, #coords do
					local other = coords[(i < #coords and (i + 1)) or 1]
					love.graphics.line(coords[i][1], coords[i][2], other[1], other[2])
				end
			love.graphics.pop()
			for i = 1, #self.wheels do
				local x, y = self.wheels[i].body:getPosition()
				local angle = self.wheels[i].body:getAngle()
				love.graphics.push()
					love.graphics.translate(x, y)
					love.graphics.rotate(angle)
					love.graphics.circle("line", 0, 0, def.wheelRadius * def.scaleFactor)
					local rx, ry = def.wheelRadius * def.scaleFactor, def.wheelRadius * def.scaleFactor
					love.graphics.rectangle("line", -0.5*rx, -0.5*ry, rx, ry, 0, 0, 0)
				love.graphics.pop()
			end
		end})
		if DRAW_DEBUG then
			love.graphics.circle('line',self.pos[1], self.pos[2], def.radius)
		end
	end
	
	function self.DrawInterface()
		
	end
	
	return self
end

return NewComponent
