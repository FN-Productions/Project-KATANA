\# KTN-007 — StateMachine Specification



Status: Draft



Owner: FN Productions



Related Documents:



\- MDS-0003 — Character State Machine



\---



\# Purpose



StateMachine owns the player's gameplay state.



It provides a centralized interface for querying and changing gameplay state.



\---



\# Responsibilities



Owns:



\- Current gameplay state

\- State transitions

\- State validation



Does NOT own:



\- Animation

\- Combat

\- Input

\- Camera

\- Character movement



\---



\# Public API



```luau

start()



getState()



is(state)



setState(state)

```



\---



\# Dependencies



Consumes:



\- CharacterController

\- MovementController (read-only)



Must NOT depend on:



\- CameraController

\- Combat systems

\- UI



\---



\# Runtime Behavior



\- Starts once.

\- Maintains exactly one active state.

\- Rejects invalid transitions.

\- Updates only when state changes are required.



\---



\# Engineering Constraints



\- Compiles with --!strict.

\- start() is idempotent.

\- No duplicate state variables.

\- Single source of truth.

\- Modular.



\---



\# Definition of Done



\- \[ ] Compiles with --!strict

\- \[ ] start() is idempotent

\- \[ ] One active state

\- \[ ] State transitions work

\- \[ ] Invalid transitions rejected

\- \[ ] Public API documented

\- \[ ] Code reviewed

\- \[ ] Playtested

\- \[ ] Committed



\---



\# Future Extensions



\- Hierarchical states

\- State callbacks

\- Network replication

\- Animation integration

\- Combat integration

