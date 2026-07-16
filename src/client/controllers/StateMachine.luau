--!strict

--[[
    StateMachine
    Centralized, passive state container for local character locomotion.
    Maintains the single source of truth for player actions and acts as a generic state gatekeeper.
]]

export type CharacterState = "Idle" | "Walking" | "Falling"

export type StateMachine = {
	start: () -> (),
	getState: () -> CharacterState,
	is: (state: CharacterState) -> boolean,
	setState: (state: CharacterState) -> boolean,
}

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Shared = ReplicatedStorage:WaitForChild("Shared")
local Logger = require(Shared:WaitForChild("core"):WaitForChild("Logger"))

-- Idempotency check flag.
local started = false

-- Passive state storage defaults to Idle.
local currentState: CharacterState = "Idle"

-- Explicit mapping of permissible state changes to prevent system state corruption.
local ALLOWED_TRANSITIONS: { [CharacterState]: { [CharacterState]: boolean } } = {
	Idle = { Walking = true, Falling = true },
	Walking = { Idle = true, Falling = true },
	Falling = { Idle = true, Walking = true },
}

local StateMachine: StateMachine = {
	start = function(): ()
		if started then return end
		started = true
	end,

	getState = function(): CharacterState
		return currentState
	end,

	is = function(state: CharacterState): boolean
		return currentState == state
	end,

	setState = function(state: CharacterState): boolean
		-- Treat redundant transition attempts as successful no-ops.
		if currentState == state then
			return true
		end

		local allowed = ALLOWED_TRANSITIONS[currentState]
		if not allowed or not allowed[state] then
			-- Log a warning to notify developers of invalid logic flows in calling modules.
			Logger.warn(`Invalid state transition requested: '{currentState}' -> '{state}'`)
			return false
		end

		currentState = state
		return true
	end,
}

return StateMachine
