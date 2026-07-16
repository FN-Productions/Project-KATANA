\# TDD-0001 — Controller Architecture



Status: Active



\---



\# Purpose



This document defines the architectural conventions followed by every controller in Project KATANA.



Controllers coordinate systems.



Controllers do not implement gameplay mechanics directly.



\---



\# Responsibilities



Controllers may:



\- Coordinate systems.

\- Own lifecycle.

\- Validate requests.

\- Route information.

\- Expose public APIs.



Controllers must not:



\- Duplicate engine logic.

\- Duplicate system logic.

\- Own unrelated responsibilities.

\- Become "God Objects."



\---



\# Lifecycle



Every controller must expose:



```luau

start()

```



Requirements:



\- Idempotent.

\- Safe to call multiple times.

\- Owns its runtime connections.



\---



\# Dependency Rules



Controllers depend on abstractions whenever practical.



Avoid direct Roblox engine APIs unless the controller specifically owns them.



Examples:



InputController



↓



UserInputService



MovementController



↓



InputController



NOT



↓



UserInputService



\---



\# Ownership



Each controller should own one responsibility.



Examples:



InputController



↓



Input



CameraController



↓



Camera



MovementController



↓



Movement



AnimationController



↓



Animation



CombatController



↓



Combat orchestration



\---



\# Public APIs



Controllers expose only the functionality required by other systems.



Avoid exposing mutable internal state.



Prefer query methods over direct access.



\---



\# Goal



Controllers should remain small, predictable, testable, and highly maintainable.

