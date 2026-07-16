\# Project KATANA Engine Architecture v1



Status: Draft



Owner: FN Productions



\---



\# Purpose



This document defines the high-level architecture of Project KATANA.



It describes how engine subsystems communicate, their responsibilities, and architectural boundaries.



This document intentionally avoids implementation details.



\---



\# Core Principles



\- Single Responsibility

\- Loose Coupling

\- High Cohesion

\- Engine Independence

\- Modular Design

\- Data-Oriented Thinking

\- Explicit Ownership



\---



\# Layered Architecture



Player Input



↓



Controllers



↓



Gameplay Systems



↓



Animation



↓



Presentation



↓



Roblox Engine



\---



\# Current Subsystems



\## Client



\- ClientBootstrap

\- InputController

\- CharacterController

\- MovementController



\## Shared



\- Logger



\## Server



\- ServerBootstrap



\---



\# Dependency Rules



Controllers may communicate with:



\- Shared modules

\- Other controllers when explicitly allowed



Controllers must NOT communicate directly with:



\- UserInputService

\- Players (unless they own player management)

\- GUI

\- Combat

\- Animation



Gameplay systems should communicate through public APIs only.



\---



\# Data Flow



Input



↓



InputController



↓



MovementController



↓



CharacterController



↓



Humanoid



↓



Roblox Physics



\---



\# Lifecycle



Game Starts



↓



Bootstrap



↓



Controllers



↓



Gameplay Systems



↓



Runtime



\---



\# Ownership



InputController



Owns:



\- Raw player input



Does NOT own:



\- Character

\- Camera

\- Movement



\---



CharacterController



Owns:



\- Character references

\- Humanoid references



Does NOT own:



\- Input

\- Movement



\---



MovementController



Owns:



\- Locomotion

\- Camera-relative movement



Does NOT own:



\- Sprint

\- Combat

\- Animation



\---



\# Future Systems



Client



\- CameraController

\- AnimationController

\- CombatController

\- TargetLockController

\- UIController



Shared



\- Configuration

\- Math

\- Utilities

\- Networking



Server



\- CombatService

\- EnemyService

\- SaveService



\---



\# Future Milestones



Milestone 1



Engine Foundation ✅



Milestone 2



Playable Character



Milestone 3



Combat Prototype



Milestone 4



Boss Prototype



Milestone 5



Vertical Slice



Milestone 6



Public Alpha



\---



\# Notes



Architecture should evolve through ADRs.



Subsystems should be added here before implementation.



No subsystem should violate ownership boundaries.

