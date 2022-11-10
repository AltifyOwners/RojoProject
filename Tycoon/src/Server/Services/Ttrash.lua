--[[
.______       _______     ___       _______     .___  ___.  _______ 
|   _  \     |   ____|   /   \     |       \    |   \/   | |   ____|
|  |_)  |    |  |__     /  ^  \    |  .--.  |   |  \  /  | |  |__   
|      /     |   __|   /  /_\  \   |  |  |  |   |  |\/|  | |   __|  
|  |\  \----.|  |____ /  _____  \  |  '--'  |   |  |  |  | |  |____ 
| _| `._____||_______/__/     \__\ |_______/    |__|  |__| |_______|
                                                                    

Reselling this is ban-able.

 __       __    ______  _______ .__   __.      _______. _______  _______          _______..______   ____    ____ 
|  |     |  |  /      ||   ____||  \ |  |     /       ||   ____||       \        /       ||   _  \  \   \  /   / 
|  |     |  | |  ,----'|  |__   |   \|  |    |   (----`|  |__   |  .--.  |      |   (----`|  |_)  |  \   \/   /  
|  |     |  | |  |     |   __|  |  . `  |     \   \    |   __|  |  |  |  |       \   \    |   ___/    \_    _/   
|  `----.|  | |  `----.|  |____ |  |\   | .----)   |   |  |____ |  '--'  |   .----)   |   |  |          |  |     
|_______||__|  \______||_______||__| \__| |_______/    |_______||_______/    |_______/    | _|          |__|     

Devforum: https://devforum.roblox.com/u/intospy
Portfolio: https://devforum.roblox.com/t/766093

]]--
local Knit = require(game:GetService('ReplicatedStorage').Packages.Knit)

local spray = Knit.CreateController {
	Name = 'Spray';
	Client = {};
}


local toolequipped=""

-- // Settings
local GridSize = .0001
local ToolName = "Spraycan"
local maxindex = 5
local maxsize = 5

local maxgamepasssize = 8
local maxgamepassindex = 10

local mps = game:GetService("MarketplaceService")

function ispart(cfram,folder)
	for i,v in pairs(folder:GetChildren()) do

		if v.Position == cfram then
			return false
		end

	end

	local x = workspace.SomeStuff:FindFirstChild("LokaleParts")
	if x then
		for i,v in pairs(x:GetChildren()) do
			if v.Position == cfram then
				return false
			end
		end
	end

	for i,v in pairs(workspace.SomeStuff.Local:GetChildren()) do
		if v.Position == cfram then
			return false
		end
	end
	return true
end

function Spray(player : Player,cframe : CFrame ,color : Color3 ,index,size)
	if not player then return end
	index= tonumber(index)
	size= tonumber(size)
	if size==nil then
		size = 1
	end
	if index==nil then
		index=1
	end
	if mps:UserOwnsGamePassAsync(player.UserId,15801260) then
		if size > maxgamepasssize then
			size=maxgamepasssize
		else
			if size > maxsize then
				size=maxsize
			end
		end
	end
	if mps:UserOwnsGamePassAsync(player.UserId,15801260) then
		if index > maxgamepassindex then
			index=maxgamepassindex
		else
			if index > maxindex then
				index=maxindex
			end
		end
	end
	local char = player.Character 
	local tool
	if char then
		tool = char:FindFirstChildOfClass("Tool")
	end
	if tool then
		if tool.Name == ToolName then
		else
			return
		end
	else
		return
	end

	if ispart(cframe,workspace[player.Name])== false then
		return
	end


	local clone = game.ReplicatedStorage.Paint:Clone()
	clone.Size = Vector3.new(size*0.5,0.001,size*0.5)
	clone.CFrame = cframe
	clone.Color = color
	clone.CFrame = cframe
	clone.Position= clone.Position+ -clone.CFrame.UpVector* index/60
	clone:SetAttribute("Owner",player.UserId)
	clone:SetAttribute("Index",index)
	clone:SetAttribute("PlayerName",player.Name)
	clone:SetAttribute("DisplayName",player.DisplayName)
	clone:SetAttribute("Size",size)
	clone.CanQuery=true
	clone.Parent = workspace.SomeStuff.Local
end



local plr = game.Players.LocalPlayer
local mouse = plr:GetMouse()
local buttondown=false
local eraser = game.ReplicatedStorage.Erase
local runservice = game:GetService("RunService")
mouse.Button1Down:Connect(function()
	buttondown=true
end)

workspace:WaitForChild(plr.Name)

mouse.Button1Up:Connect(function()
	buttondown=false
end)

local emitpart

function Raycast(player,Position)
	local handle = player.Character.HumanoidRootPart

	local Direction = CFrame.new(handle.Position,Position).LookVector


	local params = RaycastParams.new()
	params.FilterDescendantsInstances = {workspace.Whitelist}
	params.FilterType = Enum.RaycastFilterType.Whitelist
	local results = workspace:Raycast(mouse.Origin.Position,mouse.Origin.LookVector*100,params)
	if results then
		local vec = results.Normal
		local fakepart = Instance.new("Part")
		fakepart.Anchored=true
		local x,y,z = results.Position.X,results.Position.Y,results.Position.Z
		fakepart.CFrame = CFrame.lookAt(results.Position,results.Position+ results.Normal) * CFrame.Angles(math.rad(90),0,0)
		fakepart.Position = Vector3.new(math.floor(x/GridSize)*GridSize ,  math.floor(y/GridSize)*GridSize ,   math.floor(z/GridSize)*GridSize ) 
		local saved =fakepart.CFrame
		fakepart:Destroy()
		if ispart(fakepart.Position+ -fakepart.CFrame.UpVector* workspace.Settings.Layer.Value/60,workspace[player.Name]) ==false then
			return nil
		end
		return saved
	else
		return nil
	end
end

function spray:KnitInit()
	local Service = Knit.GetService("Spray")
	runservice.Heartbeat:Connect(function()
		if toolequipped == "Erase" then

			if eraser then
				local n = workspace.Settings.Size.Value
				eraser.Size = Vector3.new(0.1*n, 0.5*n, 0.5*n)    
				local params = RaycastParams.new()
				params.FilterDescendantsInstances = {workspace.Blacklist,workspace.SomeStuff.LokaleParts,workspace.SomeStuff.Local,workspace[plr.Name]}
				if workspace:FindFirstChild("Paints") then
					params.FilterDescendantsInstances = {workspace.Blacklist,workspace.Paints,workspace.SomeStuff.LokaleParts,workspace.SomeStuff.Local,workspace[plr.Name]}
				end
				params.FilterType = Enum.RaycastFilterType.Blacklist
				local results = workspace:Raycast(mouse.Origin.Position,mouse.Origin.LookVector*100,params)
				if results then
					local vec = results.Normal
					eraser.Anchored=true
					eraser.CFrame = CFrame.lookAt(results.Position,results.Position+ results.Normal) * CFrame.Angles(0,math.rad(90),0)
				end
			end

			if buttondown then
				local overlapparams = OverlapParams.new()
				local folder = workspace:FindFirstChild(plr.Name)
				overlapparams.FilterDescendantsInstances = {folder}
				overlapparams.FilterType = Enum.RaycastFilterType.Whitelist
				overlapparams.CollisionGroup = "cool"
				local parts = workspace:GetPartsInPart(eraser,overlapparams)
				if parts then
					for i,v in pairs(parts) do
						if not v:IsDescendantOf(workspace[plr.Name]) then
							return
						end
						if v:GetAttribute("Owner") == plr.UserId then
							if v:GetAttribute("Index") == workspace.Settings.Layer.Value then
								Service:Erase(v)
							end
						end

					end
				end


				local overlapparams = OverlapParams.new()
				local folder = workspace.SomeStuff.Local
				overlapparams.FilterDescendantsInstances = {folder,workspace.SomeStuff.LokaleParts}
				overlapparams.FilterType = Enum.RaycastFilterType.Whitelist
				overlapparams.CollisionGroup = "cool"
				local parts = workspace:GetPartsInPart(eraser,overlapparams)
				if parts then
					for i,v in pairs(parts) do
						if v:GetAttribute("Owner") == plr.UserId then
							if v:GetAttribute("Index") == workspace.Settings.Layer.Value then
								v:Destroy()
							end
						end

					end
				end

			end
		end

		if toolequipped == "Spraycan" then
			if buttondown then
				local cfram = Raycast(plr,mouse.Hit.Position)
				local folder = workspace:FindFirstChild(plr.Name)
				if cfram then	
					Spray(plr,cfram,workspace.Settings.Color.Value,workspace.Settings.Layer.Value,workspace.Settings.Size.Value)
					--Service:Spray(cfram,workspace.Settings.Color.Value,workspace.Settings.Layer.Value,workspace.Settings.Size.Value)
				end

			end

			local enabled= emitpart.Enabled
			local tool = plr.Character:FindFirstChildOfClass("Tool")
			if tool then
				if tool.name == "Spraycan" then
					if buttondown then
						if not enabled then
							tool.Handle.EmitPart.SmokeParticle.Enabled=true
							tool.Handle.Spray:Play()
						end

					else
						if enabled then
							tool.Handle.EmitPart.SmokeParticle.Enabled=false
							tool.Handle.Spray:Stop()
						end

					end
				end
			end
		end
	end)

	local gui = plr:WaitForChild("PlayerGui")
	gui = gui:WaitForChild("ColourWheelGui")
	gui = gui:WaitForChild("Destroy")

	gui.MouseButton1Down:Connect(function()
		Service:ClearAll()
	end)

end
repeat wait() until plr.Character
plr.CharacterAdded:Connect(function()
	plr.Character.DescendantAdded:Connect(function(child)
		if child:IsA("Tool") then
			toolequipped=child.Name
			if toolequipped == "Spraycan" then
				emitpart = child.Handle.EmitPart.SmokeParticle
			end
		end
	end)

	plr.Character.DescendantRemoving:Connect(function(child)
		if child:IsA("Tool") then
			toolequipped=""
		end
	end)
end)
plr.Character.DescendantAdded:Connect(function(child)
	if child:IsA("Tool") then
		toolequipped=child.Name
		if toolequipped == "Spraycan" then
			emitpart = child.Handle.EmitPart.SmokeParticle
		end
	end
end)

plr.Character.DescendantRemoving:Connect(function(child)
	if child:IsA("Tool") then
		toolequipped=""
	end
end)




function spray:KnitStart()
	local service = Knit.GetService("Spray")
	while true do 
		task.wait(1)
		if #workspace.SomeStuff.Local:GetChildren()>0 then
			for i,v in pairs(workspace.SomeStuff.Local:GetChildren()) do
				v.Parent = workspace.SomeStuff.LokaleParts
			end
			local tab = {}
			for i,v in pairs(workspace.SomeStuff.LokaleParts:GetChildren()) do
				local fake = {}
				fake.CFrame = v.CFrame
				fake.Color = v.Color
				fake.Size = v:GetAttribute("Size")
				fake.Index = v:GetAttribute("Index")
				table.insert(tab,fake)
				v.Parent = workspace.SomeStuff.Removing
			end
			service:GetAll(tab)
			workspace[plr.Name].ChildAdded:Wait() wait(.5)
			workspace.SomeStuff.Removing:ClearAllChildren()
		end
	end
end

return spray
