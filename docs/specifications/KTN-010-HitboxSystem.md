# KTN-010 — HitboxSystem Specification

Status: Draft

Owner: FN Productions

Related Documents:

- MDS-0005 — Combat System
- MDS-0006 — Combat Pipeline
- CDD-0001 — Combat Philosophy
- CDD-0002 — Combat Architecture
- ADR-0002 — Data-Driven Combat
- TDD-0002 — Attack Definitions

---

# Purpose

HitboxSystem is responsible for detecting valid physical intersections between attacks and potential targets.

It provides a generic, data-driven interface for creating, evaluating, and destroying hitboxes.

HitboxSystem owns collision detection only.

It does not make gameplay decisions.

---

# Responsibilities

- Create hitbox instances.
- Own hitbox lifecycle.
- Compute hitbox transforms.
- Evaluate physical intersections.
- Perform engine-level filtering.
- Prevent duplicate hits.
- Produce HitboxResult objects.
- Destroy hitboxes.

---

# It Is NOT Responsible For

HitboxSystem must never directly implement or own:

- Damage calculation
- Combat logic
- Combo logic
- Weapon logic
- Animation playback
- Stamina
- Lock-On
- Visual effects
- Audio
- Gameplay state

---

# Design Philosophy

Project KATANA uses query-based hit detection.

Hitboxes are not physical Parts.

Instead, HitboxSystem computes a hitbox transform every update while the hitbox is active and performs overlap queries using Roblox's spatial query APIs.

This produces deterministic, data-driven hit detection that remains independent of physics simulation.

---

# Public API

```luau
createHitbox()

destroyHitbox()
```

Hitbox activation and deactivation are internal lifecycle operations.

Version 1 intentionally exposes only minimal public APIs.

---

# Ownership

HitboxSystem owns:

- Hitbox instances
- Hitbox lifecycle
- Duplicate-hit cache
- Query execution
- Collision filtering
- HitboxResult generation

AttackSystem owns:

- Attack lifecycle
- Gameplay validation
- Damage routing
- Combat flow

DamageSystem owns:

- Damage application

StateMachine owns:

- Gameplay state

Ownership never transfers between systems.

---

# Dependencies

Consumes:

- Roblox Spatial Queries
- Workspace
- OverlapParams
- Attack Definitions (future)

Must NOT depend on:

- CombatController
- AnimationController
- CameraController
- InputController
- UI
- DamageSystem

---

# Runtime Behavior

Hitboxes follow the lifecycle below:

Created

↓

Inactive

↓

Active

↓

Evaluate Query

↓

Produce HitboxResult

↓

Inactive

↓

Destroyed

Only active hitboxes perform collision queries.

Destroyed hitboxes must immediately release all runtime resources.

---

# Transform Model

Hitboxes are defined in character-local space.

Each attack specifies:

- Size
- Offset
- Rotation

During evaluation the final transform is computed from:

Character Transform

+

Attack Offset

+

Attack Rotation

↓

Final Hitbox Transform

No physical Parts are created.

---

# Query Model

While active, a hitbox continuously evaluates overlap queries.

The default query implementation uses:

```luau
Workspace:GetPartBoundsInBox()
```

The query executes every evaluation step until the hitbox is deactivated.

Future hitbox shapes may use different query methods without changing the external API.

---

# Collision Filtering

HitboxSystem performs only engine-level filtering.

Examples include:

- Ignore the hitbox owner.
- Ignore duplicate targets during the current activation.
- Apply OverlapParams filtering.
- Ignore invalid instances.

Gameplay validation is performed by higher-level combat systems.

---

# HitboxResult

HitboxSystem returns structured HitboxResult objects rather than raw target lists.

Version 1 includes:

- Targets
- HitCount

Future versions may extend HitboxResult with additional metadata without changing the public API.

---

# Duplicate Hit Prevention

Each hitbox instance owns its own duplicate-hit cache.

A target may only be registered once during a single hitbox activation.

When the hitbox is destroyed, its duplicate cache is destroyed with it.

No global duplicate cache exists.

---

# Debug Visualization

Debug visualization is optional.

When enabled:

- Draw hitbox bounds.
- Display orientation.
- Visualize active state.
- Destroy debug geometry with the hitbox.

When disabled:

- No debug geometry is created.
- Gameplay behavior remains identical.

Debug visualization must never influence gameplay.

---

# Failure Modes

If a hitbox:

- loses its owner,
- references destroyed instances,
- encounters invalid configuration,
- or becomes otherwise invalid,

HitboxSystem must safely destroy the hitbox.

Failures must never propagate into unrelated gameplay systems.

---

# Definition of Done

- [ ] Compiles with --!strict
- [ ] Query-based implementation
- [ ] No physical hitbox Parts
- [ ] Character-local transforms
- [ ] Engine-level filtering only
- [ ] Structured HitboxResult
- [ ] Duplicate-hit prevention
- [ ] Proper lifecycle ownership
- [ ] Proper cleanup
- [ ] Idempotent lifecycle
- [ ] No combat logic
- [ ] No animation logic
- [ ] No damage logic
- [ ] Code reviewed
- [ ] Playtested
- [ ] Committed

---

# Future Extensions

Future versions may support:

- Capsule hitboxes
- Sphere hitboxes
- Swept hitboxes
- Continuous hitboxes
- Projectile hitboxes
- Area-of-effect hitboxes
- Multi-hit attacks
- Bone-attached hitboxes
- Debug analytics
- Network reconciliation
- Multiplayer authority