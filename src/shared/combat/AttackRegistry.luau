--!strict

--[[
    AttackRegistry
    Resolves and caches data-driven Attack Definitions dynamically from sub-modules.
    This structure is architecturally decoupled from the physical filesystem. 
    The current directory lookup layout serves as the Version 1 resolver strategy.
]]

export type AttackDefinition = {
	Id: string,
	Animation: string,
	Damage: number,
	Startup: number,
	Active: number,
	Recovery: number,
	StaminaCost: number,
	HitboxSize: Vector3,
	HitboxOffset: Vector3,
	HitboxRotation: CFrame,
}

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Logger = require(ReplicatedStorage:WaitForChild("Shared"):WaitForChild("core"):WaitForChild("Logger"))

local AttackRegistry = {}
local cachedDefinitions: { [string]: AttackDefinition } = {}
local definitionsFolder = script:WaitForChild("definitions", 5) :: Folder

function AttackRegistry.get(id: string): AttackDefinition?
	if cachedDefinitions[id] then
		return cachedDefinitions[id]
	end

	if not definitionsFolder then
		Logger.error("AttackRegistry: definitions folder was not resolved during startup")
		return nil
	end

	-- Resolve dynamically from definition modules nested under this script instance.
	local module = definitionsFolder:FindFirstChild(id)
	if not module then
		Logger.warn(`AttackRegistry: No definition module found for attack ID '{id}'`)
		return nil
	end

	if module:IsA("ModuleScript") then
		local success, definition = pcall(require, module)
		if success and typeof(definition) == "table" then
			cachedDefinitions[id] = definition :: AttackDefinition
			return cachedDefinitions[id]
		else
			Logger.error(`AttackRegistry: Failed to load module script for attack ID '{id}'`)
		end
	end

	return nil
end

return AttackRegistry
