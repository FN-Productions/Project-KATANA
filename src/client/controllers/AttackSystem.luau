--!strict

--[[
    AttackSystem
    The execution engine of Project KATANA. Interprets immutable Attack Definitions,
    tracks the active attack timeline, and manages hitbox and animation updates.
    Does NOT own player input, combat decisions, damage, or animation playback itself.
]]

export type ExecutionPhase = "Startup" | "Active" | "Recovery" | "Completed" | "Cancelled"

type AttackDefinition = AttackRegistry.AttackDefinition
type Hitbox = HitboxSystem.Hitbox

export type RuntimeAttack = {
	definition: AttackDefinition,
	elapsedTime: number,
	phase: ExecutionPhase,
	hitbox: Hitbox?,
	activationId: number,
}

export type AttackSystem = {
	start: () -> (),
	execute: (attackId: string) -> boolean,
	cancel: () -> (),
	isExecuting: () -> boolean,
}

local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local CharacterController = require(script.Parent:WaitForChild("CharacterController"))
local AnimationController = require(script.Parent:WaitForChild("AnimationController"))

local Shared = ReplicatedStorage:WaitForChild("Shared")
local HitboxSystem = require(Shared:WaitForChild("combat"):WaitForChild("HitboxSystem"))
local AttackRegistry = require(Shared:WaitForChild("combat"):WaitForChild("AttackRegistry"))

-- Idempotency and runtime state variables.
local started = false
local activeAttack: RuntimeAttack? = nil
local updateConnection: RBXScriptConnection? = nil
local activationCounter = 0

-- Releases all visual, spatial, and data resources tied to the active attack.
local function cleanup(): ()
	if not activeAttack then return end

	local def = activeAttack.definition
	
	-- Instruct AnimationController to stop the generic track, keeping playback state decoupled.
	AnimationController.stop(def.Animation)

	if activeAttack.hitbox then
		HitboxSystem.destroyHitbox(activeAttack.hitbox)
		activeAttack.hitbox = nil
	end

	activeAttack = nil

	if updateConnection then
		updateConnection:Disconnect()
		updateConnection = nil
	end
end

-- Advances the execution timeline frame-by-frame on PreSimulation (before physics computations).
local function updateAttack(dt: number): ()
	if not activeAttack then
		if updateConnection then
			updateConnection:Disconnect()
			updateConnection = nil
		end
		return
	end

	-- Verify if the character root part is still present; cancel execution if destroyed.
	local rootPart = CharacterController.getRootPart()
	local character = CharacterController.getCharacter()
	if not character or not rootPart or not rootPart.Parent then
		activeAttack.phase = "Cancelled"
		cleanup()
		return
	end

	-- Accumulate frame-by-frame delta time to allow features like hit-stop freezing.
	activeAttack.elapsedTime += dt

	local elapsed = activeAttack.elapsedTime
	local def = activeAttack.definition

	if activeAttack.phase == "Startup" then
		if elapsed >= def.Startup then
			-- Transition from Startup preparation into Active strike frames.
			activeAttack.phase = "Active"

			-- AttackSystem determines when hitboxes are created; HitboxSystem remains passive.
			local localTransform = CFrame.new(def.HitboxOffset) * def.HitboxRotation
			activeAttack.hitbox = HitboxSystem.createHitbox({
				owner = character,
				size = def.HitboxSize,
				localTransform = localTransform,
				activationId = activeAttack.activationId,
				debugEnabled = false,
			})
		end
	end

	if activeAttack.phase == "Active" then
		-- Evaluate overlaps synchronously to route target impacts instantly.
		if activeAttack.hitbox then
			local result = HitboxSystem.evaluateHitbox(activeAttack.hitbox)
			if result.HitCount > 0 then
				-- TODO: Route targets to DamageSystem.
			end
		end

		if elapsed >= def.Startup + def.Active then
			-- Transition from Active strike frames into Recovery recovery commitments.
			activeAttack.phase = "Recovery"

			if activeAttack.hitbox then
				HitboxSystem.destroyHitbox(activeAttack.hitbox)
				activeAttack.hitbox = nil
			end
		end
	end

	if activeAttack.phase == "Recovery" then
		if elapsed >= def.Startup + def.Active + def.Recovery then
			-- Timeline reached completion naturally.
			activeAttack.phase = "Completed"
			cleanup()
		end
	end
end

local AttackSystem: AttackSystem = {
	start = function(): ()
		if started then return end
		started = true
	end,

	execute = function(attackId: string): boolean
		if activeAttack then
			-- Reject execution requests if an attack is already in progress.
			return false
		end

		local definition = AttackRegistry.get(attackId)
		if not definition then
			return false
		end

		-- Verify character is alive and references are ready.
		local character = CharacterController.getCharacter()
		local humanoid = CharacterController.getHumanoid()
		if not character or not humanoid or humanoid.Health <= 0 then
			return false
		end

		activationCounter += 1

		-- Instantiate a temporary runtime attack object from immutable definition configurations.
		activeAttack = {
			definition = definition,
			elapsedTime = 0,
			phase = "Startup",
			hitbox = nil,
			activationId = activationCounter,
		}

		-- Request animation playback by ID while delegating playback mechanics to AnimationController.
		AnimationController.play(definition.Animation)

		-- Bind simulation updates only when an active attack timeline needs execution.
		if not updateConnection then
			updateConnection = RunService.PreSimulation:Connect(updateAttack)
		end

		return true
	end,

	cancel = function(): ()
		if not activeAttack then return end
		activeAttack.phase = "Cancelled"
		cleanup()
	end,

	isExecuting = function(): boolean
		return activeAttack ~= nil
	end,
}

return AttackSystem
