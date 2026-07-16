\# MDS-0006 — Combat Pipeline



Status: Draft



Owner: FN Productions



Related Documents:



\- MDS-0005 — Combat System

\- ADR-0009 — Data-Driven Combat Architecture

\- TDD-0002 — Attack Definitions



\---



\# Purpose



This document defines the execution pipeline for player combat.



It describes how combat requests flow through the Project KATANA engine from player input until an attack has completely finished.



This document intentionally describes system interactions rather than implementation details.



\---



\# Design Goals



The combat pipeline should be:



\- Predictable

\- Modular

\- Data-driven

\- Extensible

\- Easy to debug

\- Easy to test



Every combat action should follow the same execution flow.



\---



\# High-Level Flow



Player Input



↓



InputController



↓



CombatController



↓



Validation



↓



AttackSystem



↓



Attack Definition



↓



StaminaSystem



↓



AnimationController



↓



HitboxSystem



↓



Damage System (Future)



↓



Recovery



↓



Combat Complete



\---



\# Pipeline Stages



\## 1. Input



The player requests a combat action.



Examples:



\- Light Attack

\- Heavy Attack

\- Dodge

\- Block

\- Weapon Skill



InputController only reports player intent.



It never executes gameplay.



\---



\## 2. Combat Validation



CombatController receives the request.



Before execution it validates:



\- Character is alive.

\- Character is not locked.

\- Required resources are available.

\- Current state allows the requested action.

\- Attack exists.



If validation fails, execution stops immediately.



\---



\## 3. Attack Resolution



CombatController forwards the request to AttackSystem.



AttackSystem loads the corresponding Attack Definition.



No gameplay behavior is hardcoded.



The Attack Definition becomes the single source of truth.



\---



\## 4. Resource Validation



Systems verify that the attack can execute.



Examples include:



\- Stamina

\- Cooldowns

\- Future weapon requirements

\- Future buffs/debuffs



If any requirement fails, execution stops.



\---



\## 5. Animation



AnimationController begins playback of the attack animation.



Animation reflects gameplay.



Animation does not own gameplay.



Gameplay timing always remains authoritative.



\---



\## 6. Startup Frames



Startup represents the preparation phase.



Characteristics:



\- Hitbox inactive

\- Damage impossible

\- Attack may still be interrupted (depending on future rules)



Startup duration is defined by the Attack Definition.



\---



\## 7. Active Frames



AttackSystem requests HitboxSystem to activate the hitbox.



During this window:



\- Collision detection is enabled.

\- Damage can occur.

\- Effects may trigger.



The duration is defined entirely by the Attack Definition.



\---



\## 8. Recovery Frames



The hitbox is removed.



The player transitions through recovery.



Recovery represents commitment after the attack.



Future systems may allow partial or complete recovery cancellation.



\---



\## 9. Combat Complete



The attack finishes.



CombatController clears temporary combat restrictions.



The character becomes available for the next valid action.



\---



\# Responsibilities



\## CombatController



Owns:



\- Validation

\- Combat flow

\- Coordination



Does NOT own:



\- Damage

\- Hitboxes

\- Animation playback

\- Stamina calculations



\---



\## AttackSystem



Owns:



\- Attack Definition execution

\- Attack timing

\- Startup

\- Active frames

\- Recovery



\---



\## HitboxSystem



Owns:



\- Hitbox creation

\- Hitbox activation

\- Collision detection

\- Hit registration



\---



\## AnimationController



Owns:



\- Visual playback

\- Blending

\- Animation transitions



Never owns gameplay timing.



\---



\## StaminaSystem



Owns:



\- Resource validation

\- Resource consumption

\- Future regeneration



\---



\# Pipeline Principles



\## Single Direction



Combat always flows forward.



Systems should not create circular dependencies.



\---



\## Single Responsibility



Every stage owns one responsibility.



Responsibilities must not overlap.



\---



\## Data-Driven



Combat behavior comes from Attack Definitions.



Systems execute data.



They do not invent behavior.



\---



\## Deterministic



Given the same:



\- input

\- attack definition

\- player state



the combat pipeline should always produce the same result.



\---



\# Future Extensions



This pipeline intentionally leaves room for future systems.



Examples include:



\- Combo chains

\- Cancel windows

\- Perfect attacks

\- Hyper Armor

\- Poise

\- Guard Break

\- Hit Stop

\- Root Motion

\- Lock-On

\- Multiplayer prediction

\- Networking

\- Boss-specific combat

\- Weapon abilities



These systems should integrate into the existing pipeline rather than replacing it.



\---



\# Guiding Principle



CombatController coordinates.



Systems execute.



Attack Definitions describe.



This separation of responsibilities is the architectural foundation of Project KATANA's combat engine.

