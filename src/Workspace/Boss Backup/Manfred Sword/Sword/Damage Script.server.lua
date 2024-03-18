task.wait(5)

local Sword = script.Parent
local Defence = script.Parent.Parent.Parent:FindFirstChild("Humanoid"):GetAttribute("Defence")
local Damage = script.Parent:GetAttribute("Damage")

local function GetFirstParent(Part)
	local Parent = Part.Parent
	repeat
		if Parent.Parent ~= workspace then
			Parent = Parent.Parent
		end
	until Parent.Parent == nil or Parent.Parent == workspace
	return Parent
end

local isTouching = false

local function checkPart(partsList, object)
	local touch = false
	for _, part in pairs(partsList) do
		if GetFirstParent(part).Name == object.Name then
			touch = true
			break
		end
	end
	return touch
end

function onTouched(object)
	if not isTouching and script.Parent:GetAttribute("isAttacking") then
		local objectParent = GetFirstParent(object)
		if objectParent:FindFirstChildWhichIsA("Humanoid") and objectParent:FindFirstChild("Humanoid"):GetAttribute("Entity") == "Player" then
			local Humanoid = objectParent:FindFirstChild("Humanoid")
			
			local takenDamage
			local shieldDamage
			if Humanoid:GetAttribute("isBlocking") and Humanoid:GetAttribute("shieldStrength") > 0 then
				shieldDamage = Humanoid:GetAttribute("shieldStrength") - Damage
				if shieldDamage >= 0 then
					Humanoid:SetAttribute("shieldStrength", shieldDamage)
				else
					Humanoid:SetAttribute("shieldStrength", 0)
					Humanoid:TakeDamage(math.abs(shieldDamage - Defence))
				end
			else
				Humanoid:TakeDamage(script.Parent:GetAttribute("Damage"))
			end
			isTouching = true
			
			local condition = true
			while condition do
				local touchingParts = Sword:GetTouchingParts()
				condition = checkPart(touchingParts, objectParent)
				task.wait(0.2)
			end
			isTouching = false
		end
	end
end



Sword.Touched:Connect(onTouched)