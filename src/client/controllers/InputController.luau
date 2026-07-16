--!strict

--[[
    InputController
    Tracks raw user inputs and exposes them to client-side subsystems.
    Roblox-specific inputs are isolated here to keep downstream modules decoupled.
]]

export type InputController = {
	start: () -> (),
	getMoveVector: () -> Vector3,
	isSprintHeld: () -> boolean,
	isJumpHeld: () -> boolean,
	getMouseDelta: () -> Vector2,
}

local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- Flag to ensure initialization only runs once, making start() idempotent.
local started = false

-- Grouped state table to easily serialize or reset player input snapshots.
local inputState = {
	moveVector = Vector3.zero,
	mouseDelta = Vector2.zero,
	isSprintHeld = false,
	isJumpHeld = false,
}

-- Tracks directional keys independently to handle diagonal combinations cleanly.
local activeKeys = {
	forward = false,
	backward = false,
	left = false,
	right = false,
}

-- Normalizes the 3D movement vector to ensure diagonal movement speed isn't doubled.
local function updateMoveVector(): ()
	local x = (activeKeys.right and 1 or 0) - (activeKeys.left and 1 or 0)
	local z = (activeKeys.backward and 1 or 0) - (activeKeys.forward and 1 or 0)

	if x ~= 0 or z ~= 0 then
		inputState.moveVector = Vector3.new(x, 0, z).Unit
	else
		inputState.moveVector = Vector3.zero
	end
end

-- Prevents character stuck states when typing in chat or switching windows.
local function resetInputState(): ()
	activeKeys.forward = false
	activeKeys.backward = false
	activeKeys.left = false
	activeKeys.right = false
	inputState.isSprintHeld = false
	inputState.isJumpHeld = false
	inputState.moveVector = Vector3.zero
	inputState.mouseDelta = Vector2.zero
end

-- Handles key translations; ignores processed UI inputs to avoid typing conflicts.
local function handleInput(input: InputObject, isProcessed: boolean, isBegan: boolean): ()
	if isProcessed then return end

	local keyCode = input.KeyCode
	local directionChanged = false

	if keyCode == Enum.KeyCode.W or keyCode == Enum.KeyCode.Up then
		activeKeys.forward = isBegan
		directionChanged = true
	elseif keyCode == Enum.KeyCode.S or keyCode == Enum.KeyCode.Down then
		activeKeys.backward = isBegan
		directionChanged = true
	elseif keyCode == Enum.KeyCode.A or keyCode == Enum.KeyCode.Left then
		activeKeys.left = isBegan
		directionChanged = true
	elseif keyCode == Enum.KeyCode.D or keyCode == Enum.KeyCode.Right then
		activeKeys.right = isBegan
		directionChanged = true
	elseif keyCode == Enum.KeyCode.LeftShift then
		inputState.isSprintHeld = isBegan
	elseif keyCode == Enum.KeyCode.Space then
		inputState.isJumpHeld = isBegan
	end

	if directionChanged then
		updateMoveVector()
	end
end

-- Translates raw mouse movements to update our internal delta cache.
local function handleInputChanged(input: InputObject, isProcessed: boolean): ()
	if isProcessed then return end

	if input.UserInputType == Enum.UserInputType.MouseMovement then
		inputState.mouseDelta = Vector2.new(input.Delta.X, input.Delta.Y)
	end
end

local InputController: InputController = {
	start = function(): ()
		if started then return end
		started = true

		-- Defer binding to runtime startup rather than module load time.
		UserInputService.InputBegan:Connect(function(input, processed)
			handleInput(input, processed, true)
		end)

		UserInputService.InputEnded:Connect(function(input, processed)
			handleInput(input, processed, false)
		end)

		UserInputService.InputChanged:Connect(function(input, processed)
			handleInputChanged(input, processed)
		end)

		UserInputService.TextBoxFocused:Connect(resetInputState)
		UserInputService.WindowFocusReleased:Connect(resetInputState)

		-- Clears the cached mouse delta at the end of each physics frame,
		-- since InputChanged is only fired when the mouse is actively moving.
		RunService.PostSimulation:Connect(function()
			inputState.mouseDelta = Vector2.zero
		end)
	end,

	getMoveVector = function(): Vector3
		return inputState.moveVector
	end,

	isSprintHeld = function(): boolean
		return inputState.isSprintHeld
	end,

	isJumpHeld = function(): boolean
		return inputState.isJumpHeld
	end,

	getMouseDelta = function(): Vector2
		return inputState.mouseDelta
	end,
}

return InputController
