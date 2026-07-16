\# MDS-0004 — Animation System



Status: Draft



Owner: FN Productions



Related Documents:



\- MDS-0003 — Character State Machine



\---



\# Purpose



This document defines how Project KATANA drives character animations.



Animation should be completely driven by gameplay state.



Animation must never become the source of gameplay logic.



\---



\# Philosophy



Gameplay decides.



Animation visualizes.



Animation must always follow gameplay state, never control it.



\---



\# Version 1



Supported animations:



\- Idle

\- Walk

\- Fall



Future animation systems are intentionally excluded.



\---



\# Behavioral Rules



Animation transitions should be smooth.



Only one locomotion animation may play at a time.



Animation blending should prioritize responsiveness over realism.



\---



\# Future Work



Not part of Version 1:



\- Sprint

\- Jump Start

\- Jump Loop

\- Jump Landing

\- Combat

\- Hit Reactions

\- Root Motion

\- IK

\- Layered Animation

