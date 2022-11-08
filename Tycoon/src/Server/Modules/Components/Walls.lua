-- Walls
-- Max <3#9999 https://sites.google.com/view/spys-portfolio
-- August 26, 2022



local Walls = {}
Walls.__index = Walls

function Walls.new(tycoon, instance)
    local self = setmetatable({}, Walls)
    self.Tycoon = tycoon
    self.Instance = instance
    self.Owner = tycoon.Owner
    return self
end

function Walls:Initt()
	self.Owner.WallColor:GetPropertyChangedSignal("Value"):Connect(function()
		self.Instance.Color = self.Owner.WallColor.Value
	end)
    self.Instance.Color = self.Owner.WallColor.Value
end

return Walls