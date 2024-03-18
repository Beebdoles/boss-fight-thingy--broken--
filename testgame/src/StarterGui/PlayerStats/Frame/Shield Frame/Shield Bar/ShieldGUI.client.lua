local Humanoid = game.Players.LocalPlayer.Character:WaitForChild("Humanoid")

local MaxShield = Humanoid:GetAttribute("MaxShield")

Humanoid:GetAttributeChangedSignal("shieldStrength"):Connect(function()
	script.Parent:TweenSize(UDim2.new(Humanoid:GetAttribute("shieldStrength")/MaxShield, 0, 1, 0), "Out", "Linear", 0.5)
end)