local ReplicatedStorage = game:GetService("ReplicatedStorage")

local bindableEvent = ReplicatedStorage:WaitForChild("Event")

bindableEvent.Event:Connect(function(key, CooldownTime)
	if key == "Dash" then
		script.Parent.Size = UDim2.fromScale(1, -1)
		script.Parent:TweenSize(UDim2.new(1, 0, 0, 0), "Out", "Linear", CooldownTime)
	end
end)