
local Font = require("include/font")

local EffectsHandler = require("effectsHandler")
local Resources = require("resourceHandler")
local UpgradeDefs = util.LoadDefDirectory("defs/upgrades")
MusicHandler = require("musicHandler")

local self = {}
local api = {}

local upgradeOrder = {
	"engine",
	"gearbox",
	--"wheels",
	--"body",
	--"fuelTank",
	--"boostTank",
	--"boostStyle",
	--"boostDirection",
}

--------------------------------------------------
-- Utils
--------------------------------------------------

local function CanSelectOption(slot, index)
	local def = UpgradeDefs[slot]
	local option = def.options[index]
	if option.depth and option.depth > InterfaceUtil.GetRawRecordHigh("depth") then
		return false
	end
	local currentCost = (def.options[self.loadout[slot]].cost or 0)
	local deltaMoney = currentCost - (option.cost or 0)
	return self.currentCarCost - deltaMoney <= InterfaceUtil.GetRawNumber("total_money"), deltaMoney
end

--------------------------------------------------
-- API
--------------------------------------------------

function api.GetCarCost(loadout)
	local cost = 0
	for i = 1, #upgradeOrder do
		local defName = upgradeOrder[i]
		local def = UpgradeDefs[defName]
		local option = def.options[loadout[defName]]
		cost = cost + (option.cost or 0)
	end
	return cost
end

function api.ApplyCarUpgrades(loadout)
	local spec = util.CopyTable(PlayerHandler.GetDefaultCar())
	for i = 1, #upgradeOrder do
		local defName = upgradeOrder[i]
		local def = UpgradeDefs[defName]
		local option = def.options[loadout[defName]]
		spec = def.applyFunc(spec, option)
	end
	return spec
end

function api.GetLoadout()
	return self.loadout
end

function api.ToggleMenu()
	self.menuOpen = not self.menuOpen
	self.world.SetMenuState(self.menuOpen)
end

function api.MousePressed(x, y)
	local windowX, windowY = love.window.getMode()
	local drawPos = self.world.ScreenToInterface({windowX, 0})
	if self.hoveredSlot then
		if self.selectingSlot == self.hoveredSlot then
			self.selectingSlot = false
		else
			self.selectingSlot = self.hoveredSlot
		end
	elseif self.hoveredOption and self.selectingSlot then
		local enabled, moneyChange = CanSelectOption(self.selectingSlot, self.hoveredOption)
		if enabled then
			self.loadout[self.selectingSlot] = self.hoveredOption
			self.currentCarCost = api.GetCarCost(self.loadout)
			InterfaceUtil.SetNumber("money", InterfaceUtil.GetRawNumber("total_money") - self.currentCarCost)
			PlayerHandler.RespawnCar()
		end
	end
end

function api.GetViewRestriction()
	local pointsToView = {{0, 0}, {800, 800}}
	return pointsToView
end

function api.ReportOnRecord(name, newValue, prevValue)
	
end

--------------------------------------------------
-- Updating
--------------------------------------------------

function api.Update(dt)
end

function api.Draw(drawQueue)
	drawQueue:push({y=0; f=function()
		local mousePos = self.world.GetMousePosition()
		local shopX, shopY = 1060, -320
		local buttonSize = 145
		local buttonPad = 30
		self.hoveredSlot = false
		self.hoveredOption = false
		self.drawMoneyChange = false
		for i = 1, #upgradeOrder do
			local defName = upgradeOrder[i]
			local def = UpgradeDefs[defName]
			local x = shopX + (buttonSize + buttonPad) * (i - 1)
			local open = (self.selectingSlot == defName)
			self.hoveredSlot = InterfaceUtil.DrawButton(x, shopY, buttonSize, buttonSize, mousePos, def.name, false, false, false, open, 2, 32, 8) and def.name or self.hoveredSlot
			if self.selectingSlot == defName then
				local options = def.options
				for j = 1, #options do
					local option = options[j]
					local x = shopX + (buttonSize + buttonPad) * (j - 1)
					local y = shopY + (buttonSize + buttonPad*2)
					local enabled, moneyChange = CanSelectOption(defName, j)
					local inLoadout = (self.loadout[defName] == j)
					local hovered = InterfaceUtil.DrawButton(x, y, buttonSize, buttonSize, mousePos, option.name, not enabled, false, true, inLoadout, 2, 32, 8)
					self.hoveredOption = hovered and enabled and j or self.hoveredOption
					if hovered and moneyChange ~= 0 then
						self.drawMoneyChange = moneyChange
					end
				end
			end
		end
	end})
end

function api.DrawInterface()
	local windowX, windowY = Global.UI_WIDTH, Global.UI_HEIGHT
	
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
	
	Font.SetSize(1)
	if self.drawMoneyChange then
		local sign = (self.drawMoneyChange > 0) and "+" or ""
		love.graphics.printf(string.format("$%d  (%s%d)", InterfaceUtil.GetNumber("money"), sign, self.drawMoneyChange), windowX/2 - 275, 25, windowX/2, "left")
	else
		love.graphics.printf(string.format("$%d", InterfaceUtil.GetNumber("money")), windowX/2 - 275, 25, windowX/2, "left")
	end
	local depth = math.max(0, InterfaceUtil.GetNumber("depth"))
	love.graphics.printf(string.format("Depth: %d", depth), 25, windowY - 76, windowX, "left")
end

function api.Initialize(world)
	self = {
		world = world,
		loadout = {},
		currentCarCost = 0,
	}
	InterfaceUtil.RegisterSmoothNumber("money", 0, 1)
	InterfaceUtil.RegisterSmoothNumber("total_money", 0, 1)
	InterfaceUtil.RegisterSmoothNumber("destroyed_money", 0, 1)
	InterfaceUtil.RegisterSmoothNumber("depth", 0, 1)
	
	for i = 1, #upgradeOrder do
		local defName = upgradeOrder[i]
		self.loadout[defName] = 1
	end
end

return api
