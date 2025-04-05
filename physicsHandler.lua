local EffectsHandler = require("effectsHandler")

local self = {}
local api = {}
local world

--------------------------------------------------
-- API
--------------------------------------------------

function api.GetPhysicsWorld()
	return self.physicsWorld
end

function api.AddStaticObject()
	return self.physicsWorld
end

--------------------------------------------------
-- Colisions
--------------------------------------------------

local function beginContact(a, b, coll)
	--world.beginContact(a, b, coll)
end

local function endContact(a, b, coll)
end

local function preSolve(a, b, coll)
end

local function postSolve(a, b, coll,  normalimpulse, tangentimpulse)
	--world.postSolve(a, b, coll,  normalimpulse, tangentimpulse)
end

--------------------------------------------------
-- Initialize
--------------------------------------------------

local function InitPhysics()
	love.physics.setMeter(Global.PHYSICS_SCALE)
	self.physicsWorld = love.physics.newWorld(0, 0, true) -- Last argument is whether sleep is allowed.
	self.physicsWorld:setCallbacks(beginContact, endContact, preSolve, postSolve)
	self.physicsWorld:setGravity(0, Global.GRAVITY)
end

--------------------------------------------------
-- Updating
--------------------------------------------------

function api.Update(dt)
	self.physicsWorld:update(dt)
end

function api.Destroy(dt)
	if self.physicsWorld then
		self.physicsWorld:destroy()
		self.physicsWorld = nil
	end
end

function api.Initialize(parentWorld)
	world = parentWorld
	self = {}
	InitPhysics()
end

return api