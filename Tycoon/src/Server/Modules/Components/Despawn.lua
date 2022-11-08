-- Despawn
-- Max <3#9999 https://sites.google.com/view/spys-portfolio
-- August 23, 2022



local Despawn = {}
Despawn.__index = Despawn

function Despawn.new(tycoon, instance)
    local self = setmetatable({}, Despawn)
    self.Tycoon = tycoon
    self.Instance = instance

    return self
end

function Despawn:Initt()
    self.Tycoon:SubscribeToTopic("Button", function(id)
        if id == self.Instance:GetAttribute("Id") then
            self.Instance:Destroy()
        end
    end)
end

return Despawn