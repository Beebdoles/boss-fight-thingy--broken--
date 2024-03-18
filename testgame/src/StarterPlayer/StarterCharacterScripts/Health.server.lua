local Teams = game:GetService("Teams")
local ServerScriptService = game:GetService("ServerScriptService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Suicide = ServerScriptService:WaitForChild("Suicide")


game:GetService("Players"):GetPlayerFromCharacter(script.Parent).TeamColor = BrickColor.new("White")
game:GetService("Players"):GetPlayerFromCharacter(script.Parent).Team = Teams:FindFirstChild("Lobby")

script.Parent.Humanoid:GetPropertyChangedSignal("Health"):Connect(function()
	if script.Parent.Humanoid.Health == 0 then
		Suicide:Fire(game:GetService("Players"):GetPlayerFromCharacter(script.Parent))
		task.wait(0.1)
		game:GetService("Players"):GetPlayerFromCharacter(script.Parent).TeamColor = BrickColor.new("White")
		game:GetService("Players"):GetPlayerFromCharacter(script.Parent).Team = Teams:FindFirstChild("Lobby")
	end
end)