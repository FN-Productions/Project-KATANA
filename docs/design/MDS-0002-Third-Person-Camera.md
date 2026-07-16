\# MDS-0002 — Third-Person Camera



Status: Draft



Owner: FN Productions



Related Documents:



\- Game-Design-Bible.md

\- MDS-0001 — Player Locomotion



\---



\# Purpose



This document defines the gameplay feel and behavioral philosophy of the Project KATANA third-person camera.



It intentionally avoids implementation details.



\---



\# Camera Philosophy



The camera exists to support gameplay, not to impress the player.



Players should rarely notice the camera itself.



Instead, they should naturally focus on movement, combat, and the environment.



Whenever gameplay clarity and cinematic presentation conflict, gameplay clarity always wins.



\---



\# Design Goals



The camera should feel:



\- Natural

\- Responsive

\- Stable

\- Predictable

\- Comfortable



The camera should never feel:



\- Floaty

\- Overly cinematic

\- Distracting

\- Unpredictable

\- Motion-sick inducing



\---



\# Behavioral Specifications



\## Follow



The camera should remain closely attached to the player with only minimal smoothing.



Small movements should feel immediate.



Large movements should remain comfortable.



\---



\## Rotation



Camera rotation should feel responsive.



Minor smoothing is acceptable, but player control must always take priority.



\---



\## Position



The player should appear slightly over the right shoulder.



The camera should never obstruct the player.



\---



\## Collision



When the camera approaches geometry, it should smoothly move closer to the player.



Camera movement should never snap abruptly.



Once space is available again, the camera should smoothly return to its default position.



\---



\## Camera Priority



The camera should help players understand:



\- enemy positions

\- player positioning

\- movement direction

\- combat spacing



Visual spectacle should never reduce gameplay readability.



\---



\## Camera Trust



Players should quickly learn how the camera behaves.



The camera should feel consistent and reliable throughout gameplay.



It should never surprise the player.



\---



\# Version 1 Scope



Included:



\- Third-person camera

\- Slight right-shoulder offset

\- Smooth follow

\- Smooth collision handling



Not Included:



\- Lock-on camera

\- Sprint camera

\- Camera shake

\- Cinematic cameras

\- Dynamic shoulder switching

\- Boss cameras



\---



\# Success Criteria



The camera is considered successful when players stop thinking about it.



Instead, their attention naturally remains on gameplay.

