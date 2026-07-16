--!strict
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local AttackRegistry = require(ReplicatedStorage.Shared.combat.AttackRegistry)

local Katana_Light_01: AttackRegistry.AttackDefinition = {
	Id = "Katana_Light_01",
	Animation = "rbxassetid://180435571", -- Temporary placeholder asset
	Damage = 25,
	Startup = 0.15,
	Active = 0.08,
	Recovery = 0.30,
	StaminaCost = 10,
	HitboxSize = Vector3.new(4, 5, 6),
	HitboxOffset = Vector3.new(0, 0, -3),
	HitboxRotation = CFrame.identity,
}

return Katana_Light_01
