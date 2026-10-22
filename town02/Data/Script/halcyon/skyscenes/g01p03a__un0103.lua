-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/G01P03A/un0103.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  if (SkyProg.cmp_side(40, 7) >= 0) or (SkyProg.cmp_side(40, 3) >= 0) or (SkyProg.cmp_side(40, 2) >= 0) then -- if ROM: scn($SCENARIO_SIDE) >= [40, 7] || scn($SCENARIO_SIDE) >= [40
  -- @label_3 [étiquette de flux ExplorerScript]
  -- JumpCommon(CORO_END_TALK) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  else
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  local npc_npc_taneboo = SkySceneKit.spawn_npc("seedot", 416, 296, Direction.Left, "NPC_TANEBOO")
  pcall(function() UI:SetSpeaker(npc_npc_taneboo) end)
  SkySceneKit.say({english=" We're Team [CS:X]Seedgey[CR]!", french=" Nous sommes l'Equipe [CS:X]Grainicool[CR]!", german=" Wir sind Team [CS:X]Tauburzel[CR]!", italian=" Noi siamo il Team [CS:X]Seedgey[CR]!", spanish=" ¡Somos el [CS:X]Equipo Seedgey[CR]!"})
  pcall(function() UI:SetSpeaker(npc_npc_taneboo) end)
  SkySceneKit.say({english="We're [CS:N]Seedot[CR] and [CS:N]Pidgey[CR].[K]\nOur team name, [CS:X]Seedgey[CR], combines our names!", french="Nous sommes [CS:N]Grainipiot[CR] et\n[CS:N]Roucool[CR].[K] Le nom de notre équipe, [CS:X]Grainicool[CR],\nest une combinaison de nos deux noms!", german="Wir sind [CS:N]Samurzel[CR] und [CS:N]Taubsi[CR].[K]\nDer Name unseres Teams, [CS:X]Tauburzel[CR],\nkombiniert unsere Namen!", italian="Siamo [CS:N]Seedot[CR] e [CS:N]Pidgey[CR].[K] Il nome\ndella nostra squadra, [CS:X]Seedgey[CR], è la\ncombinazione dei nostri due nomi.", spanish="Somos [CS:N]Seedot[CR] y [CS:N]Pidgey[CR].[K]\nDe ahí el nombre del [CS:X]Equipo Seedgey[CR]."})
  pcall(function() UI:SetSpeaker(npc_npc_taneboo) end)
  SkySceneKit.say({english=" So remember it!", french=" Souviens-t'en!", german=" Also präge ihn dir gut ein!", italian=" Quindi ricordatevelo!", spanish="¡Así seguro que no tienes\nproblemas para recordarlo!"})
  -- message_Close
  -- jump @label_3 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  SkySceneKit.cleanup_npcs()
end
