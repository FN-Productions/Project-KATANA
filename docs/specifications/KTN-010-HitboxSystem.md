\# KTN-010 — HitboxSystem Specification



Status: Draft



Owner: FN Productions



Related Documents:



\- MDS-0005 — Combat System

\- MDS-0006 — Combat Pipeline

\- ADR-0009 — Data-Driven Combat Architecture

\- TDD-0002 — Attack Definitions



\---



\# Purpose



HitboxSystem is responsible for detecting valid combat hits.



It provides a generic interface for creating, activating, updating, and destroying hitboxes.



The system is completely independent of weapons, animations, and combat logic.



\---



\# Responsibilities



\- Spawn hitboxes.

\- Update hitboxes.

\- Detect collisions.

\- Report valid hits.

\- Prevent duplicate hits.

\- Destroy hitboxes.



\---



\# Non-Goals



HitboxSystem does NOT:



\- Apply damage.

\- Play animations.

\- Consume stamina.

\- Decide when attacks begin.

\- Manage combo logic.

\- Spawn visual effects.

\- Spawn audio.

\- Own combat state.



\---



\# Public API



```luau

create()



activate()



deactivate()



destroy()

```



No additional public APIs in Version 1.



\---



\# Dependencies



Consumes:



\- Attack Definitions (future)

\- Roblox Physics



Must NOT depend on:



\- InputController

\- CameraController

\- AnimationController

\- CombatController

\- UI



\---



\# Runtime Behavior



A hitbox progresses through the following lifecycle:



Created



↓



Inactive



↓



Active



↓



Inactive



↓



Destroyed



Only active hitboxes may detect collisions.



Destroyed hitboxes must release all runtime resources.



\---



\# Collision Rules



A valid collision must satisfy all conditions:



\- Hitbox is active.

\- Target exists.

\- Target is valid.

\- Target has not already been hit by this hitbox.

\- Collision is permitted by future combat rules.



Otherwise the collision is ignored.



\---



\# Duplicate Hit Prevention



A hitbox must never register multiple hits against the same target during a single activation.



Future attacks that intentionally support multiple hits will create separate activation windows.



\---



\# Failure Modes



If a hitbox:



\- loses its owner,

\- becomes invalid,

\- references destroyed instances,

\- or encounters invalid configuration,



the system should safely destroy the hitbox without affecting unrelated gameplay.



Failures should never crash the combat pipeline.



\---



\# Definition of Done



\- \[ ] Compiles with --!strict

\- \[ ] Generic implementation

\- \[ ] No combat logic

\- \[ ] No animation logic

\- \[ ] No damage logic

\- \[ ] Duplicate hits prevented

\- \[ ] Proper cleanup

\- \[ ] Idempotent lifecycle

\- \[ ] Code reviewed

\- \[ ] Playtested

\- \[ ] Committed



\---



\# Future Extensions



Future versions may support:



\- Capsule hitboxes

\- Sphere hitboxes

\- Box hitboxes

\- Swept hitboxes

\- Multi-hit attacks

\- Continuous hitboxes

\- Projectile hitboxes

\- Area-of-effect hitboxes

\- Network reconciliation

\- Debug visualization

