
local Font = require("include/font")

local EffectsHandler = require("effectsHandler")
local Resources = require("resourceHandler")
MusicHandler = require("musicHandler")

local self = {}
local api = {}

--------------------------------------------------
-- Updating
--------------------------------------------------

--------------------------------------------------
-- API
--------------------------------------------------

function api.ToggleMenu()
	self.menuOpen = not self.menuOpen
	self.world.SetMenuState(self.menuOpen)
end

function api.MousePressed(x, y)
	local windowX, windowY = love.window.getMode()
	local drawPos = self.world.ScreenToInterface({windowX, 0})
end

function api.GetViewRestriction()
	local pointsToView = {{0, 0}, {800, 800}}
	return pointsToView
end

--------------------------------------------------
-- Updating
--------------------------------------------------

function api.Update(dt)
end

function api.DrawInterface()
	local windowX, windowY = love.window.getMode()
	
	if self.world.GetEditMode() then
		Font.SetSize(3)
		love.graphics.setColor(1, 1, 1, 0.7)
		love.graphics.printf([[ - F to disable edit mode
 - G to warp player to mouse.
 - C to place circle.
 - V to place polygon vertices with LMB. Right click to finish.
 - Press C or V to cancel placement.
 - T to toggle surface and item type.
 - R and click to remove things.
 - B to place coins.
 Polygons are convex have 2 < vertices < 9]], 40, 40, 500)
	else
		Font.SetSize(3)
		love.graphics.setColor(1, 1, 1, 0.7)
		love.graphics.printf([[ - F to enable edit mode

 - A and D spin wheels
 - W pitch up, S pitch down
 - Space to thrust
 - Ctrl+R to respawn
 - Ctrl+Y to restart
]], 40, 40, 500)
	end
	
	Font.SetSize(2)
	love.graphics.printf(string.format("$%d", InterfaceUtil.GetNumber("money")), windowX/2 - 100, 25, windowX/2, "left")
end

function api.Initialize(world)
	self = {
		world = world,
	}
end

return api
