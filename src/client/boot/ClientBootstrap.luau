--!strict
local ClientBootstrap = {}

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Shared = ReplicatedStorage:WaitForChild("Shared")
local Logger = require(Shared:WaitForChild("core"):WaitForChild("Logger"))

-- Private initialization functions
local function initializeControllers(): ()
	local CharacterController = require(script.Parent.Parent:WaitForChild("controllers"):WaitForChild("CharacterController"))
	CharacterController.start()

	local InputController = require(script.Parent.Parent:WaitForChild("controllers"):WaitForChild("InputController"))
	InputController.start()

	local MovementController = require(script.Parent.Parent:WaitForChild("controllers"):WaitForChild("MovementController"))
	MovementController.start()

	local CameraController = require(script.Parent.Parent:WaitForChild("controllers"):WaitForChild("CameraController"))
	CameraController.start()

	local StateMachine = require(script.Parent.Parent:WaitForChild("controllers"):WaitForChild("StateMachine"))
	StateMachine.start()

	local AnimationController = require(script.Parent.Parent:WaitForChild("controllers"):WaitForChild("AnimationController"))
	AnimationController.start()
end

local function initializeUI(): ()
	-- Future UI setup goes here.
end

-- Starts the client bootstrap process.
function ClientBootstrap.start(): ()
	Logger.info("Client bootstrap sequence initiated.")

	initializeControllers()
	initializeUI()

	Logger.info("Client bootstrap sequence completed.")
end

return ClientBootstrap
