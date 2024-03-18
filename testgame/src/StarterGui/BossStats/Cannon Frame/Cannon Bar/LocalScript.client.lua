local ReplicatedStorage = game:GetService("ReplicatedStorage")

local CannonFire = ReplicatedStorage:WaitForChild("CannonFire")


CannonFire.OnClientEvent:Connect(function()
	while true do
		script.Parent:TweenSize(UDim2.new(1, 0, 1, 0), "Out", "Linear", 15)
		task.wait(15)
		script.Parent:TweenSize(UDim2.new(0, 0, 1, 0), "Out", "Linear", 2)
		task.wait(2)
	end
end)