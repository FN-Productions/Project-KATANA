--!strict

--[[
    CombatController
    Orchestrates player combat request validation and routing to subsystems.
    NOTE: This controller owns no gameplay data. All execution remains decoupled
    and managed by specialized systems to ensure modularity.
]]

export type CombatController = {
	start: () -> (),

	-- Future Request APIs (Deferred for future implementation):
	-- requestPrimaryAttack: () -> boolean,
	-- requestSecondaryAttack: () -> boolean,
	-- requestDodge: () -> boolean,
	-- requestBlock: () -> boolean,
}

local StateMachine = require(script.Parent:WaitForChild("StateMachine"))

-- Idempotency tracking flag.
local started = false

local CombatController: CombatController = {
	start = function(): ()
		if started then return end
		started = true
	end,
}

return CombatController
