--disable
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local PhaseShifted = ReplicatedStorage:WaitForChild("PhaseShifted")

local Player = game.Players.LocalPlayer
local BossHumanoid = game.Workspace:FindFirstChild("Boss"):FindFirstChild("Humanoid")

BossHumanoid:GetPropertyChangedSignal("Health"):Connect(function()
	script.Parent:TweenSize(UDim2.new(BossHumanoid.Health/BossHumanoid.MaxHealth, 0, 1, 0), "Out", "Linear", 0)
end)

PhaseShifted.OnClientEvent:Connect(function(adjustTime)
	script.Parent:TweenSize(UDim2.new(1, 0, 1, 0), "Out", "Linear", adjustTime)
end)