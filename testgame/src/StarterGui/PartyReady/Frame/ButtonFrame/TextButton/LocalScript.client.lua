local ReplicatedStorage = game:GetService("ReplicatedStorage")

local ButtonPress = ReplicatedStorage:WaitForChild("ButtonPress")

local Button = script.Parent
local cooldown = true


local function pressed()
	if cooldown then
		ButtonPress:FireServer(game.Players.LocalPlayer.Character:FindFirstChild("Humanoid"):GetAttribute("Ready"))
		cooldown = false
		task.wait(5)
		cooldown = true
	end
end

Button.Activated:Connect(pressed)