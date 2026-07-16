--!strict

--[[
    AnimationController
    Visual consumer of StateMachine. Handles locomotion animation updates.
    NOTE: This controller is strictly a visual feedback system; it never writes to or alters 
    gameplay state. Gameplay systems own state, while animation only visualizes it.
]]

export type AnimationController = {
	start: () -> (),
}

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer :: Player

local CharacterController = require(script.Parent:WaitForChild("CharacterController"))
local StateMachine = require(script.Parent:WaitForChild("StateMachine"))

local Shared = ReplicatedStorage:WaitForChild("Shared")
local Logger = require(Shared:WaitForChild("core"):WaitForChild("Logger"))
local AnimationConfig = require(Shared:WaitForChild("config"):WaitForChild("AnimationConfig"))

-- Idempotency and lifecycle tracking flags.
local started = false
local lastState: string? = nil
local updateConnection: RBXScriptConnection? = nil

-- Caches loaded AnimationTracks to prevent costly duplicate load invocations.
local tracks: { [string]: AnimationTrack } = {}

-- Loads character tracks once the humanoid and animator are fully initialized.
local function onCharacterAdded(character: Model): ()
	-- Wait for the character controller to finish resolving its humanoid reference
	-- to prevent loading animations against incomplete spawn states.
	local startTime = os.clock()
	while not CharacterController.getHumanoid() and os.clock() - startTime < 5 do
		task.wait()
	end

	local humanoid = CharacterController.getHumanoid()
	if not humanoid then
		Logger.error(`AnimationController failed to resolve Humanoid via CharacterController for '{character.Name}' within timeout.`)
		return
	end

	-- We avoid dynamically instantiating an Animator here to respect physics boundaries.
	-- Instead, we wait for the engine or character templates to provide the instance.
	local animator = humanoid:WaitForChild("Animator", 5)
	if not animator or not animator:IsA("Animator") then
		Logger.error(`AnimationController failed to resolve Animator for character '{character.Name}' within timeout.`)
		return
	end

	-- Pre-load and cache all locomotion tracks to enable smooth blend transitions.
	for stateName, animationId in pairs(AnimationConfig) do
		local animation = Instance.new("Animation")
		animation.AnimationId = animationId
		
		local track = animator:LoadAnimation(animation)
		tracks[stateName] = track
	end

	-- Ensure the animation aligns immediately with the current state active at spawn.
	local currentState = StateMachine.getState()
	local initialTrack = tracks[currentState]
	if initialTrack then
		initialTrack:Play(0)
		lastState = currentState
	end
end

-- Immediately stops tracks and clears references to prevent character memory leaks on reset.
local function onCharacterRemoving(character: Model): ()
	for _, track in pairs(tracks) do
		track:Stop(0)
	end
	table.clear(tracks)
	lastState = nil
end

-- Polls state changes to synchronize visuals with active states.
local function updateAnimations(): ()
	if not CharacterController.isAlive() then
		return
	end

	local currentState = StateMachine.getState()
	if currentState == lastState then
		return
	end

	local oldState = lastState
	lastState = currentState

	-- Cross-fade track playback smoothly to prevent jerky character movement transitions.
	if oldState and tracks[oldState] then
		tracks[oldState]:Stop(0.2)
	end

	local newTrack = tracks[currentState]
	if newTrack then
		newTrack:Play(0.2)
	end
end

local AnimationController: AnimationController = {
	start = function(): ()
		if started then return end
		started = true

		LocalPlayer.CharacterAdded:Connect(onCharacterAdded)
		LocalPlayer.CharacterRemoving:Connect(onCharacterRemoving)

		if LocalPlayer.Character then
			-- Spawn asynchronously to prevent blocking the bootstrap flow during yield sequences.
			task.spawn(onCharacterAdded, LocalPlayer.Character)
		end

		-- NOTE: Polling the StateMachine is a temporary solution for Version 1.
		-- Future iterations should transition this to an event-driven change notification system.
		updateConnection = RunService.PostSimulation:Connect(updateAnimations)
	end,
}

return AnimationController
