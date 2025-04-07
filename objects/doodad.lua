
local function NewDoodad(myDef, pos, angle)
	local self = {}
	self.def = myDef
	self.pos = pos
	self.angle = angle or 0
	self.scale = myDef.scaleRand*math.random() + 1
	self.drawOffset = math.random()*0.01
	
	function self.RemoveAtPos(pos)
		return (util.Dist(pos, self.pos) < 60)
	end
	
	function self.ShiftPosition(vector)
		self.pos = util.Add(self.pos, vector)
	end
	
	function self.ShiftRotation(angle)
		self.angle = self.angle + angle
		print(self.angle)
	end
	
	function self.WriteSaveData()
		return {self.def.name, self.pos, self.angle%(2*math.pi)}
	end
	
	function self.Draw(drawQueue)
		if self.toRemove then
			return true
		end
		drawQueue:push({y=self.def.drawLayer + self.drawOffset; f=function()
			DoodadHandler.DrawDoodad(self.def, self.pos, self.angle, self.scale)
		end})
	end
	
	return self
end

return NewDoodad
