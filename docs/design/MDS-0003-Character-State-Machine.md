\# MDS-0003 — Character State Machine



Status: Draft



Owner: FN Productions



Related Documents:



\- MDS-0001 — Player Locomotion

\- MDS-0002 — Third-Person Camera



\---



\# Purpose



This document defines the gameplay state model for the player character.



It specifies how gameplay systems determine what the player is currently doing.



It does not define implementation details.



\---



\# Philosophy



The state machine is the single source of truth for player gameplay state.



Gameplay systems should query the state machine instead of maintaining their own independent state flags.



The state machine exists to improve consistency, readability, and maintainability.



\---



\# Version 1 Goals



The first version focuses only on locomotion states.



Included:



\- Idle

\- Walking

\- Falling



Future gameplay states are intentionally excluded.



\---



\# Behavioral Rules



Only one gameplay state may be active at a time.



State transitions should always be explicit.



Invalid transitions should be rejected.



Gameplay systems should never directly modify internal state variables.



\---



\# State Definitions



\## Idle



The player is alive and not moving.



\---



\## Walking



The player is providing movement input while grounded.



\---



\## Falling



The player is not grounded.



\---



\# Future States



Not part of Version 1:



\- Sprinting

\- Jumping

\- Dodging

\- Attacking

\- Blocking

\- Hit Reaction

\- Stunned

\- Dead

\- Lock-On

\- Interacting



\---



\# Success Criteria



Every gameplay system should be able to determine the player's current gameplay state by querying a single module.

