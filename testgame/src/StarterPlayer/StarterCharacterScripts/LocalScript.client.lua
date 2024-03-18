local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Debris = game:GetService("Debris")
local TweenService = game:GetService("TweenService")

local Explosion = ReplicatedStorage:FindFirstChild("Explosion")
local Knockback = ReplicatedStorage:FindFirstChild("Knockback")

local Humanoid = script.Parent:FindFirstChild("Humanoid")


Explosion.OnClientEvent:Connect(function(distance)
	local blur = Instance.new("BlurEffect")
	blur.Size = 600/distance
	blur.Parent = game.Lighting
	
	for i = 1, 50 do
		local x = math.random(-100, 100) / (distance * i / 5)
		local y = math.random(-100, 100) / (distance * i / 5)
		local z = math.random(-100, 100) / (distance * i / 5)
		
		Humanoid.CameraOffset = Vector3.new(x, y, z)
		workspace.CurrentCamera.CFrame *= CFrame.Angles(x / (distance * i), y / (distance * i), z / (distance * i))
		task.wait()
	end
	
	Humanoid.CameraOffset = Vector3.new(0, 0, 0)
	task.wait(0.5)
	
	for i = 50, 0, -1 do
		blur.Size *= 0.9
		task.wait()
	end
	
	Debris:AddItem(blur)
end)

Knockback.OnClientEvent:Connect(function(duration)
	local vector = Vector3.new(0.2, 0.2, 0.2)
	
	Humanoid.CameraOffset = vector
end)
