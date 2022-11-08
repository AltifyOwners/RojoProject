-- Button
-- Max <3#9999 https://sites.google.com/view/spys-portfolio
-- August 23, 2022



local Button = {}
Button.__index = Button

function Button.new(tycoon, instance)
    local self = setmetatable({}, Button)
    self.Tycoon = tycoon
    self.Instance = instance

    return self
end

function Button:Initt()
    self.Prompt = self:CreatePrompt()
    self.Prompt.Triggered:Connect(function(...)
        self:Press(...)
    end)
end

function Button:CreatePrompt()
    local prompt = Instance.new("ProximityPrompt")
    prompt.HoldDuration = 0.1 
    prompt.ActionText = self.Instance:GetAttribute("Display")
    prompt.ObjectText = "Price: " .. self.Instance:GetAttribute("Cost")
    prompt.Parent = self.Instance
    return prompt
end

function Button:Press(player)
    local id = self.Instance:GetAttribute("Id")
    local money = _G.Aero.Services.Datastore:GetMoney(player)
    local cost = self.Instance:GetAttribute("Cost")
    if player == self.Tycoon.Owner and money >= cost then
        _G.Aero.Services.Datastore:UpdateLeaderstats(player,"Cash",-cost)
        self.Tycoon:PublishTopic("Button", id)
    end
end

return Button