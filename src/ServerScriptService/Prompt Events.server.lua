local ProximityPromptService = game:GetService("ProximityPromptService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")
local Debris = game:GetService("Debris")
local ServerScriptService = game:GetService("ServerScriptService")
local Teams = game:GetService("Teams")
local TweenService = game:GetService("TweenService")

local ButtonPress = ReplicatedStorage:WaitForChild("ButtonPress")
local DataTransfer = ServerScriptService:FindFirstChild("DataTransfer")
local Event = ReplicatedStorage:WaitForChild("Event")
local PhaseShifted = ReplicatedStorage:WaitForChild("PhaseShifted")
local AllDied = ServerScriptService:WaitForChild("AllDied")
local Suicide = ServerScriptService:WaitForChild("Suicide")
local cannonRequest = ServerScriptService:WaitForChild("CannonRequest")
local CannonFire = ReplicatedStorage:WaitForChild("CannonFire")
local Music = ReplicatedStorage:WaitForChild("Music")

local PlayersInParty = {}
local ReadyCount = 0
local isBattleOccuring = false
local activatecannon = false

local function transition(player, duration, transparency)
	local Frame = player.PlayerGui.Flashes.Frame

	Frame.BackgroundColor3 = Color3.new(0.164706, 0.164706, 0.164706)
	TweenService:Create(Frame, TweenInfo.new(duration, Enum.EasingStyle.Quint), {BackgroundTransparency = transparency}):Play()
end

local function onPromptTriggered(promptObject, player)
	if promptObject.Parent.Name == "Party Enter" and not player.Character:FindFirstChild("Humanoid").Sit and not isBattleOccuring then
		
		local Slots = promptObject.Parent.Parent.Parent:FindFirstChild("Slots")
		local SlotsData = {
			Slots:FindFirstChild("Slot1"),
			Slots:FindFirstChild("Slot2"),
			Slots:FindFirstChild("Slot3"),
			Slots:FindFirstChild("Slot4"),
			Slots:FindFirstChild("Slot5"),
			Slots:FindFirstChild("Slot6"),
			Slots:FindFirstChild("Slot7"),
			Slots:FindFirstChild("Slot8"),
			Slots:FindFirstChild("Slot9")
		}
		
		for i = 1, #SlotsData do
			local occupied = SlotsData[i].Occupant
			
			if occupied == nil then
				SlotsData[i]:Sit(player.Character:FindFirstChild("Humanoid"))
				player.Character:FindFirstChild("Humanoid").JumpPower = 0
				table.insert(PlayersInParty, player)
				print(PlayersInParty[#PlayersInParty].Character.Name .. " joined the party")
				break
			else	
				print("slot occupied")
			end
		end
		
		local readyGUI = player.PlayerGui.PartyReady
		readyGUI.Enabled = true
		
		for i = 1, #PlayersInParty do
			PlayersInParty[i].PlayerGui.PartyReady:FindFirstChild("Frame"):FindFirstChild("ReadyAmount"):FindFirstChild("TextLabel").Text = tostring(ReadyCount) .. "/" .. tostring(#PlayersInParty)
			PlayersInParty[i].PlayerGui.PartyReady:FindFirstChild("Frame"):FindFirstChild("Countdown"):FindFirstChild("TextLabel").Text = "Waiting for players..."
		end
	end
	
	if promptObject.Parent.Name == "Party Exit" and player.Character:FindFirstChild("Humanoid").Sit then
		local Slots = promptObject.Parent.Parent.Parent:FindFirstChild("Slots")
		local SlotsData = {
			Slots:FindFirstChild("Slot1"),
			Slots:FindFirstChild("Slot2"),
			Slots:FindFirstChild("Slot3"),
			Slots:FindFirstChild("Slot4"),
			Slots:FindFirstChild("Slot5"),
			Slots:FindFirstChild("Slot6"),
			Slots:FindFirstChild("Slot7"),
			Slots:FindFirstChild("Slot8"),
			Slots:FindFirstChild("Slot9")
		}
		
		local playerSeat = nil
		
		for i = 1, #SlotsData do
			if SlotsData[i].Occupant ~= nil then
				if SlotsData[i].Occupant.Parent.Name == player.Character.Name then
					playerSeat = SlotsData[i]
				end
			end
		end
		
		player.Character:FindFirstChild("Humanoid").JumpPower = 40
		playerSeat:FindFirstChild("SeatWeld"):Destroy()
		
		player.Character:FindFirstChild("Humanoid"):SetAttribute("Ready", false)
		ReadyCount = 0
		
		local index = table.find(PlayersInParty, player)
		table.remove(PlayersInParty, index)
		
		for i = 1, #PlayersInParty do
			PlayersInParty[i].PlayerGui.PartyReady:FindFirstChild("Frame"):FindFirstChild("ReadyAmount"):FindFirstChild("TextLabel").Text = tostring(ReadyCount) .. "/" .. tostring(#PlayersInParty)
			PlayersInParty[i].Character:FindFirstChild("Humanoid"):SetAttribute("Ready", false)
		end
		local readyGUI = player.PlayerGui.PartyReady
		readyGUI.Enabled = false
		
		wait(0.1)
		
		player.Character:MoveTo(promptObject.Parent.Parent:FindFirstChild("Exit Point").Position)
	end
	
	if promptObject.Parent.Name == "Root" then
		game.Workspace:FindFirstChild("Londinium Industrial District"):FindFirstChild("Arena"):FindFirstChild("Invisible Walls").CanCollide = true
		local BossModel = ReplicatedStorage:FindFirstChild("Boss"):Clone()
		BossModel.Parent = workspace
		BossModel:MoveTo(game.Workspace:FindFirstChild("Londinium Industrial District"):FindFirstChild("Arena"):FindFirstChild("Boss Position").Position)
		
		for i = 1, #PlayersInParty do
			if (PlayersInParty[i].Character:FindFirstChild("HumanoidRootPart").Position - promptObject.Parent.Position).Magnitude < 200 then
				PlayersInParty[i].PlayerGui.BossStats.Enabled = true
				Music:FireClient(PlayersInParty[i], "boss1")
			end
		end
		
		Debris:AddItem(promptObject.Parent.Parent, 1)
		Debris:AddItem(game.Workspace:FindFirstChild("Teekaz Root"), 1)
		
		activatecannon = true
		local EnableCannonGui = Teams:FindFirstChild("InBattle"):GetPlayers()
		for i = 1, #EnableCannonGui do
			EnableCannonGui[i].PlayerGui.BossStats:FindFirstChild("Cannon Frame"):FindFirstChild("Cannon Bar"):FindFirstChild("LocalScript").Enabled = true
			CannonFire:FireClient(EnableCannonGui[i])
		end
		
		while activatecannon do
			task.wait(7.5)
			if activatecannon then
				local targets = Teams:FindFirstChild("InBattle"):GetPlayers()
				local target = targets[math.random(1, #targets)]
				local cannon = ServerStorage:FindFirstChild("Cannon Area"):Clone()
				cannon.Parent = workspace
				cannon.WarningRing1.Position = Vector3.new(target.Character.HumanoidRootPart.Position.X, -2, target.Character.HumanoidRootPart.Position.Z)
				cannon.WarningRing2.Position = Vector3.new(0, -20, 0)
			end
			task.wait(7.5)
			task.wait(2)
		end

	end
end

local function onPromptHoldBegan(promptObject, player)
	
end

local function onPromptHoldEnded(promptObject, player)
	
end

local function pressedButton(player, boolean)
	local index = table.find(PlayersInParty, player)
	
	if index ~= nil then
		if not boolean then
			ReadyCount = ReadyCount + 1
			player.Character:FindFirstChild("Humanoid"):SetAttribute("Ready", true)
		else
			ReadyCount = ReadyCount - 1
			player.Character:FindFirstChild("Humanoid"):SetAttribute("Ready", false)
		end
		
		for i = 1, #PlayersInParty do
			PlayersInParty[i].PlayerGui.PartyReady:FindFirstChild("Frame"):FindFirstChild("ReadyAmount"):FindFirstChild("TextLabel").Text = tostring(ReadyCount) .. "/" .. tostring(#PlayersInParty)
		end
		
		if ReadyCount == #PlayersInParty then
			startMatchCountdown(player)
		end
	end
end

function startMatchCountdown(player)
	local count = 3
	while count >= 0 do
		if ReadyCount == #PlayersInParty and #PlayersInParty ~= 0 then
			
			for i = 1, #PlayersInParty do
				PlayersInParty[i].PlayerGui.PartyReady:FindFirstChild("Frame"):FindFirstChild("Countdown"):FindFirstChild("TextLabel").Text = tostring(count)
			end
			count = count - 1
			
			if count == 0 then
				print("telelporting...")
				
				local Slots = game.Workspace:FindFirstChild("Party"):FindFirstChild("Slots")
				local SlotsData = {
					Slots:FindFirstChild("Slot1"),
					Slots:FindFirstChild("Slot2"),
					Slots:FindFirstChild("Slot3"),
					Slots:FindFirstChild("Slot4"),
					Slots:FindFirstChild("Slot5"),
					Slots:FindFirstChild("Slot6"),
					Slots:FindFirstChild("Slot7"),
					Slots:FindFirstChild("Slot8"),
					Slots:FindFirstChild("Slot9")
				}
				
				for i = 1, #PlayersInParty do
					local playerSeat = nil

					for j = 1, #SlotsData do
						if SlotsData[j].Occupant ~= nil then
							if SlotsData[j].Occupant.Parent.Name == PlayersInParty[i].Character.Name then
								playerSeat = SlotsData[j]
							end
						end
					end

					PlayersInParty[i].Character:FindFirstChild("Humanoid").JumpPower = 40
					playerSeat:FindFirstChild("SeatWeld"):Destroy()
					PlayersInParty[i].Character:FindFirstChild("Humanoid"):SetAttribute("Ready", false)
					transition(PlayersInParty[i], 0.8, 0)
					wait(0.3)
					PlayersInParty[i].Character:MoveTo(game.Workspace:FindFirstChild("Londinium Industrial District"):FindFirstChild("Spawn In").Position)
					PlayersInParty[i].PlayerGui.PartyReady.Enabled = false
					PlayersInParty[i].TeamColor = BrickColor.new("Crimson")
					task.wait(0.5)
					transition(PlayersInParty[i], 1, 1)
				end
				isBattleOccuring = true
				
				local SummonStand = ReplicatedStorage:FindFirstChild("Summon Stand"):Clone()
				SummonStand.Parent = workspace
				SummonStand:SetPrimaryPartCFrame(game.Workspace:FindFirstChild("Londinium Industrial District"):FindFirstChild("Arena"):FindFirstChild("Stand Position").CFrame * CFrame.new(0, 4.2, 0) * CFrame.Angles(0, math.rad(-90), 0))
				local TeekazRoot = ServerStorage:FindFirstChild("Teekaz Root"):Clone()
				TeekazRoot.Parent = workspace
				TeekazRoot:SetPrimaryPartCFrame(SummonStand:FindFirstChild("Root").CFrame)
				ReadyCount = 0
			end
		else
			for i = 1, #PlayersInParty do
				PlayersInParty[i].PlayerGui.PartyReady:FindFirstChild("Frame"):FindFirstChild("Countdown"):FindFirstChild("TextLabel").Text = "Waiting for players..."
			end
			count = -2
		end
		wait(1)
	end
end

DataTransfer.OnInvoke = function()
	local returnedTable = table.clone(PlayersInParty)
	table.clear(PlayersInParty)
	return returnedTable
end

Event.Event:Connect(function(TableOfPlayers)
	activatecannon = false
	for i = 1, #TableOfPlayers do
		PhaseShifted:FireClient(TableOfPlayers[i], 0)
		Music:FireClient(TableOfPlayers[i], "end")
		TableOfPlayers[i].PlayerGui.BossStats:FindFirstChild("Health Frame"):FindFirstChild("Health Bar"):FindFirstChild("LocalScript").Enabled = false
		TableOfPlayers[i].PlayerGui.BossStats:FindFirstChild("Cannon Frame"):FindFirstChild("Cannon Bar"):FindFirstChild("LocalScript").Enabled = false
		TableOfPlayers[i].PlayerGui.BossStats.Enabled = false
		TableOfPlayers[i].Character:MoveTo(game.Workspace:FindFirstChild("Lobby Spawn").Position)
		TableOfPlayers[i].TeamColor = BrickColor.new("White")
	end
		
	isBattleOccuring = false
	game.Workspace:FindFirstChild("Londinium Industrial District"):FindFirstChild("Arena"):FindFirstChild("Invisible Walls").CanCollide = false
		
	task.wait(0.5)
		
	if game.Workspace:FindFirstChild("sanguinarchFolder") then
		game.Workspace:FindFirstChild("sanguinarchFolder"):Destroy()
	end

end)

AllDied.Event:Connect(function()
	isBattleOccuring = false
	game.Workspace:FindFirstChild("Londinium Industrial District"):FindFirstChild("Arena"):FindFirstChild("Invisible Walls").CanCollide = true
end)

Suicide.Event:Connect(function(player)
	if player.Team == Teams:FindFirstChild("InBattle") then
		local index = table.find(PlayersInParty, player)
		if index ~= nil then
			table.remove(PlayersInParty, index)
		end
		task.wait(0.5)
		local team = Teams:FindFirstChild("InBattle"):GetPlayers()
		if #team == 0 or team == nil then
			print("this is working")
			table.clear(PlayersInParty)
			if game.Workspace:FindFirstChild("Summon Stand") ~= nil then
				game.Workspace:FindFirstChild("Summon Stand"):Destroy()
				game.Workspace:FindFirstChild("Teekaz Root"):Destroy()
			end
			isBattleOccuring = false
		end
		table.clear(PlayersInParty)
		
	end
end)


ProximityPromptService.PromptTriggered:Connect(onPromptTriggered)
ProximityPromptService.PromptButtonHoldBegan:Connect(onPromptHoldBegan)
ProximityPromptService.PromptButtonHoldEnded:Connect(onPromptHoldEnded)

ButtonPress.OnServerEvent:Connect(pressedButton)