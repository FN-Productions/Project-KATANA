\# KTN-005 — MovementController Specification



Status: Draft



Owner: FN Productions



Related Documents:



\- MDS-0001 — Player Locomotion

\- ADR-0001 (and other relevant ADRs)



\---



\# Purpose



MovementController is responsible for converting player movement intent into character locomotion.



It is not responsible for:



\- Input handling

\- Camera implementation

\- Combat

\- Animation

\- Sprint

\- Stamina

\- Lock-on



\---



\# Responsibilities



\- Read movement intent from InputController.

\- Read character references from CharacterController.

\- Apply movement through Humanoid:Move().

\- Rotate the character during free movement.

\- Maintain a single runtime update loop.



\---



\# Public API



```luau

start()

```



No additional public APIs in Version 1.



\---



\# Dependencies



Consumes:



\- InputController

\- CharacterController



Must NOT directly use:



\- UserInputService

\- Players



\---



\# Runtime Behavior



\- Runs once started.

\- Uses RunService.PreSimulation.

\- Performs camera-relative movement.

\- Stops movement immediately when no input exists.

\- Ignores updates when the character is unavailable or dead.



\---



\# Definition of Done



\- \[ ] Compiles with --!strict

\- \[ ] start() is idempotent

\- \[ ] No direct UserInputService usage

\- \[ ] No direct Players usage

\- \[ ] Uses CharacterController

\- \[ ] Uses InputController

\- \[ ] Uses Humanoid:Move()

\- \[ ] Camera-relative movement works

\- \[ ] Character rotates correctly

\- \[ ] No sliding when input stops

\- \[ ] Code reviewed

\- \[ ] Playtested

\- \[ ] Committed



\---



\# Future Extensions



Not part of Version 1:



\- Sprint

\- Dash

\- Dodge

\- Lock-on

\- Stamina

\- Root motion

\- Custom rotation



# Acceptance Tests

The following behaviors must be true after implementation:

- Holding W moves the character forward relative to the camera.
- Releasing W immediately stops movement.
- Rotating the camera changes movement direction.
- Respawning restores movement automatically.
- Multiple calls to start() do not duplicate behavior.