local module = {}
local AttackedPlayersArray = {}
local PlayerIndexCount = 1
local CurrentAnimation = nil
local minionCount = 1

local PathFindingService = game:GetService("PathfindingService")
local TweenService = game:GetService("TweenService")
local Animations = script:WaitForChild("Animations")
local Sounds = script:WaitForChild("Sounds")
local ServerStorage = game:GetService("ServerStorage")
local Debris = game:GetService("Debris")

local ManfredSword = script.Parent.Parent:FindFirstChild("Manfred Sword"):FindFirstChild("Sword")
local ManfredSwordTrail = ManfredSword:FindFirstChild("Trail")

function playAnimation(humanoid, animation)
	if CurrentAnimation ~= nil then
		CurrentAnimation:Stop()
	end
	CurrentAnimation = animation
	CurrentAnimation:Play()
end

local debounce = false

local function flash(colour, duration, player)
	if not debounce then
		local Frame = player.PlayerGui.Flashes.Frame
		
		Frame.BackgroundColor3 = colour
		Frame.BackgroundTransparency = 0.5
		TweenService:Create(Frame, TweenInfo.new(duration, Enum.EasingStyle.Quint), {BackgroundTransparency = 1}):Play()
	end
end

local function damageKnockback(player, i, duration)
	local x = math.random(-100, 100) / i
	local y = math.random(-100, 100) / i
	local z = math.random(-100, 100) / i
	
	local cameraoffset = Vector3.new(x, y, z)
	TweenService:Create(player.Character:FindFirstChild("Humanoid"), TweenInfo.new(duration, Enum.EasingStyle.Circular, Enum.EasingDirection.Out), {CameraOffset = cameraoffset}):Play()
	TweenService:Create(player.Character:FindFirstChild("Humanoid"), TweenInfo.new(duration, Enum.EasingStyle.Circular, Enum.EasingDirection.In), {CameraOffset = Vector3.new(0, 0, 0)}):Play()
end

module.TakeDamage = function(Damage, Range, DamagePart, Player)
	if (DamagePart.Position - Player:FindFirstChild("HumanoidRootPart").Position).magnitude <= Range then
		local Humanoid = Player:FindFirstChild("Humanoid")
		
		if Player:FindFirstChild("Humanoid"):GetAttribute("isBlocking") and Humanoid:GetAttribute("shieldStrength") > 0 then
			Humanoid:SetAttribute("shieldStrength", Humanoid:GetAttribute("shieldStrength") - Damage)
		else
			Humanoid:TakeDamage(Damage)
			flash(Color3.new(0.329412, 0, 0), 0.5, game:GetService("Players"):GetPlayerFromCharacter(Player))
			damageKnockback(game:GetService("Players"):GetPlayerFromCharacter(Player), 1, 0.5)
		end
		Sounds["Manfri Beam"]:Play()
	end
end

module.Dash = function(StartPos, EndPos, Humanoid, DashSpeed)
	local DashStart = Humanoid:LoadAnimation(Animations["Dash Start Boss"])
	local DashEnd = Humanoid:LoadAnimation(Animations["Dash End Boss"])
	
	local defaultSpeed = Humanoid.WalkSpeed
	if DashSpeed then
		Humanoid.WalkSpeed = DashSpeed
	end
	
	ManfredSword:SetAttribute("Damage", 15)
	ManfredSword:SetAttribute("isAttacking", true)
	ManfredSwordTrail.Enabled = true
	
	local path = PathFindingService:CreatePath()
	path:ComputeAsync(StartPos, EndPos)
	
	playAnimation(Humanoid, DashStart)

	for _, Waypoint in pairs(path:GetWaypoints()) do
		Humanoid:MoveTo(Waypoint.Position)
		Humanoid.MoveToFinished:Wait()
	end
	
	playAnimation(Humanoid, DashEnd)
	
	Humanoid.WalkSpeed = defaultSpeed
	
	ManfredSword:SetAttribute("isAttacking", false)
	ManfredSwordTrail.Enabled = false
end

module.SwordSwipe1 = function(Player, BossHumanoidRootPart, BossHumanoid)
	local SwordSwipe1 = BossHumanoid:LoadAnimation(Animations["Sword Swipe 1 Boss"])
	
	BossHumanoidRootPart.CFrame = CFrame.lookAt(BossHumanoidRootPart.Position, Player:FindFirstChild("HumanoidRootPart").Position)
	
	ManfredSword:SetAttribute("Damage", 20)	
	ManfredSword:SetAttribute("isAttacking", true)
	ManfredSwordTrail.Enabled = true
	
	playAnimation(BossHumanoid, SwordSwipe1)
	
	task.wait(1.2)
	ManfredSwordTrail.Enabled = false
	ManfredSword:SetAttribute("isAttacking", false)
end

module.SwordSwipe2 = function(Player, BossHumanoidRootPart, BossHumanoid)
	local SwordSwipe2 = BossHumanoid:LoadAnimation(Animations["Sword Swipe 2 Boss"])

	BossHumanoidRootPart.CFrame = CFrame.lookAt(BossHumanoidRootPart.Position, Player:FindFirstChild("HumanoidRootPart").Position)
	
	ManfredSword:SetAttribute("Damage", 15)
	ManfredSword:SetAttribute("isAttacking", true)
	ManfredSwordTrail.Enabled = true
	
	playAnimation(BossHumanoid, SwordSwipe2)
	
	task.wait(0.6)
	ManfredSword:SetAttribute("Damage", 20)
	ManfredSword:SetAttribute("isAttacking", false)
	ManfredSwordTrail.Enabled = false
end

module.SwordSwipe3 = function(Player, BossHumanoidRootPart, BossHumanoid)
	local SwordSwipe3 = BossHumanoid:LoadAnimation(Animations["Sword Swipe 3 Boss"])

	BossHumanoidRootPart.CFrame = CFrame.lookAt(BossHumanoidRootPart.Position, Player:FindFirstChild("HumanoidRootPart").Position)
	
	ManfredSword:SetAttribute("Damage", 35)
	ManfredSword:SetAttribute("isAttacking", true)
	ManfredSwordTrail.Enabled = true
	
	playAnimation(BossHumanoid, SwordSwipe3)
	
	task.wait(2.1)
	ManfredSword:SetAttribute("Damage", 20)
	ManfredSword:SetAttribute("isAttacking", false)
	ManfredSwordTrail.Enabled = false
end

module.BeamAttack1 = function(Player, BossHumanoid, BossLeftArm)
	local TeekazRoot = ServerStorage["Teekaz Root"]:Clone()
	
	TeekazRoot.Parent = workspace
	TeekazRoot:MoveTo(BossLeftArm.Position + Vector3.new(0, 5, 0))
	
	local attachment0 = Instance.new("Attachment")
	local part0 = Instance.new("Part")
	part0.Size = Vector3.new(0.1, 0.1, 0.1)
	part0.Position = TeekazRoot:FindFirstChild("Flame Portion").Position
	part0.Anchored = true
	part0.Color = Color3.new(0, 0, 0)
	part0.Transparency = 1
	attachment0.Parent = part0
	attachment0.Position = Vector3.new(0, 0, 0)
	local attachment1 = Instance.new("Attachment")
	local part1 = Instance.new("Part")
	part1.Size = Vector3.new(0.1, 0.1, 0.1)
	part1.CFrame = Player:FindFirstChild("HumanoidRootPart").CFrame
	part1.Anchored = true
	part1.Color = Color3.new(0, 0, 0)
	part1.Transparency = 1
	attachment1.Parent = part1
	attachment1.Position = Vector3.new(0, 0, 0)

	local Model = Instance.new("Model")
	Model.Name = "BeamModel"
	Model.Parent = workspace
	part0.Parent = Model
	part1.Parent = Model
	
	local BeamAttack = BossHumanoid:LoadAnimation(Animations["Beam Attack 1 Boss"])
	
	local Beam = Instance.new("Beam")
	Beam.Attachment0 = attachment0
	Beam.Attachment1 = attachment1
	Beam.FaceCamera = true
	Beam.Color = ColorSequence.new(Color3.fromRGB(255, 0, 0),Color3.fromRGB(255, 0, 0))
	Beam.Width0 = 1
	Beam.Width1 = 1
	Beam.Parent = Model
	
	playAnimation(BossHumanoid, BeamAttack)
	
	task.wait(0.05)
	module.TakeDamage(10, 1000, BossHumanoid.Parent:FindFirstChild("HumanoidRootPart"), Player)
	Model:Destroy()
	task.wait(0.1)
	TeekazRoot:Destroy()
end

module.Summon = function(Player, BossHumanoidRootPart, BossHumanoid)
	local Summon = BossHumanoid:LoadAnimation(Animations["Summon Minions"])
	
	local SummonAura = ServerStorage:FindFirstChild("Summon Aura"):Clone()
	SummonAura.Transparency = 1
	SummonAura:FindFirstChild("PointLight").Brightness = 0
	SummonAura.Parent = workspace
	SummonAura.CFrame = CFrame.new(BossHumanoidRootPart.Position) * CFrame.new(0, 2, 0)
	
	local tweenInfo = TweenInfo.new(3)
	local goal11 = {}
	goal11.Transparency = 0
	local goal21 = {}
	goal21.Brightness = 3
	local goal12 = {}
	goal12.Transparency = 1
	local goal22 ={}
	goal22.Brightness = 0
	
	local Tween1 = TweenService:Create(SummonAura, tweenInfo, goal11)
	local Tween2 = TweenService:Create(SummonAura:FindFirstChild("PointLight"), tweenInfo, goal21)
	local Tween3 = TweenService:Create(SummonAura, TweenInfo.new(1), goal12)
	local Tween4 = TweenService:Create(SummonAura:FindFirstChild("PointLight"), TweenInfo.new(1), goal22)
	
	Tween1:Play()
	Tween2:Play()
	
	playAnimation(BossHumanoid, Summon)
	
	Debris:AddItem(SummonAura, 6)
	task.wait(3)
	
	local SanguinarchMinion = ServerStorage:FindFirstChild("SanguinarchGift"):Clone()
	SanguinarchMinion.Name = "SanguinarchMinion" .. tostring(minionCount)
	minionCount += 1
	
	local spawncoords = BossHumanoidRootPart.Position + Vector3.new(0, -7, 10)
	
	local foldertest = game.Workspace:FindFirstChild("sanguinarchFolder")
	if foldertest then
		SanguinarchMinion.Parent = foldertest
	else
		local sanguinarchFolder = Instance.new("Folder")
		sanguinarchFolder.Parent = workspace
		sanguinarchFolder.Name = "sanguinarchFolder"
		SanguinarchMinion.Parent = sanguinarchFolder
	end
	SanguinarchMinion:MoveTo(spawncoords)
	
	Tween3:Play()
	Tween4:Play()
end

module.BossDeath = function(Player, BossHumanoidRootPart, BossHumanoid)
	local Death = BossHumanoid:LoadAnimation(Animations["Death"])
	
	playAnimation(BossHumanoid, Death)
	Sounds["Manfri Death"]:Play()
end

module.Victory = function(BossHumanoid)
	local Victory = BossHumanoid:LoadAnimation(Animations["Victory"])
	
	playAnimation(BossHumanoid, Victory)
	task.wait(1.7)
end

module.Idle = function(Player, BossHumanoidRootPart, BossHumanoid)
	local Idle = BossHumanoid:LoadAnimation(Animations["Idle Boss"])
	
	playAnimation(BossHumanoid, Idle)
	Sounds["Manfri Reborn"]:Play()
end

module.Reviving = function(Player, BossHumanoid)
	local Summon = BossHumanoid:LoadAnimation(Animations["Summon Minions"])
	
	playAnimation(BossHumanoid, Summon)
end

module.Cannon = function(Player, BossHumanoid)
	local target = ServerStorage:FindFirstChild("Cannon Area"):Clone()
	
	target.Parent = workspace
	target:FindFirstChild("WarningRing1").Position = Vector3.new(Player.Character:FindFirstChild("HumanoidRootPart").Position.X, -2, Player.Character:FindFirstChild("HumanoidRootPart").Position.Z)
	
	local BeamAttack = BossHumanoid:LoadAnimation(Animations["Beam Attack 1 Boss"])
	playAnimation(BossHumanoid, BeamAttack)
	task.wait(0.5)
end

return module
