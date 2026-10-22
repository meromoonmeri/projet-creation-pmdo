-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/G01P03A/m13a0501.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  -- back_SetGround(LEVEL_S04P01A) [neutre/état moteur]
  GAME:FadeIn(0)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Ugh...we blew that attempt.", french=" Argh... on a échoué.", german=" Ugh... Das war ein Reinfall.", italian=" Ugh... Che buco nell'acqua...", spanish="Ay... Esta vez no lo hemos\nconseguido."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Ugh...that ended badly.", french=" Argh... on a échoué.", german=" Ugh... Das ging schlecht aus.", italian="Ohi ohi... Non è andata troppo\nbene...", spanish="Ay... Esta vez no lo hemos\nconseguido."})
  else
  SkySceneKit.say({english=" Ugh...that wasn't so good.", french=" Argh... on a échoué.", german=" Ugh... Das war kein Erfolg.", italian="Ohi ohi... Non è andata troppo\nbene...", spanish="Ay... Esta vez no lo hemos\nconseguido."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="It's tougher than I thought...[K]\nLet's go home for today.", french="C'est plus dur que je pensais...[K]\nRentrons chez nous pour aujourd'hui.", german="Es ist schwerer, als ich\ndachte...[K] Gehen wir für heute nach Hause.", italian="È più dura di quello che\npensassi...[K] Per oggi è meglio lasciar stare.", spanish="Es más difícil de lo que creía.[K]\nVolvamos al [CS:N]Pokégremio[CR] por hoy."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="This is much harder than I\nexpected...[K] Let's call it a day.", french="C'est plus dur que je pensais...[K]\nRentrons chez nous pour aujourd'hui.", german="Das ist viel schwerer, als ich\nerwartet habe...[K] Lassen wir es für heute sein.", italian="È più dura di quello che\npensassi...[K] Per oggi è meglio andare a casa.", spanish="Es más difícil de lo que\nesperaba.[K] Volvamos al [CS:N]Pokégremio[CR] por hoy."})
  else
  SkySceneKit.say({english="This won't be easy...[K] Let's call it\na day.", french="C'est plus dur que je pensais...[K]\nRentrons chez nous pour aujourd'hui.", german="Das wird nicht leicht werden...[K]\nLassen wir es für heute gut sein.", italian="È più dura di quello che\npensassi...[K] Per oggi è meglio andare a casa.", spanish="Esto no va a ser fácil.[K]\nVolvamos al [CS:N]Pokégremio[CR] por hoy."})
  end
  -- message_KeyWait
  GAME:FadeOut(false,  60)
  -- message_CloseEnforce
  GAME:WaitFrames(60)
  -- CallCommon CORO_FADE_OUT_ALL_AFTER (fermeture/attente message: géré par say())
  -- back_SetGround(LEVEL_G01P03A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeIn(30)
  pcall(function() SOUND:PlayBGM("Wigglytuff's Guild Remix.ogg", true) end)
  GAME:WaitFrames(30)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim") end)
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="What, did everyone get wiped\nout and end up back here?", french="Hein?! Est-ce que tout le monde\na échoué pour se retrouver ici?", german="Was? Alle haben schlappgemacht\nund sind wieder hier?", italian="Cosa? Sono stati tutti battuti\ncome noi?", spanish="¿Qué? ¿Han podido con todos\nnosotros y estamos de vuelta?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Oh no! Did everyone get knocked\nout and end up back here?", french="Hein?! Est-ce que tout le monde\na échoué pour se retrouver ici?", german="Oh nein! Wurden alle besiegt\nund sind wieder hier?", italian="Cosa? Sono stati tutti battuti\ncome noi?", spanish="¿Qué? ¿Han podido con todos\nnosotros y estamos de vuelta?"})
  else
  SkySceneKit.say({english="Oh my gosh! Did everybody fail\nand end up back here?", french="Hein?! Est-ce que tout le monde\na échoué pour se retrouver ici?", german="Meine Güte! Haben alle versagt\nund sind wieder hier?", italian="Cosa? Sono stati tutti battuti\ncome noi?", spanish="¿Qué? ¿Han podido con todos\nnosotros y estamos de vuelta?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  local npc_npc_dogoomu = SkySceneKit.spawn_npc("loudred", 336, 224, Direction.Down, "NPC_DOGOOMU")
  pcall(function() GROUND:CharSetEmote(npc_npc_dogoomu, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_dogoomu) end)
  SkySceneKit.say({english=" Uh...sort of...", french=" Ben... en gros, ouais...", german=" Äh... Kann man so sagen...", italian=" Eh... In effetti...", spanish=" Bueno, más o menos..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  local npc_npc_heigani = SkySceneKit.spawn_npc("corphish", 376, 224, Direction.Down, "NPC_HEIGANI")
  -- ExecuteCommon(CORO_JUMP_HAPPY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_heigani) end)
  SkySceneKit.say({english="Hey, hey! No one said it would\nbe easy!", french="Eh dis donc, personne n'a dit\nque ce serait facile!", german="Hey, hey! Niemand hat gesagt,\ndass es einfach wird!", italian="Ehi, ehi! Nessuno ha detto che\nsarebbe stato facile!", spanish="¡Oye, oye! Nadie dijo que fuera\na resultar fácil."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  local npc_npc_kimawari = SkySceneKit.spawn_npc("sunflora", 400, 232, Direction.DownLeft, "NPC_KIMAWARI")
  pcall(function() UI:SetSpeaker(npc_npc_kimawari) end)
  SkySceneKit.say({english="Let's not feel sorry for\nourselves. We'll try again tomorrow!", french="Arrêtons de nous plaindre!\nOn réessaiera demain!", german="Bemitleiden wir uns nicht selbst.\nMorgen versuchen wir es noch mal!", italian="È inutile piangerci addosso!\nRiproviamo domani!", spanish="Es mejor no lamentarse.\nYa lo intentaremos otra vez mañana."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  local npc_npc_bippa = SkySceneKit.spawn_npc("bidoof", 400, 256, Direction.UpLeft, "NPC_BIPPA")
  pcall(function() UI:SetSpeaker(npc_npc_bippa) end)
  SkySceneKit.say({english="Yup yup! We'll keep pushing on\nwith our search for a Time Gear!", french="On va continuer à chercher\nles Rouages du Temps, pour sûr!", german="Jawollja! Wir geben unsere\nSuche nach den Zahnrädern der Zeit nicht auf!", italian="Sissignore! Dobbiamo continuare\nla ricerca degli Ingranaggi del Tempo!", spanish="¡Sí, señor! Seguiremos buscando\nlos Engranajes del Tiempo."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  local npc_npc_dagutorio = SkySceneKit.spawn_npc("dugtrio", 376, 264, Direction.UpLeft, "NPC_DAGUTORIO")
  pcall(function() GROUND:CharSetEmote(npc_npc_dagutorio, "happy", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_dogoomu, "happy", 1) end)
  local npc_npc_chiriin = SkySceneKit.spawn_npc("chimecho", 352, 264, Direction.Up, "NPC_CHIRIIN")
  pcall(function() GROUND:CharSetEmote(npc_npc_chiriin, "happy", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_kimawari, "happy", 1) end)
  pcall(function() GROUND:CharSetEmote(partner, "happy", 1) end)
  pcall(function() GROUND:CharSetEmote(hero, "happy", 1) end)
  GROUND:EntTurn(npc_npc_dagutorio, Direction.Up)
  -- SetAnimation(23) [anim idle native]
  GROUND:EntTurn(npc_npc_chiriin, Direction.Up)
  -- SetAnimation(23) [anim idle native]
  GROUND:EntTurn(npc_npc_heigani, Direction.Down)
  -- SetAnimation(23) [anim idle native]
  GROUND:EntTurn(npc_npc_bippa, Direction.Up)
  -- SetAnimation(24) [anim idle native]
  GROUND:EntTurn(npc_npc_dogoomu, Direction.Down)
  -- SetAnimation(23) [anim idle native]
  GROUND:EntTurn(npc_npc_kimawari, Direction.Down)
  -- SetAnimation(23) [anim idle native]
  GROUND:EntTurn(hero, Direction.Up)
  -- SetAnimation(66) [anim idle native]
  GROUND:EntTurn(partner, Direction.Up)
  -- SetAnimation(66) [anim idle native]
  pcall(function() UI:ResetSpeaker() end)
  pcall(function() UI:SetSpeaker(npc_npc_bippa) end)
  SkySceneKit.say({english="[CS:N]Everyone[CR]: HOORAY!", french="[CS:N]Tous[CR]: HOURRA!", german="[CS:N]Alle[CR]: HURRA!", italian="[CS:N]Tutti[CR]: SÌÌÌÌÌÌÌ!", spanish="[CS:N]Todos[CR]: ¡HURRA!"})
  -- message_Close
  pcall(function() SOUND:FadeOutBGM(120) end)
  GAME:FadeOut(false, 60)
  GAME:WaitFrames(2) -- join WaitBgm
  GAME:WaitFrames(60)
  SkySceneKit.cleanup_npcs()
end
