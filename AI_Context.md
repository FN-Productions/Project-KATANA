# AI_CONTEXT.md

# Project KATANA

> Internal AI onboarding document for FN Productions.
>
> Every AI assistant (ChatGPT, Antigravity, or future tools) must read this file before making any changes.

---

# Project Status

Current Phase:
- Foundation

Current Sprint:
- Sprint 4

Current Milestone:
- Animation System

Project Status:
- In Development

---

# Project Vision

Project KATANA is an original third-person action combat game currently being prototyped on Roblox.

Roblox is used only as a rapid development platform.

The long-term objective is to build a standalone commercial-quality game using modern software engineering practices.

Project KATANA is inspired by the design philosophy of games like Sekiro and Black Myth: Wukong.

The goal is **NOT** to recreate those games.

The goal is to build an original combat-focused experience emphasizing:

- Mastery
- Satisfying combat
- Memorable bosses
- Progression
- Immersion
- Fairness

---

# Core Gameplay Pillars

1. Combat First
2. Bosses are Events
3. Mastery over Grinding
4. Fair Difficulty
5. Animation-driven Combat

---

# Engineering Philosophy

The project follows professional software engineering practices.

Rules:

- VS Code is the source of truth.
- Roblox Studio is the runtime/editor.
- Git manages source code.
- GitHub stores project history.
- Rojo synchronizes code into Roblox Studio.
- Every important decision is documented.
- Code should be modular.
- Avoid duplication.
- Optimize for maintainability.
- Prefer composition over coupling.
- Engine-specific code should remain isolated.

---

# Current Technology Stack

Engine:
- Roblox Studio

Language:
- Luau

IDE:
- VS Code

Version Control:
- Git
- GitHub

Synchronization:
- Rojo

Tool Manager:
- Aftman

AI:

- ChatGPT (Technical Director)
- Antigravity (Implementation Engineer)

---

# Repository Structure

Current:

docs/
src/
assets/

Future:

tests/
tools/
project/

---

# Branch Strategy

main
- Stable releases only

dev
- Active development

feature/*
- Individual features

---

Current Objective

Build the Combat System.

After that:

Lock-On System
---

# AI Responsibilities

## ChatGPT

Responsible for:

- Software Architecture
- System Design
- Documentation
- Technical Decisions
- Code Review
- Planning
- QA
- Engineering Standards

## Antigravity

Responsible for:

- Code Generation
- Refactoring
- Boilerplate
- Implementation
- Small isolated systems

## Human

Responsible for:

- Final approvals
- Roblox Studio testing
- Playtesting
- Publishing
- Merge decisions

---

# Current Architecture

Current completed engine modules:

- Bootstrap
- Logger
- InputController
- CharacterController
- MovementController
- CameraController
- StateMachine
- AnimationController

Current work:

- AnimationController

---

# Architectural Principles

Gameplay systems should depend on project abstractions instead of Roblox engine APIs whenever practical.

Engine-specific APIs should remain isolated behind dedicated modules.

Controllers should have a single responsibility.

Controllers should expose small, typed public APIs.

Modules should not perform work during require(); initialization belongs inside start().

All start() methods must be idempotent.

Gameplay state is the source of truth.

Animation follows gameplay.

Never allow animation to drive gameplay.

---

# Development Workflow

Every new feature follows this pipeline:

1. Design Document (MDS)
2. Specification (KTN)
3. ADR (if required)
4. Implementation Plan
5. Implementation
6. Code Review
7. Playtest
8. Commit

Implementation must never begin before documentation exists.

---

# Current Rules

Never work directly on main.

Never duplicate logic.

Never add undocumented systems.

Always prefer modular architecture.

Always document major decisions.

Always review AI-generated code before merging.

Never bypass the established architecture.

Do not introduce hidden dependencies.

Do not couple unrelated systems.

---

# Project History

For implementation history and completed work, refer to:

- CHANGELOG.md
- Git History
- GitHub Issues

This document intentionally describes the current architecture and engineering standards only.