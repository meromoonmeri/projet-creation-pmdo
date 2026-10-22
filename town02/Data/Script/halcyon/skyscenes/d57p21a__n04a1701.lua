-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D57P21A/n04a1701.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  GROUND:EntTurn(hero, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]Would you like to go on?", french="[CN]Voulez-vous continuer?", german="[CN]Fortfahren?", italian="[CN]Vuoi proseguire?", spanish="[CN]¿Quieres continuar?"})
  do local __choice = SkySceneKit.ask({{english="Yes", french="Oui", german="Ja", italian="Sì", spanish="Sí"}, {english="No", french="Non", german="Nein", italian="No", spanish="No"}}) -- message_SwitchMenu(0, 1) ROM
  if __choice == 2 then
  -- message_Close
  else -- default/annulation
  -- @label_0 [étiquette de flux ExplorerScript]
  -- message_Close
  SV.SkyScenarioSide = {main=43, sub=8} -- $SCENARIO_SIDE = scn[43,8] (ROM)
  pcall(function() SOUND:FadeOutBGM(60) end)
  GAME:FadeOut(false, 60)
  GAME:WaitFrames(80)
  pcall(function() UI:SetSpeaker("Haunter", true, "haunter", 0, '', RogueEssence.Data.Gender.Unknown) end) -- message_SetActor(ACTOR_NPC_GOOSUTO) voix hors champ (espèce ROM)
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english=" ...[K]She...", french=" ...[K] Elle...", german=" ...[K]Sie...", italian=" ...[K] Quella...", spanish=" Es...[K] ella..."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="That [CS:Y]Sunflora[CR]... I think she's\nstill pursuing me.", french="Cette [CS:Y]Héliatronc[CR]... on dirait\nqu'elle en a toujours après moi.", german="Diese [CS:Y]Sonnflora[CR]... Ich glaube,\nsie verfolgt mich immer noch.", italian="Quella [CS:Y]Sunflora[CR]... Scommetto che\nè ancora alle mie calcagna.", spanish="Esa [CS:Y]Sunflora[CR]... Creo que aún\nintenta darme caza."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english=" So persistent...[K] Good grief.", french=" Quelle obstination...[K] Bon sang.", german=" Wie hartnäckig...[K] Du meine Güte.", italian=" È proprio testarda...", spanish=" Es muy insistente...[K] Qué pesada."})
  -- message_KeyWait
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Complain") end)
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english=" ...[K]That's right!", french=" ...[K] Mais j'y pense!", german=" ...[K]Na gut!", italian=" ...[K] Ma certo!", spanish=" Ah...[K] ¡Claro!"})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english=" She's a Grass-type Pokémon.", french=" C'est un Pokémon de type Plante.", german=" Sie ist ein Pflanzen-Pokémon.", italian=" È un Pokémon di tipo Erba.", spanish=" Es un Pokémon de tipo Planta."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="So if I run away over there...[K]\nHeh heh heh heh!", french="Donc, si je m'échappe par là...[K]\nHé hé hé hé!", german="Wenn ich also dorthin laufe...[K]\nHehehehehehehe!", italian="Quindi se scappo laggiù...[K]\nEh eh eh eh eh eh!", spanish="Así que, si me meto por aquí...[K]\n¡Je, je, je, je, qué listo soy!"})
  -- message_KeyWait
  GAME:FadeOut(false,  60)
  -- message_CloseEnforce
  GAME:WaitFrames(60)
  -- CallCommon CORO_FADE_OUT_ALL_AFTER (fermeture/attente message: géré par say())
  -- main_EnterDungeon(163, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  -- main_EnterDungeon(-1, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  GAME:WaitFrames(1) -- hold
  end
  end
end
