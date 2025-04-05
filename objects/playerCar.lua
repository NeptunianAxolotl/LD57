
local Resources = require("resourceHandler")
local Font = require("include/font")

local DEF = {
	density = 1.2,
	ballastDensity = 3,
	wheelDensity = 0.5,
	scale = 50,
	wheelFriction = 0.95,
	hullFriction = 0.65,
	width = 2,
	height = 1.4,
	wheelOffX = 0.78,
	wheelOffY = 0.55,
	wheelRadius = 0.52,
	jumpReload = 4,
}

local function HandleWheel(wheel, wantLeft, wantRight)
	local motor = wheel.motor
	local speed = motor:getJointSpeed()
	if wantLeft then
		motor:setMotorEnabled(true)
		motor:setMotorSpeed(-20000)
		motor:setMaxMotorTorque(2500 * 500 / (500 + math.max(-speed, 200)))
	elseif wantRight then
		motor:setMotorEnabled(true)
		motor:setMotorSpeed(20000)
		motor:setMaxMotorTorque(2500 * 500 / (500 + math.max(speed, 200)))
	else
		motor:setMotorEnabled(false)
	end
end

local function MakeShapeCoords(def, coords)
	local modCoords = {}
	for i = 1, #coords do
		local pos = util.Mult(def.scale, coords[i])
		modCoords[#modCoords + 1] = pos[1]
		modCoords[#modCoords + 1] = pos[2]
		coords[i] = pos
	end
	return modCoords
end

local function NewComponent(self, physicsWorld, world)
	-- pos
	self.animTime = 0
	self.def = DEF
	local def = self.def
	
	self.jumpReload = false
	
	local width, height = 2, 1.4
	local wheelOffX, wheelOffY = 0.72, 0.95
	local wheelRadius = 0.52
	
	local hullCoords = {{def.width/2, def.height/2}, {-def.width/2, def.height/2}, {-def.width/2, -def.height/2}, {def.width/2, -def.height/2}}
	local ballastCoords = {{def.width/2, def.height/2}, {-def.width/2, def.height/2}, {-def.width/2, def.height/4}, {def.width/2, def.height/4}}
	
	self.hull = {}
	self.hull.body = love.physics.newBody(physicsWorld, self.pos[1], self.pos[2], "dynamic")
	self.hull.shape = love.physics.newPolygonShape(unpack(MakeShapeCoords(def, hullCoords)))
	self.hull.ballastShape = love.physics.newPolygonShape(unpack(MakeShapeCoords(def, ballastCoords)))
	self.hull.fixture = love.physics.newFixture(self.hull.body, self.hull.shape, def.density)
	self.hull.ballastFixture = love.physics.newFixture(self.hull.body, self.hull.ballastShape, def.density)
	self.hull.body:setAngularDamping(1)
	self.hull.fixture:setFriction(def.hullFriction)
	
	self.wheels = {}
	for i = 1, 2 do
		local front = 3 - i*2
		local x = self.pos[1] + front * def.wheelOffX * def.scale
		local y = self.pos[2] + def.wheelOffY * def.scale
		local body = love.physics.newBody(physicsWorld, x, y, "dynamic")
		local shape = love.physics.newCircleShape(def.wheelRadius * def.scale)
		local fixture = love.physics.newFixture(body, shape, def.wheelDensity)
		fixture:setFriction(def.wheelFriction)
		local motor = love.physics.newWheelJoint(self.hull.body, body, body:getX(), body:getY(), 0, 1, false)
		motor:setSpringDampingRatio(5)
		motor:setSpringFrequency(12)
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
		if world.GetEditMode() then
			return
		end
		
		if love.keyboard.isDown("space") and not self.jumpReload then
			local vx, vy = self.hull.body:getWorldVector(0, -1)
			local force = 2000
			local forceVec = util.Mult(force, util.Unit({vx, vy}))
			self.hull.body:applyForce(forceVec[1], forceVec[2])
			for i = 1, #self.wheels do
				self.wheels[i].body:applyForce(forceVec[1]*0.8, forceVec[2]*0.8)
			end
			self.jumpReload = def.jumpReload
		end
		if self.jumpReload then
			self.jumpReload = self.jumpReload - dt
			if self.jumpReload < 0 then
				self.jumpReload = false
			end
		end
		
		local wantLeft = love.keyboard.isDown("a") or love.keyboard.isDown("left")
		local wantRight = love.keyboard.isDown("d") or love.keyboard.isDown("right")
		for i = 1, #self.wheels do
			HandleWheel(self.wheels[i], wantLeft, wantRight)
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
			turnAmount = turnAmount * (0.5 + 0.5 * (1 - speed / (speed + 1000))) * math.max(1, 60 / (3.5 + speed))
			
			print(speed)
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
	
	function self.SetAngle(angle)
		self.hull.body:setAngle(angle)
	end
	
	function self.SetPos(pos)
		self.hull.body:setPosition(pos[1], pos[2])
		for i = 1, #self.wheels do
			self.wheels[i].body:setPosition(pos[1], pos[2])
		end
	end
	
	function self.SetVelocity(vel)
		self.hull.body:setLinearVelocity(vel[1], vel[2])
		for i = 1, #self.wheels do
			self.wheels[i].body:setLinearVelocity(vel[1], vel[2])
		end
	end
	
	function self.Draw(drawQueue)
		drawQueue:push({y=0; f=function()
			love.graphics.setColor(1, 1, 1, 1)
			local x, y = self.hull.body:getPosition()
			local angle = self.hull.body:getAngle()
			love.graphics.push()
				love.graphics.translate(x, y)
				love.graphics.rotate(angle)
				for i = 1, #hullCoords do
					local other = hullCoords[(i < #hullCoords and (i + 1)) or 1]
					love.graphics.line(hullCoords[i][1], hullCoords[i][2], other[1], other[2])
				end
				local fill = 1
				if self.jumpReload then
					fill = 1 - self.jumpReload/def.jumpReload
				end
				if fill == 1 then
					love.graphics.setColor(1, 1, 1, 0.12)
				else
					love.graphics.setColor(1, 1, 1, 0.08)
				end
				love.graphics.rectangle("fill", -0.5*def.width*def.scale, (0.5 - fill)*def.height*def.scale, def.width*def.scale, fill * def.height*def.scale)
			love.graphics.pop()
			love.graphics.setColor(1, 1, 1, 1)
			for i = 1, #self.wheels do
				local x, y = self.wheels[i].body:getPosition()
				local angle = self.wheels[i].body:getAngle()
				love.graphics.push()
					love.graphics.translate(x, y)
					love.graphics.rotate(angle)
					love.graphics.circle("line", 0, 0, def.wheelRadius * def.scale)
					local rx, ry = def.wheelRadius * def.scale, def.wheelRadius * def.scale
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
