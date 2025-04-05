

--local EffectDefs = util.LoadDefDirectory("effects")
local NewPlayerCar = require("objects/playerCar")

local self = {}
local api = {}

function api.Update(dt)
	if self.playerCar then
		self.playerCar.Update(dt)
	end
endfunction api.GetPos()	if self.playerCar then		self.lastPlayerPos = self.playerCar.GetPos()	end	return self.lastPlayerPosend
function api.GetVelocity()	if self.playerCar then		self.lastPlayerVelocity = self.playerCar.GetVelocity()	end	return self.lastPlayerVelocityend
function api.Draw(drawQueue)
	if self.playerCar then
		self.playerCar.Draw(drawQueue)
	end
end
function api.KeyPressed(key, scancode, isRepeat)	if self.world.GetEditMode() then		if key == "g" then			self.playerCar.SetPos(self.world.GetMousePosition())			self.playerCar.SetVelocity({9, 0})		end	endend
function api.Initialize(world)
	self = {
		playerCar = false,
		animationTimer = 0,
		world = world,
	}
	
	local initPlayerData = {
		pos = {500, 200}
	}
	self.playerCar = NewPlayerCar(initPlayerData, self.world.GetPhysicsWorld())
end

return api
