# KTN-011 — AttackSystem Specification

Status: Draft

Owner: FN Productions

Related Documents:

- MDS-0005 — Combat System
- MDS-0006 — Combat Pipeline
- ADR-0009 — Data-Driven Combat Architecture
- TDD-0002 — Attack Definitions
- KTN-009 — CombatController
- KTN-010 — HitboxSystem

---

# Purpose

AttackSystem is the central execution engine for combat attacks.

It interprets immutable Attack Definitions, creates temporary Runtime Attack instances, coordinates attack execution, and delegates specialized work to other combat systems.

AttackSystem owns attack execution.

It does **NOT** own combat decisions.

---

# Responsibilities

- Resolve Attack Definitions through the Attack Registry.
- Validate attack execution requests.
- Create Runtime Attack instances.
- Execute attack timelines.
- Coordinate startup, active, and recovery phases.
- Request animation playback.
- Create and evaluate hitboxes through HitboxSystem.
- Coordinate future stamina consumption.
- Safely terminate attack execution.
- Destroy Runtime Attack instances after completion.

---

# Non-Goals

AttackSystem does NOT:

- Read player input.
- Decide when attacks should begin.
- Detect collisions.
- Apply damage.
- Own combat state.
- Own weapon logic.
- Own combo trees.
- Control the camera.
- Control UI.
- Perform networking.

---

# Runtime Attack

A Runtime Attack is a temporary execution object created from an immutable Attack Definition.

Attack Definitions are never modified during gameplay.

A Runtime Attack owns only execution data required while an attack is active.

Typical runtime data includes:

- elapsed execution time
- current attack phase
- active hitboxes
- execution status
- temporary runtime references

Runtime Attack instances are destroyed immediately after execution completes or is cancelled.

---

# One Active Attack Rule

Version 1 supports only one active Runtime Attack per character.

If an execution request is received while another Runtime Attack is active, the request fails unless the current attack has first been cancelled.

Support for concurrent attack execution is outside the scope of Version 1.

---

# Public API

```luau
execute(attackId)

cancel()

isExecuting()
```

No additional public APIs are included in Version 1.

---

# Dependencies

Consumes:

- Attack Registry
- HitboxSystem
- AnimationController

Future:

- DamageSystem
- StaminaSystem
- ComboTree
- WeaponSystem

Must NOT depend on:

- InputController
- CameraController
- UI
- UserInputService

---

# Runtime Behavior

Attack execution follows the sequence below:

Resolve Attack Definition

↓

Validate Request

↓

Create Runtime Attack

↓

Request Animation Playback

↓

Execute Startup Phase

↓

Create / Evaluate Hitboxes

↓

Execute Active Phase

↓

Execute Recovery Phase

↓

Destroy Runtime Attack

↓

Execution Complete

AttackSystem owns the execution timeline.

Attack Definitions only describe the timeline.

---

# Validation

Before execution:

- Attack ID is valid.
- Attack Definition exists.
- Required fields exist.
- Definition is internally valid.
- No Runtime Attack is currently executing.
- Required future resources are available.

Execution immediately fails if validation does not succeed.

---

# Attack Definitions

Attack Definitions are immutable data assets.

AttackSystem may read Attack Definitions.

AttackSystem must never modify Attack Definitions.

All temporary execution state belongs exclusively to the Runtime Attack.

---

# Hitbox Ownership

AttackSystem owns hitbox timing.

HitboxSystem owns collision evaluation.

AttackSystem determines:

- when hitboxes are created
- when hitboxes are evaluated
- when hitboxes are destroyed

HitboxSystem performs only collision detection.

---

# Animation Ownership

AttackSystem owns animation requests.

AnimationController owns animation playback.

AnimationController never determines gameplay progression.

AttackSystem remains the single owner of attack execution.

---

# Timing

Attack timing is entirely data-driven.

Attack Definitions describe:

- Startup
- Active
- Recovery

AttackSystem executes those timings.

AttackSystem must never hardcode attack durations.

---

# Cancellation

Version 1 supports only full attack cancellation.

Cancellation immediately:

- destroys active hitboxes
- destroys the Runtime Attack
- releases temporary execution resources

Attack buffering, cancel windows, combo cancels, and animation cancels are future features.

---

# Completion

When execution finishes:

- active hitboxes are destroyed
- temporary runtime resources are released
- Runtime Attack is destroyed
- AttackSystem returns to the idle execution state

No temporary execution state may persist.

---

# Failure Modes

Execution must terminate safely if:

- Attack ID is invalid
- Attack Definition is missing
- Runtime Attack creation fails
- Animation cannot be requested
- Hitbox creation fails
- Runtime execution is interrupted

Failures must never leave partial execution state active.

---

# Definition of Done

- [ ] Compiles with --!strict
- [ ] Resolves Attack Definitions through the Attack Registry
- [ ] Creates Runtime Attack instances
- [ ] Maintains one active Runtime Attack
- [ ] Uses HitboxSystem
- [ ] Uses AnimationController
- [ ] Data-driven execution timeline
- [ ] Safe cancellation
- [ ] Proper cleanup
- [ ] Code reviewed
- [ ] Playtested
- [ ] Committed

---

# Future Extensions

Future versions may support:

- ComboTree integration
- Attack buffering
- Cancel windows
- Perfect attacks
- Charge attacks
- Hyper Armor
- Root Motion
- Hit Stop
- Air attacks
- Weapon plug-in architecture
- Multiplayer prediction
- Replay support
- Multi-hit execution
- Concurrent Runtime Attacks