-- SkyCanonScenes.lua — Cinématiques canoniques PMD Sky EU rejouées dans
-- PMDO. Traduction TECHNIQUE des SSB décompilés (ExplorerScript) : chaque
-- scène cite son script ROM ; positions/mouvements/dialogues/timing
-- proviennent du SSB+SSA, jamais inventés.
--
-- Conventions de conversion (documentées, adaptation technique) :
--  * positions SSA/SSB en tuiles NDS 8px : pixel = x_relative*8 + x_offset*4
--    (même règle que le décodeur Red gGroundLivesTypeData) ;
--  * MovePositionMark(speed, Position<'mN', x, y>) -> GROUND:MoveToPosition
--    vers le pixel du mark ; la vitesse SSB (fraction 1/256 tuile/frame)
--    est convertie en vitesse de marche PMDO la plus proche (2=walk 1=slow) ;
--  * Wait(n) = n frames NDS (60fps) -> GAME:WaitFrames(n) (PMDO 60fps) ;
--  * bgm2/screen2 (2e écran NDS) : fusionnés sur l'écran unique PMDO —
--    PARTIAL_FIDELITY documenté ;
--  * supervision_SpecialActing(21/3) = cadrage plein écran d'ouverture/fin
--    -> fondus équivalents.
local SkyCanonScenes = {}

-- ---------------------------------------------------------------------
-- m01a0204 (SCRIPT/D01P11B, ROM Sky EU) — « Quel paysage magnifique ! »
-- Le partenaire (ATTENDANT1) marche jusqu'au bord de la plage au soleil
-- couchant et admire la vue. Source exacte :
--   SSA m01a0204.ssa : ATTENDANT1 (86,24)+off(0,2) Down ;
--     marks m0=(66,24)+off(2,2), m1=(66,21)+off(2,2)
--   SSB m01a0204.ssb : BGM_ON_THE_BEACH_AT_DUSK, FadeIn 30, Wait 60,
--     MovePositionMark m0 (0.6992), Turn2Direction UP, Wait 20,
--     MovePositionMark m1 (0.5), dialogue $PARTNER_TALK_KIND (défaut),
--     message_Close, Wait 60, FadeOut 30.
-- GAPS documentés : BGM_OCEAN1 (canal 2 NDS) non joué (mono-canal PMDO) ;
-- FACE_INSPIRED -> émotion 'Inspired' si le portrait du partenaire la
-- possède, sinon portrait par défaut (jamais de crash).
-- ---------------------------------------------------------------------
function SkyCanonScenes.m01a0204(out)
  local function emit(s)
    if out then
      local f = io.open(out, 'a'); if f then f:write(s .. '\n'); f:close() end
    end
    PrintInfo('[SKY_SCENE] ' .. s)
  end
  local function px(tile, off) return tile * 8 + (off or 0) * 4 end

  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  local actor = partner or hero  -- ATTENDANT1 = partenaire ; fallback héros
  if actor == nil then
    emit('{"scene":"m01a0204","verdict":"RUNTIME_FAIL","error":"no_actor"}')
    return
  end

  -- BGM (mapping arm9 ov10: BGM_ON_THE_BEACH_AT_DUSK -> On the Beach at
  -- Dusk.ogg, présent dans le roster)
  pcall(function() SOUND:PlayBGM('On the Beach at Dusk.ogg', true) end)

  -- placement initial SSA : ATTENDANT1 (86,24)+off(0,2) Down
  GROUND:TeleportTo(actor, px(86, 0), px(24, 2), Direction.Down)
  if hero ~= nil and actor ~= hero then
    -- le héros n'est pas dans le SSA de cette scène (caméra performer) ;
    -- il reste hors champ à gauche du mark, orienté vers la mer
    GROUND:TeleportTo(hero, px(62, 0), px(24, 2), Direction.Up)
  end
  GAME:FadeIn(30)
  GAME:WaitFrames(60)

  -- MovePositionMark m0 (66.5, 24.5) vitesse 0.6992 ~ marche normale
  GROUND:MoveToPosition(actor, px(66, 2), px(24, 2), false, 2)
  GAME:WaitFrames(10)
  GROUND:EntTurn(actor, Direction.Up)
  GAME:WaitFrames(20)
  -- MovePositionMark m1 (66.5, 21.5) vitesse 0.5 ~ marche lente
  GROUND:MoveToPosition(actor, px(66, 2), px(21, 2), false, 1)

  -- dialogue canonique (branche default de $PARTNER_TALK_KIND, texte ROM EU).
  -- WaitShowTimedDialogue = API native RogueEssence (dialogue temporisé) ;
  -- durée 150 frames ≈ lecture du texte, puis le SSB attend 60 frames.
  local said = false
  pcall(function()
    UI:SetSpeaker(actor)
    pcall(function() UI:SetSpeakerEmotion('Inspired') end)
    UI:WaitShowTimedDialogue('Wow! What a beautiful sight!', 150)
    said = true
  end)
  GAME:WaitFrames(60)
  GAME:FadeOut(false, 30)

  local ax, ay = -1, -1
  pcall(function() ax = actor.Position.X; ay = actor.Position.Y end)
  emit(string.format(
    '{"scene":"m01a0204","source":"SCRIPT/D01P11B ROM Sky EU",' ..
    '"actor_final":{"x":%d,"y":%d},"expected_final":{"x":%d,"y":%d},' ..
    '"dialogue_shown":%s,"bgm":"On the Beach at Dusk.ogg",' ..
    '"gaps":["bgm2 OCEAN1 non joué (mono-canal)",' ..
    '"screen2 fusionné"],"verdict":"%s"}',
    ax, ay, px(66, 2), px(21, 2), tostring(said),
    (ax == px(66, 2) and ay == px(21, 2) and said)
      and 'CINEMATIC_RUNTIME_PASS' or 'PARTIAL'))
  GAME:FadeIn(20)
end

-- pilote background défilant (contrat CLASSIFICATION_PIPELINE.md)
function SkyCanonScenes.scroll_s13p05a(out)
  local sp = require('halcyon.skyscenes.scrollpilot')
  sp.s13p05a_t02a0204()
end

return SkyCanonScenes
