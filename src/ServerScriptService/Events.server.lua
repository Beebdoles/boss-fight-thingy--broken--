local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Debris = game:GetService("Debris")
local TweenService = game:GetService("TweenService")

local HealthUpdate = ReplicatedStorage:WaitForChild("HealthUpdate")
local BlockingUpdate = ReplicatedStorage:WaitForChild("BlockStatus")
local ShieldUpdate = ReplicatedStorage:WaitForChild("ShieldUpdate")
local SwordFired = ReplicatedStorage:WaitForChild("SwordFired")
local ManaEnabled = ReplicatedStorage:WaitForChild("ManaEnabled")
local Healing = ReplicatedStorage:WaitForChild("Healing")

local function updateHealth(player, humanoid, damage)
	if humanoid.Health - damage < 1 and humanoid.Parent.Name == "Boss" then
		humanoid.Health = 1
	else
		humanoid.Health = humanoid.Health - damage
	end
	
	if humanoid.Health <= 0 then
		Debris:AddItem(humanoid.Parent, 3)
	end
end

local function updateBlock(player, humanoid, status)
	humanoid:SetAttribute("isBlocking", status)
end

local function updateShield(player, humanoid, maxShield)
	humanoid:SetAttribute("shieldStrength", maxShield)
end

local function moveSwordProjectile(player, humanoid, HumanoidRootPart)
	local projectile = ReplicatedStorage["SwordProjectile"]:Clone()
	projectile.Anchored = true
	projectile.Parent = workspace
	projectile.CFrame = humanoid.Parent:FindFirstChild("HumanoidRootPart").CFrame
	projectile.CFrame = projectile.CFrame * CFrame.new(Vector3.new(0, 0, -5)) * CFrame.Angles(0, math.rad(180), 0)
	
	local TweenedProperties = {
		Position = (projectile.CFrame * CFrame.new(Vector3.new(0, 0, 100))).Position
	}
	local TweeningInformation = TweenInfo.new(1.5, Enum.EasingStyle.Linear, Enum.EasingDirection.In)
	local Tween = TweenService:Create(projectile, TweeningInformation, TweenedProperties)
	Tween:Play()
	Debris:AddItem(projectile, 1.5)
end

local function enableAura(player, humanoid, ManaAura, Light, boolean)
	Light.Enabled = boolean
	ManaAura.Enabled = boolean
end

local function Heal(player, Humanoid, Base, Cork, Liquid, Neck, Rim, Value1, Value2, Value3)
	Base.Transparency = Value1
	Cork.Transparency = Value3
	Liquid.Transparency = Value2
	Neck.Transparency = Value1
	Rim.Transparency = Value1
end

---------------------------------------------------------------------------

HealthUpdate.OnServerEvent:Connect(updateHealth)
BlockingUpdate.OnServerEvent:Connect(updateBlock)
ShieldUpdate.OnServerEvent:Connect(updateShield)
SwordFired.OnServerEvent:Connect(moveSwordProjectile)
ManaEnabled.OnServerEvent:Connect(enableAura)
Healing.OnServerEvent:Connect(Heal)