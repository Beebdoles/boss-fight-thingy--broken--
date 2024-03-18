task.wait(3)

local RunService = game:GetService("RunService")
local PathFindingService = game:GetService("PathfindingService")
local ServerStorage = game:GetService("ServerStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Debris = game:GetService("Debris")

local Range = 1000
local BossHumanoid = script.Parent:WaitForChild("Humanoid")
local BossHumanoidRootPart = script.Parent:WaitForChild("HumanoidRootPart")
local BossLeftArm = script.Parent:WaitForChild("Left Arm")

local DataTransfer = ServerScriptService:WaitForChild("DataTransfer")
local PhaseShifted = ReplicatedStorage:WaitForChild("PhaseShifted")
local Event = ReplicatedStorage:WaitForChild("Event")
local AllDied = ServerScriptService:WaitForChild("AllDied")
local MinionTable = ServerScriptService:WaitForChild("MinionTable")
local Music = ReplicatedStorage:WaitForChild("Music")

local BossAttacks = require(script.BossAttacks)
local CurrentBossPosition = BossHumanoidRootPart.Position

BossHumanoidRootPart:SetNetworkOwner(nil)
BossHumanoid:SetAttribute("isReviving", true)

---------------------------------------------------------------------------------------------(determines distance between self and player)

local function CheckDistanceFromSpawn(Player)
	local Character = Player.Character
	local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
	local positionMagnitude = (CurrentBossPosition - HumanoidRootPart.Position).Magnitude
	
	if positionMagnitude <= Range then
		local raycast = Ray.new(BossHumanoidRootPart.Position, (HumanoidRootPart.position - BossHumanoidRootPart.Position).Unit * 5000)
		local Part, Position, Normal = workspace:FindPartOnRay(raycast, script.Parent, false, true)
		if Part.Parent == Character then
			return true
		end
	end
end

---------------------------------------------------------------------------------------------(player list service)

local TableOfPlayers = DataTransfer:Invoke()

for i = 1, #TableOfPlayers do
	TableOfPlayers[i].PlayerGui.BossStats:FindFirstChild("Health Frame"):FindFirstChild("Health Bar"):FindFirstChild("LocalScript").Enabled = true
end

MinionTable.OnInvoke = function()
	return table.clone(TableOfPlayers)
end

---------------------------------------------------------------------------------------------
	
for _, Part in pairs(script.Parent:GetChildren()) do
	if Part:IsA("BasePart") then
		Part.CanCollide = false
	end
end

---------------------------------------------------------------------------------------------(main boss AI)

local BossPhase = 1
local AttackBreak = 0.5
local BossAlive = true

while BossAlive do
	if #TableOfPlayers >= 1 then
		local attackType = math.random(1, 100)
		local Target = nil
		if attackType <= 10 then
			Target = TableOfPlayers[math.random(1, #TableOfPlayers)]
			
			if Target.Character.Humanoid.Health > 0 then
				local dash = BossAttacks.Dash(BossHumanoidRootPart.Position, Target.Character:FindFirstChild("HumanoidRootPart").Position , BossHumanoid, 150)
			else	
				table.remove(TableOfPlayers, table.find(TableOfPlayers, Target))
			end
		else
			local distance = 200
			for i = 1, #TableOfPlayers do
				if TableOfPlayers[i] ~= nil and (CurrentBossPosition - TableOfPlayers[i].Character:FindFirstChild("HumanoidRootPart").Position).Magnitude < distance then
					distance = (CurrentBossPosition - TableOfPlayers[i].Character:FindFirstChild("HumanoidRootPart").Position).Magnitude
					Target = TableOfPlayers[i]
				elseif TableOfPlayers[i] ~= nil and (CurrentBossPosition - TableOfPlayers[i].Character:FindFirstChild("HumanoidRootPart").Position).Magnitude > 300 then
					table.remove(TableOfPlayers, table.find(TableOfPlayers, TableOfPlayers[i]))
				else
					--thing
				end
			end
		end
		if Target ~= nil then
			local Player = Target
			local DistanceResult = CheckDistanceFromSpawn(Player)
			if DistanceResult == true then
				if Player.Character.Humanoid.Health <= 0 then
					table.remove(TableOfPlayers, table.find(TableOfPlayers, Player))
				else	
					local ReturnedMatchState
					local distanceFromPlayer = (BossHumanoidRootPart.Position - Player.Character:FindFirstChild("HumanoidRootPart").Position).Magnitude

					if BossPhase == 1 then
						if distanceFromPlayer > 8 then
							local randomAttack = math.random(1, 100)
							
							if randomAttack < 41 then
								ReturnedMatchState = BossAttacks.Dash(BossHumanoidRootPart.Position, Player.Character:FindFirstChild("HumanoidRootPart").Position , BossHumanoid, 150)
								--task.wait(1.1)
							end
							
							if randomAttack > 40 then
								ReturnedMatchState = BossAttacks.BeamAttack1(Player.Character, BossHumanoid, BossLeftArm)
								--task.wait(0.5)
							end
						else
							local randomAttack = math.random(1, 100)
							
							if randomAttack <= 35 then
								ReturnedMatchState = BossAttacks.SwordSwipe1(Player.Character, BossHumanoidRootPart, BossHumanoid)
								--task.wait(1.4)
							end

							if randomAttack > 35 and randomAttack < 75 then
								ReturnedMatchState = BossAttacks.SwordSwipe2(Player.Character, BossHumanoidRootPart, BossHumanoid)
								--task.wait(0.7)
							end

							if randomAttack >= 75 then
								ReturnedMatchState = BossAttacks.SwordSwipe3(Player.Character, BossHumanoidRootPart, BossHumanoid)
								--task.wait(2.2)
							end
						end
					else
						if distanceFromPlayer > 8 then
							local randomAttack = math.random(1, 100)
							
							if randomAttack <= 10 then
								ReturnedMatchState = BossAttacks.Summon(Player.Character, BossHumanoidRootPart, BossHumanoid)
								
							elseif randomAttack < 36 then
								ReturnedMatchState = BossAttacks.Dash(BossHumanoidRootPart.Position, Player.Character:FindFirstChild("HumanoidRootPart").Position , BossHumanoid, 180)
								--task.wait(1.1)
								
							elseif randomAttack < 90 then
								ReturnedMatchState = BossAttacks.BeamAttack1(Player.Character, BossHumanoid, BossLeftArm)
								--task.wait(0.5)
							else
								ReturnedMatchState = BossAttacks.Cannon(Player, BossHumanoid)
								
							end
						else
							local randomAttack = math.random(1, 100)

							if randomAttack <= 35 then
								ReturnedMatchState = BossAttacks.SwordSwipe1(Player.Character, BossHumanoidRootPart, BossHumanoid)
								--task.wait(1.4)
							end

							if randomAttack > 35 and randomAttack < 75 then
								ReturnedMatchState = BossAttacks.SwordSwipe2(Player.Character, BossHumanoidRootPart, BossHumanoid)
								--task.wait(0.7)
							end

							if randomAttack >= 75 then
								ReturnedMatchState = BossAttacks.SwordSwipe3(Player.Character, BossHumanoidRootPart, BossHumanoid)
								--task.wait(2.2)
							end
						end
					end
					local playModule = nil
					
					if BossHumanoid.Health == 1 and BossPhase == 1 then
						BossPhase = 2
						BossHumanoid:SetAttribute("isReviving", true)
						for i = 1, #TableOfPlayers do
							PhaseShifted:FireClient(TableOfPlayers[i], 5)
							Music:FireClient(TableOfPlayers[i], "boss2")
						end
						playModule = BossAttacks.Reviving(Player, BossHumanoid)
						task.wait(5)
						BossHumanoid.Health = BossHumanoid.MaxHealth
						BossHumanoid:SetAttribute("isReviving", false)
						AttackBreak = 0.25
						playModule = BossAttacks.Idle(Player, BossHumanoidRootPart, BossHumanoid)
					end
					
					if BossHumanoid.Health == 1 and BossPhase == 2 then
						playModule = BossAttacks.BossDeath(Player.Character, BossHumanoidRootPart, BossHumanoid)
						task.wait(2.1)
						BossAlive = false
					end
				end
			end
		else
			table.remove(TableOfPlayers, table.find(TableOfPlayers, Target))
		end
	else	
		local victory = nil
		victory = BossAttacks.Victory(BossHumanoid)
		BossAlive = false
		AllDied:Fire()
	end
	BossHumanoid:SetAttribute("isReviving", false)
	task.wait(AttackBreak)
end

--------------------------------------------------------------------------------------(end of match cleanup operations)

Event:Fire(table.clone(TableOfPlayers))
print(TableOfPlayers)

task.wait(0.1)

Debris:AddItem(script.Parent, 1)

--------------------------------------------------------------------------------------(minion targets)
