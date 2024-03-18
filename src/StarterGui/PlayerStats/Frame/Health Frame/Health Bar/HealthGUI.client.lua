local TweenService = game:GetService("TweenService")

local Humanoid = game.Players.LocalPlayer.Character:WaitForChild("Humanoid")
local MaxHealth = Humanoid.MaxHealth

Humanoid:GetPropertyChangedSignal("Health"):Connect(function()
	script.Parent:TweenSize(UDim2.new(Humanoid.Health/MaxHealth, 0, 1, 0), "Out", "Linear", 0.5)
end)