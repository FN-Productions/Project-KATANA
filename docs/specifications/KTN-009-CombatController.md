# KTN-009 — CombatController Specification

Status: Draft

Owner: FN Productions

Related Documents:

- MDS-0005 — Combat System
- CDD-0001 — Combat Philosophy
- CDD-0002 — Combat Architecture
- ADR-0002 — Data-Driven Combat
- TDD-0002 — Attack Definitions

---

# Purpose

CombatController is the orchestration layer of Project KATANA's combat system.

It receives combat requests from player input, validates high-level combat conditions, coordinates gameplay systems, and forwards approved requests to the appropriate combat subsystem.

CombatController does not own combat mechanics.

---

# Responsibilities

- Receive combat requests.
- Validate high-level combat conditions.
- Query StateMachine when required.
- Coordinate combat systems.
- Forward approved combat requests.
- Reject invalid combat requests.
- Remain independent of weapon implementations.

---

# It Is NOT Responsible For

CombatController must never directly implement or own:

- Weapon logic
- Combo logic
- Attack definitions
- Cooldown timers
- Damage calculation
- Hit detection
- Animation playback
- Stamina calculation
- Lock-On logic

---

# Public API

```luau
start()
```

Version 1 exposes only a startup interface.

Future public APIs should remain minimal and request-based.

Examples may include:

```luau
requestPrimaryAttack()

requestSecondaryAttack()

requestDodge()

requestBlock()
```

These APIs are intentionally deferred until future combat iterations.

---

# Dependencies

Consumes:

- InputController
- StateMachine

Future:

- AttackSystem
- StaminaSystem
- LockOnSystem

Must NOT directly use:

- UserInputService
- Players

Must NOT directly manipulate:

- Health
- Animation
- Damage
- Hitboxes

---

# Runtime Behavior

CombatController runs continuously after initialization.

Combat flow follows the architecture defined in CDD-0002.

Player Input

↓

CombatController

↓

Validation

↓

AttackSystem

↓

Animation

↓

Hitbox

↓

Damage

↓

Health

CombatController validates whether combat actions are currently permitted.

Invalid requests are rejected silently unless debugging is enabled.

Approved requests are forwarded to the appropriate gameplay system.

---

# Design Constraints

CombatController is an orchestrator.

It coordinates gameplay systems but owns very little gameplay logic.

Combat mechanics should remain inside specialized systems.

Future gameplay features should extend CombatController through composition rather than continuously expanding its responsibilities.

CombatController should remain small, readable, and easy to reason about throughout the lifetime of the project.

---

# Definition of Done

- [ ] Compiles with --!strict
- [ ] start() is idempotent
- [ ] Uses InputController
- [ ] Uses StateMachine
- [ ] Performs validation only
- [ ] No weapon-specific logic
- [ ] No combo logic
- [ ] No attack implementation
- [ ] No damage implementation
- [ ] No hitbox implementation
- [ ] No animation implementation
- [ ] Public API documented
- [ ] Code reviewed
- [ ] Playtested
- [ ] Committed

---

# Future Extensions

Not part of Version 1:

- Combo routing
- Heavy attacks
- Charged attacks
- Perfect attacks
- Weapon skills
- Parries
- Dodges
- Finishers
- Air combat
- Hyper Armor
- Multiplayer combat