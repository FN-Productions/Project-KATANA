\# Changelog



All notable changes to Project KATANA will be documented here.



\---



\## v0.0.1 - Bootstrap



\### Added



\- Professional Git workflow

\- Rojo integration

\- Aftman tool management

\- AI onboarding documentation

\- Architecture Decision Records

\- Logger subsystem

\- Client bootstrap

\- Server bootstrap



\### Notes



Initial engineering foundation completed.



\## Sprint 4



\### KTN-008 — AnimationController



Added the first version of the client-side AnimationController.



Highlights:



\- Added AnimationController as the visual consumer of StateMachine.

\- Added AnimationConfig for centralized animation asset configuration.

\- Implemented animation loading and caching per character.

\- Added smooth cross-fade transitions between locomotion states.

\- Implemented safe Animator resolution with timeout and error logging.

\- Added lifecycle cleanup to prevent animation track leaks across respawns.

\- Integrated AnimationController into ClientBootstrap.



Notes:



\- Animation polling through StateMachine is a temporary Version 1 solution.

\- Placeholder Roblox animation assets are used until Project KATANA animations are available.

