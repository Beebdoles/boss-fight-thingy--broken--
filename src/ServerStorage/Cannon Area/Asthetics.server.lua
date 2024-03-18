local Debris = game:GetService("Debris")
local TweenService = game:GetService("TweenService")

local part1 = script.Parent.WarningRing1
local part2 = script.Parent.WarningRing2


part1.Transparency = 1
part1.Color = Color3.new(0.835294, 0.45098, 0.239216)

part2.Transparency = 1
part2.Color = Color3.new(0.666667, 0.333333, 0)

local Transparency1 = {}
local Transparency2 = {}

Transparency1.Transparency = 0
Transparency2.Transparency = 1

local Tween1 = TweenService:Create(part1, TweenInfo.new(1), Transparency1)
Tween1:Play()
task.wait(1)

while wait() do
	TweenService:Create(part2, TweenInfo.new(0.5), Transparency1):Play()
	TweenService:Create(part1, TweenInfo.new(0.5), Transparency2):Play()
	task.wait(0.5)
	TweenService:Create(part2, TweenInfo.new(0.5), Transparency2):Play()
	TweenService:Create(part1, TweenInfo.new(0.5), Transparency1):Play()
	task.wait(0.5)
end