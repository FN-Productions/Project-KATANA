--!strict

--[[
    HitboxSystem
    Provides query-based collision detection for player attacks.
    Owns collision evaluation only. Attack timing and execution are driven 
    exclusively by higher-level systems (such as AttackSystem).
]]

export type HitboxConfig = {
	owner: Model,
	size: Vector3,
	localTransform: CFrame,
	activationId: number,
	debugEnabled: boolean?,
}

export type HitboxResult = {
	Targets: { Humanoid },
	HitCount: number,
}

export type Hitbox = {
	owner: Model,
	rootPart: BasePart,
	size: Vector3,
	localTransform: CFrame,
	activationId: number,
	hitCache: { [Model]: boolean },
	overlapParams: OverlapParams,
	debugVisual: Instance?,
}

export type HitboxSystem = {
	createHitbox: (config: HitboxConfig) -> Hitbox,
	evaluateHitbox: (hitbox: Hitbox) -> HitboxResult,
	destroyHitbox: (hitbox: Hitbox) -> (),
}

local Workspace = game:GetService("Workspace")

-- Resolves the owning character Model of a hit part by walking up the tree to locate the Humanoid container.
local function getCharacterModelFromPart(part: Instance): Model?
	local current = part.Parent
	while current and current ~= Workspace do
		if current:IsA("Model") and current:FindFirstChildOfClass("Humanoid") then
			return current
		end
		current = current.Parent
	end
	return nil
end

local HitboxSystem: HitboxSystem = {
	createHitbox = function(config: HitboxConfig): Hitbox
		-- Lightweight validation to catch integration bugs early during development.
		assert(config.owner and config.owner:IsA("Model"), "HitboxSystem: Invalid or missing owner Model")
		
		local rootPart = config.owner:FindFirstChild("HumanoidRootPart") or config.owner.PrimaryPart
		assert(rootPart and rootPart:IsA("BasePart"), "HitboxSystem: Owner character lacks a valid HumanoidRootPart or PrimaryPart")
		
		assert(config.size.X > 0 and config.size.Y > 0 and config.size.Z > 0, "HitboxSystem: Size dimensions must be positive non-zero values")
		assert(config.activationId > 0, "HitboxSystem: activationId must be a positive integer")

		-- Pre-configure OverlapParams for spatial queries, excluding the owner to prevent self-collision.
		local overlapParams = OverlapParams.new()
		overlapParams.FilterType = Enum.RaycastFilterType.Exclude
		overlapParams.FilterDescendantsInstances = { config.owner }

		local debugVisual: Instance? = nil
		if config.debugEnabled then
			-- We use Adornments parented directly to the root part because Roblox handles
			-- local coordinate translation natively, preventing frame-by-frame position set overhead.
			local adornment = Instance.new("BoxHandleAdornment")
			adornment.Size = config.size
			adornment.CFrame = config.localTransform
			adornment.Color3 = Color3.fromRGB(255, 0, 0)
			adornment.Transparency = 0.5
			adornment.AlwaysOnTop = true
			adornment.Adornee = rootPart
			adornment.Parent = rootPart
			debugVisual = adornment
		end

		return {
			owner = config.owner,
			rootPart = rootPart,
			size = config.size,
			localTransform = config.localTransform,
			activationId = config.activationId,
			hitCache = {},
			overlapParams = overlapParams,
			debugVisual = debugVisual,
		}
	end,

	evaluateHitbox = function(hitbox: Hitbox): HitboxResult
		if not hitbox.rootPart or not hitbox.rootPart.Parent then
			-- Safety fallback: avoid throwing exceptions if character parts are destroyed mid-activation.
			return { Targets = {}, HitCount = 0 }
		end

		-- Convert local offset CFrame into absolute world coordinates using cached rootPart.
		local worldCFrame = hitbox.rootPart.CFrame * hitbox.localTransform
		local overlappingParts = Workspace:GetPartBoundsInBox(worldCFrame, hitbox.size, hitbox.overlapParams)

		local hitTargets: { Humanoid } = {}
		for _, part in ipairs(overlappingParts) do
			local characterModel = getCharacterModelFromPart(part)
			if not characterModel or characterModel == hitbox.owner then
				continue
			end

			local humanoid = characterModel:FindFirstChildOfClass("Humanoid")
			if humanoid and humanoid.Health > 0 and not hitbox.hitCache[characterModel] then
				hitbox.hitCache[characterModel] = true
				table.insert(hitTargets, humanoid)
			end
		end

		return {
			Targets = hitTargets,
			HitCount = #hitTargets,
		}
	end,

	destroyHitbox = function(hitbox: Hitbox): ()
		if hitbox.debugVisual then
			hitbox.debugVisual:Destroy()
		end
		
		-- Clear duplicate caches and dereference objects to facilitate Lua garbage collection.
		table.clear(hitbox.hitCache)
		hitbox.owner = nil :: any
		hitbox.rootPart = nil :: any
		hitbox.overlapParams = nil :: any
		hitbox.debugVisual = nil :: any
	end,
}

return HitboxSystem
