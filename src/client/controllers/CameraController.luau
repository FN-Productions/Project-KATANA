--!strict

--[[
    CameraController
    Coordinates camera positioning, camera rotation, collision resolution, and CFrame updates.
    Decoupled from input polling, character model structure, and mouse behavior settings.
]]

export type CameraController = {
	start: () -> (),
}

local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local CharacterController = require(script.Parent:WaitForChild("CharacterController"))
local InputController = require(script.Parent:WaitForChild("InputController"))

local Shared = ReplicatedStorage:WaitForChild("Shared")
local CameraConfig = require(Shared:WaitForChild("config"):WaitForChild("CameraConfig"))

-- Idempotency and orientation tracking states.
local started = false
local yaw = 0
local pitch = 0
local updateConnection: RBXScriptConnection? = nil

-- Cache the current character to dynamically update the raycast filter list only when it changes.
local lastCharacter: Model? = nil

-- Pre-allocate RaycastParams to avoid high frequency garbage collection inside RenderStepped.
local raycastParams = RaycastParams.new()
raycastParams.FilterType = Enum.RaycastFilterType.Exclude

-- Drives camera positioning, rotation updates, and wall collision testing.
local function updateCamera(): ()
	if not CharacterController.isAlive() then
		return
	end

	local rootPart = CharacterController.getRootPart()
	local character = CharacterController.getCharacter()
	if not rootPart or not character then
		return
	end

	-- Update Raycast Filter dynamically when the character model swaps/respawns.
	if character ~= lastCharacter then
		lastCharacter = character
		raycastParams.FilterDescendantsInstances = { character }
	end

	-- Retrieve mouse offset via our input decoupling wrapper.
	local lookDelta = InputController.getLookDelta()
	yaw = (yaw - lookDelta.X * CameraConfig.LOOK_SENSITIVITY) % 360
	pitch = math.clamp(
		pitch - lookDelta.Y * CameraConfig.LOOK_SENSITIVITY,
		CameraConfig.MIN_PITCH,
		CameraConfig.MAX_PITCH
	)

	local targetPos = rootPart.Position
	local rotation = CFrame.fromEulerAnglesYXZ(math.rad(pitch), math.rad(yaw), 0)

	-- Offset target to view over the right shoulder.
	local targetWithOffset = targetPos + rotation:VectorToWorldSpace(CameraConfig.SHOULDER_OFFSET)
	local idealCameraPos = targetWithOffset - (rotation.LookVector * CameraConfig.DEFAULT_DISTANCE)

	-- Perform collision raycast from target offset position outwards.
	local rayDirection = idealCameraPos - targetWithOffset
	local raycastResult = Workspace:Raycast(targetWithOffset, rayDirection, raycastParams)

	local finalDistance = CameraConfig.DEFAULT_DISTANCE
	if raycastResult then
		-- Keep camera slightly away from walls to prevent visual clipping through textures.
		finalDistance = math.max(0, raycastResult.Distance - CameraConfig.COLLISION_BUFFER)
	end

	local actualCameraPos = targetWithOffset - (rotation.LookVector * finalDistance)

	local camera = Workspace.CurrentCamera
	if camera then
		-- Override default Roblox camera scripts which continuously attempt to revert CameraType to Custom.
		if camera.CameraType ~= Enum.CameraType.Scriptable then
			camera.CameraType = Enum.CameraType.Scriptable
		end

		-- Explicitly face the target to guarantee alignment accuracy.
		camera.CFrame = CFrame.lookAt(actualCameraPos, targetWithOffset)
	end
end

local CameraController: CameraController = {
	start = function(): ()
		if started then return end
		started = true

		-- Update loop connected to RenderStepped to ensure camera aligns with character frame rendering.
		updateConnection = RunService.RenderStepped:Connect(updateCamera)
	end,
}

return CameraController
