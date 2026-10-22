"""Runtime harness for stage s07.

Wraps a headless RogueEssence invocation and captures observable state
(entities loaded, camera position, active BGM key, dialogues emitted,
warp destination reached) so the pipeline can compare runtime
behaviour against the Cinematic_IR it produced.
"""
