--!strict

--[[
    CharacterController
    Tracks and caches the local player's active character and humanoid.
    Decoupled from gameplay or movement mechanics to serve as a pure reference manager.
]]

export type CharacterController = {
	start: () -> (),
	getCharacter: () -> Model?,
	getHumanoid: () -> Humanoid?,
	getRootPart: () -> BasePart?,
	isAlive: () -> boolean,
}

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer :: Player

local Shared = ReplicatedStorage:WaitForChild("Shared")
local Logger = require(Shared:WaitForChild("core"):WaitForChild("Logger"))

-- Initialization flag to make start() idempotent and prevent multiple event connections.
local started = false

-- Groups runtime references in a single table to keep reference cleaning cohesive.
local state: {
	character: Model?,
	humanoid: Humanoid?,
	rootPart: BasePart?,
} = {
	character = nil,
	humanoid = nil,
	rootPart = nil,
}

-- Caches the character, humanoid, and root part once spawned.
local function onCharacterAdded(character: Model): ()
	state.character = character
	
	-- We use a timeout to prevent the thread from locking up indefinitely in corrupt spawning states.
	local humanoid = character:WaitForChild("Humanoid", 5)
	if humanoid and humanoid:IsA("Humanoid") then
		state.humanoid = humanoid
	else
		Logger.error(`Failed to resolve Humanoid for character '{character.Name}' within timeout.`)
	end

	local rootPart = character:WaitForChild("HumanoidRootPart", 5)
	if rootPart and rootPart:IsA("BasePart") then
		state.rootPart = rootPart
	else
		Logger.error(`Failed to resolve HumanoidRootPart for character '{character.Name}' within timeout.`)
	end
end

-- Clears references immediately to avoid memory leaks with dead/destroyed character instances.
local function onCharacterRemoving(character: Model): ()
	if state.character == character then
		state.character = nil
		state.humanoid = nil
		state.rootPart = nil
	end
end

local CharacterController: CharacterController = {
	start = function(): ()
		if started then return end
		started = true

		LocalPlayer.CharacterAdded:Connect(onCharacterAdded)
		LocalPlayer.CharacterRemoving:Connect(onCharacterRemoving)

		-- Handles instances where the character loaded before script execution began.
		if LocalPlayer.Character then
			onCharacterAdded(LocalPlayer.Character)
		end
	end,

	getCharacter = function(): Model?
		return state.character
	end,

	getHumanoid = function(): Humanoid?
		return state.humanoid
	end,

	getRootPart = function(): BasePart?
		return state.rootPart
	end,

	isAlive = function(): boolean
		-- Checking health explicitly provides the truest definition of an active alive status in Roblox.
		return state.character ~= nil 
			and state.humanoid ~= nil 
			and state.humanoid.Health > 0
	end,
}

return CharacterController
