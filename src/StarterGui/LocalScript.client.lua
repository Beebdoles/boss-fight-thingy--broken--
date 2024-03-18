local shiftLock = (require(script.Parent:WaitForChild("ShiftLock")))
local userInputService = (game:GetService("UserInputService"));

function input_Began(input, gpe)
	if (gpe) then return end;
	if (input.KeyCode == Enum.KeyCode.LeftControl) then
		shiftLock:Lock(not shiftLock:IsLocked())
	end;
end;

userInputService.InputBegan:Connect(input_Began)