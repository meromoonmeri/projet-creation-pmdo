-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/G01P01A/n01a0706.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  -- back_SetGround(LEVEL_G01P01A) [neutre/état moteur]
  -- supervision_StationCommon(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:WaitFrames(1)
  local npc_npc_yukikaburi = SkySceneKit.spawn_npc("snover", 240, 232, Direction.Right, "NPC_YUKIKABURI")
  do local p=npc_npc_yukikaburi.Position; GROUND:MoveToPosition(npc_npc_yukikaburi, p.X+(24), p.Y+(0), false, 1) end
  -- bgm2_PlayFadeIn(BGM_OCEAN3) [canal BGM sub: PMDO n'a qu'un canal; hors TOP_FOCUS le principal garde la main - adaptation documentée]
  GAME:FadeIn(30)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(npc_npc_yukikaburi, Direction.Left)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  do local p=npc_npc_yukikaburi.Position; GROUND:MoveToPosition(npc_npc_yukikaburi, p.X+(-48), p.Y+(0), false, 1) end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(npc_npc_yukikaburi, Direction.Right)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  do local p=npc_npc_yukikaburi.Position; GROUND:MoveToPosition(npc_npc_yukikaburi, p.X+(24), p.Y+(0), false, 1) end
  GAME:WaitFrames(30)
  -- supervision_Acting(1) [neutre/état moteur]
  GROUND:EntTurn(npc_npc_yukikaburi, Direction.Up)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Startled") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_yukikaburi, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_yukikaburi) end)
  SkySceneKit.say({english=" Oh!", french=" Oh!", german=" Oh!", italian=" Oh!", spanish=" ¡Anda!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Huh? You are?", french=" Hein? Toi?", german=" Huch! Du?", italian=" Eh? Ma tu sei...", spanish=" ¿Eh? ¿Quién eres?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:MoveToPosition(hero, 240, 196, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" You're from yesterday!", french=" C'était toi, hier!", german=" Du bist der von gestern!", italian=" Tu sei quello di ieri!", spanish=" ¡Yo te conozco de ayer!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_yukikaburi) end)
  SkySceneKit.say({english="...Y-yes.[K] Nice to meet you.[K]\nM-my name is [CS:N]Snover[CR].", french="... Heu, oui.[K] Ravi de te rencontrer.[K]\nM-mon nom est [CS:N]Blizzi[CR].", german="...J-ja.[K] Schön, dich zu sehen.[K]\nM-mein Name ist [CS:N]Shnebedeck[CR].", italian="S-Sì...[K] Piacere di conoscerti.[K]\nM-Mi chiamo [CS:N]Snover[CR].", spanish="Sí...[K] Encantado de conocerte.[K]\nMe... Me llamo [CS:N]Snover[CR]."})
  pcall(function() UI:SetSpeaker(npc_npc_yukikaburi) end)
  SkySceneKit.say({english="I'm really sorry to have caused\nyou trouble yesterday.", french="Je suis vraiment désolé de\nt'avoir mis dans le pétrin, hier.", german="Die Aufregung gestern tut mir\nsehr leid.", italian="Mi dispiace davvero di averti\ncausato tutto quel disturbo ieri.", spanish="Siento mucho haberte causado\nproblemas ayer."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- SetAnimation(24) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(hero, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="Never mind that...[K] What\nabout those scary Pokémon that were\nchasing you...", french="T'inquiète...[K] Mais, ces deux\naffreux Pokémon qui t'poursuivaient...", german="Ach, schon gut...[K] Was ist mit\nden furchteinflößenden Pokémon, die dich\ngestern gejagt haben?", italian="Non ti preoccupare...[K]\nChe è successo con quei loschi Pokémon\nche ti stavano dando la caccia?", spanish="No te preocupes...[K] Cuéntame\nlo de esos Pokémon horripilantes que\nte perseguían..."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" A-are you all right?", french=" T-tu t'portes bien?", german=" D-dir geht es gut?", italian=" S-Stai bene?", spanish=" ¿E... estás bien?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_yukikaburi) end)
  SkySceneKit.say({english="Y-yes. I'm OK.[K]\nBut...", french="Oui, tout va bien.[K]\nMais...", german=" J-ja. Ich bin okay.[K] Aber...", italian="S-Sì. È tutto a posto.[K]\nMa...", spanish=" Sí... Sí, estoy bien.[K] Pero..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_yukikaburi, Direction.Left)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_yukikaburi) end)
  SkySceneKit.say({english="Truth is I had a bit of a\nscary encounter...", french="Pour dire la vérité, j'ai fait une\nmauvaise rencontre...", german="Ich habe allerdings eine\nbeängstigende Begegnung hinter mir...", italian="La verità è che me la sono\nvista brutta...", spanish="La verdad es que tuve un\nencuentro bastante espeluznante..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- bgm2_FadeOut [canal BGM sub: voir bgm2_Play]
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim") end)
  pcall(function() GROUND:CharSetEmote(hero, "shock", 1) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="Whaaat?[K] Scary encounter...[K]\nWhat happened?!", french="Ah oui?[K]\nQu'est-c'qui s'est passé?!", german="Waaaas?[K] Beängstigend...[K]\nWas ist passiert?!?", italian="Cooosa?[K] Te la sei vista brutta?[K]\nChe cosa è successo?!", spanish="¿Quéee?[K] Se me están poniendo\nlos pelos como escarpias...[K] ¡Cuéntamelo todo!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: BGM BGM_AIR_OF_UNEASE non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  pcall(function() UI:SetSpeaker(npc_npc_yukikaburi) end)
  SkySceneKit.say({english="After we met, I tried my best to\nrun away...", french="Après notre rencontre, j'ai\nessayé de détaler le plus loin possible...", german="Nach unserer Begegnung gab\nich mein Bestes, wegzurennen...", italian="Dopo il nostro incontro, ho fatto\ndel mio meglio per fuggire...", spanish="Después de que nos cruzáramos,\nintenté huir por todos los medios..."})
  pcall(function() UI:SetSpeaker(npc_npc_yukikaburi) end)
  SkySceneKit.say({english="But [CS:N]Bagon[CR] and [CS:N]Gligar[CR] caught up\nwith me...", french="Mais [CS:N]Draby[CR] et [CS:N]Scorplane[CR]\nont fini par me rattraper...", german="Aber [CS:N]Kindwurm[CR] und [CS:N]Skorgla[CR]\nholten mich ein...", italian="Ma [CS:N]Bagon[CR] e [CS:N]Gligar[CR] mi\nhanno raggiunto...", spanish=" Pero [CS:N]Bagon[CR] y [CS:N]Gligar[CR] me alcanzaron..."})
  -- message_Close
  GAME:FadeOut(false, 30)
  SkySceneKit.cleanup_npcs()
end
