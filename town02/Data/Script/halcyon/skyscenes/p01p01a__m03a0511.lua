-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/P01P01A/m03a0511.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  -- GAP: BGM BGM_OH_NO non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  -- back_SetGround(LEVEL_P01P01A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:WaitFrames(1)
  GROUND:MoveToPosition(partner, 216, 100, false, 2)
  GROUND:MoveToPosition(hero, 216, 76, false, 2)
  GAME:FadeIn(15)
  local npc_npc_mariru = SkySceneKit.spawn_npc("marill", 336, 200, Direction.Right, "NPC_MARIRU")
  pcall(function() GROUND:CharSetEmote(npc_npc_mariru, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharSetEmote(npc_npc_mariru, "sweating", 1) end)
  GROUND:EntTurn(partner, Direction.DownRight)
  GROUND:EntTurn(hero, Direction.DownRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharSetEmote(partner, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Hey! There's [CS:N]Marill[CR]!", french=" Regarde! Là! C'est [CS:N]Marill[CR]!", german=" Hey! Da ist [CS:N]Marill[CR]!", italian=" Ehi! Ecco [CS:N]Marill[CR]!", spanish=" ¡Mira! ¡Allí está [CS:N]Marill[CR]!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Look! There's [CS:N]Marill[CR]!", french=" Regarde! Là! C'est [CS:N]Marill[CR]!", german=" Sieh mal! Da ist [CS:N]Marill[CR]!", italian=" Ehi! Ecco [CS:N]Marill[CR]!", spanish=" ¡Mira! ¡Allí está [CS:N]Marill[CR]!"})
  else
  SkySceneKit.say({english=" Oh! [CS:N]Marill[CR]'s over there!", french=" Regarde! Là! C'est [CS:N]Marill[CR]!", german=" Oh! Da ist [CS:N]Marill[CR]!", italian=" Ehi! Ecco [CS:N]Marill[CR]!", spanish=" ¡Mira! ¡Allí está [CS:N]Marill[CR]!"})
  end
  -- message_Close
  pcall(function() GAME:MoveCamera(216, 188, 60, false) end) -- performer/caméra
  GROUND:MoveToPosition(partner, 216, 204, false, 2)
  GROUND:MoveToPosition(hero, 216, 180, false, 2)
  GROUND:EntTurn(npc_npc_mariru, Direction.Left)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharSetEmote(npc_npc_mariru, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GROUND:MoveToPosition(npc_npc_mariru, 260, 196, false, 2)
  GAME:WaitFrames(10)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(partner, Direction.Right)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(hero, Direction.Right)
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" [CS:N]Marill[CR], what's wrong?", french=" [CS:N]Marill[CR], qu'est-ce qu'il y a?", german=" [CS:N]Marill[CR], was ist los?", italian=" [CS:N]Marill[CR], cosa c'è?", spanish=" [CS:N]Marill[CR], ¿qué pasa?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" [CS:N]Marill[CR], what's the matter?", french=" [CS:N]Marill[CR], qu'est-ce qu'il y a?", german=" [CS:N]Marill[CR], was ist los?", italian=" [CS:N]Marill[CR], cosa succede?", spanish=" [CS:N]Marill[CR], ¿qué pasa?"})
  else
  SkySceneKit.say({english=" [CS:N]Marill[CR], what's the matter?", french=" [CS:N]Marill[CR], qu'est-ce qu'il y a?", german=" [CS:N]Marill[CR], was ist los?", italian=" [CS:N]Marill[CR], cos'è accaduto?", spanish=" [CS:N]Marill[CR], ¿qué pasa?"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Where are [CS:N]Azurill[CR] and [CS:N]Drowzee[CR]?", french=" Où sont [CS:N]Azurill[CR] et [CS:N]Soporifik[CR]?", german=" Wo sind [CS:N]Azurill[CR] und [CS:N]Traumato[CR]?", italian=" Dove sono [CS:N]Azurill[CR] e [CS:N]Drowzee[CR]?", spanish="¿Dónde están [CS:N]Azurill[CR]\ny [CS:N]Drowzee[CR]?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Where are [CS:N]Azurill[CR] and [CS:N]Drowzee[CR]?", french=" Où sont [CS:N]Azurill[CR] et [CS:N]Soporifik[CR]?", german=" Wo sind [CS:N]Azurill[CR] und [CS:N]Traumato[CR]?", italian=" Dove sono [CS:N]Azurill[CR] e [CS:N]Drowzee[CR]?", spanish="¿Dónde están [CS:N]Azurill[CR]\ny [CS:N]Drowzee[CR]?"})
  else
  SkySceneKit.say({english=" Where are [CS:N]Azurill[CR] and [CS:N]Drowzee[CR]?", french=" Où sont [CS:N]Azurill[CR] et [CS:N]Soporifik[CR]?", german=" Wo sind [CS:N]Azurill[CR] und [CS:N]Traumato[CR]?", italian=" Dove sono [CS:N]Azurill[CR] e [CS:N]Drowzee[CR]?", spanish="¿Dónde están [CS:N]Azurill[CR]\ny [CS:N]Drowzee[CR]?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- ExecuteCommon(CORO_JUMP_HAPPY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharSetEmote(npc_npc_mariru, "sweating", 1) end)
  pcall(function() UI:SetSpeaker(npc_npc_mariru) end)
  SkySceneKit.say({english=" Yes...about them...!", french=" Oui... justement...!", german=" Ja... hört zu!", italian=" Sì... Si tratta proprio di loro...!", spanish=" Eso mismo me pregunto yo."})
  pcall(function() UI:SetSpeaker(npc_npc_mariru) end)
  SkySceneKit.say({english="After we all left, we went\nlooking for our lost item together...", french="On est partis tous les trois\nà la recherche de notre objet perdu...", german="Nachdem wir losgegangen sind,\nhaben wir zusammen nach unserem verlorenen\nItem gesucht...", italian="Siamo partiti insieme per\nandare a cercare il nostro strumento...", spanish="Nos marchamos todos juntos\npara buscar el objeto que habíamos perdido..."})
  pcall(function() UI:SetSpeaker(npc_npc_mariru) end)
  SkySceneKit.say({english="But I wound up all alone when\nMr. [CS:N]Drowzee[CR] went somewhere with [CS:N]Azurill[CR].", french="Mais j'ai fini par me retrouver\ntout seul quand M. [CS:N]Soporifik[CR] est parti\nje ne sais où avec [CS:N]Azurill[CR].", german="Aber plötzlich war ich allein und\nHerr [CS:N]Traumato[CR] ist mit [CS:N]Azurill[CR] verschwunden.", italian="Io sono rimasto da solo\nquando il signor [CS:N]Drowzee[CR] è andato da\nqualche parte con [CS:N]Azurill[CR].", spanish="Pero de repente vi que me había\nquedado solo. El Sr. [CS:N]Drowzee[CR] se fue a alguna\nparte con [CS:N]Azurill[CR]."})
  pcall(function() UI:SetSpeaker(npc_npc_mariru) end)
  SkySceneKit.say({english="I called and called! But they\ndidn't come back.[K] I got scared...", french="Je les ai appelés! Mais ils ne\nsont pas revenus.[K] J'ai peur...", german="Ich rief und rief! Aber sie\nblieben weg.[K] Dann habe ich Angst bekommen.", italian="Li ho chiamati più volte! Ma non\nsono tornati.[K] Mi sono spaventato...", spanish="¡Les llamé una y otra vez! Pero\nno volvieron.[K] Me asusté. No sabía qué hacer."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" So which way did they go?!", french="Dans quelle direction est-ce\nqu'ils sont partis?", german="In welche Richtung sind sie\ngegangen?!?", italian=" Da che parte sono andati?!", spanish=" ¿Por dónde se fueron?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" So which way did they go?!", french="Dans quelle direction est-ce\nqu'ils sont partis?", german="In welche Richtung sind sie\ngegangen?!?", italian=" Da che parte sono andati?!", spanish=" ¿Por dónde se fueron?"})
  else
  SkySceneKit.say({english=" So which way did they go?!", french="Dans quelle direction est-ce\nqu'ils sont partis?", german="In welche Richtung sind sie\ngegangen?!?", italian=" Da che parte sono andati?!", spanish=" ¿Por dónde se fueron?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_mariru) end)
  SkySceneKit.say({english=" Th-that way!", french=" Par là!", german=" D-da lang!", italian=" D-Da quella parte!", spanish=" Por... por ahí."})
  -- message_Close
  do local p=npc_npc_mariru.Position; GROUND:MoveToPosition(npc_npc_mariru, p.X+(120), p.Y+(0), false, 2) end
  GAME:WaitFrames(10)
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(160), p.Y+(0), false, 2) end
  GAME:WaitFrames(5)
  do local p=partner.Position; GROUND:MoveToPosition(partner, p.X+(160), p.Y+(0), false, 2) end
  GAME:WaitFrames(45)
  pcall(function() SOUND:FadeOutBGM(120) end)
  GAME:FadeOut(false, 60)
  GAME:WaitFrames(2) -- join WaitBgm
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[4] = 1 -- dungeon_mode(4) = DMODE_OPEN (ROM)
  SkySceneKit.cleanup_npcs()
end
