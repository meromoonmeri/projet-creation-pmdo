-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/P01P01A/s03p1001.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  pcall(function() SOUND:PlayBGM("Treasure Town.ogg", true) end)
  SkyProg.set(29, 48) -- $SCENARIO_MAIN = scn[29,48] (ROM)
  -- back_SetGround(LEVEL_P01P03A) [neutre/état moteur]
  -- supervision_StationCommon(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_StationCommon(7) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeIn(30)
  local npc_npc_perappu = SkySceneKit.spawn_npc("chatot", 224, 64, Direction.Down, "NPC_PERAPPU")
  GROUND:MoveToPosition(npc_npc_perappu, 220, 148, false, 2)
  GROUND:MoveToPosition(partner, 220, 196, false, 2)
  GROUND:MoveToPosition(hero, 192, 196, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Complain") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_perappu, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() SOUND:FadeOutBGM(120) end)
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" Ah, Team [team:]! ♪", french=" Ah, l'Equipe [team:]! ♪", german=" Ah, Team [team:]! ♪", italian=" Ah, Team [team:]! ♪", spanish=" ¡Ah, [CS:X]Equipo[CR] [team:]! ♪"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(partner, Direction.Up)
  GROUND:EntTurn(hero, Direction.UpRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:MoveToPosition(npc_npc_perappu, 220, 172, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="I was just on my way to see\nhow [CS:N]Manaphy[CR] is doing! ♪", french="Je venais justement voir\ncomment se portait [CS:N]Manaphy[CR]! ♪", german="Ich war gerade auf dem Weg,\num zu sehen, wie es [CS:N]Manaphy[CR] geht! ♪", italian="Sono passato a vedere come sta\n[CS:N]Manaphy[CR]! ♪", spanish="Venía a ver qué tal está\n[CS:N]Manaphy[CR]. ♪"})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" I trust [CS:N]Manaphy[CR] is doing well?", french=" J'espère que [CS:N]Manaphy[CR] va bien?", german="Ich nehme mal an, [CS:N]Manaphy[CR] geht\nes gut?", italian="Immagino che [CS:N]Manaphy[CR] stia\nbene!", spanish="Confío en que [CS:N]Manaphy[CR] esté\nbien..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Shock") end)
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Th-there's trouble!", french=" Il... il y a un problème!", german=" D-da gibt es ein kleines Problem!", italian=" C-C'è un problema!", spanish="Me temo... que tenemos un\nproblema."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Th-there's trouble!", french=" Il... il y a un problème!", german=" D-da gibt es ein kleines Problem!", italian=" C-C'è un problema!", spanish="Me temo... que tenemos un\nproblema."})
  else
  SkySceneKit.say({english=" Th-there's trouble!", french=" Il... il y a un problème!", german=" D-da gibt es ein kleines Problem!", italian=" C-C'è un problema!", spanish="Me temo... que tenemos un\nproblema."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" It's [CS:N]Manaphy[CR]...[K] [CS:N]Manaphy[CR]'s gone!", french=" C'est [CS:N]Manaphy[CR]...[K] il a disparu!", german="Es geht um [CS:N]Manaphy[CR]...[K]\n[CS:N]Manaphy[CR] ist verschwunden!", italian="Si tratta di [CS:N]Manaphy[CR]...[K] [CS:N]Manaphy[CR]\nè scomparso!", spanish=" [CS:N]Manaphy[CR]...[K] ¡[CS:N]Manaphy[CR] se ha ido!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="It's [CS:N]Manaphy[CR]...[K] [CS:N]Manaphy[CR]\ndisappeared!", french=" C'est [CS:N]Manaphy[CR]...[K] il a disparu!", german="Es geht um [CS:N]Manaphy[CR]...[K]\n[CS:N]Manaphy[CR] ist verschwunden!", italian="Si tratta di [CS:N]Manaphy[CR]...[K] [CS:N]Manaphy[CR]\nè scomparso!", spanish=" [CS:N]Manaphy[CR]...[K] ¡[CS:N]Manaphy[CR] se ha ido!"})
  else
  SkySceneKit.say({english="It's [CS:N]Manaphy[CR]...[K] [CS:N]Manaphy[CR]\ndisappeared!", french=" C'est [CS:N]Manaphy[CR]...[K] il a disparu!", german="Es geht um [CS:N]Manaphy[CR]...[K]\n[CS:N]Manaphy[CR] ist verschwunden!", italian="Si tratta di [CS:N]Manaphy[CR]...[K] [CS:N]Manaphy[CR]\nè scomparso!", spanish="[CS:N]Manaphy[CR]...[K] ¡[CS:N]Manaphy[CR] ha\ndesaparecido!"})
  end
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_perappu, "shock", 1) end)
  -- SetAnimation(22) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" Wh-what?!", french=" Qu-quoi?!", german=" W-was?!?", italian=" C-Cosa?!", spanish=" ¡¿Quéee?!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="Didn't I tell you two to take\nproper care of that baby? Didn't I?!", french="Ne vous ai-je pas dit de prendre\ngrand soin de ce bébé?!", german="Hab ich euch nicht gesagt, ihr\nsollt gut auf das Kleine aufpassen? Hab ich\ndas etwa nicht gesagt?!?", italian="Non vi avevo detto di prendervi\ncura del cucciolo? Non ve l'avevo forse detto?!", spanish="¿No os dije que lo cuidarais\nbien?"})
  -- message_KeyWait
  pcall(function() GROUND:CharSetEmote(npc_npc_perappu, "sweating", 1) end)
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" Squawk! I'll look too!", french="Couaaac! Je vais le chercher\naussi!", german=" Kreisch! Ich suche mit!", italian="Squack! Vengo anche\nio a cercarlo!", spanish=" ¡Cruac! ¡Os ayudaré a buscarlo!"})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="[CS:N]Manaphy[CR]'s still a toddler.[K]\nThat baby couldn't have gotten too far.", french="[CS:N]Manaphy[CR] est encore tout petit.[K]\nIl n'a pas pu aller bien loin.", german="[CS:N]Manaphy[CR] ist immer noch ein\nKleinkind.[K] Es kann nicht sehr weit\ngekommen sein.", italian="[CS:N]Manaphy[CR] è ancora un cucciolo.[K]\nNon può essere andato molto lontano.", spanish="[CS:N]Manaphy[CR] es todavía un bebé.[K]\nNo ha podido ir muy lejos."})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="I'll look through the guild! You\ntwo search outside!", french="Je vais chercher dans la Guilde!\nVous deux, cherchez aux alentours!", german="Ich sehe in der Gilde nach! Ihr\nzwei sucht draußen nach ihm!", italian="Io perlustrerò la Gilda! Voi due\ncercate fuori!", spanish="¡Yo buscaré por el [CS:N]Pokégremio[CR]!\n¡Encargaos de los alrededores!"})
  -- message_Close
  do local p=npc_npc_perappu.Position; GROUND:MoveToPosition(npc_npc_perappu, p.X+(0), p.Y+(-180), false, 2) end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- Destroy() [neutre/état moteur]
  pcall(function() local p=hero.Position; GAME:MoveCamera(p.X, p.Y, 60, false) end) -- MovePositionLives performer/caméra vers ACTOR_PLAYER
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  pcall(function() SOUND:PlayBGM("Treasure Town.ogg", true) end)
  SkySceneKit.cleanup_npcs()
end
