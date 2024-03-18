local Debris = game:GetService("Debris")

local Damage = script.Parent:GetAttribute("Damage")
local hitbox = script.Parent

local listofcontacts = {}

local function GetFirstParent(Part)
	local Parent = Part.Parent
	repeat
		if Parent.Parent ~= workspace or Parent.Parent ~= game then
			Parent = Parent.Parent
		end
	until Parent.Parent == nil or Parent.Parent.Name == "sanguinarchFolder" or Parent.Parent == workspace
	return Parent
end

local function checkforcontact(entity)
	local index = nil
	if #listofcontacts >= 1 then
		for i = 1, #listofcontacts do
			index = table.find(listofcontacts, entity)
		end
	end
	return index
end

local function onTouched(object)
	local objectParent = GetFirstParent(object)
	local Humanoid = objectParent:FindFirstChildWhichIsA("Humanoid")
	if Humanoid then
		if Humanoid:GetAttribute("Entity") == "Enemy" and not Humanoid:GetAttribute("isReviving") and checkforcontact(Humanoid.Parent.Name) == nil then
			table.insert(listofcontacts, Humanoid.Parent.Name)
			if Humanoid.Health - Damage < 1 and Humanoid.Parent.Name == "Boss" then
				Humanoid.Health = 1
			else
				Humanoid:TakeDamage(Damage)
				if Humanoid.Health <= 0 then
					Debris:AddItem(Humanoid.Parent, 3)
				end
			end
		end
	end
end

--------------------------------------------------------------------

hitbox.Touched:Connect(onTouched)