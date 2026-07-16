--!strict

--[[
    MovementController
    Drives character movement and orientation relative to the active camera.
    Decoupled from input and camera implementation details.
]]

export type MovementController = {
	start: () -> (),
}

local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

local CharacterController = require(script.Parent:WaitForChild("CharacterController"))
local InputController = require(script.Parent:WaitForChild("InputController"))

-- Idempotency and lifecycle tracking variables.
local started = false
local lastHumanoid: Humanoid? = nil
local updateConnection: RBXScriptConnection? = nil

-- Calculates the flat horizontal direction relative to the active camera.
local function getCameraRelativeDirection(moveVector: Vector3): Vector3
	local camera = Workspace.CurrentCamera
	if not camera then
		-- Fallback to default world space when the camera instance is missing or rebuilding.
		return moveVector
	end

	local cameraCFrame = camera.CFrame
	
	-- We project vectors onto the flat horizontal XZ plane to prevent player speed from stalling
	-- or causing vertical lift when looking up/down.
	local forward = cameraCFrame.LookVector
	forward = Vector3.new(forward.X, 0, forward.Z).Unit

	local right = cameraCFrame.RightVector
	right = Vector3.new(right.X, 0, right.Z).Unit

	-- Reconstruct intent with W/S mapping to forward/backward and A/D mapping to right/left.
	local direction = (forward * -moveVector.Z) + (right * moveVector.X)
	if direction.Magnitude > 0 then
		return direction.Unit
	end
	
	return Vector3.zero
end

-- Evaluates intent and routes movement coordinates to the humanoid on each physics step.
local function updateMovement(): ()
	if not CharacterController.isAlive() then
		return
	end

	local humanoid = CharacterController.getHumanoid()
	if not humanoid then
		return
	end

	-- Avoids setting properties every frame since re-configuring AutoRotate causes engine updates.
	if humanoid ~= lastHumanoid then
		lastHumanoid = humanoid
		humanoid.AutoRotate = true
	end

	local moveVector = InputController.getMoveVector()
	local worldDirection = getCameraRelativeDirection(moveVector)

	-- Drive character physics using Roblox's native controller step.
	humanoid:Move(worldDirection, false)
end

local MovementController: MovementController = {
	start = function(): ()
		if started then return end
		started = true

		-- Connect to PreSimulation so movement is computed right before the physics engine runs.
		updateConnection = RunService.PreSimulation:Connect(updateMovement)
	end,
}

return MovementController
