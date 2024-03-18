task.wait()

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Music = ReplicatedStorage:WaitForChild("Music")

local Boss1 = script["生存之形"]
local Boss2 = script["Crawling Forward!"]
local Lobby = script["Hortus de Escapismo"]
local End = script["Der Tag neigt sich"]
local currentMusicTrack = nil


local function playMusic(music)
	if currentMusicTrack ~= nil then
		currentMusicTrack:Stop()
		currentMusicTrack = nil
	end
	
	currentMusicTrack = music
	currentMusicTrack:Play()
end

playMusic(Lobby)

Music.OnClientEvent:Connect(function(key)
	if key == "boss1" then
		playMusic(Boss1)
	end
	
	if key == "boss2" then
		playMusic(Boss2)
	end
	
	if key == "lobby" then
		playMusic(Lobby)
	end
	
	if key == "end" then
		playMusic(End)
	end
end)
