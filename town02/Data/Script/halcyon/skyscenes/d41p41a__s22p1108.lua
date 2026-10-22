-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D41P41A/s22p1108.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:PlayBGM("Hidden Highland.ogg", true) end)
  -- back_SetGround(LEVEL_D41P41A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeIn(30)
  GAME:WaitFrames(30)
  local npc_npc_daakurai = SkySceneKit.spawn_npc("darkrai", 280, 152, Direction.Down, "NPC_DAAKURAI")
  pcall(function() UI:SetSpeaker(npc_npc_daakurai) end)
  SkySceneKit.say({english="However, [CS:N]Grovyle[CR] and\n[hero] decided to meddle.", french="Mais il a fallu que [CS:N]Massko[CR]\net [hero] viennent s'en mêler.", german="Dann entschieden [CS:N]Reptain[CR] und\n[hero], sich einzumischen.", italian="Tuttavia, [CS:N]Grovyle[CR] e\n[hero] hanno deciso di immischiarsi.", spanish="Sin embargo, [CS:N]Grovyle[CR] y\n[hero] decidieron entrometerse."})
  pcall(function() UI:SetSpeaker(npc_npc_daakurai) end)
  SkySceneKit.say({english="I learned of their impending\narrival from the future...", french="J'ai eu vent de leur arrivée\nimminente du futur...", german="Ich erfuhr von ihrem\nbevorstehenden Eintreffen aus der Zukunft...", italian="Sono venuto a sapere del loro\narrivo dal futuro...", spanish="Me enteré de su inminente\nllegada del futuro..."})
  pcall(function() UI:SetSpeaker(npc_npc_daakurai) end)
  SkySceneKit.say({english="And I attacked [CS:N]Grovyle[CR] and\n[hero] as they traveled in time...[K]\nSo that I would be rid of them.", french="Et j'ai attaqué [CS:N]Massko[CR] et\n[hero] pendant leur voyage dans\nle temps...[K] histoire de m'en débarrasser.", german="Und dann griff ich [CS:N]Reptain[CR] und\n[hero] auf ihrer Zeitreise an...[K]\nUm sie loszuwerden.", italian="Così li ho attaccati mentre\nviaggiavano nel tempo...[K]\nIn modo da sbarazzarmene.", spanish="Y ataqué a [CS:N]Grovyle[CR] y a\n[hero] mientras viajaban en el tiempo...[K]\nQuería librarme de ellos."})
  pcall(function() UI:SetSpeaker(npc_npc_daakurai) end)
  SkySceneKit.say({english="But...[K]an unforeseen event made\nit impossible to be rid of either of them.", french="Mais...[K] un imprévu m'a empêché\nde mener ce plan à son terme.", german="Aber[K] ein unvorhersehbares\nEreignis machte es unmöglich, auch nur einen\nder beiden zu beseitigen.", italian="Ma...[K] un evento imprevisto\nha reso impossibile farli sparire.", spanish="Pero...[K] un acontecimiento\ninesperado me impidió librarme de\nellos."})
  pcall(function() UI:SetSpeaker(npc_npc_daakurai) end)
  SkySceneKit.say({english="It should have been enough.[K]\nEspecially for [CS:N]Grovyle[CR].[K] However...", french="Néanmoins, cela aurait dû être\nsuffisant.[K] Surtout pour [CS:N]Massko[CR].[K] Pourtant...", german="Es hätte reichen sollen.[K]\nBesonders für [CS:N]Reptain[CR].[K] Übrigens...", italian="Avrebbe dovuto essere\nsufficiente.[K] Soprattutto per [CS:N]Grovyle[CR].[K] Ma...", spanish="Debería haber bastado.[K] Sobre\ntodo en lo que respecta a [CS:N]Grovyle[CR].[K] Sin\nembargo..."})
  pcall(function() UI:SetSpeaker(npc_npc_daakurai) end)
  SkySceneKit.say({english="Do you know how you came to\nbe a Pokémon, [hero]?", french="Sais-tu pourquoi tu as pris\nla forme d'un Pokémon, [hero]?", german="Weißt du, wie du zu einem\nPokémon wurdest, [hero]?", italian="Sai come hai fatto a diventare\nun Pokémon, [hero]?", spanish="¿Quieres saber cómo te acabaste\nconvirtiendo en un Pokémon, [hero]?"})
  pcall(function() UI:SetSpeaker(npc_npc_daakurai) end)
  SkySceneKit.say({english="During the accident...[K]you shielded\n[CS:N]Grovyle[CR] from my attack.", french="Pendant l'accident...[K] tu as\nprotégé [CS:N]Massko[CR] en parant mon attaque\navec ton corps.", german="Während des Unfalls[K] hast du\n[CS:N]Reptain[CR] vor meinem Angriff geschützt.", italian="Quando si è verificato\nl'incidente...[K] hai protetto [CS:N]Grovyle[CR] dal\nmio attacco.", spanish="Durante el accidente...[K] protegiste\na [CS:N]Grovyle[CR] de mi ataque."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(I shielded [CS:N]Grovyle[CR]...?!)", french="(J'ai protégé [CS:N]Massko[CR]...?!)", german="(Ich habe [CS:N]Reptain[CR] geschützt?)", italian="(Ho protetto [CS:N]Grovyle[CR]...?!)", spanish="(¿Protegí a [CS:N]Grovyle[CR]?)"})
  else
  SkySceneKit.say({english="(I shielded [CS:N]Grovyle[CR]...?!)", french="(J'ai protégé [CS:N]Massko[CR]...?!)", german="(Ich habe [CS:N]Reptain[CR] geschützt?)", italian="(Ho protetto [CS:N]Grovyle[CR]...?!)", spanish="(¿Protegí a [CS:N]Grovyle[CR]?)"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_daakurai) end)
  SkySceneKit.say({english="Yes, you absorbed the brunt of\nthe attack I'd intended for [CS:N]Grovyle[CR]...", french="Oui, tu as essuyé le plus gros\nde l'attaque que je destinais à [CS:N]Massko[CR]...", german="Ja, du hast die volle Wucht\nder Attacke auf [CS:N]Reptain[CR] abbekommen...", italian="Sì, hai assorbito gran parte della\npotenza dell'attacco che doveva colpire\n[CS:N]Grovyle[CR]...", spanish="Sí, absorbiste la mayor parte del\nataque dirigido a [CS:N]Grovyle[CR]..."})
  pcall(function() UI:SetSpeaker(npc_npc_daakurai) end)
  SkySceneKit.say({english="It appears your fierce will to\nprotect your partner became entangled with the\nmany dimensions during your time travel.", french="Apparemment, ta résolution à le\nprotéger a interféré avec les nombreuses\ndimensions traversées pendant votre voyage.", german="Dein grimmiger Wille, deinen\nPartner zu schützen, hat sich auf der Zeitreise\nwohl in den vielen Dimensionen verheddert.", italian="Sembra che la tua forte volontà\ndi proteggere il tuo compagno si sia mischiata\ncon le molte dimensioni che avete attraversato.", spanish="Puede que, al proteger a tu\ncompañero cuando viajabais en el tiempo,\nacabaras en otra dimensión."})
  -- message_Close
  GAME:FadeOut(false, 30)
  SkySceneKit.cleanup_npcs()
end
