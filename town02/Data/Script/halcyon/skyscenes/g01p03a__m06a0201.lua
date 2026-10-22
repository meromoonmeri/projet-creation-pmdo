-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/G01P03A/m06a0201.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  pcall(function() SOUND:PlayBGM("Wigglytuff's Guild.ogg", true) end)
  SkyProg.set(7, 2) -- $SCENARIO_MAIN = scn[7,2] (ROM)
  SV.SkyVars = SV.SkyVars or {}
  SV.SkyVars.REQUEST_CLEAR_COUNT = 0 -- $REQUEST_CLEAR_COUNT = 0 (ROM)
  -- back_SetGround(LEVEL_G01P03A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- supervision_Acting(10) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  local npc_npc_heigani = SkySceneKit.spawn_npc("corphish", 416, 248, Direction.DownLeft, "NPC_HEIGANI")
  -- SetAnimation(4) [anim idle native]
  local npc_npc_kimawari = SkySceneKit.spawn_npc("sunflora", 392, 272, Direction.UpRight, "NPC_KIMAWARI")
  -- SetAnimation(4) [anim idle native]
  local npc_npc_bippa = SkySceneKit.spawn_npc("bidoof", 456, 216, Direction.Up, "NPC_BIPPA")
  -- SetAnimation(4) [anim idle native]
  GAME:FadeIn(30)
  -- supervision_Acting(1) [neutre/état moteur]
  GAME:WaitFrames(15)
  GROUND:MoveToPosition(hero, 364, 248, false, 2)
  GAME:WaitFrames(30)
  -- supervision_Acting(2) [neutre/état moteur]
  GAME:WaitFrames(15)
  GROUND:MoveToPosition(partner, 364, 220, false, 2)
  pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(30)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="So today they want us to work\non the jobs listed on the Job Bulletin Board and\nthe Outlaw Notice Board?", french="Il faut donc qu'on accomplisse\ndes missions affichées sur le Tableau\ndes Missions et des Avis de Recherche.", german="Heute sollen wir uns also um die\nJobs kümmern, die am Job-Infobrett und am\nGanoven-Infobrett aushängen?", italian="Quindi, oggi vogliono che ci\noccupiamo delle missioni e dei ricercati che\ncompaiono sulle Bacheche?", spanish="¿Así que hoy quieren que\nemprendamos alguna misión del Tablón\nde Anuncios y del Tablón \"Se Busca\"?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="So today they want us to work\non the jobs listed on the Job Bulletin Board and\nthe Outlaw Notice Board?", french="Il faut donc qu'on accomplisse\ndes missions affichées sur le Tableau\ndes Missions et des Avis de Recherche.", german="Heute sollen wir uns also um die\nJobs kümmern, die am Job-Infobrett und am\nGanoven-Infobrett aushängen?", italian="Quindi, oggi vogliono che ci\noccupiamo delle missioni elencate sulla Bacheca\ndelle missioni e su quella dei ricercati?", spanish="¿Así que hoy quieren que\nemprendamos alguna misión del Tablón\nde Anuncios y del Tablón \"Se Busca\"?"})
  else
  SkySceneKit.say({english="So today they want us to work\non the jobs listed on the Job Bulletin Board and\nthe Outlaw Notice Board?", french="Il faut donc qu'on accomplisse\ndes missions affichées sur le Tableau\ndes Missions et des Avis de Recherche.", german="Heute sollen wir uns also um die\nJobs kümmern, die am Job-Infobrett und am\nGanoven-Infobrett aushängen?", italian="Quindi, oggi vogliono che ci\noccupiamo delle missioni elencate sulla Bacheca\ndelle missioni e su quella dei ricercati?", spanish="¿Así que hoy quieren que\nemprendamos alguna misión del Tablón\nde Anuncios y del Tablón \"Se Busca\"?"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Let's try to do as many jobs as\nwe can.", french="Essayons de faire le plus de\nmissions possible.", german="Versuchen wir, so viele Jobs\nzu erledigen, wie wir können.", italian="Cerchiamo di fare più missioni\npossibili.", spanish="¡Vamos a hacer todas las\nmisiones que podamos!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Let's try to do as many jobs as\nwe can.", french="Essayons de faire le plus de\nmissions possible.", german="Versuchen wir, so viele Jobs\nzu erledigen, wie wir können.", italian="Cerchiamo di fare più missioni\npossibili.", spanish="¡Intentemos hacer tantas\nmisiones como podamos!"})
  else
  SkySceneKit.say({english="Let's try to do as many jobs as\nwe can.", french="Essayons de faire le plus de\nmissions possible.", german="Versuchen wir, so viele Jobs\nzu erledigen, wie wir können.", italian="Cerchiamo di fare più missioni\npossibili.", spanish="¡Intentemos hacer tantas\nmisiones como podamos!"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Then they'll have to pick us for\nthe expedition party!", french="Et comme ça ils nous choisiront\npour l'expédition!", german="Dann müssen sie uns einfach ins\nExpeditionsteam aufnehmen!", italian="Così ci sceglieranno di sicuro\nper la spedizione!", spanish="¡Seguro que así nos\nescogerán para ir a la expedición!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Then they'll have to pick us for\nthe expedition party!", french="Et comme ça ils nous choisiront\npour l'expédition!", german="Dann müssen sie uns einfach ins\nExpeditionsteam aufnehmen!", italian="Così ci sceglieranno di sicuro\nper la spedizione!", spanish="¡Seguro que así nos\nescogerán para ir a la expedición!"})
  else
  SkySceneKit.say({english="Then they'll have to pick us for\nthe expedition party!", french="Et comme ça ils nous choisiront\npour l'expédition!", german="Dann müssen sie uns einfach ins\nExpeditionsteam aufnehmen!", italian="Così ci sceglieranno di sicuro\nper la spedizione!", spanish="¡Seguro que así nos\nescogerán para ir a la expedición!"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Let's go check now,\n[hero]!", french="Allons jeter un œil,\n[hero]!", german="Sehen wir gleich nach,\n[hero]!", italian="Andiamo a dare un'occhiata alle\nBacheche, [hero]!", spanish="¡Vamos a echar un vistazo,\n[hero]!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Let's go check now,\n[hero]!", french="Allons jeter un œil,\n[hero]!", german="Sehen wir gleich nach,\n[hero]!", italian="Andiamo a controllare le\nBacheche, [hero]!", spanish="¡Vamos a ver qué hay,\n[hero]!"})
  else
  SkySceneKit.say({english="Let's go check now,\n[hero]!", french="Allons jeter un œil,\n[hero]!", german="Sehen wir gleich nach,\n[hero]!", italian="Andiamo a vedere cosa troviamo\nin Bacheca, [hero]!", spanish="¡Vamos a ver qué hay,\n[hero]!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() local g=GAME:GetCurrentGround(); GAME:MoveCamera(g.ViewCenter.X+(-32), g.ViewCenter.Y+(0), 40, false) end) -- MovePositionOffset performer/caméra
  GAME:WaitFrames(5)
  GROUND:MoveToPosition(partner, 332, 220, false, 2)
  GROUND:MoveToPosition(hero, 332, 248, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Startled") end)
  pcall(function() GROUND:CharSetEmote(partner, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() SOUND:FadeOutBGM(120) end)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Look! Those Pokémon...", french=" Regarde! Ces Pokémon...", german=" Sieh mal! Diese Pokémon...", italian=" Guarda! Quei Pokémon...", spanish=" ¡Mira! Esos Pokémon..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Look! Those Pokémon...", french=" Regarde! Ces Pokémon...", german=" Sieh mal! Diese Pokémon...", italian=" Guarda! Quei Pokémon...", spanish=" ¡Mira! Esos Pokémon..."})
  else
  SkySceneKit.say({english=" Look! Those Pokémon...", french=" Regarde! Ces Pokémon...", german=" Sieh mal! Diese Pokémon...", italian=" Guarda! Quei Pokémon...", spanish=" ¡Mira! Esos Pokémon..."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GAME:MoveCamera(296, 236, 60, false) end) -- performer/caméra
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  GAME:WaitFrames(30)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Startled") end)
  local npc_npc_zubatto = SkySceneKit.spawn_npc("zubat", 264, 216, Direction.Up, "NPC_ZUBATTO")
  -- GAP: SetEffect EFFECT_TWO_ARROWS_AT_SIDE_LEFT — VFX sans émote PMDO équivalente
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_zubatto, partner, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  local npc_npc_dogaasu = SkySceneKit.spawn_npc("koffing", 240, 216, Direction.Up, "NPC_DOGAASU")
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_dogaasu, partner, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Shock_Bad") end)
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(0, -1) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_zubatto) end)
  SkySceneKit.say({english=" Hey!", french=" Hé!", german=" Hey!", italian=" Ehi!", spanish=" ¡Eh!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:MoveToPosition(npc_npc_zubatto, 264, 220, false, 2)
  GROUND:MoveToPosition(npc_npc_dogaasu, 264, 248, false, 2)
  GROUND:EntTurn(npc_npc_zubatto, Direction.Right)
  GROUND:EntTurn(npc_npc_dogaasu, Direction.Right)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_dogaasu, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_dogaasu) end)
  SkySceneKit.say({english=" You two?!", french=" Vous deux?!", german=" Ihr zwei?!?", italian=" Voi due?!", spanish=" ¡¿Pero si son...?!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Confused") end)
  pcall(function() GROUND:CharSetEmote(partner, "question", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Huh? That duo...", french=" Hein? Ces deux-là...", german=" Äh? Diese beiden...", italian=" Eh? Quei due...", spanish=" ¡Espera! Esos dos..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Huh? That duo...", french=" Hein? Ces deux-là...", german=" Äh? Diese beiden...", italian=" Eh? Quei due...", spanish=" ¡Espera! Esos dos..."})
  else
  SkySceneKit.say({english=" Huh? That duo...", french=" Hein? Ces deux-là...", german=" Äh? Diese beiden...", italian=" Eh? Quei due...", spanish=" ¡Espera! Esos dos..."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Wait, haven't we seen\nthem before?", french="Attends, on les a déjà vus\nquelque part!", german="Warte, haben wir die nicht\nschon mal gesehen?", italian="Aspetta, non li abbiamo già\nvisti?", spanish=" ¿No les hemos visto antes?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Wait, haven't we seen\nthem before?", french="Attends, on les a déjà vus\nquelque part!", german="Warte, haben wir die nicht\nschon mal gesehen?", italian="Aspetta, non li abbiamo già\nvisti?", spanish=" ¿No les hemos visto antes?"})
  else
  SkySceneKit.say({english="Wait, haven't we seen\nthem before?", french="Attends, on les a déjà vus\nquelque part!", german="Warte, haben wir die nicht\nschon mal gesehen?", italian="Aspetta, non li abbiamo già\nvisti?", spanish=" ¿No les hemos visto antes?"})
  end
  -- message_Close
  GAME:FadeOut(false, 30)
  SkySceneKit.cleanup_npcs()
end
