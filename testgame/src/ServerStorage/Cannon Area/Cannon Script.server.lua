local Debris = game:GetService("Debris")
local ServerScriptService = game:GetService("ServerScriptService")

local CannonRequest = ServerScriptService:FindFirstChild("CannonRequest")


local gunChoice = math.random(0, 1)

task.wait(7.5)

if gunChoice == 0 then
	CannonRequest:Fire(script.Parent, "Cannon1")
else
	CannonRequest:Fire(script.Parent, "Cannon2")
end

task.wait(2)

script.Parent:FindFirstChild("WarningRing1"):FindFirstChild("Artillery"):Play()