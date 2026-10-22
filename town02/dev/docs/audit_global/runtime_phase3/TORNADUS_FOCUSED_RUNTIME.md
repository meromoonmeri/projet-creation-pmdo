# Tornadus focused-X runtime correction

Real PMDO 0.8.12 was run under Xvfb with an active X11 window and keyboard events.
The introduction reached, in order: CUTSCENE_START, ENTITY_SPAWNED,
BOSS_REVEALED, PUSH_BEGIN, PUSH_END, BATTLE_PREPARATION, CUTSCENE_END,
DungeonMapInit and DungeonFloorEnter.

Root causes repaired:
1. three invalid `ScriptUI.SetSpeaker` overload calls used integer `0` instead of
   a valid Gender enum for the hidden voice; the already-created Tornadus
   GroundChar is now the speaker.
2. the four concurrent recoil movement coroutines could leave JoinCoroutines
   unresolved when one collision movement did not complete. They are replaced
   by deterministic, staggered, collision-safe 8px recoil teleports plus Hurt/
   emote reactions. Narrative intent and all four reactions are preserved.

Validated: intro completion and battle initialization. Battle victory,
post-battle, save/reload and repeat remain not proven by this run.
