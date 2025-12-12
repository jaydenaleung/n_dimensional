# N-Dimensional

Arrays/Objects final project for my AP CS A class. Features an ultra-minimalistic, geometric combat game with complex moves and game mechanics. Total time: 13 hours.

## Overview
N-Dimensional is a fast local PvP duel where two polygons fight on a minimalist stage, whittling each other’s sides down with physics-driven movement and auto-aiming attacks. It blends simple controls with timing-based darts and boomerang spikes, set to rotating music and backgrounds. See JOURNAL.md for more details.

## Gameplay
- Each player is a regular polygon starting at 20 sides; taking damage removes sides and dropping below 3 ends the round.
- Physics-driven movement (delta timing, gravity, friction), screen shake, and cycling music/backgrounds keep matches lively.
- Two auto-aiming attacks: Darts (1 dmg) and Spikes (2 dmg) with distinct motion patterns and hit timing.

## Controls
- Player 1: WASD to move/jump/fall; numeric keywords for attacks.
- Player 2: Arrow keys to move/jump/fall; letter keywords for attacks.
- Keywords (type up to 5 chars, then release): Darts = 54321 / pinky, Spikes = 15243 / nylon. Enter or Space clears the keyword buffer.

## Running
- Built for Processing 4 using the processing.sound library; assets live in data/.
- Expect a brief white screen (~10–15s) on startup while music and backgrounds load, then press Play on the intro screen.

## Notes
- Win condition: force the opponent below 3 sides.

## Attribution
- Music Attribution: NCS tracks Wanderlust, Strobe, The Return.

Song: NIVIRO - The Return [NCS Release]
Music provided by NoCopyrightSounds
Free Download/Stream: http://ncs.io/TheReturn
Watch: http://youtu.be/R0QkZOyuqIs

Song: Everen Maxwell - Wanderlust [NCS Release]
Music provided by NoCopyrightSounds
Free Download/Stream: http://ncs.io/Wanderlust
Watch: http://ncs.lnk.to/WanderlustAT/youtube

Song: NIVIRO - Strobe
Music provided by NoCopyrightSounds
Free Download/Stream: http://ncs.io/Strobe
Watch: http://ncs.lnk.to/StrobeAT/youtube
