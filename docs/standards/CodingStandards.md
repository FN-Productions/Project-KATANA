\# Coding Standards



\## Language



\- Luau

\- `--!strict` in every source file



\## File Naming



\- PascalCase for ModuleScripts

\- camelCase for local variables

\- UPPER\_SNAKE\_CASE for constants



\## Module Rules



\- One responsibility per module.

\- No global variables.

\- Public APIs should use type annotations.



\## Functions



\- Keep functions small.

\- Prefer composition over long functions.



\## Comments



\- Explain \*\*why\*\*, not \*\*what\*\*.

# Naming Conventions

## Controllers

All controllers must end with:

Controller

Examples:

- MovementController
- CameraController
- CombatController

---

## Services

All server services must end with:

Service

Examples:

- EnemyService
- SaveService
- CombatService

---

## Managers

Managers coordinate multiple systems.

Examples:

- AudioManager
- AssetManager

---

## Modules

Utility modules should describe what they provide.

Examples:

- Logger
- Configuration
- MathUtils

---

## Events

Events should use verbs.

Examples:

PlayerSpawned

EnemyDefeated

BossStarted

---

## Booleans

Should read naturally.

Examples:

isAlive

isGrounded

hasTarget

canAttack

shouldSprint

Never:

alive

grounded

target

---

## Functions

Prefer verbs.

Examples:

start()

stop()

initialize()

update()

calculateDirection()

Never:

movement()

camera()

thing()

runStuff()

---

## Constants

UPPER_SNAKE_CASE

Example:

DEFAULT_WALK_SPEED

MAX_CAMERA_DISTANCE

DEBUG_ENABLED



# Configuration

Gameplay tuning values should not be hardcoded inside gameplay systems.

Whenever practical, tunable values should be stored in dedicated configuration modules.

Examples:

- CameraConfig
- MovementConfig
- CombatConfig

This separates gameplay tuning from implementation logic and simplifies balancing.
