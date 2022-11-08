-- Tycoon
-- Max <3#9999 https://sites.google.com/view/spys-portfolio
-- August 23, 2022

local Tycoon = {}
Tycoon.__index = Tycoon

local CollectionService = game:GetService("CollectionService")
local template = game:GetService("ServerStorage").Template
local componentFolder
local TycoonStorage = game:GetService("ServerStorage").TycoonStorage

function Tycoon:Start()
	componentFolder = self.Modules.Components
end

local function NewModel(model, cframe)
	local newModel = model:Clone()
	newModel:SetPrimaryPartCFrame(cframe)
	newModel.Parent = workspace
	return newModel
end

function Tycoon.new(Player, spawnPoint)
	local self = setmetatable({}, Tycoon)
	self.Owner = Player
	self.CashPerSec = 0
	self._topicEvent = Instance.new("BindableEvent")
	self._spawn = spawnPoint
	return self
end	

function Tycoon:Initt()
	self.Model = NewModel(template, self._spawn.CFrame)
	self._spawn:SetAttribute("Occupied",true)

	self.Owner.RespawnLocation = self.Model.Spawn
	self.Owner:LoadCharacter()


	self:LockAll()
	self:LoadUnlocks()
end

function Tycoon:LoadUnlocks()
	for _, id in ipairs(_G.Aero.Services.Datastore:GetUnlockedIds(self.Owner)) do
		self:PublishTopic("Button", id)
	end
end

function Tycoon:LockAll()
	for _, instance in ipairs(self.Model:GetDescendants()) do
		if CollectionService:HasTag(instance, "Unlockable") then
			self:Lock(instance)
		else
			self:AddComponents(instance)
		end
	end
end

function Tycoon:Lock(instance)
	instance.Parent=TycoonStorage
	self:CreateComponent(instance, componentFolder.Unlockable)
end

function Tycoon:Unlock(instance, id)
	_G.Aero.Services.Datastore:AddUnlockId(self.Owner, id)
	CollectionService:RemoveTag(instance, "Unlockable")
	self:AddComponents(instance)
	instance.Parent = self.Model
end

function Tycoon:AddComponents(instance)
	for _, tag in ipairs(CollectionService:GetTags(instance)) do
		local component = componentFolder[tag]
		if component then
			self:CreateComponent(instance, component)
		end
	end
end

function Tycoon:CreateComponent(instance, compModule)
	local newComp = compModule.new(self, instance)
	newComp:Initt()
end

function Tycoon:PublishTopic(topicName, ...)
	self._topicEvent:Fire(topicName, ...)
end

function Tycoon:SubscribeToTopic(topicName, callback)
	local connection = self._topicEvent.Event:Connect(function(name, ...)
		if name == topicName then
			callback(...)
		end
	end)
	return connection
end

function Tycoon:Destroy()
	self.Model:Destroy()
	self._topicEvent:Destroy()
	self._spawn:SetAttribute("Occupied",false)
end


return Tycoon