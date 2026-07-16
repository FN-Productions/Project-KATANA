\# KTN-013 — LockOnSystem Specification



Status: Draft



Owner: FN Productions



Related Documents:



\- MDS-0005 — Combat System

\- MDS-0006 — Combat Pipeline

\- MDS-0002 — Third-Person Camera



\---



\# Purpose



LockOnSystem manages target selection and lock-on state.



It provides a consistent target reference for gameplay systems while remaining independent of combat execution.



Lock-on is optional.



Combat must remain fully functional without it.



\---



\# Responsibilities



\- Acquire targets.

\- Release targets.

\- Maintain active lock-on state.

\- Validate target availability.

\- Switch between valid targets.

\- Expose the currently locked target.



\---



\# Non-Goals



LockOnSystem does NOT:



\- Execute attacks.

\- Move the character.

\- Rotate the camera.

\- Apply damage.

\- Play animations.

\- Spawn hitboxes.

\- Consume stamina.

\- Own combat logic.



\---



\# Public API



```luau

lock(target)



unlock()



toggle()



switch(direction)



hasTarget()



getTarget()

```



No additional public APIs in Version 1.



\---



\# Dependencies



Consumes:



\- CharacterController



Must NOT depend on:



\- AttackSystem

\- HitboxSystem

\- AnimationController

\- StaminaSystem

\- UI



\---



\# Runtime Behavior



A lock-on session follows this lifecycle:



Unlocked



↓



Target Acquired



↓



Locked



↓



Target Lost or Released



↓



Unlocked



\---



\# Target Validation



A valid target must:



\- Exist.

\- Be alive.

\- Be targetable.

\- Be within maximum range.

\- Be visible (future).



If any requirement fails, the target is released.



\---



\# Target Switching



Version 1 supports manual target switching.



Switching should only consider valid nearby targets.



Selection rules will be expanded in future versions.



\---



\# Failure Modes



If:



\- Target is destroyed.

\- Target dies.

\- Target leaves range.

\- Target becomes invalid.



The system releases the lock safely.



No stale references should remain.



\---



\# Definition of Done



\- \[ ] Compiles with --!strict

\- \[ ] Target acquisition implemented

\- \[ ] Target validation implemented

\- \[ ] Lock/unlock implemented

\- \[ ] Target switching implemented

\- \[ ] Safe cleanup

\- \[ ] No stale references

\- \[ ] Code reviewed

\- \[ ] Playtested

\- \[ ] Committed



\---



\# Future Extensions



Future versions may support:



\- Soft Lock

\- Smart Target Selection

\- Boss Priority

\- Threat Priority

\- Camera Assist

\- Aim Assist

\- Multiplayer Target Ownership

\- Lock Persistence

\- Predictive Target Selection

