
local NewPlayerCar = require("objects/playerCar")

local self = {}
local api = {}local defaultCar = {	density = 1.2,	ballastDensity = 5,	hullMass = 0.015,	wheelDensity = 0.5,
	wheelMass = 0.011,	ballastProp = 0.1,
		airSeconds = 15,		massScale = 10,	scale = 50,	pickupRadius = 50,	wheelFriction = 0.95,	wheelBounce = 0.05,	hullFriction = 0.65,	hullBounce = 0.05,	width = 2.1,	height = 1.4,	
	wheelDownforce = 200,	wheelOffX = 0.82,	wheelOffY = 0.6,	wheelRadius = 0.52,	wheelDampen = 4,	wheelFreq = 10,	wheelCount = 2,	reactionControl = 0.25,		jumpMax = 4,	jumpChargeRate = 1,	jumpUseRate = false,	jumpPropRequired = 1,	jumpForce = 1250,
	jumpVector = {0, -1},
	jumpAngleName = "Up",	
	fireFxQuanta = 220,	hullRotateMult = 0.6,	motorMaxSpeed = 10000,
	topSpeedAccel = 0.0003,	motorTorque = 5000,	accelMult = 1,	baseDrag = 0.05,	hydrofoilForceMult = 1,	hyroDragReduce = 0.1,	hydroPerpEffect = 0.6,}function api.ProcessPickup(pickup)
	if pickup.def.money then
		InterfaceUtil.AddNumber("money", pickup.def.money or 0)		InterfaceUtil.AddNumber("total_money", pickup.def.money or 0)
		EffectsHandler.SpawnEffect("popup", self.playerCar.GetPos(), {text = string.format("+$%d", pickup.def.money), velocity = {0, -2}})
	end
	if pickup.def.portalExit or pickup.def.portalEntrance then
		TerrainHandler.HandlePortal(pickup)
	endend---------------------------------------------------- API--------------------------------------------------function api.GetPos()	if self.playerCar then		self.lastPlayerPos = self.playerCar.GetPos()	end	return self.lastPlayerPosend
function api.GetVelocity()	if self.playerCar then		self.lastPlayerVelocity = self.playerCar.GetVelocity()	end	return self.lastPlayerVelocityendfunction api.GetDefaultCar()	return defaultCarendfunction api.GetUpgradedCar(loadout)	return GameHandler.ApplyCarUpgrades(loadout)end
function api.SetCarPos(pos)
	if self.playerCar then
		self.playerCar.SetPos(pos)
	end
end

function api.SetCarVelocity(vel)
	if self.playerCar then
		self.lastPlayerVelocity = self.playerCar.SetVelocity(vel)
	end
end
function api.RespawnCar()	if self.playerCar then		self.playerCar.Destroy()	end	local carSpec = api.GetUpgradedCar(GameHandler.GetLoadout())	self.playerCar = NewPlayerCar(self.world.GetLevelData().playerSpawn, self.world.GetPhysicsWorld(), self.world, carSpec)end---------------------------------------------------- Updates--------------------------------------------------
function api.Draw(drawQueue)
	if self.playerCar then
		self.playerCar.Draw(drawQueue)
	end
end
function api.KeyPressed(key, scancode, isRepeat)	if self.world.GetEditMode() then		if key == "g" then			self.playerCar.SetPos(self.world.GetMousePosition())			self.playerCar.SetVelocity({9, 0})			self.playerCar.SetAngle(0)			return true		end	end	if key == "r" and (love.keyboard.isDown("lctrl") or love.keyboard.isDown("rctrl")) then		self.playerCar.CleanupCar()
		api.RespawnCar()		return true	endendfunction api.GetUnderwaterTimeProp()	if self.playerCar then		return self.playerCar.GetUnderwaterTimeProp()	endend
function api.GetUnderwaterTime()
	if self.playerCar then
		return self.playerCar.GetUnderwaterTime()
	end
end

function api.GetCarDef()
	if self.playerCar then
		return self.playerCar.GetDef()
	end
end
function api.Update(dt)	if self.playerCar then		local wantRespawn = self.playerCar.Update(dt)		if wantRespawn then			api.RespawnCar()		end	endend
function api.Initialize(world)
	self = {
		playerCar = false,
		world = world,
	}
	api.RespawnCar()
end

return api
