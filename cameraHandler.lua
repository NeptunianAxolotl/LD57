
local self = {}
local api = {}

function api.GetCameraTransform()
	return self.cameraTransform
end

function api.Update(dt, playerPos, playerVelocity)
	local playerVelocity = util.Mult(0.02, playerVelocity)
	local speed = util.AbsVal(playerVelocity)
	cameraX, cameraY, cameraScale = Camera.UpdateCameraToPlayer(dt, playerPos, playerVelocity, speed, 0.9)
	self.cameraPos[1] = cameraX + cameraScale * 0.65
	self.cameraPos[2] = cameraY - cameraScale * 0.02
	self.cameraScale = cameraScale
	print(cameraX, playerPos[1], cameraY, playerPos[2], cameraScale)
	Camera.UpdateTransform(self.cameraTransform, self.cameraPos[1], self.cameraPos[2], self.cameraScale)
end

local function UpdateCamera(dt, vector)
	local cameraX, cameraY, cameraScale = Camera.PushCamera(dt, vector, 0.55)
	Camera.UpdateTransform(self.cameraTransform, cameraX, cameraY, cameraScale)
	--if ((cameraX - self.cameraPos[1])*10 < 150 or (cameraX - self.cameraPos[1])*10 > 180) and (cameraX - self.cameraPos[1])*10 > 40 then
	--	print(math.floor((cameraX - self.cameraPos[1])*10))
	--end
	self.cameraPos[1] = cameraX
	self.cameraPos[2] = cameraY
end

function api.GetCameraTransform()
	return self.cameraTransform
end

function api.Initialize(world, levelData, padding)
	self = {
		world = world,
		levelData = levelData,
	}
	
	self.cameraTransform = love.math.newTransform()
	self.cameraPos = {0, 0}
	Camera.Initialize({
		baseScale = Global.CAMERA_SCALE,
	})
	local cameraX, cameraY, cameraScale = Camera.UpdateCameraToPlayer(false, {0, 0}, {0, 0}, 0)
	
	self.cameraPos[1] = cameraX
	self.cameraPos[2] = cameraY
	self.cameraScale = cameraScale
	Camera.UpdateTransform(self.cameraTransform, cameraX, cameraY, cameraScale)
end

return api
