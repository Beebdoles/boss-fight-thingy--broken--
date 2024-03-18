local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Knockback = ReplicatedStorage:WaitForChild("Knockback")

local Sword = script.Parent
local Damage = script.Parent:GetAttribute("Damage")
local SwordSound = script.Parent["Manfri Sword"]

local function GetFirstParent(Part)
	local Parent = Part.Parent
	repeat
		if Parent.Parent ~= workspace and Part.Name ~= workspace then
			Parent = Parent.Parent
		end
	until Parent.Parent == nil or Parent.Parent == workspace
	return Parent
end

local isTouching = false

local function checkPart(partsList, object)
	local touch = false
	local check = true
	for _, part in pairs(partsList) do
		if check then
			if GetFirstParent(part).Name == object.Name then
				touch = true
				check = false
			end
		end
	end
	return touch
end

local function flash(colour, duration, player)
	local Frame = player.PlayerGui.Flashes.Frame

	Frame.BackgroundColor3 = colour
	Frame.BackgroundTransparency = 0.5
	TweenService:Create(Frame, TweenInfo.new(duration, Enum.EasingStyle.Quint), {BackgroundTransparency = 1}):Play()

end

function onTouched(object)
	if not isTouching and script.Parent:GetAttribute("isAttacking") then
		local objectParent = GetFirstParent(object)
		if objectParent:FindFirstChildWhichIsA("Humanoid") and objectParent:FindFirstChild("Humanoid"):GetAttribute("Entity") == "Player" then
			isTouching = true
			local Humanoid = objectParent:FindFirstChild("Humanoid")
			local Defence = Humanoid:GetAttribute("Defence")
			
			local takenDamage
			local shieldDamage
			if Humanoid:GetAttribute("isBlocking") and Humanoid:GetAttribute("shieldStrength") > 0 then
				shieldDamage = Humanoid:GetAttribute("shieldStrength") - Damage
				if shieldDamage >= 0 then
					Humanoid:SetAttribute("shieldStrength", shieldDamage)
				else
					Humanoid:SetAttribute("shieldStrength", 0)
					
					if Defence - math.abs(shieldDamage) < 0 then
						Humanoid:TakeDamage(Defence - math.abs(shieldDamage))
						flash(Color3.new(0.329412, 0, 0), 0.5, game:GetService("Players"):GetPlayerFromCharacter(Humanoid.Parent))
						Knockback:FireClient(game:GetService("Players"):GetPlayerFromCharacter(Humanoid.Parent), 0.5)
						SwordSound:Play()
					end
				end
			else
				if Defence - Damage < 0 then
					Humanoid:TakeDamage(script.Parent:GetAttribute("Damage"))
					flash(Color3.new(0.329412, 0, 0), 0.5, game:GetService("Players"):GetPlayerFromCharacter(Humanoid.Parent))
					Knockback:FireClient(game:GetService("Players"):GetPlayerFromCharacter(Humanoid.Parent), 0.5)
					SwordSound:Play()
				else
					Knockback:FireClient(game:GetService("Players"):GetPlayerFromCharacter(Humanoid.Parent), 0.5)
					SwordSound:Play()
				end
			end
			
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