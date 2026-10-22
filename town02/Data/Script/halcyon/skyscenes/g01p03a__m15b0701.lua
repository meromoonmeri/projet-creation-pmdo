-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/G01P03A/m15b0701.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  -- back_SetGround(LEVEL_S04P01A) [neutre/état moteur]
  GAME:FadeIn(0)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Ugh, we didn't do so good,\ndid we?", french="Argh, il n'y a pas de quoi\nse glorifier, pas vrai?", german=" Uff, das war wohl nichts, was?", italian=" Ugh... Che fiasco!", spanish="¡Ay! No lo hemos hecho muy\nbien, ¿verdad?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Ugh, we didn't do well,\ndid we?", french="Argh, il n'y a pas de quoi\nse glorifier, pas vrai?", german=" Uff, das war wohl nichts, was?", italian=" Ohi ohi... Niente da fare.", spanish="¡Ay! No lo hemos hecho muy\nbien, ¿verdad?"})
  else
  SkySceneKit.say({english="Ugh, we didn't do well,\ndid we?", french="Argh, il n'y a pas de quoi\nse glorifier, pas vrai?", german=" Uff, das war wohl nichts, was?", italian=" Ohi ohi... Niente da fare.", spanish="¡Ay! No lo hemos hecho muy\nbien, ¿verdad?"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="This is pretty tough. Let's go\nhome and regroup.", french="Ce n'est pas de tout repos.\nRestons-en là pour aujourd'hui.", german="Das ist ziemlich schwer. Gehen\nwir heim zu den anderen.", italian="Questa volta è proprio tosta.\nAndiamo a casa per ora.", spanish="Esto es bastante duro.\nVolvamos a casa a recuperar fuerzas."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="This is tougher than expected.\nLet's go home and regroup.", french="Ce n'est pas de tout repos.\nRestons-en là pour aujourd'hui.", german="Das ist ziemlich schwer. Gehen\nwir heim zu den anderen.", italian="È più difficile di quanto\npensassimo. Andiamo a casa a recuperare\nle forze.", spanish="Esto es bastante duro.\nVolvamos a casa a recuperar fuerzas."})
  else
  SkySceneKit.say({english="This is tougher than I expected.\nLet's go home and regroup.", french="Ce n'est pas de tout repos.\nRestons-en là pour aujourd'hui.", german="Das ist ziemlich schwer. Gehen\nwir heim zu den anderen.", italian="È più difficile di quanto\npensassimo. Andiamo a casa a recuperare\nle forze.", spanish="Esto es bastante duro.\nVolvamos a casa a recuperar fuerzas."})
  end
  -- message_KeyWait
  GAME:FadeOut(false,  60)
  -- message_CloseEnforce
  -- CallCommon CORO_FADE_OUT_ALL_AFTER (fermeture/attente message: géré par say())
  -- back_SetGround(LEVEL_G01P03A) [neutre/état moteur]
  -- supervision_StationCommon(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_LoadStation(LEVEL_G01P03A, 'UM15') [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Station(2) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Acting(0) [neutre/état moteur]
  -- supervision_Acting(1) [neutre/état moteur]
  local npc_npc_bippa = SkySceneKit.spawn_npc("bidoof", 296, 272, Direction.Up, "NPC_BIPPA")
  -- SetPositionInitial [position SSA de départ, déjà posée par le placement de scène]
  local npc_npc_dogoomu = SkySceneKit.spawn_npc("loudred", 296, 240, Direction.Down, "NPC_DOGOOMU")
  -- SetPositionInitial [position SSA de départ, déjà posée par le placement de scène]
  local npc_npc_chiriin = SkySceneKit.spawn_npc("chimecho", 400, 240, Direction.Down, "NPC_CHIRIIN")
  -- SetPositionInitial [position SSA de départ, déjà posée par le placement de scène]
  -- camera_SetMyself() [neutre/état moteur]
  -- SetAnimation(4) [anim idle native]
  local npc_npc_kimawari = SkySceneKit.spawn_npc("sunflora", 352, 272, Direction.Right, "NPC_KIMAWARI")
  -- SetAnimation(4) [anim idle native]
  local npc_npc_dagutorio = SkySceneKit.spawn_npc("dugtrio", 320, 256, Direction.UpLeft, "NPC_DAGUTORIO")
  -- SetAnimation(4) [anim idle native]
  local npc_npc_diguda = SkySceneKit.spawn_npc("diglett", 416, 256, Direction.UpLeft, "NPC_DIGUDA")
  -- SetAnimation(4) [anim idle native]
  -- SetAnimation(4) [anim idle native]
  -- SetAnimation(4) [anim idle native]
  GAME:FadeIn(30)
  pcall(function() SOUND:PlayBGM("Wigglytuff's Guild Remix.ogg", true) end)
  GAME:WaitFrames(30)
  pcall(function() UI:SetSpeaker(npc_npc_bippa) end)
  SkySceneKit.say({english="Did you all get knocked out?[K]\nSame thing happened to me, by golly!", french="Alors, vous êtes tombés K.O.,\nvous autres?[K] Moi aussi, pardi!", german="Seid ihr K.O. gegangen?[K]\nMir ist dasselbe passiert, Donnerwetter!", italian="È andata male, eh?[K]\nA me è successa la stessa cosa, ohibò!", spanish="¿También os han derrotado?[K]\n¡Huy, igual que a mí!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_dogoomu) end)
  SkySceneKit.say({english="It's a BRUTAL place. That cave\nis unforgiving!", french="Cet endroit est VACHEMENT\nbalaise. Pas droit à l'erreur là-dedans!", german="Was für ein GRAUSAMER Ort!\nDiese Höhle ist wirklich lebensgefährlich!", italian="Che posto spaventoso. È davvero\ndifficile da esplorare.", spanish="Es un sitio muy difícil.\n¡Esa cueva no perdona!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_chiriin, Direction.Left)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_chiriin) end)
  SkySceneKit.say({english="But we mustn't give up! Let's\nkeep our spirits up!", french="Mais nous devons persévérer!\nHaut les cœurs!", german="Aber wir dürfen nicht aufgeben!\nLassen wir uns nicht entmutigen!", italian="Ma non dobbiamo arrenderci!\nBisogna tenere duro!", spanish="¡Pero no debemos rendirnos!\n¡Arriba ese ánimo!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
  -- message_FacePositionOffset(0, -1) [neutre/état moteur]
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="We solved the secret of the\nthree crystals.", french="On a résolu l'énigme des trois\ncristaux.", german="Wir haben das Rätsel der drei\nKristalle herausbekommen.", italian="Abbiamo risolto il mistero dei\ntre cristalli.", spanish="Hemos resuelto el misterio de\nlos tres cristales."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="We've solved the mystery of the\nthree crystals.", french="On a résolu l'énigme des trois\ncristaux.", german="Wir haben das Rätsel der drei\nKristalle gelöst.", italian="Abbiamo risolto il mistero dei\ntre cristalli.", spanish="Hemos resuelto el misterio de\nlos tres cristales."})
  else
  SkySceneKit.say({english="We figured out the mystery of\nthe three crystals.", french="On a résolu l'énigme des trois\ncristaux.", german="Wir haben das Rätsel der drei\nKristalle gelöst.", italian="Abbiamo risolto il mistero dei\ntre cristalli.", spanish="Hemos resuelto el misterio de\nlos tres cristales."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="We're getting closer. Let's keep\nat it, [hero]!", french="On se rapproche du but. Courage,\n[hero]!", german="Wir kommen immer näher.\nDurchhalten, [hero]!", italian="Ci siamo quasi. Non dobbiamo\nmollare, [hero]!", spanish="Ya estamos más cerca. ¡Hay\nque seguir adelante, [hero]!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="I'm sure we were nearly done.\nLet's keep at it, [hero]!", french="On se rapproche du but. Courage,\n[hero]!", german="Wir sind bestimmt bald da.\nDurchhalten, [hero]!", italian="Non manca molto. Dobbiamo\ntener duro, [hero]!", spanish="Creo que pronto llegaremos.\n¡Hay que seguir adelante, [hero]!"})
  else
  SkySceneKit.say({english="We're getting closer. Let's keep\nat it, [hero]!", french="On se rapproche du but. Courage,\n[hero]!", german="Wir kommen immer näher.\nDurchhalten, [hero]!", italian="Non manca molto. Dobbiamo\ntener duro, [hero]!", spanish="Ya estamos más cerca. ¡Hay\nque seguir adelante, [hero]!"})
  end
  -- message_Close
  pcall(function() SOUND:FadeOutBGM(120) end)
  GAME:FadeOut(false, 60)
  -- supervision_RemoveActing(1) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GROUND:TeleportTo(hero, 360, 228, Direction.Down)
  GROUND:TeleportTo(partner, 336, 228, Direction.Down)
  GROUND:TeleportTo(npc_npc_chiriin, 516, 236, Direction.Down)
  GROUND:TeleportTo(npc_npc_dogoomu, 328, 276, Direction.Down)
  GROUND:TeleportTo(npc_npc_bippa, 352, 300, Direction.Down)
  pcall(function() GAME:MoveCamera(0, 0, 1, true) end) -- caméra défaut
  GROUND:EntTurn(hero, Direction.Down)
  GROUND:EntTurn(partner, Direction.Down)
  GROUND:EntTurn(npc_npc_chiriin, Direction.Down)
  GROUND:EntTurn(npc_npc_dogoomu, Direction.DownRight)
  GROUND:EntTurn(npc_npc_bippa, Direction.UpLeft)
  GAME:WaitFrames(30)
  GAME:FadeIn(30)
  pcall(function() SOUND:PlayBGM("Wigglytuff's Guild.ogg", true) end)
  SkySceneKit.cleanup_npcs()
end
