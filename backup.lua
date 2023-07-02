--credits to https://raw.githubusercontent.com/Henrymistert123/ExploitCompilation/main/LUAGptSetup.lua
--[[
$$\   $$\ $$\ 
$$ |  $$ |\__|
$$ |  $$ |$$\ 
$$$$$$$$ |$$ |
$$  __$$ |$$ |
$$ |  $$ |$$ |
$$ |  $$ |$$ |
\__|  \__|\__|

this is where i define all the functions and bypasses for the ai so it can do shtuff in psx
]]

local Network = require(game:GetService("ReplicatedStorage").Library.Client.Network)
local Fire, Invoke = Network.Fire, Network.Invoke
 
local old
old = hookfunction(getupvalue(Fire, 1), function(...)
   return true
end)
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local HttpService = game:GetService("HttpService")
local InputService = game:GetService('UserInputService')
local RunService = game:GetService('RunService')
local ContentProvider = game:GetService("ContentProvider")
local banSuccess, banError = pcall(function() 
		local Blunder = require(game:GetService("ReplicatedStorage"):WaitForChild("X", 10):WaitForChild("Blunder", 10):WaitForChild("BlunderList", 10))
		if not Blunder or not Blunder.getAndClear then LocalPlayer:Kick("Error while bypassing the anti-cheat! (Didn't find blunder)") end
 
		local OldGet = Blunder.getAndClear
		setreadonly(Blunder, false)
		local function OutputData(Message)
		   print("-- PET SIM X BLUNDER --")
		   print(Message .. "\n")
		end
 
		Blunder.getAndClear = function(...)
		   local Packet = ...
			for i,v in next, Packet.list do
			   if v.message ~= "PING" then
				   OutputData(v.message)
				   table.remove(Packet.list, i)
			   end
		   end
		   return OldGet(Packet)
		end
 
		setreadonly(Blunder, true)
	end)
 
	if not banSuccess then
		LocalPlayer:Kick("Error while bypassing the anti-cheat! (".. banError ..")")
		return
	end
 
	local Library = require(game:GetService("ReplicatedStorage").Library)
	assert(Library, "Oopps! Library has not been loaded. Maybe try re-joining?") 
	while not Library.Loaded do task.wait() end
 
	Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
	Humanoid = Character:WaitForChild("Humanoid")
	HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
 
 
	local bypassSuccess, bypassError = pcall(function()
		if not Library.Network then 
			LocalPlayer:Kick("Network not found, can't bypass!")
		end
 
		if not Library.Network.Invoke or not Library.Network.Fire then
			LocalPlayer:Kick("Network Invoke/Fire was not found! Failed to bypass!")
		end
 
		hookfunction(debug.getupvalue(Library.Network.Invoke, 1), function(...) return true end)
		-- Currently we don't need to hook Fire, since both Invoke/Fire have the same upvalue, this may change in future.
		-- hookfunction(debug.getupvalue(Library.Network.Fire, 1), function(...) return true end)
 
		local originalPlay = Library.Audio.Play
		Library.Audio.Play = function(...) 
			if checkcaller() then
				local audioId, parent, pitch, volume, maxDistance, group, looped, timePosition = unpack({ ... })
				if type(audioId) == "table" then
					audioId = audioId[Random.new():NextInteger(1, #audioId)]
				end
				if not parent then
					warn("Parent cannot be nil", debug.traceback())
					return nil
				end
				if audioId == 0 then return nil end
 
				if type(audioId) == "number" or not string.find(audioId, "rbxassetid://", 1, true) then
					audioId = "rbxassetid://" .. audioId
				end
				if pitch and type(pitch) == "table" then
					pitch = Random.new():NextNumber(unpack(pitch))
				end
				if volume and type(volume) == "table" then
					volume = Random.new():NextNumber(unpack(volume))
				end
				if group then
					local soundGroup = game.SoundService:FindFirstChild(group) or nil
				else
					soundGroup = nil
				end
				if timePosition == nil then
					timePosition = 0
				else
					timePosition = timePosition
				end
				local isGargabe = false
				if not pcall(function() local _ = parent.Parent end) then
					local newParent = parent
					pcall(function()
						newParent = CFrame.new(newParent)
					end)
					parent = Instance.new("Part")
					parent.Anchored = true
					parent.CanCollide = false
					parent.CFrame = newParent
					parent.Size = Vector3.new()
					parent.Transparency = 1
					parent.Parent = workspace:WaitForChild("__DEBRIS")
					isGargabe = true
				end
				local sound = Instance.new("Sound")
				sound.SoundId = audioId
				sound.Name = "sound-" .. audioId
				sound.Pitch = pitch and 1
				sound.Volume = volume and 0.5
				sound.SoundGroup = soundGroup
				sound.Looped = looped and false
				sound.MaxDistance = maxDistance and 100
				sound.TimePosition = timePosition
				sound.RollOffMode = Enum.RollOffMode.Linear
				sound.Parent = parent
				if not require(game:GetService("ReplicatedStorage"):WaitForChild("Library"):WaitForChild("Client")).Settings.SoundsEnabled then
					sound:SetAttribute("CachedVolume", sound.Volume)
					sound.Volume = 0
				end
				sound:Play()
				getfenv(originalPlay).AddToGarbageCollection(sound, isGargabe)
				return sound
			end
 
			return originalPlay(...)
		end
 
	end)
 
	if not bypassSuccess then
		print(bypassError)
		LocalPlayer:Kick("Error while bypassing network, try again or wait for an update!")
		return
	end
function GetPetDataById(id2)
    for i2, v2 in pairs(game:GetService("ReplicatedStorage")["__DIRECTORY"].Pets:GetChildren()) do
 
        if string.match(v2.Name, "%d+") == tostring(id2) then
            for i3, v3 in pairs(v2:GetChildren()) do
                if v3:IsA("ModuleScript") then
                    return require(v3)
                end
            end
        end
    end
end
function getallpets()
    Lib = require(game.ReplicatedStorage.Library)
    pets = Lib.Save.Get().Pets
    FRPETS = {}
    for petid, petdata in pairs(pets) do
        table.insert(FRPETS, petid)
    end
    return FRPETS
end
local Library = require(game:GetService("ReplicatedStorage").Library)
function Teleport(world, area)
        if Library.Save.Get().World ~= world then 
            local Library = require(game:GetService("ReplicatedStorage").Library)
		Library.WorldCmds.Load(world)
		wait(0.25)
		local areaTeleport = Library.WorldCmds.GetMap().Teleports:FindFirstChild(area)
		Library.Signal.Fire("Teleporting")
		task.wait(0.25)
		local Character = game.Players.LocalPlayer.Character
		local Humanoid = Character.Humanoid
		local HumanoidRootPart = Character.HumanoidRootPart
		Character:PivotTo(areaTeleport.CFrame + areaTeleport.CFrame.UpVector * (Humanoid.HipHeight + HumanoidRootPart.Size.Y / 2))
		Library.Network.Fire("Performed Teleport", area)
		task.wait(0.25)
        else
            local areaTeleport = Library.WorldCmds.GetMap().Teleports:FindFirstChild(area)
            task.wait(0.25)
            local Character = game.Players.LocalPlayer.Character
            local Humanoid = Character.Humanoid
            local HumanoidRootPart = Character.HumanoidRootPart
            Character:PivotTo(areaTeleport.CFrame + areaTeleport.CFrame.UpVector * (Humanoid.HipHeight + HumanoidRootPart.Size.Y / 2))
            Library.Network.Fire("Performed Teleport", area)
            task.wait(0.25)
        end
end
function deletepets(pets)
    Invoke("Delete Several Pets", pets)
end
function buyegg(eggname, mode)
    if mode == 1 then
	Invoke("Buy Egg", eggname)
    end
    if mode == 3 then
	Invoke("Buy Egg", eggname, 1)
    end
    if mode == 8 then
	Invoke("Buy Egg", eggname, 1, 1)
    end
end

function getcoins()
    coins = Invoke("Get Coins")
    frcoins = {}
    for coinid, coin in pairs(coins) do
        frcoins[coinid] = {
            Type = coin.n,
            Health = coin.h,
            Maxhealth = coin.mh,
            Area = coin.a
        }
    end
    return frcoins
end
function getequipped()
    equipped = Library.Save.Get().PetsEquipped
    frequip = {}
    for petid, _ in pairs(equipped) do table.insert(frequip, petid) end
    return frequip
end
function attackcoin(coinid,pets)
    local v86 = Invoke("Join Coin", coinid, pets)
    for v88, v89 in pairs(v86) do
        Fire("Farm Coin", coinid, v88);
    end
end
function equippet(petuid)
    Invoke("Equip Pet", petuid)
end
function unequippet(petuid)
    Invoke("Unequip Pet", petuid)
end
function equipstrongestpets()
    Invoke("Equip Best Pets")
end
function unequipallpets()
    Invoke("Unequip All Pets")
end
function get_all_worlds()
    worldspath = game:GetService("ReplicatedStorage")["__DIRECTORY"].Worlds
    worldstable = {}
    for _, world in pairs(worldspath:GetChildren()) do
        pcall(function()
            wdata = require(world)
            for worldname, _ in pairs(wdata) do
                if not _.disabled then 
                    worldstable[worldname] = {Currency = _.mainCurrency}
                end
            end
        end)
    end
    return worldstable
end
function get_all_areas_in_world(world_name)
    areaspath = game:GetService("ReplicatedStorage")["__DIRECTORY"].Areas
    areastable = {}
    for _, world in pairs(areaspath:GetChildren()) do
        if string.find(world.Name, world_name) then
            areadata = require(world)
            for areaName, areaData in pairs(areadata) do
                if not areaData.hidden then
                    areastable[areaName] = nil
                    pcall(function()
			areastable[areaName] = {Cost = areaData.gate.cost, Currency = areaData.gate.currency}
		    end)
                end
            end
        end
    end
    return areastable
end
function wait_until_destroyed(coinId)
    while true do
        local coins = getcoins()
        if not coins[coinId] then
            break
        end
	wait()
    end
end
function get_currency(name)
    savedata = Library.Save.Get()
    return savedata[name]
end
function buy_area(area_name)
    Invoke("Buy Area", area_name)
end
function has_area(area_name)
    unlockedtable = Library.Save.Get().AreasUnlocked
    found = false
    for _, area in pairs(unlockedtable) do if area == area_name then found = true break end end
    return found
end
function send_mail(recipient, gems, pet, message)
    Invoke("Send Mail", {
        ["Recipient"] = recipient,
        ["Diamonds"] = gems,
        ["Pets"] = {pet},
        ["Message"] = message
    })
end
function claim_all_mail()
    Invoke("Claim All Mail")
end	
function get_all_mail()
    mail = Invoke("Get Mail")
    return mail.Inbox
end
function get_comets()
    return Invoke("Comets: Get Data")
end
function bank_deposit(bankUID, gems, pets)
    Invoke("Bank Deposit", bankUID, pets, gems)
end
function bank_withdraw(bankUID, gems, pets)
    Invoke("Bank Withdraw", bankUID, pets, gems)
end
function leave_bank(bankUID)
    Invoke("Leave Bank", bankUID)
end
function accept_bank_invite(bankUID)
    Invoke("Accept Bank Invite", bankUID)
end
function decline_bank_invite(bankUID)
    Invoke("Decline Bank Invite", bankUID)
end
function get_all_bank_invites()
    return Invoke("Get Bank Invites")
end
function get_my_banks()
    return Invoke("Get My Banks")
end
function get_bank_data(bankUID)
    return Invoke("Get Bank", bankUID).Storage
end
function invite_to_bank(bankUID, userid)
    Invoke("Invite To Bank", bankUID, userid)
end
function get_all_eggs()
    freggs = {}
    for i,v in pairs(game:GetService("ReplicatedStorage")["__DIRECTORY"].Eggs:GetChildren()) do
        if v:IsA("Folder") then
            for _, egg in pairs(v:GetChildren()) do
                pcall(function()
                    eggData = require(egg[egg.Name])
                    if not eggData.disabled and eggData.hatchable then
                        freggs[egg.Name] = {Price = eggData.cost, Currency = eggData.currency, Area = eggData.area, Drops = eggData.drops}
                    end
                end)
            end
        end
    end
    return freggs
end
function get_pet_data_by_uid(uid)
    local petCMDs = require(game.ReplicatedStorage.Library.Client.PetCmds)
    data = petCMDs.Get(uid)
    Varient = "Normal"
        if data.g then Varient = "Golden" end
        if data.r then Varient = "Rainbow" end
        if data.dm then Varient = "Dark Matter" end
    realdata = {
        Name = GetPetDataById(data.id).name,
        Rarity = GetPetDataById(data.id).rarity,
        Nickname = data.nk,
        Variant = Varient,
    Strength = data.s,
        Enchants = data.powers
    }
    return realdata
end
function get_all_booths()
    return Invoke("Get All Booths")
end
function buy_booth_pet(boothid, petuid, price)
    boothid = tonumber(boothid)
    Invoke("Purchase Trading Booth Pet", boothid, petuid, price)
end
function teleport_to_booth(owner_user_id)
    username = game.Players:GetNameFromUserIdAsync(tonumber(owner_user_id))
    booths = game:GetService("Workspace").__MAP.Interactive.Booths:GetChildren()
    for i,booth in pairs(booths) do
        usertext = booth.Info.SurfaceGui.Frame.Top.Text
        boothpos = booth.Info.CFrame
        boothuser = string.match(usertext, "(.-)'")
		print(boothuser)
        if username == boothuser then
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = boothpos
        end
    end
    return nil
end
function serverhop(min, max)
	local function getServerIDs(minPlayers, maxPlayers)
	    local apiUrl = "https://games.roblox.com/v1/games/[GAME_ID]/servers/Public?sortOrder=Asc&limit=100"
	    local gameID = game.PlaceId
	    local serverIDs = {}
	    local nextPageCursor = ""
	    local stopSearching = false
	    
	    repeat
	        local url = apiUrl:gsub("%[GAME_ID%]", gameID)
	        if nextPageCursor ~= "" then
	            url = url .. "&cursor=" .. nextPageCursor
	        end
	        local response = game:HttpGetAsync(url)
	        local json = game.HttpService:JSONDecode(response)
	        
	        for _, server in ipairs(json.data) do
	            local playerCount = server.playing
	            if playerCount >= minPlayers and playerCount <= maxPlayers then
	                table.insert(serverIDs, server.id)
	            elseif playerCount > maxPlayers then
	                stopSearching = true
	                break
	            end
	        end
	        
	        nextPageCursor = json.nextPageCursor
	    until nextPageCursor == nil or stopSearching
	    
	    return serverIDs
	end
	
	function ServerHop(ServerList)
	    oldJob = game.JobId
	    while 1 do
	        game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, ServerList[math.random(1, #ServerList)], game.Players.LocalPlayer)
	        task.wait(1)
	        if oldJob ~= game.JobId then break end
	    end
	end
	
	local servers = getServerIDs(min, max)
	ServerHop(servers)
end
