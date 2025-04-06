
local Font = require("include/font")

local EffectsHandler = require("effectsHandler")
local Resources = require("resourceHandler")
local UpgradeDefs = util.LoadDefDirectory("defs/upgrades")
MusicHandler = require("musicHandler")

local self = {}
local api = {}

local upgradeOrder = {
	"air",
	"engine",
	"body",
	"wheels",
	"hydro",
	"boostTank",
	"boostStyle",
	"boostDirection",
}


--------------------------------------------------
-- Utils
--------------------------------------------------

local statsList = {
	{text = "Oxygen: ",  param = "airSeconds", showDepth = 100},
	{text = "Mass: ",  param = "mass", showDepth = 100},
	{text = "Width: ",  param = "width", showDepth = 100},
	{text = "Height: ",  param = "height", showDepth = 100},
	{text = "Engine Power: ",  param = "power", showDepth = 100},
	{text = "Engine Speed: ",  param = "speed", showDepth = 100},
	{text = "Counter-Torque: ",  param = "reactionControl", showDepth = 250},
	{text = "Hull Rotation: ",  param = "hullRotateMult", showDepth = 250},
	--{text = "Bounce: ",  param = "bounce", showDepth = 450},
	{text = "Drag: ",  param = "drag", showDepth = 450},
	{text = "Lift: ",  param = "lift", showDepth = 450},
	{text = "Boost Capacity: ",  param = "jumpMax", showDepth = 450},
	{text = "Charge Rate: ",  param = "jumpChargeRate", showDepth = 450},
	{text = "Use Rate: ",  param = "jumpUseRate", showDepth = 450},
	{text = "Boost Power: ",  param = "jumpForce", showDepth = 450},
	{text = "Direction: ",  param = "jumpAngleName", showDepth = 450},
}

local function ExtractSpecStats(spec)
	local default = PlayerHandler.GetDefaultCar()
	local data = {}
	data.airSeconds = string.format("%ds", spec.airSeconds)
	data.mass = string.format("%.02f tons", 10*(spec.massScale*spec.hullMass + spec.wheelCount*spec.wheelMass))
	data.power = string.format("%d%%", 100 * spec.motorTorque / default.motorTorque)
	data.speed = string.format("%d%%", 100 * spec.motorMaxSpeed / default.motorMaxSpeed)
	data.width = string.format("%ds", spec.width / default.width * 10)
	data.height = string.format("%ds", spec.height / default.height * 10)
	data.reactionControl = string.format("%d%%", 100 * spec.reactionControl)
	data.hullRotateMult = string.format("%d%%", 100 * spec.hullRotateMult)
	data.bounce = string.format("%d%%", 100 * spec.wheelBounce)
	data.drag = string.format("%d%%", 100 * (1 - spec.hyroDragReduce) * spec.hydrofoilForceMult)
	data.lift = string.format("%d%%", 100 * spec.hydroPerpEffect)
	data.jumpMax = string.format("%.01f", spec.jumpMax)
	data.jumpChargeRate = string.format("%.01f/s", spec.jumpChargeRate)
	data.jumpAngleName = spec.jumpAngleName
	if spec.jumpUseRate then
		data.jumpUseRate = string.format("%.01f/s", spec.jumpUseRate)
		data.jumpForce = string.format("%d/s", spec.jumpForce/10)
	else
		data.jumpUseRate = "Instant"
		data.jumpForce = string.format("%d", spec.jumpForce * spec.jumpMax/10)
	end
	return data
end

local function CanSelectOption(slot, index)
	local def = UpgradeDefs[slot]
	local option = def.options[index]
	if option.depth and option.depth > InterfaceUtil.GetRawRecordHigh("depth") and not Global.DEBUG_SHOP then
		return false
	end
	local currentCost = (def.options[self.loadout[slot]].cost or 0)
	local deltaMoney = currentCost - (option.cost or 0)
	return true, self.currentCarCost - deltaMoney <= InterfaceUtil.GetRawNumber("total_money"), deltaMoney
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
		local shown, enabled, moneyChange = CanSelectOption(self.selectingSlot, self.hoveredOption)
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

local buttonOffset = {47, 27}
local function DrawCarStats()
	local def = PlayerHandler.GetCarDef()
	local defData = ExtractSpecStats(def)
	local newData = false
	if self.hoveredOptionEvenDisabled and self.selectingSlot then
		local loadout = util.CopyTable(self.loadout)
		loadout[self.selectingSlot] = self.hoveredOptionEvenDisabled
		newData = ExtractSpecStats(api.ApplyCarUpgrades(loadout))
	end
	local shopX, shopY = 550, -450
	local offset = 35
	love.graphics.setColor(1, 1, 1, 0.9)
	Font.SetSize(2)
	for i = 1, #statsList do
		local stat = statsList[i]
		if stat.showDepth < InterfaceUtil.GetRawRecordHigh("depth") or Global.DEBUG_SHOP then
			local text = stat.text .. defData[stat.param]
			if newData and newData[stat.param] ~= defData[stat.param] then
				text = text .. " (" .. newData[stat.param] .. ")"
			end
			love.graphics.printf(text, shopX, shopY, 500, "left")
			shopY = shopY + offset
		end
	end
end

function api.Draw(drawQueue)
	drawQueue:push({y=0; f=function()
		local mousePos = self.world.GetMousePosition()
		local shopX, shopY = 1060, -320
		local buttonSize = 145
		local buttonPad = 30
		self.hoveredSlot = false
		self.hoveredOption = false
		self.hoveredOptionEvenDisabled = false
		self.drawMoneyChange = false
		local drawIndex = 1
		for i = 1, #upgradeOrder do
			local defName = upgradeOrder[i]
			local def = UpgradeDefs[defName]
			if def.showDepth < InterfaceUtil.GetRawRecordHigh("depth") or Global.DEBUG_SHOP then
				local x = shopX + (buttonSize + buttonPad) * (drawIndex - 1)
				drawIndex = drawIndex + 1
				local open = (self.selectingSlot == defName)
				self.hoveredSlot = InterfaceUtil.DrawButton(x, shopY, buttonSize, buttonSize, mousePos, def.humanName or def.name, false, false, false, open, 2, buttonOffset[def.textLine], 8) and def.name or self.hoveredSlot
				if self.selectingSlot == defName then
					local options = def.options
					for j = 1, #options do
						local option = options[j]
						local x = shopX + (buttonSize + buttonPad) * (j - 1)
						local y = shopY + (buttonSize + buttonPad*2)
						local shown, enabled, moneyChange = CanSelectOption(defName, j)
						if shown then
							local inLoadout = (self.loadout[defName] == j)
							local hovered = InterfaceUtil.DrawButton(x, y, buttonSize, buttonSize, mousePos, option.name, not enabled, false, true, inLoadout, 2, buttonOffset[option.textLine or 1], 8)
							self.hoveredOptionEvenDisabled = hovered and j or self.hoveredOptionEvenDisabled
							self.hoveredOption = hovered and enabled and j or self.hoveredOption
							if hovered and moneyChange ~= 0 then
								self.drawMoneyChange = moneyChange
							end
						end
					end
				end
			end
		end
		DrawCarStats()
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
 Polygons are convex have 2 < vertices < 9]], Global.UI_WIDTH - 200, 40, 500)
	else
		Font.SetSize(3)
		love.graphics.setColor(1, 1, 1, 0.7)
		love.graphics.printf([[ - F to enable edit mode

 - A and D spin wheels
 - W pitch up, S pitch down
 - Space to thrust
 - Ctrl+R to respawn
 - Ctrl+Y to restart
]], Global.UI_WIDTH - 200, 40, 500)
	end
	
	Font.SetSize(1)
	if self.drawMoneyChange then
		local sign = (self.drawMoneyChange > 0) and "+" or ""
		love.graphics.printf(string.format("$%d  (%s%d)", InterfaceUtil.GetNumber("money"), sign, self.drawMoneyChange), windowX/2 - 275, 25, windowX/2, "left")
	else
		love.graphics.printf(string.format("$%d", InterfaceUtil.GetNumber("money")), windowX/2 - 275, 25, windowX/2, "left")
	end
	local depth = math.max(0, InterfaceUtil.GetNumber("depth"))
	love.graphics.printf(string.format("Depth: %d", depth), 25, windowY - 85, windowX, "left")
	
	local underwaterTime = PlayerHandler.GetUnderwaterTime()
	love.graphics.printf(string.format("Oxygen: %.1fs", underwaterTime), 25, windowY - 135, windowX, "left")
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
