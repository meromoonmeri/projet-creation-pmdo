-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D07P11A/m08a1001.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  SkyProg.set(9, 4) -- $SCENARIO_MAIN = scn[9,4] (ROM)
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[10] = 1 -- dungeon_mode(10) = DMODE_OPEN (ROM)
  -- back_SetGround(LEVEL_D07P11A) [neutre/état moteur]
  -- supervision_StationCommon(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeIn(30)
  pcall(function() SOUND:PlayBGM("Mt. Horn.ogg", true) end)
  local npc_npc_bippa = SkySceneKit.spawn_npc("bidoof", 0, 208, Direction.Right, "NPC_BIPPA")
  GROUND:MoveToPosition(npc_npc_bippa, 176, 204, false, 2)
  GAME:WaitFrames(50)
  GROUND:MoveToPosition(partner, 144, 212, false, 2)
  GAME:WaitFrames(20)
  GROUND:MoveToPosition(hero, 144, 196, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_bippa) end)
  SkySceneKit.say({english="Whew... By golly, I reckon we're\nfinally through.", french="Pfiou... Sapristi! On y est enfin\narrivés.", german="Puh... Menschenskind, ich glaube,\njetzt haben wir es endlich geschafft.", italian="Fiuu... Ohibò, credo che ce\nl'abbiamo finalmente fatta.", spanish="Madre mía. Nos ha costado\nlo suyo cruzar."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_bippa, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(hero, npc_npc_bippa, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Yeah, but we're still pretty far\nfrom the base camp.", french="Ouais, mais on est encore\nassez loin du camp de base.", german="Ja, aber bis zum Basislager ist\nes noch immer ganz schön weit.", italian="Già, ma siamo ancora molto\nlontani dal Campo Base.", spanish="Sí, pero aún falta un buen\ntrecho para llegar al campamento base."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Yes, but we still have a long\nways to go for the base camp.", french="Ouais, mais on est encore\nassez loin du camp de base.", german="Ja, aber bis zum Basislager\nmüssen wir noch ziemlich weit gehen.", italian="Già, ma siamo ancora molto\nlontani dal Campo Base.", spanish="Sí, pero aún falta un buen\ntrecho para llegar al campamento base."})
  else
  SkySceneKit.say({english="Yes, but we're still quite far\nfrom the base camp.", french="Ouais, mais on est encore\nassez loin du camp de base.", german="Ja, aber bis zum Basislager ist\nes noch immer ziemlich weit.", italian="Già, ma siamo ancora molto\nlontani dal Campo Base.", spanish="Sí, pero aún falta un buen\ntrecho para llegar al campamento base."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Let's check the Wonder Map.", french="Jetons un coup d'œil sur la\nCarte Miracle.", german="Lass uns einen Blick auf die\nWunderkarte werfen.", italian="Controlliamo la Mappa delle\nmeraviglie.", spanish="Vamos a echarle un vistazo\nal Mapa Mágico."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Let's check the Wonder Map.", french="Jetons un coup d'œil sur la\nCarte Miracle.", german="Lass uns einen Blick auf die\nWunderkarte werfen.", italian="Controlliamo la Mappa delle\nmeraviglie.", spanish=" Vamos a mirar el Mapa Mágico."})
  else
  SkySceneKit.say({english=" Let's look at the Wonder Map.", french="Jetons un coup d'œil sur la\nCarte Miracle.", german="Lass uns einen Blick auf die\nWunderkarte werfen.", italian="Controlliamo la Mappa delle\nmeraviglie.", spanish=" Vamos a mirar el Mapa Mágico."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(partner, Direction.UpRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(hero, Direction.DownRight)
  GROUND:EntTurn(npc_npc_bippa, Direction.Left)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- GAP: se_Play(6667) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(false, 15)
  SkySceneKit.cleanup_npcs()
end
