\# KTN-011 — AttackSystem Specification



Status: Draft



Owner: FN Productions



Related Documents:



\- MDS-0005 — Combat System

\- MDS-0006 — Combat Pipeline

\- ADR-0009 — Data-Driven Combat Architecture

\- TDD-0002 — Attack Definitions

\- KTN-010 — HitboxSystem



\---



\# Purpose



AttackSystem executes Attack Definitions.



It coordinates the lifecycle of an attack by interpreting attack data and delegating work to specialized systems.



AttackSystem owns attack execution.



It does not own combat decisions.



\---



\# Responsibilities



\- Execute Attack Definitions.

\- Validate attack data.

\- Coordinate attack timing.

\- Coordinate startup, active, and recovery phases.

\- Request hitbox activation.

\- Request stamina consumption.

\- Request animation playback.

\- Notify completion.



\---



\# Non-Goals



AttackSystem does NOT:



\- Read player input.

\- Decide when attacks should begin.

\- Detect collisions.

\- Apply damage.

\- Own combat state.

\- Control camera.

\- Manage lock-on.

\- Manage UI.



\---



\# Public API



```luau

execute(attackDefinition)



cancel()



isExecuting()

```



No additional public APIs in Version 1.



\---



\# Dependencies



Consumes:



\- Attack Definitions

\- HitboxSystem

\- AnimationController

\- StaminaSystem



Must NOT depend on:



\- InputController

\- CameraController

\- UI



\---



\# Runtime Behavior



Attack execution follows this sequence:



Validate



↓



Consume Resources



↓



Play Animation



↓



Startup



↓



Activate Hitbox



↓



Active Frames



↓



Deactivate Hitbox



↓



Recovery



↓



Complete



\---



\# Validation



Before execution:



\- Attack Definition exists.

\- Required fields exist.

\- Timings are valid.

\- Resources are sufficient.

\- Attack is executable.



Execution stops immediately if validation fails.



\---



\# Timing



Attack timing is completely data-driven.



The Attack Definition specifies:



\- Startup

\- Active

\- Recovery



AttackSystem must never hardcode timings.



\---



\# Cancellation



Version 1 supports only full cancellation.



Partial cancels, combo cancels, animation cancels, and buffering are future features.



\---



\# Completion



When recovery finishes:



\- Temporary resources are released.

\- Active hitboxes are destroyed.

\- Completion is reported to CombatController.



\---



\# Failure Modes



If execution fails:



\- Invalid Attack Definition

\- Missing animation

\- Missing hitbox

\- Stamina failure

\- Runtime interruption



The current attack must terminate safely.



No partial attack state may remain active.



\---



\# Definition of Done



\- \[ ] Compiles with --!strict

\- \[ ] Executes Attack Definitions

\- \[ ] Data-driven timing

\- \[ ] Uses HitboxSystem

\- \[ ] Uses StaminaSystem

\- \[ ] Uses AnimationController

\- \[ ] Safe cancellation

\- \[ ] Proper cleanup

\- \[ ] Code reviewed

\- \[ ] Playtested

\- \[ ] Committed



\---



\# Future Extensions



Future versions may support:



\- Combo chains

\- Attack buffering

\- Cancel windows

\- Perfect attacks

\- Charge attacks

\- Hyper Armor

\- Root Motion

\- Hit Stop

\- Air attacks

\- Weapon-specific execution

\- Multiplayer prediction

