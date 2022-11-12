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

function ispart(cfram,folder) --[[ 
cfram is the new position, folder is the folder with the parts
	horrible math
	]]--
	for i,v in pairs(folder:GetChildren()) do -- this checks if any position is similar to the current position to not mass create parts

		if v.Position == cfram then
			return false
		end

	end

	local x = workspace.SomeStuff:FindFirstChild("LokaleParts")
	if x then
		for i,v in pairs(x:GetChildren()) do -- does the same as above just different folder
			if v.Position == cfram then
				return false
			end
		end
	end
 -- makes sure nothing is at exact same position
	for i,v in pairs(workspace.SomeStuff.Local:GetChildren()) do -- does same as above just different folder
		if v.Position == cfram then
			return false
		end
	end
	return true
end

function Spray(player : Player,cframe : CFrame ,color : Color3 ,index,size) -- spray stuff
	if not player then return end -- checks if player is an player
	index= tonumber(index) -- index = the layer
	size= tonumber(size) -- size = the size
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
	end -- checks if user owns gamepass and makes sure size is under maxsize
	if mps:UserOwnsGamePassAsync(player.UserId,15801260) then
		if index > maxgamepassindex then
			index=maxgamepassindex
		else
			if index > maxindex then
				index=maxindex
			end
		end
	end -- same as size just for index
	local char = player.Character  -- character
	local tool
	if char then
		tool = char:FindFirstChildOfClass("Tool")
	end -- if tool
	if tool then
		if tool.Name == ToolName then
		else
			return
		end
	else
		return
	end -- checks if the tool is spray can

	if ispart(cframe,workspace[player.Name])== false then
		return
	end -- checks if part already exists

-- clones of  Paint
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
	clone.Parent = workspace.SomeStuff.Local -- puts it into local folder
end


-- horrible scripting again
local plr = game.Players.LocalPlayer
local mouse = plr:GetMouse() -- gets plrs mouse
local buttondown=false -- this checks if button is down
local eraser = game.ReplicatedStorage.Erase -- thats an part
local runservice = game:GetService("RunService")
mouse.Button1Down:Connect(function() -- mouse down mouse buttondown yes true
	buttondown=true
end)

workspace:WaitForChild(plr.Name) -- waits for folder to be added

mouse.Button1Up:Connect(function()
	buttondown=false
end)

local emitpart

function Raycast(player,Position) -- raycasts from mouse 
	
	local params = RaycastParams.new()-- checks for raycast
	params.FilterDescendantsInstances = {workspace.Whitelist} -- filterdescendant whitelisted stuff  
	params.FilterType = Enum.RaycastFilterType.Whitelist --
	local results = workspace:Raycast(mouse.Origin.Position,mouse.Origin.LookVector*100,params) -- mouse raycast
	if results then -- returns an position on the whitelisted part with orientation etc
		local vec = results.Normal
		local fakepart = Instance.new("Part")
		fakepart.Anchored=true -- some math
		local x,y,z = results.Position.X,results.Position.Y,results.Position.Z
		fakepart.CFrame = CFrame.lookAt(results.Position,results.Position+ results.Normal) * CFrame.Angles(math.rad(90),0,0) -- the part has to be extra rotated thats why math.rad(90)
		fakepart.Position = Vector3.new(math.floor(x/GridSize)*GridSize ,  math.floor(y/GridSize)*GridSize ,   math.floor(z/GridSize)*GridSize ) 
		local saved =fakepart.CFrame
		fakepart:Destroy() -- checks something
		if ispart(fakepart.Position+ -fakepart.CFrame.UpVector* workspace.Settings.Layer.Value/60,workspace[player.Name]) ==false then
			return nil -- yes
		end
		return saved
	else
		return nil
	end
end

function spray:KnitInit()
	local Service = Knit.GetService("Spray")
	runservice.Heartbeat:Connect(function() -- runservice
		if toolequipped == "Erase" then -- to erase

			if eraser then -- eraser
				local n = workspace.Settings.Size.Value -- gets the settings size
				eraser.Size = Vector3.new(0.1*n, 0.5*n, 0.5*n)     -- sets the size for eraser 
				local params = RaycastParams.new() -- raycast params
				params.FilterDescendantsInstances = {workspace.Blacklist,workspace.SomeStuff.LokaleParts,workspace.SomeStuff.Local,workspace[plr.Name]}
				if workspace:FindFirstChild("Paints") then --some stuff
					params.FilterDescendantsInstances = {workspace.Blacklist,workspace.Paints,workspace.SomeStuff.LokaleParts,workspace.SomeStuff.Local,workspace[plr.Name]}
				end
				params.FilterType = Enum.RaycastFilterType.Blacklist
				local results = workspace:Raycast(mouse.Origin.Position,mouse.Origin.LookVector*100,params)
				if results then -- gets results
					local vec = results.Normal
					eraser.Anchored=true -- eraser position is at position
					eraser.CFrame = CFrame.lookAt(results.Position,results.Position+ results.Normal) * CFrame.Angles(0,math.rad(90),0)
				end
			end

			if buttondown then -- if button down
				local overlapparams = OverlapParams.new()
				local folder = workspace:FindFirstChild(plr.Name)
				overlapparams.FilterDescendantsInstances = {folder}
				overlapparams.FilterType = Enum.RaycastFilterType.Whitelist
				overlapparams.CollisionGroup = "cool"
				local parts = workspace:GetPartsInPart(eraser,overlapparams) -- also checks if same layer
				if parts then -- erase
					for i,v in pairs(parts) do -- checks if the parts are from the plr
						if not v:IsDescendantOf(workspace[plr.Name]) then
							return
						end
						if v:GetAttribute("Owner") == plr.UserId then -- if owner is localplr
							if v:GetAttribute("Index") == workspace.Settings.Layer.Value then -- checks layer
								Service:Erase(v) -- this erases server sided
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
				if parts then -- destroys parts that are on same layer
					for i,v in pairs(parts) do
						if v:GetAttribute("Owner") == plr.UserId then
							if v:GetAttribute("Index") == workspace.Settings.Layer.Value then
								v:Destroy()
							end
						end

					end
				end -- does same as above

			end
		end

		if toolequipped == "Spraycan" then -- sprays when mouse button down
			if buttondown then
				local cfram = Raycast(plr,mouse.Hit.Position)
				local folder = workspace:FindFirstChild(plr.Name)
				if cfram then	
					Spray(plr,cfram,workspace.Settings.Color.Value,workspace.Settings.Layer.Value,workspace.Settings.Size.Value)
					--Service:Spray(cfram,workspace.Settings.Color.Value,workspace.Settings.Layer.Value,workspace.Settings.Size.Value)
				end

			end

			local enabled= emitpart.Enabled -- this is for sounds 
			local tool = plr.Character:FindFirstChildOfClass("Tool")
			if tool then
				if tool.name == "Spraycan" then
					if buttondown then
						if not enabled then -- spray lol
							tool.Handle.EmitPart.SmokeParticle.Enabled=true
							tool.Handle.Spray:Play()
						end

					else
						if enabled then
							tool.Handle.EmitPart.SmokeParticle.Enabled=false
							tool.Handle.Spray:Stop()
						end
					end -- kinda useless no cap
				end
			end
		end
	end)

	local gui = plr:WaitForChild("PlayerGui")
	gui = gui:WaitForChild("ColourWheelGui")
	gui = gui:WaitForChild("Destroy")

	gui.MouseButton1Down:Connect(function() -- clear all button
		Service:ClearAll()
	end)

end
repeat wait() until plr.Character -- waits for player to be added and checking if they equipped the stuff.
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




function spray:KnitStart() -- When the Service starts
	local service = Knit.GetService("Spray") -- gets the serversided Spray
	while true do 
		task.wait(1) -- each second it updates the local parts to server
		if #workspace.SomeStuff.Local:GetChildren()>0 then
			for i,v in pairs(workspace.SomeStuff.Local:GetChildren()) do
				v.Parent = workspace.SomeStuff.LokaleParts
			end
			local tab = {}
			for i,v in pairs(workspace.SomeStuff.LokaleParts:GetChildren()) do
				local fake = {}
				fake.CFrame = v.CFrame
				fake.Color = v.Color
				fake.Size = v:GetAttribute("Size") -- size
				fake.Index = v:GetAttribute("Index") -- index
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
