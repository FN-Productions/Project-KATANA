\# MDS-0001 — Player Locomotion



Status: Draft v1



Owner: FN Productions



Related Tickets:

\- KTN-005

\- KTN-006



\---



\# Purpose



This document defines the intended feel, behavior, and engineering goals of player locomotion.



It is a gameplay design specification.



It does not define implementation details.



\---



\# Design Philosophy



Movement is the foundation of Project KATANA.



Players should feel:



\- Responsive

\- Precise

\- Weighty

\- Deliberate

\- In Control



Movement should never feel:



\- Floaty

\- Slippery

\- Delayed

\- Random

\- Automatic



\---



\# Core Principles



\## Principle 1 — Input First



Player input should be reflected immediately.



The player should never feel like the game ignored their intention.



\---



\## Principle 2 — Combat First



Movement exists primarily to support combat.



Exploration is secondary.



Every movement mechanic must improve combat readability.



\---



\## Principle 3 — Mastery



Movement should reward skill.



Experienced players should naturally become more efficient.



No mechanic should trivialize positioning.



\---



\## Principle 4 — Fairness



Failures should feel deserved.



The player should rarely blame the controls.



\---



\## Principle 5 — Consistency



Movement rules should remain predictable.



Similar situations should produce similar outcomes.



\---



\# Camera Relationship



Phase 1



\- Over-the-Shoulder Camera



Phase 2



\- Dynamic Combat Camera



Movement should always be camera-relative.



\---



\# Initial Feature Scope



Version 1 includes:



\- Walk

\- Camera-relative movement

\- Character rotation

\- Idle



Version 1 excludes:



\- Sprint

\- Dash

\- Dodge

\- Roll

\- Jump improvements

\- Climbing

\- Wall mechanics

\- Swimming

\- Lock-on



\---



\## Behavioral Specifications



\### Weight



Weight should be communicated through animation, audio, camera, and visual feedback.



Character control should remain responsive.



Stopping should feel deliberate rather than slippery.



Movement should never appear to slide across the ground.



\---



\### Rotation



During free movement, the character rotates to face the movement direction relative to the camera.



During lock-on combat (future feature), the character rotates to face the locked target while movement becomes strafe-oriented.



\---



\### Input Priority



Movement physics should react immediately to player input.



Animation should adapt to movement, never delay it.





\# Engineering Constraints



Movement logic must never:



\- Read keyboard input directly.

\- Depend on UserInputService.

\- Depend on Roblox key bindings.



Movement must communicate only with:



\- InputController

\- CharacterController



\---



\# Success Criteria



Movement is considered successful when:



\- Controls feel immediate.

\- Character movement is predictable.

\- Camera-relative movement feels natural.

\- Character orientation is intuitive.

\- Players feel in control at all times.



\---



\# Future Extensions



Planned future systems:



\- Sprint

\- Dash

\- Dodge

\- Lock-on

\- Stamina

\- Air control

\- Landing system

\- Animation blending

\- Combat locomotion



These systems must extend this specification rather than replace it.

