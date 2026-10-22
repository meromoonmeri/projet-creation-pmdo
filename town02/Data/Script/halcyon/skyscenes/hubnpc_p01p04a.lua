-- GÉNÉRÉ par dev/tools/sky_compile_hub_npcs.py — NE PAS ÉDITER À LA MAIN.
-- NPC résidents canoniques du hub p01p04a (enter.sse ROM Sky EU: placements SSA exacts,
-- dialogues enterNN.ssb 5 langues; talk=nil = script ROM sans dialogue compilable, tracé).
local SkySceneKit = require 'halcyon.skyscenes.kit'
local function talk_npc_soonano(hero, partner)
      pcall(function() UI:ResetSpeaker() end)
      SkySceneKit.say({english=" We made a wonderful discovery!", french="Nous avons fait une découverte\nfabuleuse!", german="Wir haben eine wunderbare\nEntdeckung gemacht!", italian="Abbiamo fatto una scoperta\nsensazionale!", spanish="¡Menudo descubrimiento\nhemos hecho!"})
end
local function talk_npc_soonansu(hero, partner)
      SkySceneKit.say({english="Did you try asking [CS:N]Wynaut[CR]\nover there?", french="Demande plutôt à [CS:N]Okéoké[CR],\nà côté.", german="Probier doch mal,\n[CS:N]Isso[CR] anzusprechen.", italian="Hai provato a chiedere\na [CS:N]Wynaut[CR]?", spanish="¿Has probado a preguntarle a\n[CS:N]Wynaut[CR]?"}) -- SwitchTalk: branche default (canon générique)
      pcall(function() UI:ResetSpeaker() end)
      SkySceneKit.say({english=" That's right!", french=" Banco!", german=" Ganz genau!", italian=" Esatto!", spanish=" ¡Eso, eso!"})
end
local function talk_npc_patchiiru(hero, partner)
      pcall(function() UI:ResetSpeaker() end)
      SkySceneKit.say({english=" Oh, [hero]!", french=" Oh, [hero]!", german=" Oh, [hero]!", italian=" Oh, [hero]!", spanish=" ¡Anda, [hero]!"})
      pcall(function() UI:ResetSpeaker() end)
      SkySceneKit.say({english="There is a package here for\nTeam [team:]!", french="Un colis vient d'arriver pour\nl'Equipe [team:]!", german="Ich habe hier ein Paket für\nTeam [team:]!", italian="È arrivato un pacchetto per\nil Team [team:]!", spanish="Tengo un paquete para el [CS:X]Equipo[CR]\n[team:]."})
      pcall(function() UI:ResetSpeaker() end)
      SkySceneKit.say({english=" Aaaah!", french=" Aaaah!", german=" Aaaah!", italian=" Aaah!", spanish=" ¡Aaaah!"})
      pcall(function() UI:ResetSpeaker() end)
      SkySceneKit.say({english="Eureka![K]\nIt sounds good to hear a shout like that, huh?", french="Eurêka![K]\nC'est une douce musique pour les oreilles\nque ce cri de joie, non?", german="Heureka![K]\nDer Ausruf klingt gut, nicht wahr?", italian="Perbacco![K]\nSentire un urlo simile ti dà la carica, eh?", spanish=" ¡Eureka![K] Es genial oír ese grito, ¿eh?"})
      pcall(function() UI:ResetSpeaker() end)
      SkySceneKit.say({english=" Please continue to explore!", french="S'il vous plaît,\ncontinuez à explorer le monde!", german=" Bitte erkundet weiter!", italian=" Continuate a esplorare!", spanish=" ¡Continúa explorando!"})
end
return {
  {species="wynaut", x=432, y=152, dir=Direction.Down, name="NPC_SOONANO", talk=talk_npc_soonano},
  {species="wobbuffet", x=456, y=152, dir=Direction.Down, name="NPC_SOONANSU", talk=talk_npc_soonansu},
  {species="spinda", x=256, y=152, dir=Direction.Down, name="NPC_PATCHIIRU", talk=talk_npc_patchiiru},
}
