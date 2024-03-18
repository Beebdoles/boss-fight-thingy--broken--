local Humanoid = game.Players.LocalPlayer.Character:WaitForChild("Humanoid")
local MaxStamina = Humanoid:GetAttribute("StaminaMax")

local condition = true

while condition do
	local check = Humanoid:GetAttribute("StaminaDrain")
	if not check then
		if Humanoid:GetAttribute("Stamina") < MaxStamina then
			Humanoid:SetAttribute("Stamina", Humanoid:GetAttribute("Stamina") + 1)
			script.Parent:TweenSize(UDim2.new(Humanoid:GetAttribute("Stamina")/MaxStamina, 0, 1, 0), "Out", "Linear", 0.2)
		end
	else
		if Humanoid:GetAttribute("Stamina") > 0 then
			Humanoid:SetAttribute("Stamina", Humanoid:GetAttribute("Stamina") - 1)
			script.Parent:TweenSize(UDim2.new(Humanoid:GetAttribute("Stamina")/MaxStamina, 0, 1, 0), "Out", "Linear", 0.2)
		end
	end

	task.wait(0.1)
end