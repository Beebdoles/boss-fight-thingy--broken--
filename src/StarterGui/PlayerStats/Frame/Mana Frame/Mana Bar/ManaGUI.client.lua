local Humanoid = game.Players.LocalPlayer.Character:WaitForChild("Humanoid")
local MaxMana = Humanoid:GetAttribute("MaxMana")

local condition = true

while condition do
	local check = Humanoid:GetAttribute("ManaDrain")
	if not check then
		if Humanoid:GetAttribute("Mana") < MaxMana then
			Humanoid:SetAttribute("Mana", Humanoid:GetAttribute("Mana") + 1)
			script.Parent:TweenSize(UDim2.new(Humanoid:GetAttribute("Mana")/MaxMana, 0, 1, 0), "Out", "Linear", 0.2)
		end
	else
		if Humanoid:GetAttribute("Mana") > 0 then
			Humanoid:SetAttribute("Mana", Humanoid:GetAttribute("Mana") - 1)
			script.Parent:TweenSize(UDim2.new(Humanoid:GetAttribute("Mana")/MaxMana, 0, 1, 0), "Out", "Linear", 0.2)
		end
	end
	
	task.wait(0.1)
end