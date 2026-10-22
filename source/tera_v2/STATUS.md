# Téra V2 — 17 septembre 2026

Latest user: regenerate/correct crowns, create missing types, canonical-inspired animated glass on all SpriteCollab sprites, finish missing project portraits/sprites. User selected **existing project queue**, not all catalogue absences for character production.

Ten successful generations used on crowns; two subsequent Zarude/Stellar generation calls blocked by the tool's ten-image limit. No new character sprite/portrait created this turn. Preserve all existing resources and approved backgrounds.

Deliverable `apercu_tera_v2.html`, details `exports/tera_v2/README.md`:
- 19 type models drawn, **not all usable**. Fire4cardinals, Water8provisional views, other17front-only. Flying balloon count wrong; Stellar statue rejected for use and stored under review/rejected_models. No wearer head/body; plain front jewels, type emblems remain. New models not blindly substituted into old attachments.
- Crystal surface reference renderer with24phase independent light clock, local refraction, panes, specular/rim/spectrum; no species whitelist, exact alpha and transparent RGB preservation. Full opaque cells now use padded distance transform (fixed inf/NaN edge case).
-Complete nontruncated pinned catalogue:984roots,3337formXMLs,55953animation sheets,853154114source bytes. 55941remote sheets unrendered. Generic CLI can fetch/verify/render any listed sheet on demand; it is NOT a PMDO runtime hook.
-New Fire + glass review:4local forms x4cardinals,16proposed placements; Tirtouga rear seat corrected +2native pixels. No horn/ear masks, no anatomical certification.
-11unit tests pass with warnings treated as errors. Decoded-output checks in delivery_checks.json. No actual Ground/Dungeon import/render/integration.

Next: do not mark this as global in-game coverage. Correct Vol and Stellar models; remaining direction generation/crown animation/anatomical fitting; actual PMDO material integration; then resume faithful character production with generator budget available. Don't animate the rejected Stellar species sheet or the rejected Stellar crown statue.
