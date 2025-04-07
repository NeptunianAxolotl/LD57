
local Resources = require("resourceHandler")
local Font = require("include/font")

local function HandleWheel(def, wheel, wantLeft, wantRight)
	local motor = wheel.motor
	local speed = motor:getJointSpeed()
	if wantLeft then
		if speed > -def.motorMaxSpeed then
			motor:setMotorEnabled(true)
			motor:setMotorSpeed(-def.motorMaxSpeed)
			motor:setMaxMotorTorque(def.motorTorque * 500 * (def.topSpeedAccel + (1 - def.topSpeedAccel) / (500 + math.max(-speed/def.accelMult, 100))))
		else
			motor:setMotorEnabled(false)
		end
	elseif wantRight then
		if speed < def.motorMaxSpeed then
			motor:setMotorEnabled(true)
			motor:setMotorSpeed(def.motorMaxSpeed)
			motor:setMaxMotorTorque(def.motorTorque * 500 * (def.topSpeedAccel + (1 - def.topSpeedAccel) / (500 + math.max(speed/def.accelMult, 100))))
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

local function UpdateHyrdodynamics(def, dt, body, self)
	self.debugDraw.bodyForce = false
	self.debugDraw.backComp = false
	self.debugDraw.penaltyComponent = false
	local x, y = body:getPosition()
	if TerrainHandler.GetDepth(y) < 2 then
		return
	end
	local vx, vy = body:getLinearVelocity()
	local velUnit, speed = util.Unit({vx, vy})
	if speed < 5 then
		return
	end
	local angle = body:getAngle() + (def.hydroRotation or 0)
	local bodyUnit = util.PolarToCart(1, angle)
	local offMag = util.Cross2D(velUnit, bodyUnit)
	local bodyPerp = util.RotateVector(bodyUnit, math.pi/2)
	local bodyForce = util.Mult(dt*def.hydrofoilForceMult*offMag*math.pow(speed, 2)/100, bodyPerp)
	
	-- The bonus partially reduces the component of bodyForce in the -velUnit direction
	-- Reduction scales down to zero when the car is flying flat-side-on
	local bonusComponent = (math.abs(offMag) - 1)*def.hyroDragReduce*util.Dot(bodyForce, velUnit)
	local backForceAdjust = util.Mult(bonusComponent, velUnit)
	bodyForce = util.Add(bodyForce, backForceAdjust)
	
	
	-- The penalty reduces the component perpendicular to velocity, ie the useful lift part
	local penaltyComponent = util.Mult(1 - def.hydroPerpEffect, util.Subtract(util.Mult(util.Dot(bodyForce, velUnit), velUnit), bodyForce))
	bodyForce = util.Add(bodyForce, penaltyComponent)
	
	body:applyForce(bodyForce[1], bodyForce[2])
	self.debugDraw.bodyForce = bodyForce
	self.debugDraw.backComp = backForceAdjust
	self.debugDraw.penaltyComponent = penaltyComponent
end

local function DrawVector(pos, vector, scale, color)
	if vector then
		local draw = util.Add(pos, util.Mult(scale, vector))
		love.graphics.setColor(unpack(color))
		love.graphics.line(pos[1], pos[2], draw[1], draw[2])
	end
end

local function ShootFire(self, def, unit, mag)
	local bx, by = self.hull.body:getPosition()
	local vx, vy = self.hull.body:getLinearVelocity()
	local ox, oy = 0, 0
	if def.jumpVector ~= "adaptive" then
		if math.abs(def.jumpVector[1]) > 0 and math.abs(def.jumpVector[2]) > 0 then
			ox, oy = self.hull.body:getWorldVector(-0.1*def.width*def.scale, 0.5*def.height*def.scale)
		else
			ox, oy = self.hull.body:getWorldVector(-0.5*def.jumpVector[1]*def.width*def.scale, -0.5*def.jumpVector[2]*def.height*def.scale)
		end
	end
	local spawnPos = util.Add({ox, oy}, {bx, by})
	local carVel = {vx/60, vy/60}
	self.toShootFire = (self.toShootFire or 0) + mag
	while self.toShootFire > def.fireFxQuanta do
		EffectsHandler.SpawnEffect("fire", spawnPos, {
			velocity = util.Add(carVel, util.Add(util.Mult(-3 - math.random()*5, unit), util.RandomPointInCircle(2.5))),
			scale = 0.8 + 0.4*math.random(),
			life = 0.7 + 0.3*math.random(),
			drag = 1 + math.random(),
		})
		self.toShootFire = self.toShootFire - (0.7 + math.random()*0.3)*def.fireFxQuanta
	end
end

local function NewComponent(spawnPos, physicsWorld, world, def)
	if def.spawnOffset then
		spawnPos = util.Add(spawnPos, def.spawnOffset)
	end
	local self = {
		pos = spawnPos,
		debugDraw = {}
	}
	self.age = 0
	self.animTime = 0
	self.underwaterTime = 0
	self.jumpStore = def.jumpMax
	local hullCoords = {{def.width/2, def.height/2}, {-def.width/2, def.height/2}, {-def.width/2, -def.height/2}, {def.width/2, -def.height/2}}
	local ballastCoords = {{def.width/2, def.height/2}, {-def.width/2, def.height/2}, {-def.width/2, def.height*def.ballastProp}, {def.width/2, def.height*def.ballastProp}}
	
	self.hull = {}
	self.hull.body = love.physics.newBody(physicsWorld, self.pos[1], self.pos[2], "dynamic")
	do
		local shape = love.physics.newPolygonShape(unpack(MakeShapeCoords(def, hullCoords)))
		local fixture = love.physics.newFixture(self.hull.body, shape, def.density)
		self.hull.body:setAngularDamping(1)
		self.hull.body:setLinearDamping(def.baseDrag)
		fixture:setFriction(def.hullFriction)
		fixture:setRestitution(def.hullBounce)
	end
	self.hull.ballastShape = love.physics.newPolygonShape(unpack(MakeShapeCoords(def, ballastCoords)))
	self.hull.ballastFixture = love.physics.newFixture(self.hull.body, self.hull.ballastShape, def.density)
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
	
	function self.CleanupCar()
		local bx, by = self.hull.body:getPosition()
		local vx, vy = self.hull.body:getLinearVelocity()
		GameHandler.UpdateDepthRecordMarker()
		self.hull.body:setLinearVelocity(vx*0.6, vy*0.6)
		self.hull.body:setLinearDamping(20)
		self.hull.body:setGravityScale(0.2)
		self.hull.body:setAngularDamping(2)
		for i = 1, 35 do
			EffectsHandler.SpawnEffect("bubble", {bx, by}, {velocity = util.RandomPointInAnnulus(3, 12)})
		end
		for i = 1, #self.wheels do
			StopWheel(self.wheels[i])
		end
	end
	
	function self.Update(dt)
		self.animTime = self.animTime + dt
		self.age = self.age + dt
		TerrainHandler.UpdateSpeedLimit(self.hull.body)
		UpdateHyrdodynamics(def, dt, self.hull.body, self)
		
		local bx, by = self.hull.body:getPosition()
		local pickup = TerrainHandler.TryCollectPickup({bx, by}, def.pickupRadius)
		if pickup then
			PlayerHandler.ProcessPickup(pickup)
		end
		
		for i = 1, #self.wheels do
			local torque = self.wheels[i].motor:getReactionTorque(1/dt)
			self.hull.body:applyTorque(torque * def.reactionControl)
		end
		
		if not self.noAirWaitTimer then
			InterfaceUtil.SetNumber("depth", TerrainHandler.GetDepth(by))
		end
		if world.GetEditMode() then
			return
		end
		
		local myDepth = TerrainHandler.GetDepth(by)
		if myDepth > def.height and myDepth < Global.DEPTHS[#Global.DEPTHS] - 40 then
			self.underwaterTime = self.underwaterTime + dt
			if self.underwaterTime > def.airSeconds then
				local vx, vy = self.hull.body:getLinearVelocity()
				local speed = util.Dist(0, 0, vx, vy)
				if not self.noAirWaitTimer then
					self.CleanupCar()
				end
				self.noAirWaitTimer = (self.noAirWaitTimer or 0) + dt * (0.8 + 0.2 * (200 / (200 + speed)))
				if self.noAirWaitTimer > 2 then
					return true
				end
				return false
			end
			self.bubbleSpawn = (self.bubbleSpawn or 0) + dt*(1.2 + math.random()*3 + (2 + math.random()*8)*math.pow(1 - self.GetUnderwaterTimeProp(), 2))
			if self.bubbleSpawn > 1 then
				local vx, vy = self.hull.body:getWorldVector(0.25*def.width*def.scale, -0.5*def.height*def.scale)
				local spawnPos = util.Add({vx, vy}, {bx, by})
				EffectsHandler.SpawnEffect("bubble", spawnPos, {velocity = {6*math.random() - 3, -2*(0.4 + 0.6*math.random())}})
				self.bubbleSpawn = self.bubbleSpawn - (0.8 + math.random()*0.2)
			end
		end
		
		if self.jumpStore < def.jumpMax then
			self.jumpStore = self.jumpStore + dt*def.jumpChargeRate
			if self.jumpStore > def.jumpMax then
				self.jumpStore = def.jumpMax
			end
		end
		
		if self.age < Global.NO_DRIVE_TIME then
			return
		end
		
		if (love.keyboard.isDown("space") or love.keyboard.isDown("return")) and (self.jumping or (self.jumpStore/def.jumpMax >= def.jumpPropRequired)) then
			local jumpUse = (def.jumpUseRate and math.min(self.jumpStore, dt*def.jumpUseRate)) or self.jumpStore
			local vx, vy
			if def.jumpVector == "adaptive" then
				vx, vy = self.hull.body:getLinearVelocity()
				local v = util.Unit({vx, vy})
				vx, vy = v[1], v[2]
			else
				vx, vy = self.hull.body:getWorldVector(def.jumpVector[1], def.jumpVector[2])
			end
			local forceUnit = util.Unit({vx, vy})
			local forceMag = def.jumpForce*jumpUse
			local forceVec = util.Mult(forceMag, forceUnit)
			self.hull.body:applyForce(forceVec[1], forceVec[2])
			self.jumpStore = self.jumpStore - jumpUse
			self.jumping = (self.jumpStore > 0)
			ShootFire(self, def, forceUnit, forceMag)
		else
			self.jumping = false
		end
		
		local wantLeft = love.keyboard.isDown("a") or love.keyboard.isDown("left")
		local wantRight = love.keyboard.isDown("d") or love.keyboard.isDown("right")
		if wantLeft or wantRight then
			local vx, vy = self.hull.body:getWorldVector(0, 1)
			local forceVec = util.Mult(def.wheelDownforce*dt, util.Unit({vx, vy}))
			self.hull.body:applyForce(forceVec[1], forceVec[2])
		end
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
			turnAmount = turnAmount * (0.65 + 0.35 * (1 - speed / (speed + 1800))) * math.max(1, 150 / (6 + speed))
			self.hull.body:applyTorque(turnAmount)
		end
	end
	
	function self.GetUnderwaterTimeProp()
		return 1 - math.min(1, self.underwaterTime / def.airSeconds)
	end
	
	function self.GetBoost()
		local fill = self.jumpStore/def.jumpMax
		return fill, fill >= def.jumpPropRequired
	end
	
	function self.GetUnderwaterTime()
		return math.max(0, def.airSeconds - self.underwaterTime)
	end
	
	function self.GetDef()
		return def
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
		drawQueue:push({y=10; f=function()
			local x, y = self.hull.body:getPosition()
			local pos = {x, y}
			local angle = self.hull.body:getAngle()
			local debugMode = world.GetEditMode()
			love.graphics.push()
				love.graphics.translate(x, y)
				love.graphics.rotate(angle)
				Resources.DrawImage(def.carImage, def.carImageOffset[1], def.carImageOffset[2], 0, 1, def.carImageScale)
				love.graphics.setColor(1, 1, 1, 1)
				if debugMode then
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
				end
			love.graphics.pop()
			love.graphics.setColor(1, 1, 1, 1)
			
			if debugMode then
				DrawVector(pos, self.debugDraw.bodyForce, 5, {0, 0, 0, 1})
				DrawVector(pos, self.debugDraw.backComp, 5, {0, 1, 0, 1})
				DrawVector(pos, self.debugDraw.penaltyComponent, 5, {1, 0, 0, 1})
			end
			love.graphics.setColor(1, 1, 1, 1)
			for i = 1, #self.wheels do
				local x, y = self.wheels[i].body:getPosition()
				local angle = self.wheels[i].body:getAngle()
				love.graphics.push()
					love.graphics.translate(x, y)
					love.graphics.rotate(angle)
					Resources.DrawImage(def.wheelImage, 0, 0, 0, 1, def.wheelRadius * 2 * def.wheelImageScale )
					if debugMode then
						love.graphics.circle("line", 0, 0, def.wheelRadius * def.scale)
						local rx, ry = def.wheelRadius * def.scale, def.wheelRadius * def.scale
						love.graphics.rectangle("line", -0.5*rx, -0.5*ry, rx, ry, 0, 0, 0)
					end
				love.graphics.pop()
			end
		end})
	end
	
	function self.DrawInterface()
		
	end
	
	return self
end

return NewComponent
