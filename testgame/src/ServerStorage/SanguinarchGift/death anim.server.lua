local TweenService = game:GetService("TweenService")
local Debris = game:GetService("Debris")

local Humanoid = script.Parent.Humanoid


Humanoid.Died:Connect(function()
	for _, part in pairs(script.Parent:GetChildren()) do
		if part:IsA("Part") then
			local deathparticle = Instance.new("ParticleEmitter")
			deathparticle.Enabled = true
			deathparticle.LightEmission = 0.2
			deathparticle.Lifetime = NumberRange.new(1, 2)
			local colorsequence = {
				ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 0, 0)),
				ColorSequenceKeypoint.new(0.811, Color3.fromRGB(29, 0, 1)),
				ColorSequenceKeypoint.new(1, Color3.fromRGB(129, 0, 2))
			}
			deathparticle.Color = ColorSequence.new(colorsequence)
			deathparticle.Rate = 5
			
			deathparticle.Parent = part
			
			local goal = {}
			goal.Transparency = 1
			local Tween = TweenService:Create(part, TweenInfo.new(5), goal):Play()
			Debris:AddItem(part.Parent, 5)
		end
	end
end)