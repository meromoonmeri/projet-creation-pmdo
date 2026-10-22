-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D55P11A/n06a3903.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  -- GAP: BGM BGM_ILLUSION_STONE_CHAMBER non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  -- back_SetGround(LEVEL_D55P11A) [neutre/état moteur]
  -- supervision_StationCommon(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_StationCommon(1) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  local npc_npc_metamon_otachi = SkySceneKit.spawn_npc("sentret", 280, 304, Direction.Up, "NPC_METAMON_OTACHI")
  -- SetPositionInitial [position SSA de départ, déjà posée par le placement de scène]
  local npc_npc_saanaito = SkySceneKit.spawn_npc("gardevoir", 312, 352, Direction.Up, "NPC_SAANAITO")
  -- SetPositionInitial [position SSA de départ, déjà posée par le placement de scène]
  local npc_npc_chaaremu = SkySceneKit.spawn_npc("medicham", 240, 360, Direction.Up, "NPC_CHAAREMU")
  -- SetPositionInitial [position SSA de départ, déjà posée par le placement de scène]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GAME:MoveCamera(276, 292, 1, false) end) -- SetPositionMark performer/caméra
  GROUND:TeleportTo(npc_npc_metamon_otachi, 276, 300, Direction.Down)
  GROUND:TeleportTo(npc_npc_chaaremu, 240, 252, Direction.Down)
  GROUND:TeleportTo(npc_npc_saanaito, 312, 252, Direction.Down)
  GROUND:TeleportTo(hero, 276, 252, Direction.Down)
  GROUND:EntTurn(npc_npc_chaaremu, Direction.Down)
  GROUND:EntTurn(npc_npc_saanaito, Direction.Down)
  GROUND:EntTurn(hero, Direction.Down)
  GROUND:EntTurn(npc_npc_metamon_otachi, Direction.Up)
  GAME:FadeOut(false, 0) -- screen_FlushOut
  GAME:FadeIn(30)
  GAME:WaitFrames(30)
  pcall(function() UI:SetSpeaker(npc_npc_metamon_otachi) end)
  SkySceneKit.say({english="After watching you...[K]\nI feel like I can trust you, so...", french="Maintenant que j'ai vu ça...[K]\nje sais que vous êtes dignes de confiance...", german="Nachdem ich euch gesehen habe...[K]\nIch bin sicher, dass ich euch vertrauen kann...", italian="Dopo avervi visto...[K]\nSento di potermi fidare di voi, quindi...", spanish="Después de ver algo así...[K]\nCreo que puedo confiar en vosotras, así que..."})
  pcall(function() UI:SetSpeaker(npc_npc_metamon_otachi) end)
  SkySceneKit.say({english=" I have a request.", french="Aussi, j'aimerais vous demander\nquelque chose.", german=" Ich habe eine Bitte an euch.", italian=" ... avrei una richiesta da fare.", spanish=" Tengo algo que pediros."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(hero, "question", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" A request?", french=" Quoi donc?", german=" Eine Bitte?", italian=" Una richiesta?", spanish=" ¿De qué se trata?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_metamon_otachi) end)
  SkySceneKit.say({english=" Yes.[K] Team [CS:X]AWD[CR]...", french=" L'Equipe [CS:X]DDA[CR]...", german=" Ja.[K] Team [CS:X]SPA[CR]...", italian=" Sì.[K] Il Team [CS:X]AWD[CR]...", spanish=" Pues...[K] El [CS:X]Equipo WAD[CR]..."})
  pcall(function() UI:SetSpeaker(npc_npc_metamon_otachi) end)
  SkySceneKit.say({english=" Team [CS:X]AWD[CR] needs to be punished.", french="L'Equipe [CS:X]DDA[CR] mérite\nune bonne correction.", german="Team [CS:X]SPA[CR] hat eine Lektion\nverdient.", italian="Il Team [CS:X]AWD[CR] deve essere\npunito.", spanish=" El [CS:X]Equipo WAD[CR] merece un castigo."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GAME:WaitFrames(20)
  pcall(function() UI:SetSpeaker(npc_npc_metamon_otachi) end)
  SkySceneKit.say({english="[CN]The one who asked us to punish\n[CN]Team [CS:X]AWD[CR]...", french="[CN]Ce Pokémon qui nous a demandé de donner\n[CN]une bonne leçon à l'Equipe [CS:X]DDA[CR]...", german="[CN]Das Pokémon, das uns gegen\n[CN]Team [CS:X]SPA[CR] aufgehetzt hat...", italian="[CN]Chi ci ha chiesto di punire\n[CN]il Team [CS:X]AWD[CR]...", spanish="[CN]El que nos pidió que castigáramos al\n[CN][CS:X]Equipo WAD[CR]..."})
  pcall(function() UI:SetSpeaker(npc_npc_metamon_otachi) end)
  SkySceneKit.say({english="[CN]That [CS:N]Sentret[CR] too...", french="[CN]Ce [CS:N]Fouinette[CR]...", german="[CN]Dieser [CS:N]Wiesor[CR]...", italian="[CN]Quel [CS:N]Sentret[CR]...", spanish="[CN]Es decir, aquel [CS:N]Sentret[CR]..."})
  pcall(function() UI:SetSpeaker(npc_npc_metamon_otachi) end)
  SkySceneKit.say({english="[CN]They were really...[K]you?", french="[CN]En réalité, c'était...[K] toi?", german="[CN]In Wirklichkeit...[K]\n[CN]Warst du das?", italian="[CN]Eri...[K] tu?", spanish="[CN]En realidad...[K] ¿eras tú?"})
  -- message_Close
  GAME:FadeOut(true, 30) -- screen_WhiteOut
  GAME:FadeIn(0) -- screen_FlushIn
  SkySceneKit.cleanup_npcs()
end
