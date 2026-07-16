\# CDD-0002 — Combat Architecture



Status: Approved



Owner: FN Productions



\---



\# Purpose



This document defines the architectural philosophy of Project KATANA's combat systems.



It establishes ownership, responsibilities, communication patterns, and long-term engineering principles.



Every combat system should follow these rules.



\---



\# Philosophy



Combat is composed of many small systems.



Each system should have a single responsibility.



No system should own another system's data.



Systems communicate through well-defined interfaces.



\---



\# Combat Flow



Player Input



↓



CombatController



↓



Gameplay Systems



↓



Animation



↓



Hitboxes



↓



Damage



↓



Health



↓



Feedback



Combat always flows forward.



Dependencies should never flow backward.



\---



\# CombatController



CombatController is the orchestrator.



It coordinates gameplay systems.



It does not own gameplay mechanics.



CombatController should remain small, readable, and easy to reason about.



Responsibilities:



\- Receive combat requests

\- Validate high-level conditions

\- Coordinate gameplay systems

\- Forward requests



CombatController should never directly implement:



\- weapon logic

\- combo logic

\- hit detection

\- damage calculation

\- stamina costs

\- animation playback



\---



\# AttackSystem



AttackSystem owns attacks.



Responsibilities:



\- combo progression

\- cooldowns

\- attack selection

\- attack definitions

\- attack timing



AttackSystem should not know:



\- camera

\- movement input

\- UI



\---



\# AnimationController



AnimationController is purely visual.



It reflects gameplay.



It never decides gameplay.



Gameplay always has authority over animation.



\---



\# StateMachine



StateMachine is the single source of truth for gameplay state.



Other systems may read it.



Only designated gameplay systems may request state transitions.



\---



\# HitboxSystem



HitboxSystem owns hit detection.



It decides:



\- active windows

\- collision checks

\- hit registration



It does not calculate damage.



\---



\# DamageSystem



DamageSystem owns damage calculation.



Responsibilities:



\- damage values

\- modifiers

\- resistances

\- critical hits

\- future elemental systems



\---



\# HealthSystem



HealthSystem owns health.



Only HealthSystem modifies health values.



Other systems request health changes.



\---



\# Data Driven Design



Gameplay data should live outside code whenever practical.



Examples:



\- attack definitions

\- weapon statistics

\- stamina costs

\- combo timings

\- hitbox sizes



Adding a new weapon should primarily require creating new data rather than modifying gameplay code.



\---



\# Communication Rules



Systems communicate only through public APIs.



No system should directly modify another system's internal state.



Every system owns its own data.



\---



\# Single Source of Truth



Every piece of gameplay information should have one owner.



Examples:



State → StateMachine



Health → HealthSystem



Attack Data → AttackSystem



Animation Playback → AnimationController



Input → InputController



Character References → CharacterController



\---



\# Scalability



The combat architecture should support future additions without requiring major redesign.



Examples include:



\- multiple weapons

\- bosses

\- lock-on

\- parries

\- stamina

\- magic

\- multiplayer

\- replay systems



New systems should integrate by extending existing interfaces rather than modifying established systems.



\---



\# Design Principles



The combat architecture follows these principles:



\- Single Responsibility Principle

\- Data-Oriented Design where appropriate

\- Composition over inheritance

\- Explicit ownership

\- Loose coupling

\- High cohesion

\- Predictable data flow



\---



\# Long-Term Goal



Combat systems should remain understandable even after years of development.



Adding new mechanics should primarily involve creating new modules and new data, not expanding existing controllers.



The architecture should encourage growth without increasing complexity.

