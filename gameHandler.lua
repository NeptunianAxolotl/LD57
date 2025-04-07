
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
	{text = "Oxygen: ",  param = "airSeconds", showDepth = Global.DEPTHS[1]},
	{text = "Mass: ",  param = "mass", showDepth = Global.DEPTHS[1]},
	--{text = "Width: ",  param = "width", showDepth = Global.DEPTHS[1]},
	--{text = "Height: ",  param = "height", showDepth = Global.DEPTHS[1]},
	{text = "Engine Power: ",  param = "power", showDepth = Global.DEPTHS[1]},
	{text = "Top Speed: ",  param = "speed", showDepth = Global.DEPTHS[1]},
	{text = "Counter-Torque: ",  param = "reactionControl", showDepth = Global.DEPTHS[2]},
	{text = "Hull Rotation: ",  param = "hullRotateMult", showDepth = Global.DEPTHS[2]},
	--{text = "Bounce: ",  param = "bounce", showDepth = Global.DEPTHS[2]},
	{text = "Drag: ",  param = "drag", showDepth = Global.DEPTHS[2]},
	{text = "Lift: ",  param = "lift", showDepth = Global.DEPTHS[2]},
	{text = "Boost Capacity: ",  param = "jumpMax", showDepth = Global.DEPTHS[3]},
	{text = "Charge Rate: ",  param = "jumpChargeRate", showDepth = Global.DEPTHS[3]},
	{text = "Use Rate: ",  param = "jumpUseRate", showDepth = Global.DEPTHS[4]},
	{text = "Boost Power: ",  param = "jumpForce", showDepth = Global.DEPTHS[4]},
	{text = "Direction: ",  param = "jumpAngleName", showDepth = Global.DEPTHS[4]},
}

local function ExtractSpecStats(spec)
	local default = PlayerHandler.GetDefaultCar()
	local data = {}
	data.airSeconds = string.format("%ds", spec.airSeconds)
	data.mass = string.format("%.02f tons", 10*(spec.massScale*spec.hullMass + spec.wheelCount*spec.wheelMass))
	data.power = string.format("%d%%", 100 * spec.motorTorque / default.motorTorque)
	data.speed = string.format("%d%%", 100 * spec.topSpeedAccel / default.topSpeedAccel)
	data.width = string.format("%dm", spec.width / default.width * 10)
	data.height = string.format("%dm", spec.height / default.height * 10)
	data.reactionControl = string.format("%d%%", 100 * spec.reactionControl)
	data.hullRotateMult = string.format("%d%%", 100 * spec.hullRotateMult)
	data.bounce = string.format("%d%%", 100 * spec.wheelBounce)
	data.drag = string.format("%d%%", 100 * spec.hydrofoilForceMult)
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
	local debugMode = self.world.GetEditMode()
	if option.depth and option.depth > InterfaceUtil.GetRawRecordHigh("depth") and not debugMode then
		return false
	end
	local currentCost = (def.options[self.loadout[slot]].cost or 0)
	local deltaMoney = currentCost - (option.cost or 0)
	return true, (self.currentCarCost - deltaMoney <= InterfaceUtil.GetRawNumber("total_money")) or debugMode, deltaMoney
end

--------------------------------------------------
-- Design Checks
--------------------------------------------------

local function PrintDepthCosts()
	for di = 1, #Global.DEPTHS do
		local depth = Global.DEPTHS[di]
		local totalCost = 0
		for i = 1, #upgradeOrder do
			local def = UpgradeDefs[upgradeOrder[i]]
			local maxCost = 0
			for j = 1, #def.options do
				local option = def.options[j]
				if (not option.depth) or option.depth <= depth then
					maxCost = math.max(maxCost, option.cost)
				end
			end
			totalCost = totalCost + maxCost
		end
		print("depth cost", depth, totalCost)
	end
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
		self.shopOpened = true
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
			InterfaceUtil.SetNumber("car_cost", self.currentCarCost)
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
	if name == "depth" then
		local _, markKey, markData = IterableMap.GetBarbarianData(self.depthMarkers)
		for i = 1, #markKey do
			local marker = markData[markKey[i]]
			if newValue > marker.depth and not marker.toRemove then
				
				local carPos = PlayerHandler.GetPos()
				if carPos then
					local pos = util.Add(carPos, {700, 0})
					EffectsHandler.SpawnEffect("popup", pos, {text = marker.beatPopup, velocity = {0, -2}})
				end
				marker.toRemove = true
			end
		end
	end
end

function api.UpdateDepthRecordMarker()
	InterfaceUtil.SetNumber("depthRecord", InterfaceUtil.GetRawRecordHigh("depth"))
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
	local debugMode = self.world.GetEditMode()
	if self.hoveredOptionEvenDisabled and self.selectingSlot then
		local loadout = util.CopyTable(self.loadout)
		loadout[self.selectingSlot] = self.hoveredOptionEvenDisabled
		newData = ExtractSpecStats(api.ApplyCarUpgrades(loadout))
	end
	local shopX, shopY = 460, 310
	local offset = 35
	love.graphics.setColor(1, 1, 1, 0.9)
	Font.SetSize(2)
	for i = 1, #statsList do
		local stat = statsList[i]
		if stat.showDepth < InterfaceUtil.GetRawRecordHigh("depth") or debugMode then
			local text = stat.text .. defData[stat.param]
			if newData and newData[stat.param] ~= defData[stat.param] then
				text = text .. " (" .. newData[stat.param] .. ")"
			end
			love.graphics.printf(text, shopX, shopY, 500, "left")
			shopY = shopY + offset
		end
	end
end

local function DrawTitleText()
	local carPos = PlayerHandler.GetPos()
	local alpha = math.min(1, (800 - carPos[1])/180)
	if alpha > 0 then
		Font.SetSize(-1)
		love.graphics.setColor(0, 0, 0, 0.7*alpha)
		love.graphics.printf("Journey to the Centre of the Ocean", 1020, 180, 1600, "center")
		Font.SetSize(1)
		love.graphics.printf([[Collect treasure to upgrade your submersible
    - A and D to accelerate wheels
           - W and S to rotate chassis
                - Space or Enter to boost
                   - R to Respawn
                      Dive deep, until the Oxygen expires
                        Find the motherload
]], 1520, 320, 1200, "left")
	end
end

function api.Draw(drawQueue)
	drawQueue:push({y=800; f=function()
		local debugMode = self.world.GetEditMode()
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
			if def.showDepth < InterfaceUtil.GetRawRecordHigh("depth") or debugMode then
				local x = shopX + (buttonSize + buttonPad) * (drawIndex - 1)
				drawIndex = drawIndex + 1
				local open = (self.selectingSlot == defName)
				self.hoveredSlot = InterfaceUtil.DrawButton(x, shopY, buttonSize, buttonSize, mousePos, def.humanName or def.name, false, not self.shopOpened, false, open, 2, buttonOffset[def.textLine], 8) and def.name or self.hoveredSlot
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
		DrawTitleText()
	end})
	
	drawQueue:push({y=1000; f=function()
		love.graphics.setLineWidth(3)
		local carPos = PlayerHandler.GetPos()
		local _, markKey, markData = IterableMap.GetBarbarianData(self.depthMarkers)
		for i = 1, #markKey do
			local marker = markData[markKey[i]]
			local worldDepth = TerrainHandler.DepthToWorld(marker.depth)
			if marker.toRemove then
				marker.fade = (marker.fade or 0) + self.world.recentDt*1.8
			end
			if (marker.fade or 0) < 1 then
				love.graphics.setColor(1, 1, 1, 1 - (marker.fade or 0))
				love.graphics.line(-1000, worldDepth, 10000000, worldDepth)
				Font.SetSize(1)
				if carPos then
					love.graphics.printf(marker.text, carPos[1] - 350, worldDepth - 60, 600)
				end
			else
				marker.map_want_remove = true
			end
		end
		IterableMap.CleanupMapWantRemove(self.depthMarkers)
		
		local depthRecord = InterfaceUtil.GetNumber("depthRecord")
		if depthRecord > 0 then
			local worldDepth = TerrainHandler.DepthToWorld(depthRecord)
			love.graphics.setColor(1, 1, 1, 1)
			love.graphics.line(-1000, worldDepth, 10000000, worldDepth)
			Font.SetSize(1)
			if carPos then
				love.graphics.printf(string.format("%dm Record", depthRecord), carPos[1] - 350, worldDepth - 60, 600)
			end
		end
		
		love.graphics.setLineWidth(1)
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
 - T to toggle surface and pickup type.
 - R and click to remove things.
 - B to place coins.
 Polygons are convex have 2 < vertices < 9
 Right click with T to make unusual pickups.

 - Numpad to select doodads.
 - Right click to rotate recent placement.
 - kp+ delete.
]], Global.UI_WIDTH - 500, 40, 500)
--	else
--		Font.SetSize(3)
--		love.graphics.setColor(1, 1, 1, 0.7)
--		love.graphics.printf([[ - F to enable edit mode
--
-- - A and D spin wheels
-- - W pitch up, S pitch down
-- - Space to thrust
-- - Ctrl+R to respawn
-- - Ctrl+Y to restart
--]], Global.UI_WIDTH - 200, 40, 500)
	end
	
	local textGap = 70
	local money = InterfaceUtil.GetNumber("money")
	local totalMoney = InterfaceUtil.GetNumber("total_money")
	Font.SetSize(1)
	if totalMoney > 0 then
		if self.drawMoneyChange then
			local sign = (self.drawMoneyChange > 0) and "+" or ""
			love.graphics.printf(string.format("$%d  (%s%d)", money, sign, self.drawMoneyChange), windowX/2 - 275, 25, windowX/2, "left")
		else
			love.graphics.printf(string.format("$%d", money), windowX/2 - 275, 25, windowX/2, "left")
		end
	end
	
	local carPos = PlayerHandler.GetPos()
	local alpha = math.min(1, (800 - carPos[1])/180)
	if alpha > 0 then
		if totalMoney > 0 then
			love.graphics.setColor(1, 1, 1, 0.7*alpha)
			love.graphics.printf(string.format("Total: $%d", totalMoney + 1000), 25, 25, windowX/2, "left")
			love.graphics.printf(string.format("Vehicle: $%d", InterfaceUtil.GetNumber("car_cost") + 1000), 25, 25 + textGap, windowX/2, "left")
		end
	end
	
	local alpha = math.min(1, (carPos[1] - 1100)/300)
	if alpha > 0 then
		love.graphics.setColor(1, 1, 1, 0.7*alpha)
		local depth = math.max(0, InterfaceUtil.GetNumber("depth"))
		love.graphics.printf(string.format("Depth: %dm", depth), 25, windowY - 85, windowX, "left")
		local underwaterTime = PlayerHandler.GetUnderwaterTime()
		if underwaterTime then
			love.graphics.printf(string.format("Oxygen: %.1fs", underwaterTime), 25, windowY - 85 - textGap, windowX, "left")
		end
		local boostProp, boostReady = PlayerHandler.GetBoost()
		if boostProp then
			love.graphics.setColor(1, 1, 1, 0.7*alpha*(boostReady and 1 or 0.5))
			love.graphics.printf(string.format("Boost: %d%%", 100*boostProp), 25, windowY - 85 - textGap*2, windowX, "left")
		end
	end
end

function api.Initialize(world)
	self = {
		world = world,
		loadout = {},
		currentCarCost = 0,
		shopOpened = false,
		depthMarkers = IterableMap.New(),
	}
	InterfaceUtil.RegisterSmoothNumber("money", 0, 0.9, false, 1)
	InterfaceUtil.RegisterSmoothNumber("total_money", 0, 0.9, false, 1)
	InterfaceUtil.RegisterSmoothNumber("car_cost", 0, 0.9, false, 1)
	InterfaceUtil.RegisterSmoothNumber("destroyed_money", 0, 1.1)
	InterfaceUtil.RegisterSmoothNumber("depth", 0, 1)
	InterfaceUtil.RegisterSmoothNumber("depthRecord", 0, 0.8)
	
	for i = 1, #Global.DEPTHS do
		local marker = {
			depth = Global.DEPTHS[i],
			text = string.format("%dm", Global.DEPTHS[i]),
			beatPopup = Global.DEPTH_TEXT[i] or "New Shop Items",
		}
		IterableMap.Add(self.depthMarkers, marker)
	end
	
	for i = 1, #upgradeOrder do
		local defName = upgradeOrder[i]
		self.loadout[defName] = 1
	end
	PrintDepthCosts()
end

return api
