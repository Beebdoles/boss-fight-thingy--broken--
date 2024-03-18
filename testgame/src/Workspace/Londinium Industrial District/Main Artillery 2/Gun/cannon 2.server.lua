local Debris = game:GetService("Debris")
local ServerScriptService = game:GetService("ServerScriptService")
local ServerStorage = game:GetService("ServerStorage")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local CannonRequest = ServerScriptService:FindFirstChild("CannonRequest")
local Explosion = ReplicatedStorage:FindFirstChild("Explosion")

local Artillery2 = game.Workspace:FindFirstChild("Londinium Industrial District"):FindFirstChild("Main Artillery 2")

local GunpointStart2 = Artillery2:FindFirstChild("Gun"):FindFirstChild("Artillery 2 Gunpoint")
local GunpointEnd2 = Artillery2:FindFirstChild("Gun"):FindFirstChild("Artillery 2 Gunpoint End")

local function GetFirstParent(Part)
	local Parent = Part.Parent
	repeat
		if Parent.Parent ~= workspace then
			Parent = Parent.Parent
		end
	until Parent.Parent == nil or Parent.Parent == workspace
	return Parent
end

CannonRequest.Event:Connect(function(object, key)
	if key == "Cannon2" then
		local shell = ServerStorage:FindFirstChild("Artillery"):Clone()

		shell.Parent = workspace
		shell.Position = script.Parent["Artillery 2  Gunpoint"].Position
		shell.CFrame = CFrame.lookAt(shell.Position, GunpointEnd2.Position)

		local goal1 = {}
		local goal2 = {}

		goal1.Position = GunpointEnd2.Position
		goal2.Position = object:FindFirstChild("WarningRing1").Position

		TweenService:Create(shell, TweenInfo.new(1), goal1):Play()
		task.wait(1)
		shell.CFrame = CFrame.lookAt(shell.Position, object:FindFirstChild("WarningRing1").Position)
		TweenService:Create(shell, TweenInfo.new(1), goal2):Play()
		task.wait(1)

		local Damage = ServerStorage["Cannon AOE"]:Clone()

		Damage.Parent = workspace
		Damage.Position = object:FindFirstChild("WarningRing1").Position
		
		local Smoke = ServerStorage["Smoke Block"]:Clone()
		Smoke.ParticleEmitter.Enabled = true
		Smoke.Position = object:FindFirstChild("WarningRing1").Position
		Smoke.Parent = workspace
		
		local explosion = Instance.new("Explosion")

		explosion.Position = object:FindFirstChild("WarningRing1").Position
		explosion.BlastRadius = 200
		explosion.BlastPressure = 0
		explosion.Parent = workspace
		explosion.Hit:Connect(function(hit, distance)
			if GetFirstParent(hit):FindFirstChildWhichIsA("Humanoid") and GetFirstParent(hit).Name ~= "Boss" and GetFirstParent(hit).Name ~= "SanguinarchGift" then
				Explosion:FireClient(game.Players:GetPlayerFromCharacter(GetFirstParent(hit)), distance)
			end
		end)
		
		Debris:AddItem(shell, 0)
		task.wait(3)

		Smoke.ParticleEmitter.Enabled = false

		Debris:AddItem(object, 2)
		Debris:AddItem(Smoke.PointLight, 2)
		Debris:AddItem(Damage, 2)
		Debris:AddItem(explosion, 2)
		Debris:AddItem(Smoke, 10)
	end
end)