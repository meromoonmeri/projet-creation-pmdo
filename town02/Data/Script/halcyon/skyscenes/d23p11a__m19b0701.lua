-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D23P11A/m19b0701.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  SkyProg.set(20, 3) -- $SCENARIO_MAIN = scn[20,3] (ROM)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Hey, [CS:N]Grovyle[CR].", french=" Dis, [CS:N]Massko[CR].", german=" Hey, [CS:N]Reptain[CR].", italian=" Ehi, [CS:N]Grovyle[CR].", spanish=" Oye, [CS:N]Grovyle[CR]..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Hey, [CS:N]Grovyle[CR].", french=" Dis, [CS:N]Massko[CR].", german=" Hey, [CS:N]Reptain[CR].", italian=" Ehi, [CS:N]Grovyle[CR].", spanish=" Oye, [CS:N]Grovyle[CR]..."})
  else
  SkySceneKit.say({english=" Say, [CS:N]Grovyle[CR].", french=" Dis, [CS:N]Massko[CR].", german=" Hey, [CS:N]Reptain[CR].", italian=" Senti, [CS:N]Grovyle[CR].", spanish=" Oye, [CS:N]Grovyle[CR]..."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" So what's the Passage of Time?", french=" C'est quoi, le Couloir du Temps?", german=" Was ist denn dieser Zeittunnel?", italian=" Cos'è il Portale del Tempo?", spanish=" ¿Qué es el Pasaje del Tiempo?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" So what's the Passage of Time?", french=" C'est quoi, le Couloir du Temps?", german=" Was ist denn dieser Zeittunnel?", italian=" Cos'è il Portale del Tempo?", spanish=" ¿Qué es el Pasaje del Tiempo?"})
  else
  SkySceneKit.say({english=" So what's the Passage of Time?", french=" C'est quoi, le Couloir du Temps?", german=" Was ist denn dieser Zeittunnel?", italian=" Cos'è il Portale del Tempo?", spanish=" ¿Qué es el Pasaje del Tiempo?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  local npc_npc_juputoru = SkySceneKit.spawn_npc("grovyle", 280, 512, Direction.Up, "NPC_JUPUTORU")
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english="The Passage of Time is a portal\nthat [CS:N]Celebi[CR] uses to travel through time.", french="Le Couloir du Temps est le\npassage dont se sert [CS:N]Celebi[CR] pour voyager dans\nle temps.", german="Der Zeittunnel ist ein Portal, das\n[CS:N]Celebi[CR] für Zeitreisen verwendet.", italian="Il Portale del Tempo è un\npassaggio che usa [CS:N]Celebi[CR] per viaggiare\nattraverso il tempo.", spanish="El Pasaje del Tiempo es un portal\nque utiliza [CS:N]Celebi[CR] para viajar por el tiempo."})
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english="It's a secret corridor that\nspans dimensions.", french="C'est un passage secret,\nune sorte de pont entre les dimensions.", german="Es ist ein geheimer Gang über\nmehrere Dimensionen.", italian="È un corridoio segreto che\nattraversa le dimensioni.", spanish="Es una especie de túnel secreto\nque cruza dimensiones."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  local npc_npc_serebii = SkySceneKit.spawn_npc("celebi", 280, 488, Direction.Up, "NPC_SEREBII")
  pcall(function() UI:SetSpeaker(npc_npc_serebii) end)
  SkySceneKit.say({english="For short trips, I can travel\nthrough time all by myself.", french="Pour les voyages de courte\ndurée, je peux voyager dans le temps sans\npasser par le Couloir du Temps.", german="Bei kurzen Ausflügen kann ich\nallein durch die Zeit reisen.", italian="Per viaggi brevi, non ho bisogno\ndel Portale.", spanish="Si se trata de un viaje corto,\npuedo viajar yo sola."})
  pcall(function() UI:SetSpeaker(npc_npc_serebii) end)
  SkySceneKit.say({english="But for big trips that span many\ngenerations, I must use the Passage of Time.", french="Mais pour faire des sauts dans\nle temps sur plusieurs générations,\nj'en ai besoin.", german="Aber für größere Reisen, die\nmehrere Generationen umfassen, muss ich den\nZeittunnel verwenden.", italian="Ma per quelli lunghi che\nattraversano molte generazioni, devo\nusare il Portale del Tempo.", spanish="Pero para viajes más largos\nque abarcan varias generaciones, debo\nusar el Pasaje del Tiempo."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Oh! So if we go through that\nPassage of Time...", french="Oh! Alors si on passe par\nle Couloir du Temps...", german="Oh! Also wenn wir durch\ndiesen Zeittunnel gehen...", italian="Oh! Allora se passiamo\nattraverso quel Portale del Tempo...", spanish="¡Oh! Entonces, si cruzamos\nel Pasaje del Tiempo..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Oh! So if we were to go\nthrough that Passage of Time...", french="Oh! Alors si on passe par\nle Couloir du Temps...", german="Oh! Also wenn wir durch\ndiesen Zeittunnel gehen...", italian="Oh! Allora se passiamo\nattraverso quel Portale del Tempo...", spanish="¡Oh! Entonces, si cruzamos\nel Pasaje del Tiempo..."})
  else
  SkySceneKit.say({english="Oh! So if we were to go\nthrough that Passage of Time...", french="Oh! Alors si on passe par\nle Couloir du Temps...", german="Oh! Also wenn wir durch\ndiesen Zeittunnel gehen...", italian="Oh! Allora se passiamo\nattraverso quel Portale del Tempo...", spanish="¡Oh! Entonces, si cruzamos\nel Pasaje del Tiempo..."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english="Yes. You will be able to return\nto your time.", french="Oui. Vous pourrez regagner\nvotre époque.", german="Ja. Dann könnt ihr in eure\neigene Zeit zurückkehren.", italian="Sì, potrete tornare nel vostro\ntempo.", spanish="Exacto. Podréis volver a\nvuestra época."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_serebii) end)
  SkySceneKit.say({english=" Oh! I see it!", french=" Ça y est! Je l'aperçois!", german=" Oh! Ich kann ihn sehen!", italian=" Oh! Ecco!", spanish=" ¡Ya lo veo!"})
  -- message_Close
  -- back_SetGround(LEVEL_D23P11A) [neutre/état moteur]
  -- supervision_StationCommon(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_LoadStation(LEVEL_D23P11A, 'UM19') [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Station(3) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Acting(0) [neutre/état moteur]
  GAME:WaitFrames(1)
  -- camera_SetMyself() [neutre/état moteur]
  -- SetPositionInitial [position SSA de départ, déjà posée par le placement de scène]
  -- SetPositionInitial [position SSA de départ, déjà posée par le placement de scène]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  GAME:FadeIn(30)
  pcall(function() SOUND:PlayBGM("Deep Dusk Forest.ogg", true) end)
  GAME:WaitFrames(30)
  GROUND:MoveToPosition(npc_npc_serebii, 276, 308, false, 2)
  GAME:WaitFrames(15)
  GROUND:MoveToPosition(npc_npc_juputoru, 276, 348, false, 2)
  GAME:WaitFrames(10)
  GROUND:MoveToPosition(partner, 256, 372, false, 2)
  GAME:WaitFrames(5)
  GROUND:MoveToPosition(hero, 296, 372, false, 2)
  GROUND:EntTurn(npc_npc_serebii, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(30)
  GROUND:EntTurn(npc_npc_serebii, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_serebii) end)
  SkySceneKit.say({english="There's the entrance that leads\nup to the plateau.", french="Voilà le passage qui mène\nau plateau.", german="Da ist der Eingang, der zur\nHochebene hinaufführt.", italian="Questa è l'entrata che conduce\nall'altopiano.", spanish="Ahí está el camino para subir\na la explanada."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_serebii, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_serebii) end)
  SkySceneKit.say({english="The Passage of Time is way\nup there.", french="Le Couloir du Temps se trouve\ntout en haut.", german=" Der Zeittunnel ist ganz da oben.", italian="Il Portale del Tempo è\npiù avanti.", spanish="Para llegar al Pasaje del Tiempo\nhay que subir por allí."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english="Good.[K] We'll leave as soon as\nwe're ready.", french="Bien.[K] Préparez-vous pour que\nnous puissions partir au plus vite.", german="Gut.[K] Wir brechen auf, sobald wir\nfertig sind.", italian=" Bene.[K] Appena pronti partiamo.", spanish="Estupendo.[K] Nos iremos\nen cuanto estemos todos listos."})
  -- message_Close
  GROUND:MoveToPosition(npc_npc_juputoru, 228, 324, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(npc_npc_juputoru, Direction.UpLeft)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(30)
  SkySceneKit.cleanup_npcs()
end
