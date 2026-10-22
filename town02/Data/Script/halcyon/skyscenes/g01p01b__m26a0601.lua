-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/G01P01B/m26a0601.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkySubScreen = require 'halcyon.skyscenes.subscreen'
return function(hero, partner)
  -- GAP: BGM BGM_A_WISH_FOR_PEACE non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  -- back2_SetMode(4) [mode d'affichage sub NDS: géré par SubScreen]
  -- back2_SetGround(V02P01A) [décor sub chargé: Sub_v02p01a]
  -- back_SetGround(LEVEL_G01P01B) [neutre/état moteur]
  -- supervision_StationCommon(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  SkySubScreen.Show("v02p01a", 60, false) -- screen2_FadeIn: TOP_FOCUS (timeline ROM)
  pcall(function() SOUND:FadeOutBGM(210) end)
  GAME:FadeIn(60)
  GAME:WaitFrames(30)
  GAME:WaitFrames(45)
  -- supervision_Acting(1) [neutre/état moteur]
  local npc_npc_bippa = SkySceneKit.spawn_npc("bidoof", 224, 392, Direction.Up, "NPC_BIPPA")
  GROUND:MoveToPosition(npc_npc_bippa, 220, 276, false, 2)
  GAME:WaitFrames(20)
  pcall(function() GAME:MoveCamera(236, 300, 60, false) end) -- performer/caméra
  GROUND:MoveToPosition(partner, 240, 304, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Startled") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_bippa, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GROUND:EntTurn(npc_npc_bippa, Direction.DownRight)
  pcall(function() UI:SetSpeaker(npc_npc_bippa) end)
  SkySceneKit.say({english="Huh?[K] Howdy, [partner].\nGoing out?", french="Hein?[K] Salut, [partner].\nTu sors?", german="Hallihallo, [partner].[K] Gehst\ndu noch weg?", italian="Eh?[K] Salve, [partner].\nStai uscendo?", spanish="¿Eh?[K] ¿Qué tal, [partner]?\n¿Vas a salir?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(partner, Direction.UpLeft)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Yup.[K] Out for a walk.", french="Ouaip.[K] Je vais faire une petite\npromenade.", german=" Jep.[K] Ein kleiner Spaziergang.", italian=" Già.[K] Vado a fare due passi.", spanish=" Sí.[K] Voy a dar una vuelta."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Yes.[K] Out for a walk.", french="Ouaip.[K] Je vais faire une petite\npromenade.", german=" Jep.[K] Ein kleiner Spaziergang.", italian="Sì.[K] Esco a fare una\npasseggiata.", spanish=" Sí.[K] Voy a dar una vuelta."})
  else
  SkySceneKit.say({english=" Yep.[K] Out for a walk.", french="Ouaip.[K] Je vais faire une petite\npromenade.", german=" Jep.[K] Ein kleiner Spaziergang.", italian="Sì.[K] Esco a fare una\npasseggiata.", spanish=" Sí.[K] Voy a dar una vuelta."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_bippa) end)
  SkySceneKit.say({english=" Sounds nice, yup yup!", french="T'as raison, c'est agréable,\nah ça oui!", german=" Hört sich nett an, jawollja!", italian=" Buona idea, sì, sì.", spanish=" Buena idea. Sí, señor."})
  pcall(function() UI:SetSpeaker(npc_npc_bippa) end)
  SkySceneKit.say({english="It'll be dinnertime soon, though.\nYou don't want to be late for that!", french="Mais, attention, c'est bientôt\nl'heure d'manger. Faut pas rater ça, hein!", german="Es ist allerdings bald Zeit fürs\nAbendessen. Da willst du doch bestimmt nicht\nzu spät kommen!", italian="Però presto sarà ora di cena.\nNon fare tardi!", spanish="Aunque pronto será hora de\ncenar. ¡Procura no retrasarte!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Yep.[K] I hear you.", french=" Oui.[K] Entendu.", german=" Jep.[K] Das stimmt.", italian=" Sì.[K] Va bene.", spanish=" Vale.[K] De acuerdo."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" OK.[K] Understood.", french=" Oui.[K] Entendu.", german=" Okay.[K] Du hast recht.", italian=" Ok.[K] Capito.", spanish=" Vale.[K] Entendido."})
  else
  SkySceneKit.say({english=" Yep.[K] I hear you.", french=" Oui.[K] Entendu.", german=" Jep.[K] Das stimmt.", italian=" Sì.[K] Va bene.", spanish=" Vale.[K] De acuerdo."})
  end
  -- message_Close
  do local p=partner.Position; GROUND:MoveToPosition(partner, p.X+(0), p.Y+(80), false, 2) end
  GROUND:EntTurn(npc_npc_bippa, Direction.Down)
  GAME:WaitFrames(80)
  SkySubScreen.Hide(30) -- screen2_FadeOut: retour BOTTOM_FOCUS (timeline ROM)
  GAME:FadeOut(false, 30)
  -- back2_SetMode(0) [mode d'affichage sub NDS: géré par SubScreen]
  GAME:WaitFrames(60)
  SkySceneKit.cleanup_npcs()
  SkySubScreen.Hide(10) -- fin de scène: nappe sub retirée
end
