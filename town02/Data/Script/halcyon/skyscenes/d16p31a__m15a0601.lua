-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D16P31A/m15a0601.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  -- GAP: BGM BGM_IN_THE_DEPTHS_OF_THE_PIT non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  pcall(function() SOUND:FadeOutBGM(60) end)
  GAME:FadeOut(false, 30)
  -- back2_SetMode(0) [mode d'affichage sub NDS: géré par SubScreen]
  GAME:WaitFrames(2) -- join WaitSubScreen (fondu sub déjà séquencé par SubScreen)
  -- supervision_RemoveCommon(13) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_RemoveCommon(14) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_RemoveCommon(15) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Acting(1) [neutre/état moteur]
  -- supervision_Acting(3) [neutre/état moteur]
  -- SetAnimation(9) [anim idle native]
  -- SetAnimation(10) [anim idle native]
  pcall(function() GAME:MoveCamera(300, 228, 1, false) end)
  -- SetFunctionAttribute(2) [attribut interne de l'interpréteur SSB NDS - sans objet PMDO]
  -- SetFunctionAttribute(2) [attribut interne de l'interpréteur SSB NDS - sans objet PMDO]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  GROUND:TeleportTo(hero, 316, 228, Direction.Down)
  GROUND:TeleportTo(partner, 284, 228, Direction.Down)
  GROUND:EntTurn(hero, Direction.Up)
  GROUND:EntTurn(partner, Direction.Up)
  GAME:WaitFrames(30)
  GAME:FadeIn(30)
  GAME:WaitFrames(30)
  -- GAP: se_Play(7176) — id SE NDS sans portage PMDO identifié
  -- SetAnimation(17) [anim idle native]
  -- SetAnimation(18) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteObject(OBJECT_D16P31A2_37) [routine d'objet NDS non simulée - documenté]
  -- SetAnimation(17) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteObject(OBJECT_D16P31A2_37) [routine d'objet NDS non simulée - documenté]
  GAME:WaitFrames(30)
  -- ExecuteCommon(CORO_LOOK_AROUND_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(15)
  -- ExecuteCommon(CORO_LOOK_AROUND_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(60)
  -- GAP: BGM BGM_EARTHQUAKE1 non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  pcall(function() GROUND:MoveScreen(RogueEssence.Content.ScreenMover(0, 2, 30)) end) -- camera_SetEffect('2', '1', '1', '0')
  GAME:WaitFrames(30)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Waaah! A tremor!", french="Ouaaah! Un tremblement\nde terre!", german=" Waaah! Ein Beben!", italian=" Waaah! Un terremoto!", spanish=" ¡Aaaah! ¡Un temblor!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Waaah! A tremor!", french="Ouaaah! Un tremblement\nde terre!", german=" Waaah! Ein Beben!", italian=" Waaah! Un terremoto!", spanish=" ¡Aaaah! ¡Un temblor!"})
  else
  SkySceneKit.say({english=" Waaah! A tremor!", french="Ouaaah! Un tremblement\nde terre!", german=" Waaah! Ein Beben!", italian=" Waaah! Un terremoto!", spanish=" ¡Aaaah! ¡Un temblor!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GAME:WaitFrames(30)
  -- GAP: se_Play(7177) — id SE NDS sans portage PMDO identifié
  -- supervision_Acting(2) [neutre/état moteur]
  -- SetOutputAttribute(4) [neutre/état moteur]
  -- SetAnimation(17) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteObject(OBJECT_D16P31A9_58) [routine d'objet NDS non simulée - documenté]
  -- SetAnimation(18) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteObject(OBJECT_D16P31A9_58) [routine d'objet NDS non simulée - documenté]
  -- SetAnimation(3) [anim idle native]
  GAME:WaitFrames(30)
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  GAME:WaitFrames(10)
  pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="It's dangerous, [hero]!\nLet's take cover!", french="C'est dangereux, [hero]!\nAux abris!", german="Es wird gefährlich,\n[hero]! Gehen wir in Deckung!", italian=" Al riparo, [hero]!", spanish="¡Ten cuidado, [hero]!\n¡Pongámonos a cubierto!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="It's dangerous, [hero]!\nLet's back off!", french="C'est dangereux, [hero]!\nAux abris!", german="Es wird gefährlich,\n[hero]! Weg von hier!", italian=" Al riparo, [hero]!", spanish="¡Ten cuidado, [hero]!\n¡Pongámonos a cubierto!"})
  else
  SkySceneKit.say({english="It's dangerous, [hero]!\nLet's back off!", french="C'est dangereux, [hero]!\nAux abris!", german="Es wird gefährlich,\n[hero]! Weg von hier!", italian=" Al riparo, [hero]!", spanish="¡Ten cuidado, [hero]!\n¡Pongámonos a cubierto!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:MoveToPosition(partner, 284, 404, false, 2)
  GAME:WaitFrames(10)
  GROUND:MoveToPosition(hero, 316, 404, false, 2)
  GAME:WaitFrames(20)
  do local p=SkySceneKit.team_member(1).Position; GROUND:MoveToPosition(SkySceneKit.team_member(1), p.X+(0), p.Y+(180), false, 2) end
  GAME:WaitFrames(5)
  do local p=SkySceneKit.team_member(2).Position; GROUND:MoveToPosition(SkySceneKit.team_member(2), p.X+(0), p.Y+(180), false, 2) end
  pcall(function() SOUND:FadeOutBGM(60) end)
  -- se_FadeOut(7177, 60) [SE one-shot PMDO déjà terminé: fondu sans objet, canal SE V2]
  GAME:FadeOut(false, 30)
  -- camera_SetEffect(0): arrêt d'effet caméra
  GAME:WaitFrames(2) -- join WaitBgm
end
