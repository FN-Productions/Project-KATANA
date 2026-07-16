--!strict

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local HitboxSystem = require(
	ReplicatedStorage.Shared.combat.HitboxSystem
)

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()

-- Give the character time to finish spawning.
task.wait(2)

local hitbox = HitboxSystem.createHitbox({
	owner = character,
	size = Vector3.new(6, 6, 6),
	localTransform = CFrame.new(0, 0, -4),
	activationId = 1,
	debugEnabled = true,
})

print("========== HITBOX TEST START ==========")
print("Created Hitbox")

local totalHits = 0

-- Evaluate the hitbox for roughly 5 seconds.
for frame = 1, 300 do
	local result = HitboxSystem.evaluateHitbox(hitbox)

	assert(result ~= nil, "HitboxSystem returned nil!")

	if result.HitCount > 0 then
		totalHits += result.HitCount

		print("----------------------------------")
		print("Frame:", frame)
		print("HitCount:", result.HitCount)

		for _, humanoid in ipairs(result.Targets) do
			print("Hit Target:", humanoid.Parent and humanoid.Parent.Name)
		end
	end

	task.wait()
end

print("----------------------------------")
print("Evaluation Complete")
print("Total Registered Hits:", totalHits)

HitboxSystem.destroyHitbox(hitbox)

print("Destroyed Hitbox")
print("=========== TEST COMPLETE ==========")