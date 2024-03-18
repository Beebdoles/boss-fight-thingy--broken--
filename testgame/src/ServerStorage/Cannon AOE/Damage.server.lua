local function GetFirstParent(Part)
	local Parent = Part.Parent
	repeat
		if Parent.Parent ~= workspace then
			Parent = Parent.Parent
		end
	until Parent.Parent == nil or Parent.Parent.Name == "sanguinarchFolder" or Parent.Parent == workspace
	return Parent
end

local damage = 500

script.Parent.Touched:Connect(function(hit)
	if GetFirstParent(hit):FindFirstChildWhichIsA("Humanoid") and GetFirstParent(hit).Name ~= "Boss" then
		GetFirstParent(hit):FindFirstChild("Humanoid"):TakeDamage(damage)
		damage = 100
	end
end)