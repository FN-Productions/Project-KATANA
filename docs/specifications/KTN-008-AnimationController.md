\# KTN-008 — AnimationController Specification



Status: Implemented



Owner: FN Productions



Related Documents:



\- MDS-0004 — Animation System



\---



\# Purpose



AnimationController converts gameplay state into character animations.



\---



\# Responsibilities



Owns:



\- Animation playback

\- Animation transitions

\- Animation caching



Does NOT own:



\- Gameplay state

\- Input

\- Movement

\- Camera



\---



\# Public API



```luau

start()

```



\---



\# Dependencies



Consumes:



\- StateMachine

\- CharacterController



Must NOT depend on:



\- InputController

\- CameraController

\- MovementController



\---



\# Runtime Behavior



\- Starts once.

\- Loads animations.

\- Reacts to gameplay state changes.

\- Plays exactly one locomotion animation.



\---



\# Engineering Constraints



\- Compiles with --!strict.

\- start() is idempotent.

\- No duplicate animation loading.

\- Cached AnimationTracks.



\---



\# Definition of Done



## Definition of Done

- [x] Compiles with --!strict
- [x] start() is idempotent
- [x] Uses AnimationConfig
- [x] Uses CharacterController
- [x] Uses StateMachine
- [x] Loads animations safely
- [x] Cleans tracks on respawn
- [x] Smooth cross-fade transitions
- [x] No gameplay state mutation
- [x] Code reviewed
- [x] Playtested
- [x] Committed
