-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/G01P03A/n01a0301.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  if (SkyProg.cmp_side(40, 2) >= 0) then -- if ROM: scn($SCENARIO_SIDE) >= [40, 2]
  -- @label_0 [étiquette de flux ExplorerScript]
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="I don't have time to be looking\nat the Outlaw Notice Board! Yup yup!", french="Pas l'temps d'regarder les Avis\nde Recherche, ma foi!", german="Ich habe keine Zeit, mir das\nGanoven-Infobrett anzusehen! Jawollja!", italian="Non ho tempo di controllare\nla Bacheca dei ricercati! Già, già!", spanish="No tengo tiempo para estar\nmirando el Tablón \"Se Busca\". ¡No, señor!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- @label_1 [étiquette de flux ExplorerScript]
  GROUND:EntTurn(hero, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  else
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" This is the Outlaw Notice Board.", french=" C'est les Avis de Recherche.", german=" Dies ist das Ganoven-Infobrett.", italian="Questa è la Bacheca\ndei ricercati.", spanish=" Este es el Tablón \\\"Se Busca\\\"."})
  -- message_KeyWait
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(hero, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="Sniff...[K] But I'm too scared to\nface someone with a mean look on their face...", french="Snif...[K] Mais j'ai trop la trouille\nde m'retrouver face à un type\nau r'gard mauvais.", german="Schnief...[K] Aber ich habe zu viel\nAngst, jemandem entgegenzutreten, der so\ngrimmig dreinblickt...", italian="Sniff...[K] Ma ho troppa paura\ndi affrontare uno di questi tipacci...", spanish="Ay...[K] Soy demasiado cobardica\npara batirme con alguien con cara de malote..."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="...If I goof off, [CS:N]Chatot[CR] will\nbe mighty angry.", french="... Si j'pars en vadrouille, [CS:N]Pijako[CR]\nva perdre la boule.", german="...Wenn ich das vergeige, wird\n[CS:N]Plaudagei[CR] mächtig sauer auf mich sein.", italian="Beh, meglio che vada a Borgo\nTesoro adesso.", spanish="Si hago el vago... [CS:N]Chatot[CR] igual\nme echa la bronca del siglo."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="I should get going to\nTreasure Town.", french="J'ferais mieux d'aller\nà Bourg-Trésor.", german="Ich sollte mich auf nach\nSchatzstadt machen.", italian="Se batto la fiacca, [CS:N]Chatot[CR]\nsi arrabbierà moltissimo.", spanish=" Debería ir tirando a Aldea Tesoro."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- jump @label_1 [saut final de branche vers l'épilogue commun: flux naturel]
  end
end
