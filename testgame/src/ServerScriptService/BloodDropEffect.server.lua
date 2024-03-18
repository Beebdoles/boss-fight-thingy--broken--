local healthPerDrop = 10
local dropLifetime = 20
local dropSizeMin, dropSizeMax = 0.1, 2

local blood = script:WaitForChild("Blood")


local tweenService = game:GetService("TweenService")
local Debris = game:GetService("Debris")
local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.InOut)

local dropsFolder = Instance.new("Folder", workspace)


game.Players.PlayerAdded:Connect(function(plr)
	
	plr.CharacterAdded:Connect(function(char)
		
		local humanoid = char:WaitForChild("Humanoid")
		
		
		local previousHealth = humanoid.Health
		
		humanoid.HealthChanged:Connect(function(newHealth)
			
			
			local healthDifference = previousHealth - newHealth
			
			previousHealth = newHealth
			
			if healthDifference < 0 then return end
			
			
			local numOfDrops = math.floor(healthDifference / healthPerDrop)
			
			
			for i = 1, numOfDrops do
				
				local dropSize = math.random(dropSizeMin * 10, dropSizeMax * 10) / 10
				
				local bloodDrop = blood:Clone()
				bloodDrop.Size = Vector3.new(0, 0, 0)
				
				
				local xPos = char.HumanoidRootPart.Position.X + math.random(-30, 30) / 10
				local yPos = -2.35 --maybe implement a raycast later to determine lowest possible y instead, so blood doesnt end up floating
				local zPos = char.HumanoidRootPart.Position.Z + math.random(-30, 30) / 10
				
				bloodDrop.Position = Vector3.new(xPos, yPos, zPos)
				
				bloodDrop.Parent = dropsFolder
				
				Debris:AddItem(bloodDrop, dropLifetime)
				
				
				tweenService:Create(bloodDrop, tweenInfo, {Size = Vector3.new(0.05, dropSize, dropSize)}):Play()
			end
			
		end)
	end)
end)