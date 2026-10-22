-- GÉNÉRÉ par dev/tools/sky_compile_hub_npcs.py — NE PAS ÉDITER À LA MAIN.
-- NPC résidents canoniques du hub d73p28a (enter.sse ROM Sky EU: placements SSA exacts,
-- dialogues enterNN.ssb 5 langues; talk=nil = script ROM sans dialogue compilable, tracé).
local SkySceneKit = require 'halcyon.skyscenes.kit'
local function talk_npc_denryuu(hero, partner)
      pcall(function() UI:ResetSpeaker() end)
      SkySceneKit.say({english="Hey.\nIf it isn't Team [team:].", french="Hé.\nVoilà l'Equipe [team:].", german="Hey! Wenn das nicht\nTeam [team:] ist.", italian="Ehi! Ma guarda se non è\nil Team [team:]!", spanish="Anda...\nPero si es el [CS:X]Equipo[CR] [team:]."})
      pcall(function() UI:ResetSpeaker() end)
      SkySceneKit.say({english="Heading up to the summit\nagain today?", french="On tente une nouvelle ascension\ndu sommet?", german="Heute wieder zum Gipfel\nunterwegs?", italian="Di nuovo alla conquista\ndella cima?", spanish="¿Hoy también te diriges\na la cima?"})
      pcall(function() UI:ResetSpeaker() end)
      SkySceneKit.say({english=" Good luck!", french=" Bonne chance!", german=" Viel Erfolg!", italian=" Buona fortuna!", spanish=" ¡Pues que tengas buena suerte!"})
      pcall(function() UI:ResetSpeaker() end)
      SkySceneKit.say({english=" He's kind of clumsy, isn't he?", french="Il est du genre maladroit,\nn'est-ce pas?", german="Er ist ein wenig tollpatschig,\nnicht wahr?", italian=" È un po' strano, non è vero?", spanish=" Es un poco torpe, ¿no?"})
      pcall(function() UI:ResetSpeaker() end)
      SkySceneKit.say({english=" What?!", french=" Quoi?!", german=" Wie bitte?!?", italian=" Come?!", spanish=" ¡¿Cómo?!"})
      pcall(function() UI:ResetSpeaker() end)
      SkySceneKit.say({english=" The summit is utterly ruined?!", french="Le sommet est\ncomplètement dévasté?!", german="Der Gipfel ist vollkommen\nverdreckt?!?", italian=" La cima è devastata?!", spanish="¡¿La cima está totalmente\nen ruinas?!"})
      pcall(function() UI:ResetSpeaker() end)
      SkySceneKit.say({english="I haven't been to the summit in\na long time myself...", french="Ça fait longtemps que je ne\nsuis pas allé au sommet, moi-même...", german="Ich persönlich war schon lange\nnicht mehr auf dem Gipfel...", italian="È da tanto che non metto\npiede lassù...", spanish="La verdad es que hace mucho\nque no subo a la cima..."})
      pcall(function() UI:ResetSpeaker() end)
      SkySceneKit.say({english=" I wonder what happened...", french="Je me demande ce qui\ns'est passé...", german="Ich frage mich, was geschehen\nist...", italian=" Mi chiedo cosa sia successo...", spanish=" Me pregunto qué habrá pasado..."})
end
return {
  {species="ampharos", x=320, y=288, dir=Direction.UpLeft, name="NPC_DENRYUU", talk=talk_npc_denryuu},
}
