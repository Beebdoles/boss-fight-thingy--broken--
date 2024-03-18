local function GetFirstParent(Part)
	local Parent = Part.Parent
	repeat
		if Parent.Parent ~= workspace then
			Parent = Parent.Parent
		end
	until Parent.Parent == nil or Parent.Parent == workspace
	return Parent
end

script.Parent.Torso.Touched:Connect(function(touch)
	if GetFirstParent(touch):FindFirstChildWhichIsA("Humanoid") and GetFirstParent(touch):FindFirstChild("Humanoid"):GetAttribute("Entity") == "Player" then
		GetFirstParent(touch):FindFirstChild("Humanoid"):TakeDamage(1)
	end
end)

local debounce = false
script.Parent["Right Arm"].Touched:Connect(function(touch)
	if GetFirstParent(touch):FindFirstChildWhichIsA("Humanoid") and GetFirstParent(touch):FindFirstChild("Humanoid"):GetAttribute("Entity") == "Player"  and not debounce then
		GetFirstParent(touch):FindFirstChild("Humanoid"):TakeDamage(50)
		debounce = true
		task.wait(1.5)
		debounce = false
	end
end)