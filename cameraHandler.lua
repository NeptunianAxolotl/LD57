
local self = {}
local api = {}

function api.GetCameraTransform()
	return self.cameraTransform
end

function api.Update(dt, playerPos, playerVelocity)
	local playerVelocity = util.Mult(0.02, playerVelocity)
	local speed = util.AbsVal(playerVelocity)
	local offset = {0.15, 0.43}
	local minRatio = 13/9
	cameraX, cameraY, cameraScale = Camera.UpdateCameraToPlayer(dt, playerPos, playerVelocity, speed, 0.9)
	self.cameraPos[1] = cameraX
	self.cameraPos[2] = cameraY
	self.cameraScale = cameraScale
	Camera.UpdateTransform(self.cameraTransform, self.cameraPos[1], self.cameraPos[2], self.cameraScale, offset, minRatio)
end

local function UpdateCameraVector(dt, vector)
	local cameraX, cameraY, cameraScale = Camera.PushCamera(dt, vector, 0.55)
	Camera.UpdateTransform(self.cameraTransform, cameraX, cameraY, cameraScale)
	self.cameraPos[1] = cameraX
	self.cameraPos[2] = cameraY
	self.cameraScale = cameraScale
end

function api.UpdateFree(dt, zoomAmount)
	local cameraVector = {0, 0}
	local mouseScroll, keyScroll = self.world.GetCosmos().GetScrollSpeeds()
	keyScroll = keyScroll * self.cameraScale
	if (love.keyboard.isDown("a") or love.keyboard.isDown("left")) then
		cameraVector = util.Add(cameraVector, {-Global.CAMERA_SPEED*keyScroll, 0})
	end
	if (love.keyboard.isDown("d") or love.keyboard.isDown("right")) then
		cameraVector = util.Add(cameraVector, {Global.CAMERA_SPEED*keyScroll, 0})
	end
	if (love.keyboard.isDown("w") or love.keyboard.isDown("up")) then
		cameraVector = util.Add(cameraVector, {0, -Global.CAMERA_SPEED*keyScroll})
	end
	if (love.keyboard.isDown("s") or love.keyboard.isDown("down")) then
		cameraVector = util.Add(cameraVector, {0, Global.CAMERA_SPEED*keyScroll})
	end
	if zoomAmount then
		Camera.ZoomCamera(zoomAmount)
	end
	UpdateCameraVector(dt, cameraVector)
end


function api.GetCameraTransform()
	return self.cameraTransform
end

function api.Initialize(world, playerPos)
	self = {
		world = world,
	}
	
	self.cameraTransform = love.math.newTransform()
	self.cameraPos = {0, 0}
	Camera.Initialize({
		baseScale = Global.CAMERA_SCALE,
	})
	local cameraX, cameraY, cameraScale = Camera.UpdateCameraToPlayer(false, playerPos, {0, 0}, 0)
	
	self.cameraPos[1] = cameraX
	self.cameraPos[2] = cameraY
	self.cameraScale = cameraScale
	Camera.UpdateTransform(self.cameraTransform, cameraX, cameraY, cameraScale)
end

return api
