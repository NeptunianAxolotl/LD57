
local NewPlayerCar = require("objects/playerCar")

local self = {}
local api = {}
local defaultCar = {	density = 1.2,	ballastDensity = 3,	wheelDensity = 0.35,	scale = 50,	pickupRadius = 50,	wheelFriction = 0.95,	hullFriction = 0.65,	width = 2.1,	height = 1.4,	wheelOffX = 0.78,	wheelOffY = 0.55,	wheelRadius = 0.52,	jumpReload = 4,	jumpForce = 4800,	hullRotateMult = 1,	motorMaxSpeed = 16000,	motorTorque = 4500,	accelMult = 1,	baseDrag = 0.05,	hydrofoilForceMult = 1,	hyroDragReduce = 0.1,	hydroPerpEffect = 0.6,}function api.ProcessPickup(pickup)end---------------------------------------------------- API--------------------------------------------------function api.GetPos()	if self.playerCar then		self.lastPlayerPos = self.playerCar.GetPos()	end	return self.lastPlayerPosend
function api.GetVelocity()	if self.playerCar then		self.lastPlayerVelocity = self.playerCar.GetVelocity()	end	return self.lastPlayerVelocityend---------------------------------------------------- Updates--------------------------------------------------
function api.Draw(drawQueue)
	if self.playerCar then
		self.playerCar.Draw(drawQueue)
	end
end
function api.KeyPressed(key, scancode, isRepeat)	if self.world.GetEditMode() then		if key == "g" then			self.playerCar.SetPos(self.world.GetMousePosition())			self.playerCar.SetVelocity({9, 0})			self.playerCar.SetAngle(0)		end	endendfunction api.Update(dt)	if self.playerCar then		self.playerCar.Update(dt)	endend
function api.Initialize(world)
	self = {
		playerCar = false,
		animationTimer = 0,
		world = world,
	}
	
	local initPlayerData = {
		pos = {500, 200}
	}
	self.playerCar = NewPlayerCar(initPlayerData, self.world.GetPhysicsWorld(), world, defaultCar)
end

return api
