\# TDD-0002 — Attack Definitions



Status: Draft



\---



\# Purpose



Attack Definitions describe combat actions as data.



They contain all information required for the AttackSystem to execute an attack.



Attack Definitions do not contain gameplay logic.



The AttackSystem interprets the data.



\---



\# Design Philosophy



Combat behavior should be driven by data.



Adding a new attack should require creating a new Attack Definition rather than modifying engine code.



\---



\# Required Fields



Every attack definition must specify:



\- Identifier

\- Animation

\- Damage

\- Startup

\- Active

\- Recovery

\- Stamina Cost

\- Hitbox

\- Cancel Rules



\---



\# Example



```lua

Katana\_Light\_01 = {



&#x20;   Id = "Katana\_Light\_01",



&#x20;   Animation = "Katana\_Light\_01",



&#x20;   Damage = 25,



&#x20;   Startup = 0.15,



&#x20;   Active = 0.08,



&#x20;   Recovery = 0.30,



&#x20;   StaminaCost = 10,



&#x20;   Hitbox = "KatanaSlash",



&#x20;   NextAttack = "Katana\_Light\_02",



}

```



\---



\# Engine Responsibilities



The AttackSystem is responsible for interpreting the definition.



Typical execution flow:



Read Definition



↓



Validate



↓



Spend Stamina



↓



Play Animation



↓



Spawn Hitbox



↓



Apply Damage



↓



Recovery



↓



Finished



\---



\# Future Fields



Examples:



\- Hyper Armor

\- Poise Damage

\- Guard Damage

\- Hit Stop

\- Camera Shake

\- Visual Effects

\- Audio

\- Projectile

\- Root Motion

\- Tracking Strength

\- Lock-On Behavior



\---



\# Validation



Every attack definition should be validated before execution.



Examples:



\- Animation exists.

\- Damage ≥ 0.

\- Timings are valid.

\- Required fields are present.



Invalid definitions should fail fast during development.



\---



\# Goal



Attack Definitions should become the single source of truth for all combat actions in Project KATANA.

