
local Resources = require("resourceHandler")
local Font = require("include/font")

local function HandleWheel(def, wheel, wantLeft, wantRight)
	local motor = wheel.motor
	local speed = motor:getJointSpeed()
	if wantLeft then
		if speed > -def.motorMaxSpeed then
			motor:setMotorEnabled(true)
			motor:setMotorSpeed(-def.motorMaxSpeed)
			motor:setMaxMotorTorque(def.motorTorque * 500 / (500 + math.max(-speed/def.accelMult, 100)))
		else
			motor:setMotorEnabled(false)
		end
	elseif wantRight then
		if speed < def.motorMaxSpeed then
			motor:setMotorEnabled(true)
			motor:setMotorSpeed(def.motorMaxSpeed)
			motor:setMaxMotorTorque(def.motorTorque * 500 / (500 + math.max(speed/def.accelMult, 100)))
		else
			motor:setMotorEnabled(false)
		end
	else
		motor:setMotorEnabled(false)
	end
end

local function StopWheel(wheel)
	local motor = wheel.motor
	motor:setMotorEnabled(true)
	motor:setMotorSpeed(0)
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

local function UpdateHyrdodynamics(def, dt, body)
	local x, y = body:getPosition()
	if TerrainHandler.GetDepth(y) < 10 then
		return
	end
	local vx, vy = body:getLinearVelocity()
	local velUnit, speed = util.Unit({vx, vy})
	if speed < 10 then
		return
	end
	local angle = body:getAngle()
	local bodyUnit = util.PolarToCart(1, angle)
	local offMag = util.Cross2D(velUnit, bodyUnit)
	local bodyPerp = util.RotateVector(bodyUnit, math.pi/2)
	local bodyForce = util.Mult(dt*def.hydrofoilForceMult*offMag*math.pow(speed, 3)/100000, bodyPerp)
	
	-- The bonus partially reduces the component of bodyForce in the -velUnit direction
	-- Reduction scales down to zero when the car is flying flat-side-on
	local bonusComponent = (math.abs(offMag) - 1)*def.hyroDragReduce*util.Dot(bodyForce, velUnit)
	local backForceAdjust = util.Mult(bonusComponent, velUnit)
	bodyForce = util.Add(bodyForce, backForceAdjust)
	
	-- The penalty reduces the component perpendicular to velocity, ie the useful lift part
	local penaltyComponent = util.Mult(1 - def.hydroPerpEffect, util.Subtract(util.Mult(util.Dot(bodyForce, velUnit), velUnit), bodyForce))
	bodyForce = util.Add(bodyForce, penaltyComponent)
	body:applyForce(bodyForce[1], bodyForce[2])
end

local function NewComponent(spawnPos, physicsWorld, world, def)
	local self = {
		pos = spawnPos,
	}
	self.animTime = 0
	self.underwaterTime = 0
	self.jumpStore = def.jumpMax
	
	local hullCoords = {{def.width/2, def.height/2}, {-def.width/2, def.height/2}, {-def.width/2, -def.height/2}, {def.width/2, -def.height/2}}
	local ballastCoords = {{def.width/2, def.height/2}, {-def.width/2, def.height/2}, {-def.width/2, def.height/4}, {def.width/2, def.height/4}}
	
	self.hull = {}
	self.hull.body = love.physics.newBody(physicsWorld, self.pos[1], self.pos[2], "dynamic")
	self.hull.shape = love.physics.newPolygonShape(unpack(MakeShapeCoords(def, hullCoords)))
	self.hull.ballastShape = love.physics.newPolygonShape(unpack(MakeShapeCoords(def, ballastCoords)))
	self.hull.fixture = love.physics.newFixture(self.hull.body, self.hull.shape, def.density)
	self.hull.ballastFixture = love.physics.newFixture(self.hull.body, self.hull.ballastShape, def.density)
	self.hull.body:setAngularDamping(1)
	self.hull.body:setLinearDamping(def.baseDrag)
	self.hull.fixture:setFriction(def.hullFriction)
	self.hull.fixture:setRestitution(def.hullBounce)
	self.hull.body:setMass(def.hullMass * def.massScale)
	
	self.wheels = {}
	for i = 1, def.wheelCount do
		local front = (def.wheelCount <= 1 and 0) or (1 - ((i - 1)/(def.wheelCount - 1))*2)
		local x = self.pos[1] + front * def.wheelOffX * def.scale
		local y = self.pos[2] + def.wheelOffY * def.scale
		local body = love.physics.newBody(physicsWorld, x, y, "dynamic")
		local shape = love.physics.newCircleShape(def.wheelRadius * def.scale)
		local fixture = love.physics.newFixture(body, shape, def.wheelDensity)
		fixture:setFriction(def.wheelFriction)
		fixture:setRestitution(def.wheelBounce)
		body:setMass(def.wheelMass)
		local motor = love.physics.newWheelJoint(self.hull.body, body, body:getX(), body:getY(), 0, 1, false)
		motor:setSpringDampingRatio(def.wheelDampen)
		motor:setSpringFrequency(def.wheelFreq)
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
		UpdateHyrdodynamics(def, dt, self.hull.body)
		
		local bx, by = self.hull.body:getPosition()
		InterfaceUtil.SetNumber("depth", TerrainHandler.GetDepth(by))
		local pickup = TerrainHandler.TryCollectPickup({bx, by}, def.pickupRadius)
		if pickup then
			PlayerHandler.ProcessPickup(pickup)
		end
		
		for i = 1, #self.wheels do
			local torque = self.wheels[i].motor:getReactionTorque(1/dt)
			self.hull.body:applyTorque(torque * def.reactionControl)
		end
		
		if world.GetEditMode() then
			return
		end
		
		if TerrainHandler.GetDepth(by) > def.height then
			self.underwaterTime = self.underwaterTime + dt
			if self.underwaterTime > def.airSeconds then
				local vx, vy = self.hull.body:getLinearVelocity()
				local speed = util.Dist(0, 0, vx, vy)
				if not self.noAirWaitTimer then
					for i = 1, 35 do
						EffectsHandler.SpawnEffect("bubble", {bx, by}, {velocity = util.RandomPointInAnnulus(3, 12)})
					end
					for i = 1, #self.wheels do
						StopWheel(self.wheels[i])
					end
				end
				self.noAirWaitTimer = (self.noAirWaitTimer or 0) + dt * (0.4 + 0.6 * (200 / (200 + speed)))
				if self.noAirWaitTimer > 2.2 then
					return true
				end
				return false
			end
			self.bubbleSpawn = (self.bubbleSpawn or 0) + dt*(1.2 + math.random()*3 + (2 + math.random()*8)*math.pow(1 - self.GetUnderwaterTimeProp(), 2))
			if self.bubbleSpawn > 1 then
				EffectsHandler.SpawnEffect("bubble", {bx, by}, {velocity = {6*math.random() - 3, -2*(0.4 + 0.6*math.random())}})
				self.bubbleSpawn = self.bubbleSpawn - (0.8 + math.random()*0.2)
			end
		end
		
		if self.jumpStore < def.jumpMax then
			self.jumpStore = self.jumpStore + dt*def.jumpChargeRate
			if self.jumpStore > def.jumpMax then
				self.jumpStore = def.jumpMax
			end
		end
		if love.keyboard.isDown("space") and (self.jumping or (self.jumpStore/def.jumpMax >= def.jumpPropRequired)) then
			local jumpUse = (def.jumpUseRate and math.min(self.jumpStore, dt*def.jumpUseRate)) or self.jumpStore
			local vx, vy = self.hull.body:getWorldVector(def.jumpVector[1], def.jumpVector[2])
			local forceVec = util.Mult(def.jumpForce*jumpUse, util.Unit({vx, vy}))
			self.hull.body:applyForce(forceVec[1], forceVec[2])
			self.jumpStore = self.jumpStore - jumpUse
			self.jumping = (self.jumpStore > 0)
		else
			self.jumping = false
		end
		
		local wantLeft = love.keyboard.isDown("a") or love.keyboard.isDown("left")
		local wantRight = love.keyboard.isDown("d") or love.keyboard.isDown("right")
		for i = 1, #self.wheels do
			HandleWheel(def, self.wheels[i], wantLeft, wantRight)
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
			turnAmount = turnAmount * Global.TURN_MULT * def.hullRotateMult
			turnAmount = turnAmount * (0.5 + 0.5 * (1 - speed / (speed + 1000))) * math.max(1, 140 / (8 + speed))
			self.hull.body:applyTorque(turnAmount)
		end
	end
	
	function self.GetUnderwaterTimeProp()
		return 1 - math.min(1, self.underwaterTime / def.airSeconds)
	end
	
	function self.GetUnderwaterTime()
		return math.max(0, def.airSeconds - self.underwaterTime)
	
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
	
	function self.Destroy()
		self.hull.body:destroy()
		for i = 1, #self.wheels do
			self.wheels[i].body:destroy()
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
				for i = 1, #ballastCoords do
					local other = ballastCoords[(i < #ballastCoords and (i + 1)) or 1]
					love.graphics.line(ballastCoords[i][1], ballastCoords[i][2], other[1], other[2])
				end
				local fill = self.jumpStore/def.jumpMax
				if fill >= def.jumpPropRequired then
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
