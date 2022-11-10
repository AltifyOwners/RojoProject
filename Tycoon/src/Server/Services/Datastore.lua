-- Max<#0001 https://sites.google.com/view/spys-portfolio
-- August 23, 2022

local Datastore = {Client = {}}

-- ProfileTemplate table is what empty profiles will default to.
-- Updating the template will not include missing template values
--   in existing player profiles!
local ProfileTemplate = {
    leaderstats = {
        ["Cash"] = 0,
    },
    Colors = {
        R=255,
        G=255,
        B=255,
    },
	Buttons = {},
}

----- Loaded Modules -----

local ProfileService 
local TycoonService

----- Private Variables -----

local Players = game:GetService("Players")

local ProfileStore

local Profiles = {} -- [player] = profile

----- Private Functions -----

function FindSpawn()
    for _, SpawnPoint in ipairs(workspace.TycoonSpawns:GetChildren()) do
        if not SpawnPoint:GetAttribute("Occupied") then
            return SpawnPoint
        end
    end
end


function Datastore:UpdateLeaderstats(player,what,value)
    local profile = Profiles[player] -- Gets the Players Profile
    if profile then
        profile.Data.leaderstats[what]+=value -- Saves the Value 
        player.leaderstats[what].Value = profile.Data.leaderstats[what] -- Makes it Visible in the leaderstats        
    end
end

function Datastore:GetMoney(player)
    return Profiles[player].Data.leaderstats["Cash"]
end

function Datastore:AddUnlockId(player, id)
    local profile = Profiles[player] -- Gets the Players Profile
    if profile then
        if not table.find(profile.Data.Buttons,id) then
            table.insert(profile.Data.Buttons,id)
        end
    end
end

function Datastore:GetUnlockedIds(player)
    local profile = Profiles[player] -- Gets the Players Profile
    if profile then
        return profile.Data.Buttons
    end
end

function Datastore:PlayerAdded(player)
	local profile = ProfileStore:LoadProfileAsync("Player_" .. player.UserId)
	if profile ~= nil then
		profile:AddUserId(player.UserId) -- GDPR compliance
		profile:Reconcile() -- Fill in missing variables from ProfileTemplate (optional)
		profile:ListenToRelease(function()
			Profiles[player] = nil
			-- The profile could've been loaded on another Roblox server:
			player:Kick()
		end)

        -- // Data Loaded
        if player:IsDescendantOf(Players) == true then
            Profiles[player] = profile

            -- // Add the Folders to the Player
            for _,v in pairs(game.ServerStorage.PlayerTemplate:GetChildren()) do
                v:Clone().Parent = player
            end

            local succ,err = pcall(function()
                for name,value in pairs(profile.Data.leaderstats) do
                    player.leaderstats[name].Value = value
                end
            end)

            if not succ then
                player:Kick("Your data didn't load in succesfully, please rejoin game")
                print(err)
                return
            end

            local Color3s = Instance.new("Color3Value")
            Color3s.Name = "WallColor"
            Color3s.Parent= player
            Color3s.Value = Color3.fromRGB(profile.Data.Colors.R,profile.Data.Colors.G,profile.Data.Colors.B)

            local Tycoon = TycoonService.new(player, FindSpawn())
            Tycoon:Initt()

            -- // Working with the Loaded Data

            while Profiles[player] do wait(1)
                Datastore:UpdateLeaderstats(player,"Cash",Tycoon.CashPerSec+500)
            end
            Tycoon:Destroy()
        else
			-- Player left before the profile loaded:
			profile:Release()
		end
	else
		-- The profile couldn't be loaded possibly due to other
		--   Roblox servers trying to load this profile at the same time:
		player:Kick() 
	end
end


function Datastore:Start()
	ProfileService = self.Modules.ProfileService
    TycoonService = self.Modules.Tycoon

    ProfileStore = ProfileService.GetProfileStore(
	"gwgwgwklmgewlgmlenwglkgnlkgwnalgewgp",
	ProfileTemplate
    )

    ----- Initialize -----

    -- In case Players have joined the server earlier than this script ran:
    for _, player in ipairs(Players:GetPlayers()) do
        task.spawn(function()
            Datastore:PlayerAdded(player)
        end)
    end

    ----- Connections -----

    Players.PlayerAdded:Connect(function(Player)
        task.spawn(function()
            Datastore:PlayerAdded(Player)
        end)
    end)

    Players.PlayerRemoving:Connect(function(player)
        local profile = Profiles[player]
        if profile ~= nil then
            profile:Release()
        end
    end)
end


function Datastore:Init()
    local player = Instance.new("Folder")
    player.Parent = game.ServerStorage
    player.Name = "PlayerTemplate"
	 for i,v in pairs(ProfileTemplate) do
        if type(v) == "table" then
            local folder = Instance.new("Folder")
            folder.Name = i
            folder.Parent = player
            for name,value in pairs(v) do
                if type(value) == "boolean" then
                    local newstring = Instance.new("BoolValue")
                    newstring.Parent = folder
                    newstring.Name = name
                    newstring.Value =value
                elseif tonumber(value) then
                    local newstring = Instance.new("NumberValue")
                    newstring.Parent = folder
                    newstring.Name = name
                    newstring.Value =value
                else
                    if tostring(value) then
                        local newstring = Instance.new("StringValue")
                        newstring.Parent = folder
                        newstring.Name = name
                        newstring.Value =value
                    end
                end
            end
        end
    end
end


return Datastore
