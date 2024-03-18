local Character = script.Parent
local Humanoid = Character.Humanoid
local HumanoidRootPart = Humanoid.Parent:WaitForChild("HumanoidRootPart")

local currentAnimTrack = nil
local Run = script:WaitForChild("Run")
local Crouch = script:WaitForChild("Crouch")
local Walk = script:WaitForChild("Walk")
local Idle = script:WaitForChild("Idle")
local Heal = script:WaitForChild("Heal")
local Block = script:WaitForChild("Block")
local Stun = script:WaitForChild("Stun")
local Sword1 = script:WaitForChild("Sword slash 1")

local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local Debris = game:GetService("Debris")
local StarterGUI = game:GetService("StarterGui")
local ServerScriptService = game:GetService("ServerScriptService")

local HealthUpdate = ReplicatedStorage:WaitForChild("HealthUpdate")
local BlockStatus = ReplicatedStorage:WaitForChild("BlockStatus")
local ShieldUpdate = ReplicatedStorage:WaitForChild("ShieldUpdate")
local SwordFired = ReplicatedStorage:WaitForChild("SwordFired")
local ManaEnabled = ReplicatedStorage:WaitForChild("ManaEnabled")
local Healing = ReplicatedStorage:WaitForChild("Healing")

local BindableEvent = ReplicatedStorage:WaitForChild("Event")

Humanoid.WalkSpeed = 5

local isRunning = false
local isHealing = false
local isAttacking = false
local isBlocking = false
local isStunned = false
local isCrouching = false
local isRecovering = false

local Players = game:GetService("Players")
local player = Players.LocalPlayer
local mouse = player:GetMouse()

local blade = Character:FindFirstChild("Sword"):FindFirstChild("Sword")
local swordTrail = blade:FindFirstChild("Trail")
local ManaAura = script.Parent:FindFirstChild("Head"):FindFirstChild("Mana Aura"):FindFirstChild("ParticleEmitter")
local Light = game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart"):FindFirstChild("PointLight")

local Damage = Humanoid:GetAttribute("Damage")
local Defence = Humanoid:GetAttribute("Defence")
local MaxShield = Humanoid:GetAttribute("MaxShield")
local AttackSpeed = Humanoid:GetAttribute("AttackSpeed")

local HumanoidWalkSpeed = 5
local HumanoidRunSpeed = 15

local DashTime = 0.150
local Amount = 50
local MaxForce = Vector3.new(math.huge, math.huge, math.huge)
local P = 100
local Cooldown = false
local CooldownTime = 2


---------------------------------------------------------------------------------(resetting boss gui)

game.Players.LocalPlayer.PlayerGui.BossStats:FindFirstChild("Health Frame"):FindFirstChild("Health Bar"):FindFirstChild("LocalScript").Enabled = false
game.Players.LocalPlayer.PlayerGui.BossStats.Enabled = false

---------------------------------------------------------------------------------(disable default gui's)

--StarterGUI:SetCoreGuiEnabled(Enum.CoreGuiType.All, false)

---------------------------------------------------------------------------------(playing animations code block)

function playAnimation(humanoid, animation)
	if currentAnimTrack ~= nil then
		currentAnimTrack:Stop()
	end
	currentAnimTrack = humanoid:LoadAnimation(animation)
	currentAnimTrack:Play()
end

---------------------------------------------------------------------------------(player movement related code)

function onRunning(speed)
	if not isAttacking and not isHealing and not isBlocking and not isCrouching and not isStunned then
		if speed > 0.1 then
			if isCrouching then
				if isRunning then
					playAnimation(Humanoid, Run)
				else
					playAnimation(Humanoid, Walk)
				end
			else
				if isRunning then
					playAnimation(Humanoid, Run)
				else
					playAnimation(Humanoid, Walk)
				end
			end
		else
			if isCrouching then
				playAnimation(Humanoid, Idle)
			end
		end
	end
end

function onJumping()
	
end

function onFallingDown()
	
end

function onDied()
	
end

---------------------------------------------------------------------------(healing code block)

local healCooldown = true
local attackCooldown = true

local potionHolder = Character:FindFirstChild("Left Arm"):FindFirstChild("Potion"):FindFirstChild("Holder") --potentially move this entire block into a remote event so everyone can see it
local Base = potionHolder:FindFirstChild("Base")
local Cork = potionHolder:FindFirstChild("Cork")
local Liquid = potionHolder:FindFirstChild("Liquid")
local Neck = potionHolder:FindFirstChild("Neck")
local Rim = potionHolder:FindFirstChild("Rim")

function healPlayer()
	Healing:FireServer(Humanoid, Base, Cork, Liquid, Neck, Rim, 0.7, 0.5, 0)
	
	playAnimation(Humanoid, Heal)
	task.wait(1)
	HealthUpdate:FireServer(Humanoid, -1000)
	task.wait(0.5)
	
	Healing:FireServer(Humanoid, Base, Cork, Liquid, Neck, Rim, 1, 1, 1)
	
	Humanoid.WalkSpeed = HumanoidWalkSpeed
	isHealing = false
end

------------------------------------------------------------------------------(input begun code block)

UserInputService.InputBegan:Connect(function(input, gameProcessedEvent)
	if not isStunned then
		
		if input.KeyCode == Enum.KeyCode.LeftShift and not isHealing and not isAttacking then
			isRunning = true
			
			if not isCrouching and not isAttacking and not isBlocking then
				Humanoid.WalkSpeed = HumanoidRunSpeed
				Humanoid:SetAttribute("StaminaDrain", true)
			end
		end

		if input.KeyCode == Enum.KeyCode.C and not isHealing and not isAttacking and not isBlocking then
			isCrouching = true
			Humanoid.WalkSpeed = 1
			playAnimation(Humanoid, Crouch)
		end
		
		if input.KeyCode == Enum.KeyCode.E and not isCrouching and not isAttacking and not isBlocking then
			if healCooldown then
				isHealing = true
				healCooldown = false
				Humanoid.WalkSpeed = 0.5
				healPlayer()
				BindableEvent:Fire("Heal", 5)
				task.wait(5)
				healCooldown = true
			end
		end
		
		if input.KeyCode == Enum.KeyCode.F and not isCrouching and not isHealing then
			if Humanoid:GetAttribute("Stamina") >= 15 and not Cooldown then
				Cooldown = true
				Humanoid:SetAttribute("Stamina", Humanoid:GetAttribute("Stamina") - 15)
				
				local BodyVelocity = Instance.new("BodyVelocity")
				BodyVelocity.Parent = script.Parent:FindFirstChild("Torso")
				BodyVelocity.P = P
				BodyVelocity.MaxForce = MaxForce
				BodyVelocity.Velocity = Humanoid.MoveDirection * Amount
				script:FindFirstChild("Dash"):Play()

				Debris:AddItem(BodyVelocity, DashTime)

				local startTime = tick()
				local condition = true

				while condition do
					local PlayerBody = ReplicatedStorage:FindFirstChild("Shadow"):Clone()
					PlayerBody.Parent = workspace
					PlayerBody:SetPrimaryPartCFrame(HumanoidRootPart.CFrame)
					Debris:AddItem(PlayerBody, 0.5)

					local endTime = tick()
					if endTime - startTime >= DashTime then
						condition = false
					end
					task.wait(0.05)
				end
				
				BindableEvent:Fire("Dash", CooldownTime)
				task.wait(CooldownTime)
				Cooldown = false
			end
		end
		
		if input.KeyCode == Enum.KeyCode.R then
			if Humanoid:GetAttribute("Mana") >= 10 then
				ManaAura.Enabled = true
				ManaEnabled:FireServer(Humanoid, ManaAura, Light, true)
				Humanoid:SetAttribute("ManaDrain", true)
			end
		end
	end
end)

-----------------------------------------------------------------------------------(input ended code block)

UserInputService.InputEnded:Connect(function(input, gameProcessedEvent) 
	if not isStunned then	--may cause a problem in the future
		if input.KeyCode == Enum.KeyCode.LeftShift then
			Humanoid:SetAttribute("StaminaDrain", false)
			if not isHealing and not isBlocking and not isAttacking then
				isRunning = false
				Humanoid.WalkSpeed = 5
				playAnimation(Humanoid, Idle)
			end
		end

		if input.KeyCode == Enum.KeyCode.C and isCrouching and not isHealing and not isBlocking and not isAttacking then
			playAnimation(Humanoid, Idle)
			if not isRunning then
				Humanoid.WalkSpeed = 5
			else
				Humanoid.WalkSpeed = HumanoidRunSpeed
			end
			isCrouching = false
		end
	end
end)

-----------------------------------------------------------------------------------(sword attacks code block)

function onButton1Down()
	if attackCooldown and not isHealing and not isStunned then
		isAttacking = true
		local pastSpeed = Humanoid.WalkSpeed
		Humanoid.WalkSpeed = 5
		
		swordTrail.Enabled = true
		attackCooldown = false
		playAnimation(Humanoid, Sword1)
		if ManaAura.Enabled == true then
			script.Cast:Play()
			Humanoid:SetAttribute("ManaDrain", false)
			if Humanoid:GetAttribute("Mana") - 20 < 0 then
				Humanoid:SetAttribute("Mana", 0)
			else	
				Humanoid:SetAttribute("Mana", Humanoid:GetAttribute("Mana") - 20)--make damage based off of quantity of mana, with it exponentially increasing
			end
			task.wait(0.5)
			SwordFired:FireServer(Humanoid, HumanoidRootPart)
			ManaEnabled:FireServer(Humanoid, ManaAura, Light, false)
			ManaAura.Enabled = false
			script:FindFirstChild("Swish"):Play()
		else
			task.wait(0.4)
			script:FindFirstChild("Swish"):Play()
		end
		task.wait(AttackSpeed - 0.4)
		isAttacking = false
		attackCooldown = true
		swordTrail.Enabled = false
		
		if isBlocking then
			Humanoid.WalkSpeed = 1
		elseif isRunning then
			Humanoid.WalkSpeed = HumanoidRunSpeed
			playAnimation(Humanoid, Run)
		elseif Humanoid.Parent:FindFirstChild("HumanoidRootPart").Velocity.Magnitude > 0 then
			Humanoid.WalkSpeed = 5
			playAnimation(Humanoid, Walk)
		else	
			Humanoid.WalkSpeed = pastSpeed
			playAnimation(Humanoid, Idle)
		end
	end
end

function onButton2Down()
	if not isHealing and not isStunned and not isCrouching then
		Humanoid.WalkSpeed = 1
		isBlocking = true
		playAnimation(Humanoid, Block)
		BlockStatus:FireServer(Humanoid, true)
	end
end

function onButton2Up()
	if not isHealing and not isStunned and not isCrouching then
		playAnimation(Humanoid, Idle)
		if not isRunning then
			Humanoid.WalkSpeed = 5
			playAnimation(Humanoid, Idle)
		else
			Humanoid.WalkSpeed = HumanoidRunSpeed
			playAnimation(Humanoid, Run)
		end
		isBlocking = false
		BlockStatus:FireServer(Humanoid, false)
	end
end

local shieldIsUpdating = false

Humanoid:GetAttributeChangedSignal("shieldStrength"):Connect(function()
	if Humanoid:GetAttribute("shieldStrength") <= 0 and not isStunned then
		isStunned = true
		isBlocking = false
		BlockStatus:FireServer(Humanoid, false)
		playAnimation(Humanoid, Stun)
	end
	
	if isStunned and not isRecovering then
		isRecovering = true
		task.wait(10)
		isStunned = false
		playAnimation(Humanoid, Idle)
		ShieldUpdate:FireServer(Humanoid, MaxShield)
		isRecovering = false
	else
		if not shieldIsUpdating and not isStunned and not isRecovering then
			shieldIsUpdating = true
			task.wait(10)
			if not isStunned then
				ShieldUpdate:FireServer(Humanoid, MaxShield)
			end
			shieldIsUpdating = false
		end
	end
end)

Humanoid:GetAttributeChangedSignal("Stamina"):Connect(function()
	if Humanoid:GetAttribute("Stamina") <= 0 then
		isRunning = false
		Humanoid:SetAttribute("StaminaDrain", false)
		if not isStunned and not isAttacking and not isCrouching and not isBlocking and not isHealing then
			Humanoid.WalkSpeed = 5
			playAnimation(Humanoid, Walk)
		end
	end
end)

-------------------------------------------------------------------------(damage code block)

local function GetFirstParent(Part)
	local Parent = Part.Parent
	repeat
		if Parent.Parent ~= workspace or Parent.Parent ~= game then
			Parent = Parent.Parent
		end
	until Parent.Parent == nil or Parent.Parent.Name == "sanguinarchFolder" or Parent.Parent == workspace
	return Parent
end

local function checkName(object)
	local isPlayer = false
	for _, Player in pairs(game:GetService("Players"):GetChildren()) do
		if object.Name == Player.Character.Name then
			isPlayer = true
			break
		end
	end
	return isPlayer
end

function onTouched(object)
	if isAttacking then
		local objectParent = GetFirstParent(object)
		if objectParent:FindFirstChildWhichIsA("Humanoid") and objectParent:FindFirstChild("Humanoid"):GetAttribute("Entity") == "Enemy" then
			isAttacking = false
			local enemyHumanoid = objectParent:FindFirstChild("Humanoid")
			
			local enemyDefence = enemyHumanoid:GetAttribute("Defence")
			if Damage - enemyDefence > 0 then
				HealthUpdate:FireServer(enemyHumanoid, Damage - enemyDefence)
			end
		end
	end
end

------------------------------------------------------------------------(event handlers)

Humanoid.Running:connect(onRunning)
Humanoid.Jumping:connect(onJumping)
Humanoid.FallingDown:connect(onFallingDown)
Humanoid.Died:connect(onDied)

mouse.Button1Down:Connect(onButton1Down)
mouse.Button2Down:Connect(onButton2Down)
mouse.Button2Up:Connect(onButton2Up)

blade.Touched:Connect(onTouched)

playAnimation(Humanoid, Idle)
